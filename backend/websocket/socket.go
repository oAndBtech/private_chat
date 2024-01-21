package websocket

import (
	"encoding/json"
	"log"
	"net/http"
	"strconv"
	"sync"

	"github.com/gorilla/websocket"
	"github.com/oAndBtech/private_chat/backend/database"
	"github.com/oAndBtech/private_chat/backend/notifications"

	"time"
)

type Message struct {
	ID        int    `json:"senderId"`
	Sender    string `json:"sender"`
	Content   string `json:"content"`
	IsText    bool   `json:"istext"`
	Timestamp string `json:"timestamp"`
	UniqueId  string `json:"uniqueid"`
	ReplyTo   any    `json:"replyto"`
}

var (
	upgrader = websocket.Upgrader{
		CheckOrigin: func(r *http.Request) bool {
			return true
		},
	}
	clients      = make(map[string]map[*websocket.Conn]bool)
	clientsMutex sync.Mutex
)

func HandleConnections(w http.ResponseWriter, r *http.Request) {
	userID := r.URL.Query().Get("userId")
	roomID := r.URL.Query().Get("roomId")

	userIdInteger, err := strconv.Atoi(userID) //convert to int
	if err != nil {
		log.Println(err)
		return
	}

	//check user exists in db or not
	userExists := database.VerifyUser(userIdInteger)
	if !userExists {
		log.Println("WRONG USER ID")
		return
	}

	//check room id exists
	roomExists, err := database.VerifyRoomId(roomID)
	if err != nil {
		log.Println(err)
		return
	}

	if !roomExists {
		log.Println("WRONG ROOMID")
		return
	}

	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	defer conn.Close()

	log.Printf("%v User connected to the room: %v\n", userID, roomID)

	//if user not in db then add him to db by roomID
	database.AddUserInRoom(userIdInteger, roomID)
	//register to live room
	registerClient(roomID, conn)

	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			log.Println(err)
			break
		}

		var jsonMsg Message
		err = json.Unmarshal(msg, &jsonMsg)
		if err != nil {
			log.Println(err)
			break
		}

		currentTime := time.Now()
		senderName, err := database.UsersName(userIdInteger)
		if err != nil {
			log.Println(err)
			return
		}

		broadcastMsg := Message{
			ID:        userIdInteger,
			Sender:    senderName,
			Content:   jsonMsg.Content,
			IsText:    jsonMsg.IsText,
			Timestamp: currentTime.Format(time.RFC3339),
			UniqueId:  jsonMsg.UniqueId,
			ReplyTo:   jsonMsg.ReplyTo,
		}

		broadcastJSON, err := json.Marshal(broadcastMsg)
		if err != nil {
			log.Println(err)
			break
		}

		storeMessage(userIdInteger, roomID, []byte(jsonMsg.Content), jsonMsg.IsText, senderName,jsonMsg.UniqueId,jsonMsg.ReplyTo)
		broadcast(roomID, conn, broadcastJSON)
		notifications.NewMessageArriveNotification(roomID, senderName, userIdInteger, jsonMsg.IsText)
	}
}

func registerClient(roomID string, conn *websocket.Conn) {
	clientsMutex.Lock()
	defer clientsMutex.Unlock()

	if _, ok := clients[roomID]; !ok {
		clients[roomID] = make(map[*websocket.Conn]bool)
	}

	clients[roomID][conn] = true
}

func broadcast(roomID string, sender *websocket.Conn, message []byte) {
	clientsMutex.Lock()
	defer clientsMutex.Unlock()

	for conn := range clients[roomID] {
		if conn != sender {
			err := conn.WriteMessage(websocket.TextMessage, message)
			if err != nil {
				log.Println(err)
				conn.Close()
				delete(clients[roomID], conn)
			}
		}
	}
}

func storeMessage(senderId int, roomId string, msg []byte, isText bool, senderName string, uniqueid string, replyto any) {
	res := database.AddMessage(senderId, roomId, msg, isText, senderName, uniqueid, replyto)
	if !res {
		log.Println("failed to add msg in db")
	}
}

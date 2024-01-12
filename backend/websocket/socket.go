package websocket

import (
	"encoding/json"
	"fmt"
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
	Content   any    `json:"content"`
	IsText    bool   `json:"istext"`
	Timestamp string `json:"timestamp"`
	Image     []byte `json:img`
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
		fmt.Println(err)
		return
	}

	//check user exists in db or not
	userExists := database.VerifyUser(userIdInteger)
	if !userExists {
		fmt.Println("WRONG USER ID")
		return
	}

	//check room id exists
	roomExists, err := database.VerifyRoomId(roomID)
	if err != nil {
		fmt.Println(err)
		return
	}

	if !roomExists {
		fmt.Println("WRONG ROOMID")
		return
	}

	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer conn.Close()

	fmt.Printf("%v User connected to the room: %v\n", userID, roomID)

	//if user not in db then add him to db by roomID
	database.AddUserInRoom(userIdInteger, roomID)
	//register to live room
	registerClient(roomID, conn)

	for {
		_, msg, err := conn.ReadMessage()
		if err != nil {
			fmt.Println(err)
			break
		}
		fmt.Println("MESSAGE: ", msg)

		var jsonMsg Message
		err = json.Unmarshal(msg, &jsonMsg)
		if err != nil {
			fmt.Println(err)
			break
		}

		fmt.Println(jsonMsg)

		currentTime := time.Now()
		senderName, err := database.UsersName(userIdInteger)
		if err != nil {
			fmt.Println(err)
			return
		}

		var broadcastMsg Message

		if jsonMsg.IsText {
			broadcastMsg = Message{
				ID:        userIdInteger,
				Sender:    senderName,
				Content:   jsonMsg.Content,
				IsText:    jsonMsg.IsText,
				Timestamp: currentTime.Format(time.RFC3339),
			}
		} else {
			broadcastMsg = Message{
				ID:        userIdInteger,
				Sender:    senderName,
				Content:   jsonMsg.Image,
				IsText:    jsonMsg.IsText,
				Timestamp: currentTime.Format(time.RFC3339),
			}
		}

		broadcastJSON, err := json.Marshal(broadcastMsg)
		if err != nil {
			fmt.Println(err)
			break
		}

		if jsonMsg.IsText {
			storeMessage(userIdInteger, roomID, []byte(jsonMsg.Content.(string)), jsonMsg.IsText, senderName)
		} else {
			storeMessage(userIdInteger, roomID, (jsonMsg.Image), jsonMsg.IsText, senderName)
		}

		broadcast(roomID, conn, broadcastJSON)
		notifications.NewMessageArriveNotification(roomID, senderName, userIdInteger)
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

	//TODO: send notification

	for conn := range clients[roomID] {
		if conn != sender {
			err := conn.WriteMessage(websocket.TextMessage, message)
			if err != nil {
				fmt.Println(err)
				conn.Close()
				delete(clients[roomID], conn)
			}
		}
	}
}

func storeMessage(senderId int, roomId string, msg []byte, isText bool, senderName string) {
	res := database.AddMessage(senderId, roomId, msg, isText, senderName)
	if !res {
		fmt.Println("failed to add msg in db")
	}
}

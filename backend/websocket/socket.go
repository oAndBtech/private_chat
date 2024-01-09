package websocket

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"sync"

	"github.com/gorilla/websocket"
	"github.com/oAndBtech/private_chat/backend/database"
)

type Message struct {
	Sender  string `json:"sender"`
	Content string `json:"content"`
	IsText  bool   `json:"istext"`
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

		var jsonMsg Message
		err = json.Unmarshal(msg, &jsonMsg)
		if err != nil {
			fmt.Println(err)
			break
		}

		storeMessage(userIdInteger, roomID, []byte(jsonMsg.Content))
		broadcast(roomID, conn, msg)
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

func storeMessage(senderId int, roomId string, msg []byte) {
	res := database.AddMessage(senderId, roomId, msg)
	if !res {
		fmt.Println("failed to add msg in db")
	}
}

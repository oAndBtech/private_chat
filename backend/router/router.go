package router

import (
	"github.com/gorilla/mux"
	"github.com/oAndBtech/private_chat/backend/controller"

	"github.com/oAndBtech/private_chat/backend/websocket"
)

func Router() *mux.Router {

	r := mux.NewRouter()

	//WEBSCOKET Connection
	r.HandleFunc("/ws", websocket.HandleConnections)

	//Message Controllers

	//User Controllers
	r.HandleFunc("/user/{id}", controller.GetUser).Methods("GET")       //get user
	r.HandleFunc("/user", controller.AddUser).Methods("POST")           //Add user
	r.HandleFunc("/user/{id}", controller.UpdateUser).Methods("POST")   //update user
	r.HandleFunc("/user/{id}", controller.DeleteUser).Methods("DELETE") //delete user

	//Room Controllers
	r.HandleFunc("/room/{id}", controller.GetRoom).Methods("GET")                 //get room
	r.HandleFunc("/room/oandbtech", controller.AddRoom).Methods("POST")           //Add room
	r.HandleFunc("/room/{id}", controller.UpdateRoom).Methods("POST")             //Update room
	r.HandleFunc("/room/{id}", controller.DeleteRoom).Methods("DELETE")           //Delete room
	r.HandleFunc("/room/{id}/users", controller.AllUserInRoom).Methods("GET")     //get all users in room
	r.HandleFunc("/room/{id}/messages", controller.MessagesInRoom).Methods("GET") //Get all messages in a room

	return r
}

package model

type RoomModel struct {
	ID       int    `json:"id"`
	RoomId   string `json:"roomid"`
	RoomName any    `json:"roomname"`
}

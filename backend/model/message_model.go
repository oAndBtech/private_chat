package model

type MessageModel struct {
	ID         int    `json:"id"`
	Content    []byte `json:"content"`
	Sender     int    `json:"sender"`
	Receiver   string `json:"receiver"`
	IsText     bool   `json:"istext"`
	Timestamp  string `json:"timestamp"`
	SenderName string `json:"sendername"`
}

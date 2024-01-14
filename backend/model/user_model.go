package model

type UserModel struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Phone       string `json:"phone"`
	FcmToken    any    `json:"fcmtoken"`
	WebFcmToken any    `json:"webfcmtoken"`
	Notif       bool   `json:"notif"`
}

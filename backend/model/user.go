package model

type UserModel struct {
	ID       int    `json:"id"`
	Name     string `json:"name"`
	Phone    string `json:"phone"`
	FcmToken string `json:"fcmtoken"`
}

package model

import (
	"github.com/google/uuid"
)

type UserBook struct {
	UserID uuid.UUID `gorm:"primaryKey;type:uuid;default:uuid_generate_v4()" json:"user_id"`
	BookID uuid.UUID `gorm:"primaryKey;type:uuid;default:uuid_generate_v4()" json:"book_id"`
}

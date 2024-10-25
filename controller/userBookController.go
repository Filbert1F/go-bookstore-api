package controller

import (
	"echo-test-go/config"
	"echo-test-go/helper"
	"echo-test-go/model"
	"math"
	"net/http"
	"strings"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"gorm.io/gorm"
)

func GetMyBooks(c echo.Context) error {
	claims := c.Get("user").(*helper.JWTClaims)
	db := config.DB()

	var user model.User

	if err := db.Where("email = ?", strings.ToLower(claims.Email)).First(&user).Error; err != nil {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"error": "Invalid credentials",
		})
	}

	var books []model.Book

	if err := db.Model(&model.UserBook{}).Select("books.*").Where("user_id = ?", user.ID).Joins("LEFT JOIN books ON books.id = user_books.book_id").Scan(&books).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error": "Error fetching book",
		})
	}

	var totalPrice float64
	var year int
	for _, v := range books {
		totalPrice += v.Price
		year += v.Year
	}
	var averagePrice float64
	var averageYear float64
	if len(books) > 0 {
		averagePrice = math.Round((totalPrice/float64(len(books)))*100) / 100
		averageYear = math.Round((float64(year)/float64(len(books)))*100) / 100
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"count":         len(books),
		"total_price":   totalPrice,
		"average_price": averagePrice,
		"average_year":  averageYear,
		"data":          books,
	})
}

func AddToMyBooks(c echo.Context) error {
	var body model.Book
	if err := c.Bind(&body); err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid request format",
		})
	}

	db := config.DB()

	if err := db.First(&body, "id = ?", body.ID).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return c.JSON(http.StatusNotFound, map[string]interface{}{
				"error": "Book not found",
			})
		}
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"error": "Error fetching book",
		})
	}

	claims := c.Get("user").(*helper.JWTClaims)
	var user model.User

	if err := db.Where("email = ?", strings.ToLower(claims.Email)).First(&user).Error; err != nil {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"error": "Invalid credentials",
		})
	}

	userBook := model.UserBook{
		UserID: user.ID,
		BookID: body.ID,
	}

	err := db.Where("user_id = ? AND book_id = ?", userBook.UserID, userBook.BookID).First(&userBook).Error
	if err == nil {
		return c.JSON(http.StatusConflict, map[string]interface{}{
			"error": "Book already added to my collection",
		})
	}

	if err := db.Create(&userBook).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error": "Error adding book",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"message": "Book added to my collection",
	})
}

func DeleteFromMyBooks(c echo.Context) error {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid book ID",
		})
	}

	db := config.DB()

	claims := c.Get("user").(*helper.JWTClaims)
	var user model.User

	if err := db.Where("email = ?", strings.ToLower(claims.Email)).First(&user).Error; err != nil {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"error": "Invalid credentials",
		})
	}

	existingUserBook := model.UserBook{
		UserID: user.ID,
		BookID: id,
	}

	if err := db.Where("user_id = ? AND book_id = ?", existingUserBook.UserID, existingUserBook.BookID).First(&existingUserBook).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return c.JSON(http.StatusNotFound, map[string]interface{}{
				"error": "Book not found in my collection",
			})
		}
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"error": "Error fetching book",
		})
	}

	if err := db.Delete(&existingUserBook).Error; err != nil {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"error": "Error removing book",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"message": "Book removed from my collection",
	})
}

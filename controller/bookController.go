package controller

import (
	"echo-test-go/config"
	"echo-test-go/model"
	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"gorm.io/gorm"
)

func GetBooks(c echo.Context) error {
	db := config.DB()

	var books []map[string]interface{}

	if res := db.Raw("SELECT id, name, author, year, price FROM books ORDER BY updated_at DESC").Scan(&books); res.Error != nil {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error": "Error fetching book",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"data": books,
	})
}

func GetBookByID(c echo.Context) error {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid book ID",
		})
	}

	db := config.DB()
	var book model.Book
	book.ID = id

	if err := db.First(&book).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return c.JSON(http.StatusNotFound, map[string]interface{}{
				"error": "Book not found",
			})
		}
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"error": "Error fetching book",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"data": book,
	})
}

func CreateBook(c echo.Context) error {
	var body model.Book
	if err := c.Bind(&body); err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid request format",
		})
	}

	if body.Name == "" {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Name is required",
		})
	}
	if body.Year < 1000 || body.Year > 9999 {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Year must be 1000 - 9999",
		})
	}
	if body.Price < 0 {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Price cannot be negative",
		})
	}

	db := config.DB()

	book := model.Book{
		Name:        body.Name,
		Author:      body.Author,
		Year:        body.Year,
		Price:       body.Price,
		Description: body.Description,
	}

	if err := db.Create(&book).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error": "Error creating book",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"data": book,
	})
}

func UpdateBook(c echo.Context) error {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid book ID",
		})
	}

	var body model.Book
	if err := c.Bind(&body); err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid request format",
		})
	}

	db := config.DB()
	var existingBook model.Book
	existingBook.ID = id

	if err := db.First(&existingBook).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return c.JSON(http.StatusNotFound, map[string]interface{}{
				"error": "Book not found",
			})
		}
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"error": "Error fetching book",
		})
	}

	if body.Name != "" {
		existingBook.Name = body.Name
	}
	if body.Author != nil {
		existingBook.Author = body.Author
	}
	if body.Year != 0 {
		if body.Year < 1000 || body.Year > 9999 {
			return c.JSON(http.StatusBadRequest, map[string]interface{}{
				"error": "Year must be 1000 - 9999",
			})
		}
		existingBook.Year = body.Year
	}
	if body.Price != 0 {
		if body.Price < 0 {
			return c.JSON(http.StatusBadRequest, map[string]interface{}{
				"error": "Price cannot be negative",
			})
		}
		existingBook.Price = body.Price
	}
	if body.Description != nil {
		existingBook.Description = body.Description
	}

	if err := db.Save(&existingBook).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error": "Error updating book",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"data": existingBook,
	})
}

func DeleteBook(c echo.Context) error {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid book ID",
		})
	}

	db := config.DB()
	var existingBook model.Book
	existingBook.ID = id

	if err := db.First(&existingBook).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return c.JSON(http.StatusNotFound, map[string]interface{}{
				"error": "Book not found",
			})
		}
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"error": "Error fetching book",
		})
	}

	if err := db.Delete(&existingBook).Error; err != nil {
		return c.JSON(http.StatusNotFound, map[string]interface{}{
			"error": "Error deleting book",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"message": "Book deleted successfully",
	})
}

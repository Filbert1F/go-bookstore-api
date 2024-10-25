package controller

import (
	"echo-test-go/config"
	"echo-test-go/helper"
	"echo-test-go/model"
	"net/http"
	"strings"

	"github.com/labstack/echo/v4"
	"golang.org/x/crypto/bcrypt"
)

const (
	MinPasswordLength = 8
	MinUsernameLength = 3
	BcryptCost        = 12
	JWTSecret         = "my-secret-key"
)

func LoginController(c echo.Context) error {
	var loginRequest model.LoginRequest
	if err := c.Bind(&loginRequest); err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid request format",
		})
	}

	if !helper.IsValidEmail(loginRequest.Email) {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid email",
		})
	}

	db := config.DB()
	var user model.User

	// Find user by email
	if err := db.Where("email = ?", strings.ToLower(loginRequest.Email)).First(&user).Error; err != nil {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"error": "Invalid credentials",
		})
	}

	// Verify password
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(loginRequest.Password)); err != nil {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"error": "Invalid credentials",
		})
	}

	// Generate JWT
	token, err := helper.GenerateJWT(user, JWTSecret)
	if err != nil {
		return c.JSON(http.StatusUnauthorized, map[string]interface{}{
			"error": "Error generating token",
		})
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"user":  user,
		"token": token,
	})
}

func RegistrationController(c echo.Context) error {
	var registerRequest model.RegisterRequest
	if err := c.Bind(&registerRequest); err != nil {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid request format",
		})
	}

	if !helper.IsValidEmail(registerRequest.Email) {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Invalid email",
		})
	}

	// Validate input
	if len(registerRequest.Password) < MinPasswordLength {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Password must be at least 8 characters",
		})
	}

	if len(registerRequest.Username) < MinUsernameLength {
		return c.JSON(http.StatusBadRequest, map[string]interface{}{
			"error": "Username must be at least 3 characters",
		})
	}

	user := model.User{
		Email:    registerRequest.Email,
		Password: registerRequest.Password,
		Username: registerRequest.Username,
	}

	db := config.DB()

	// Check if email exists
	var existingUser model.User
	if err := db.Where("email = ?", strings.ToLower(user.Email)).First(&existingUser).Error; err == nil {
		return c.JSON(http.StatusConflict, map[string]interface{}{
			"error": "Email already exists",
		})
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), BcryptCost)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error": "Error processing request",
		})
	}

	// Create user
	user.Email = strings.ToLower(user.Email)
	user.Password = string(hashedPassword)

	if err := db.Create(&user).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error": "Error creating user",
		})
	}

	// Generate JWT
	token, err := helper.GenerateJWT(user, JWTSecret)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]interface{}{
			"error": "Error generating token",
		})
	}

	return c.JSON(http.StatusCreated, map[string]interface{}{
		"user":  user,
		"token": token,
	})
}

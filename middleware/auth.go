package middleware

import (
	"echo-test-go/config"
	"echo-test-go/helper"
	"echo-test-go/model"
	"net/http"
	"strings"

	"github.com/labstack/echo/v4"
)

func JWTMiddleware(secretKey string) echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			authHeader := c.Request().Header.Get("Authorization")
			if authHeader == "" {
				return c.JSON(http.StatusUnauthorized, map[string]string{
					"error": "No authorization header",
				})
			}

			tokenParts := strings.Split(authHeader, " ")
			if len(tokenParts) != 2 || tokenParts[0] != "Bearer" {
				return c.JSON(http.StatusUnauthorized, map[string]string{
					"error": "Invalid authorization header format",
				})
			}

			claims, err := helper.ValidateJWT(tokenParts[1], secretKey)
			if err != nil {
				return c.JSON(http.StatusUnauthorized, map[string]string{
					"error": "Invalid token",
				})
			}

			c.Set("user", claims)

			db := config.DB()

			var user model.User
			if err := db.Where("email = ?", strings.ToLower(claims.Email)).First(&user).Error; err != nil {
				return c.JSON(http.StatusUnauthorized, map[string]interface{}{
					"error": "Invalid token",
				})
			}

			return next(c)
		}
	}
}

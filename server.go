package main

import (
	"echo-test-go/config"
	"echo-test-go/controller"
	"echo-test-go/middleware"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	config.DatabaseInit()

	gorm := config.DB()

	dbGorm, err := gorm.DB()
	if err != nil {
		panic(err)
	}

	dbGorm.Ping()

	bookRoute := e.Group("/books")
	bookRoute.GET("", controller.GetBooks)
	bookRoute.GET("/:id", controller.GetBookByID)
	bookRoute.POST("", controller.CreateBook, middleware.JWTMiddleware(controller.JWTSecret))
	bookRoute.PUT("/:id", controller.UpdateBook, middleware.JWTMiddleware(controller.JWTSecret))
	bookRoute.DELETE("/:id", controller.DeleteBook, middleware.JWTMiddleware(controller.JWTSecret))

	e.POST("/login", controller.LoginController)
	e.POST("/register", controller.RegistrationController)

	userBookRoute := e.Group("/user/books", middleware.JWTMiddleware(controller.JWTSecret))
	userBookRoute.GET("", controller.GetMyBooks)
	userBookRoute.POST("", controller.AddToMyBooks)
	userBookRoute.DELETE("/:id", controller.DeleteFromMyBooks)

	e.Logger.Fatal(e.Start(":1323"))
}

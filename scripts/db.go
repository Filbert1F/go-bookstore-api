package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

func getConnectionString(dbName string) string {
	return fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=%s",
		os.Getenv("DB_HOST"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		dbName,
		os.Getenv("DB_PORT"),
		os.Getenv("DB_SSL_MODE"),
	)
}

func createDatabase() error {
	db, err := sql.Open("postgres", getConnectionString("postgres"))
	if err != nil {
		return fmt.Errorf("error connecting to postgres database: %v", err)
	}
	defer db.Close()

	dbName := os.Getenv("DB_NAME")
	_, err = db.Exec(fmt.Sprintf(`CREATE DATABASE "%s"`, dbName))
	if err != nil {
		return fmt.Errorf("error creating database: %v", err)
	}

	fmt.Printf("Database %s created successfully\n", dbName)
	return nil
}

func dropDatabase() error {
	db, err := sql.Open("postgres", getConnectionString("postgres"))
	if err != nil {
		return fmt.Errorf("error connecting to postgres database: %v", err)
	}
	defer db.Close()

	dbName := os.Getenv("DB_NAME")

	terminateConnections := fmt.Sprintf(`
        SELECT pg_terminate_backend(pg_stat_activity.pid)
        FROM pg_stat_activity
        WHERE pg_stat_activity.datname = '%s'
        AND pid <> pg_backend_pid()`, dbName)

	_, err = db.Exec(terminateConnections)
	if err != nil {
		return fmt.Errorf("error terminating connections: %v", err)
	}

	time.Sleep(time.Second)

	_, err = db.Exec(fmt.Sprintf(`DROP DATABASE IF EXISTS "%s"`, dbName))
	if err != nil {
		return fmt.Errorf("error dropping database: %v", err)
	}

	fmt.Printf("Database %s dropped successfully\n", dbName)
	return nil
}

func main() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatalf("Error loading .env file")
	}

	requiredEnvVars := []string{"DB_HOST", "DB_PORT", "DB_USER", "DB_PASSWORD", "DB_NAME"}
	for _, envVar := range requiredEnvVars {
		if os.Getenv(envVar) == "" {
			log.Fatalf("Environment variable %s is not set", envVar)
		}
	}

	if len(os.Args) != 2 {
		log.Fatal("Usage: go run script.go [create|drop]")
	}

	command := os.Args[1]

	switch command {
	case "create":
		if err := createDatabase(); err != nil {
			log.Fatal(err)
		}
	case "drop":
		if err := dropDatabase(); err != nil {
			log.Fatal(err)
		}
	default:
		log.Fatal("Invalid command. Use 'create' or 'drop'")
	}
}

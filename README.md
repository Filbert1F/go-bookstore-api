## Install dependencies

```bash
go mod download
```

## Database Management

### Create Database

```bash
make create_db
```

### Drop Database

```bash
make drop_db
```

### Recreate Database (drops, creates, and runs migrations)

```bash
make recreate_db
```

### Run Migrations

```bash
# Apply migrations
make migration_up

# Rollback migrations
make migration_down

# Fix migration version
make migration_fix
```

### Check Database URL

```bash
make print-db-url
```

## Running the Application

1. Set up the database

```bash
make recreate_db
```

2. Start the server

```bash
go run .
```

The server will start on `localhost:1323`.

## API Endpoints

### Books

```http
GET /books
GET /books/{id}
```

```http
POST /books (protected)
```

```json
// Request Body for POST /books
"name": "The Two Towers",
"author": "John Ronald Reuel Tolkien",
"year": 1954,
"price": 11.99,
"description": "The Two Towers is the second volume of J. R. R. Tolkien's high fantasy novel The Lord of the Rings. It is preceded by The Fellowship of the Ring and followed by The Return of the King"
```

```http
PUT /books/{id} (protected)
```

```json
// Request Body for PUT /books/{id}
"name": "The Two Towers Edited",
"author": "John Ronald Reuel Tolkien Edited",
"year": 1888,
"price": 1100.99,
"description": "Edited description"
```

```http
DELETE /books/{id} (protected)
```

### Authentication

```http
POST /login
```

```json
// Request Body for POST /login
"email": "avery.brown@gmail.com",
"password": "avery123"
```

```http
POST /register
```

```json
// Request Body for POST /register
"email": "homersimpson@gmail.com",
"username": "homersimpson",
"password": "homersimpson"
```

### User Book Collection

```http
GET /user/books (protected)
```

```http
POST /user/books (protected)
```

```json
// Request Body for POST /user/books
"id": "a746a611-314a-41e9-a7c2-788c2f187511"
```

```http
DELETE /user/books/{id} (protected)
```

## Authorization

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

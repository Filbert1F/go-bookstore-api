CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE books 
(
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR NOT NULL,
  author VARCHAR,
  year INTEGER NOT NULL,
  price DECIMAL(15,2) NOT NULL,
  description TEXT
);

CREATE TABLE users 
(
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR NOT NULL UNIQUE,
  password VARCHAR NOT NULL,
  username VARCHAR NOT NULL
);

CREATE TABLE user_books
(
  user_id UUID NOT NULL,
  book_id UUID NOT NULL,
  CONSTRAINT fk_user
    FOREIGN KEY(user_id) 
    REFERENCES users(id),
  CONSTRAINT fk_book
    FOREIGN KEY(book_id) 
    REFERENCES books(id),
  PRIMARY KEY (user_id, book_id)
);
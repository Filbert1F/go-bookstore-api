DROP TRIGGER IF EXISTS set_timestamp ON books;
DROP TRIGGER IF EXISTS set_timestamp ON users;

ALTER TABLE books 
  DROP COLUMN created_at,
  DROP COLUMN updated_at;

ALTER TABLE users 
  DROP COLUMN created_at,
  DROP COLUMN updated_at;

DROP FUNCTION IF EXISTS trigger_set_timestamp();
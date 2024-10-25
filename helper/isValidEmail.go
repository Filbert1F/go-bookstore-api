package helper

import (
	"regexp"
	"strings"
)

func IsValidEmail(email string) bool {
	email = strings.TrimSpace(strings.ToLower(email))

	emailRegex := regexp.MustCompile(`^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$`)

	if len(email) > 254 ||
		strings.Count(email, "@") != 1 ||
		strings.Contains(email, "..") ||
		strings.HasPrefix(email, ".") ||
		strings.HasSuffix(email, ".") {
		return false
	}

	return emailRegex.MatchString(email)
}

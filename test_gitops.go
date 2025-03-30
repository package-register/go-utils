package main

import (
	"log"

	"agcore/gitops"
)

func main() {
	err := gitops.CommitAll("Add dummy.txt")
	if err != nil {
		log.Fatalf("Failed to commit changes: %v", err)
	}
	log.Println("Changes committed successfully")
}

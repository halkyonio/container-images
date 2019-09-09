package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
)

const (
	filePattern = "/deployments/*.jar"
	port        = ":8585"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if fileExists(filePattern) {
			fmt.Fprint(w, "App deployed")
		} else {
			fmt.Fprint(w, "App not yet deployed")
		}

	})
	log.Fatal(http.ListenAndServe(port, nil))
}

func fileExists(filePattern string) bool {
	files, err := filepath.Glob(filePattern)
	if err != nil {
		return false
	}
	if len(files) == 0 || len(files) > 1 {
		return false
	}

	fi, err := os.Stat(files[0])
	if err != nil {
		return false
	}

	if fi.Size() == 0 {
		return false
	} else {
		return true
	}
}

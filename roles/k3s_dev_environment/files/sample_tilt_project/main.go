// roles/k3s_dev_environment/files/sample_tilt_project/main.go
package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
    "time"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        hostname, _ := os.Hostname()
        currentTime := time.Now().Format(time.RFC1123)
        fmt.Fprintf(w, "Hello from Go (Default Sample)!\nHost: %s\nTime: %s\nVersion: go-v1.0.1\n",
            hostname, currentTime)
    })

    http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
        fmt.Fprint(w, "OK")
    })

    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    log.Printf("Go server starting on port %s...", port)
    if err := http.ListenAndServe(":"+port, nil); err != nil {
        log.Fatalf("Error starting server: %s", err)
    }
}
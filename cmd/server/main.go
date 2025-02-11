package main

import (
    "fmt"
    "log"
    "os"

    "github.com/a-dev-mobile/investment-tracker/internal/config"
    "github.com/gin-gonic/gin"
)

type HealthResponse struct {
    Status      string `json:"status"`
    Environment string `json:"environment"`
    Version     string `json:"version"`
    DBStatus    string `json:"db_status"`
}

func main() {
    // Get environment from ENV variable or default to local
    env := os.Getenv("ENV")
    if env == "" {
        env = "local"
    }

    // Load configuration
    cfg, err := config.LoadConfig(env)
    if err != nil {
        log.Fatalf("Failed to load config: %v", err)
    }

    // Initialize Gin router
    router := gin.Default()

    // Health check endpoint
    router.GET("/health", func(c *gin.Context) {
        response := HealthResponse{
            Status:      "OK",
            Environment: cfg.Environment,
            Version:     "1.0.0", // You can make this dynamic
            DBStatus:    "Connected", // You should implement real DB status check
        }
        c.JSON(200, response)
    })

    // Start server
    serverAddr := fmt.Sprintf("%s:%d", cfg.Server.Host, cfg.Server.Port)
    log.Printf("Server starting on %s in %s environment", serverAddr, env)
    if err := router.Run(serverAddr); err != nil {
        log.Fatalf("Failed to start server: %v", err)
    }
}
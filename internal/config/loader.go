package config

import (
    "fmt"
    "os"
    "path/filepath"

    "gopkg.in/yaml.v3"
)

func LoadConfig(env string) (*Config, error) {
    configPath := filepath.Join("configs", "environments", fmt.Sprintf("%s.yaml", env))
    
    data, err := os.ReadFile(configPath)
    if err != nil {
        return nil, fmt.Errorf("error reading config file: %v", err)
    }

    var config Config
    if err := yaml.Unmarshal(data, &config); err != nil {
        return nil, fmt.Errorf("error parsing config file: %v", err)
    }

    return &config, nil
}
package config

type Config struct {
    Environment string `yaml:"environment"`
    Database    struct {
        Host     string `yaml:"host"`
        Port     int    `yaml:"port"`
        Name     string `yaml:"name"`
        User     string `yaml:"user"`
        Password string `yaml:"password"`
    } `yaml:"database"`
    Server struct {
        Port int    `yaml:"port"`
        Host string `yaml:"host"`
    } `yaml:"server"`
    MarketData struct {
        UpdateInterval string `yaml:"update_interval"`
    } `yaml:"market_data"`
}
package main

import (
    "github.com/pocketbase/pocketbase"
)

func main() {
    app := pocketbase.New()
    app.Bootstrap()
}
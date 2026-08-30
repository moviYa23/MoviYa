package main

import (
	"fmt"
	"log"
	"os"

	"github.com/gofiber/fiber/v3"
	"github.com/redis/go-redis/v9"
)

func main() {
	app := fiber.New(fiber.Config{
		AppName: "MoviYa E-Commerce Service v2.0",
	})

	// Conectar a Redis
	rdb := redis.NewClient(&redis.Options{
		Addr: os.Getenv("REDIS_URL"),
	})

	if rdb == nil {
		rdb = redis.NewClient(&redis.Options{
			Addr: "localhost:6379",
		})
	}

	// Health Check
	app.Get("/health", func(c fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"status":  "healthy",
			"service": "ecommerce",
			"version": "2.0.0",
		})
	})

	// Search Products - Agregación de precios desde múltiples fuentes
	app.Post("/api/search", func(c fiber.Ctx) error {
		type SearchRequest struct {
			Query   string `json:"query"`
			Limit   int    `json:"limit"`
			Source  string `json:"source"`
		}

		var req SearchRequest
		if err := c.Bind().Body(&req); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
		}

		if req.Limit == 0 {
			req.Limit = 10
		}

		// Buscar en Amazon, AliExpress, Temu
		amazonResults := searchAmazon(req.Query, req.Limit)
		aliexpressResults := searchAliExpress(req.Query, req.Limit)
		temuResults := searchTemu(req.Query, req.Limit)

		// Agregar y normalizar resultados
		results := aggregateResults(amazonResults, aliexpressResults, temuResults)

		return c.JSON(fiber.Map{
			"status":  "success",
			"query":   req.Query,
			"count":   len(results),
			"results": results,
		})
	})

	// Get Product Details
	app.Get("/api/products/:id", func(c fiber.Ctx) error {
		id := c.Params("id")

		return c.JSON(fiber.Map{
			"status": "success",
			"product": fiber.Map{
				"id":    id,
				"name":  "Sample Product",
				"price": 99.99,
			},
		})
	})

	// Get Product Providers - Mostrar disponibilidad en múltiples plataformas
	app.Get("/api/products/:id/providers", func(c fiber.Ctx) error {
		id := c.Params("id")

		providers := []fiber.Map{
			{
				"source":        "amazon",
				"price":         99.99,
				"shipping_time": "2-3 days",
				"rating":        4.8,
			},
			{
				"source":        "aliexpress",
				"price":         75.50,
				"shipping_time": "7-15 days",
				"rating":        4.5,
			},
			{
				"source":        "temu",
				"price":        45.99,
				"shipping_time": "10-20 days",
				"rating":        4.2,
			},
		}

		return c.JSON(fiber.Map{
			"status":    "success",
			"product":   id,
			"providers": providers,
		})
	})

	log.Println("🚀 E-Commerce Service running on :8001")
	app.Listen(":8001")
}

// searchAmazon - Buscar productos en Amazon (placeholder)
func searchAmazon(query string, limit int) []fiber.Map {
	return []fiber.Map{
		{
			"id":       "amz-001",
			"name":     query + " (Amazon)",
			"price":    99.99,
			"source":   "amazon",
			"shipping": "2-3 days",
		},
	}
}

// searchAliExpress - Buscar productos en AliExpress (placeholder)
func searchAliExpress(query string, limit int) []fiber.Map {
	return []fiber.Map{
		{
			"id":       "ali-001",
			"name":     query + " (AliExpress)",
			"price":    75.50,
			"source":   "aliexpress",
			"shipping": "7-15 days",
		},
	}
}

// searchTemu - Buscar productos en Temu (placeholder)
func searchTemu(query string, limit int) []fiber.Map {
	return []fiber.Map{
		{
			"id":       "temu-001",
			"name":     query + " (Temu)",
			"price":    45.99,
			"source":   "temu",
			"shipping": "10-20 days",
		},
	}
}

// aggregateResults - Normalizar y agregar resultados
func aggregateResults(amazon, aliexpress, temu []fiber.Map) []fiber.Map {
	var results []fiber.Map
	results = append(results, amazon...)
	results = append(results, aliexpress...)
	results = append(results, temu...)
	return results
}

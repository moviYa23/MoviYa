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
		AppName: "MoviYa Logistics Service v2.0",
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
			"service": "logistics",
			"version": "2.0.0",
		})
	})

	// Quote Shipping - Cotizar envío con múltiples opciones
	app.Post("/api/quote", func(c fiber.Ctx) error {
		type QuoteRequest struct {
			Origin      string  `json:"origin"`
			Destination string  `json:"destination"`
			WeightKg    float64 `json:"weight_kg"`
		}

		var req QuoteRequest
		if err := c.Bind().Body(&req); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
		}

		// Obtener cotizaciones de Uber, DiDi, Rappi
		uberQuote := getUberQuote(req.Origin, req.Destination, req.WeightKg)
		didiQuote := getDidiQuote(req.Origin, req.Destination, req.WeightKg)
		rappiQuote := getRappiQuote(req.Origin, req.Destination, req.WeightKg)

		// Comparar y retornar la mejor opción
		quotes := []fiber.Map{uberQuote, didiQuote, rappiQuote}

		return c.JSON(fiber.Map{
			"status":   "success",
			"origin":   req.Origin,
			"destination": req.Destination,
			"quotes":   quotes,
			"best":     selectBestQuote(quotes),
		})
	})

	// Create Shipping Order
	app.Post("/api/order", func(c fiber.Ctx) error {
		type OrderRequest struct {
			ShippingProvider string `json:"provider"`
			Origin           string `json:"origin"`
			Destination      string `json:"destination"`
		}

		var req OrderRequest
		if err := c.Bind().Body(&req); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "Invalid request"})
		}

		return c.JSON(fiber.Map{
			"status": "success",
			"order_id": "SHP-" + randomString(8),
			"provider": req.ShippingProvider,
			"eta": "2-4 hours",
		})
	})

	// Track Shipment
	app.Get("/api/tracking/:order_id", func(c fiber.Ctx) error {
		orderID := c.Params("order_id")

		return c.JSON(fiber.Map{
			"status": "success",
			"order_id": orderID,
			"current_status": "in_transit",
			"location": "Sector 10, Medellín",
			"driver_name": "Juan Pérez",
			"eta": "15 minutes",
		})
	})

	log.Println("🚀 Logistics Service running on :8002")
	app.Listen(":8002")
}

// getUberQuote - Obtener cotización de Uber (placeholder)
func getUberQuote(origin, destination string, weight float64) fiber.Map {
	return fiber.Map{
		"provider": "uber",
		"price":    15.99,
		"eta":      "5 minutes",
		"rating":   4.9,
	}
}

// getDidiQuote - Obtener cotización de DiDi (placeholder)
func getDidiQuote(origin, destination string, weight float64) fiber.Map {
	return fiber.Map{
		"provider": "didi",
		"price":    14.50,
		"eta":      "8 minutes",
		"rating":   4.7,
	}
}

// getRappiQuote - Obtener cotización de Rappi (placeholder)
func getRappiQuote(origin, destination string, weight float64) fiber.Map {
	return fiber.Map{
		"provider": "rappi",
		"price":    13.25,
		"eta":      "10 minutes",
		"rating":   4.6,
	}
}

// selectBestQuote - Seleccionar la mejor opción
func selectBestQuote(quotes []fiber.Map) fiber.Map {
	if len(quotes) == 0 {
		return fiber.Map{}
	}

	best := quotes[0]
	for _, quote := range quotes {
		if quote["price"].(float64) < best["price"].(float64) {
			best = quote
		}
	}

	return best
}

// randomString - Generar string aleatorio
func randomString(length int) string {
	return fmt.Sprintf("%x", os.Getenv("RANDOM"))[:length]
}

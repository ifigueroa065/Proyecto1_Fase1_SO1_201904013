package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"sync"
	"time"

	"github.com/gofiber/fiber/v2"
)

type RamInfo struct {
	Total      uint64 `json:"total"`
	Libre      uint64 `json:"libre"`
	Uso        uint64 `json:"uso"`
	Porcentaje uint64 `json:"porcentaje"`
}

type CpuInfo struct {
	PorcentajeUso uint64 `json:"porcentajeUso"`
}

type MetricsPayload struct {
	CPU CpuInfo `json:"cpu"`
	RAM RamInfo `json:"ram"`
}

var currentMetrics MetricsPayload
var mu sync.RWMutex

func leerArchivoJSON(path string, target interface{}) error {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return err
	}
	return json.Unmarshal(data, target)
}

func recolector() {
	for {
		var ram RamInfo
		var cpu CpuInfo

		err1 := leerArchivoJSON("/proc/ram_201904013", &ram)
		err2 := leerArchivoJSON("/proc/cpu_201904013", &cpu)

		if err1 != nil || err2 != nil {
			log.Println("******* Error leyendo módulos:", err1, err2)
		} else {
			mu.Lock()
			currentMetrics = MetricsPayload{CPU: cpu, RAM: ram}
			mu.Unlock()
		}

		time.Sleep(5 * time.Second)
	}
}

func enviarAPI() {
	for {
		time.Sleep(5 * time.Second)

		mu.RLock()
		payload := currentMetrics
		mu.RUnlock()

		jsonData, err := json.Marshal(payload)
		if err != nil {
			log.Println("******* Error serializando JSON:", err)
			continue
		}

		resp, err := http.Post("http://localhost:3000/metrics", "application/json", bytes.NewBuffer(jsonData))
		if err != nil {
			log.Println("******* Error enviando a la API:", err)
			continue
		}

		defer resp.Body.Close()
		log.Println(" Métricas enviadas correctamente ✅")
	}
}

func main() {
	go recolector()
	go enviarAPI()

	app := fiber.New()

	app.Get("/metrics", func(c *fiber.Ctx) error {
		mu.RLock()
		defer mu.RUnlock()
		return c.JSON(currentMetrics)
	})

	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("Recolector en ejecución. Endpoint disponible en /metrics ✅ ")
	})

	port := 8080
	fmt.Printf("✅ Servidor Fiber escuchando en http://localhost:%d\n", port)
	log.Fatal(app.Listen(fmt.Sprintf(":%d", port)))
}

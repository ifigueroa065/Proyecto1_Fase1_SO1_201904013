package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"time"

	"github.com/gofiber/fiber/v2"
)

// Estructuras para las métricas de RAM y CPU
type RamInfo struct {
	Total      uint64 `json:"total"`
	Libre      uint64 `json:"libre"`
	Uso        uint64 `json:"uso"`
	Porcentaje uint64 `json:"porcentaje"`
}

type CpuInfo struct {
	PorcentajeUso uint64 `json:"porcentajeUso"`
}

// Estructura para unificar los resultados de RAM y CPU
type MetricsPayload struct {
	CPU CpuInfo `json:"cpu"`
	RAM RamInfo `json:"ram"`
}

// Canal para pasar las métricas
var metricsChan = make(chan MetricsPayload, 1)

// Función para leer los archivos JSON de métricas
func leerArchivoJSON(path string, target interface{}) error {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return err
	}
	return json.Unmarshal(data, target)
}

// Función para recolectar las métricas de RAM
func recolectorRam(ch chan<- RamInfo) {
	for {
		var ram RamInfo
		err := leerArchivoJSON("/proc/ram_201904013", &ram)
		if err != nil {
			log.Println("Error leyendo módulo RAM:", err)
		}
		ch <- ram
		time.Sleep(5 * time.Second) // Recolectar cada 5 segundos
	}
}

// Función para recolectar las métricas de CPU
func recolectorCpu(ch chan<- CpuInfo) {
	for {
		var cpu CpuInfo
		err := leerArchivoJSON("/proc/cpu_201904013", &cpu)
		if err != nil {
			log.Println("Error leyendo módulo CPU:", err)
		}
		ch <- cpu
		time.Sleep(5 * time.Second) // Recolectar cada 5 segundos
	}
}

// Función que unifica las métricas de RAM y CPU y las envía por el canal
func unificarMetricas(ramCh <-chan RamInfo, cpuCh <-chan CpuInfo) {
	for {
		ram := <-ramCh
		cpu := <-cpuCh

		// Unificando las métricas
		metrics := MetricsPayload{
			CPU: cpu,
			RAM: ram,
		}

		// Enviar las métricas por el canal
		metricsChan <- metrics
	}
}

// Función para enviar las métricas a la API
func enviarAPI() {
	for {
		time.Sleep(5 * time.Second)

		// Obtener las métricas del canal
		metrics := <-metricsChan

		// Convertir a JSON
		jsonData, err := json.Marshal(metrics)
		if err != nil {
			log.Println("Error serializando JSON:", err)
			continue
		}

		// Enviar las métricas a la API
		resp, err := http.Post("http://localhost:3000/metrics", "application/json", bytes.NewBuffer(jsonData))
		if err != nil {
			log.Println("Error enviando a la API:", err)
			continue
		}

		defer resp.Body.Close()
		log.Println("Métricas enviadas correctamente ✅")
	}
}

func main() {
	// Crear los canales para las métricas de RAM y CPU
	ramCh := make(chan RamInfo)
	cpuCh := make(chan CpuInfo)

	// Iniciar las goroutines para la recolección de métricas
	go recolectorRam(ramCh)
	go recolectorCpu(cpuCh)
	go unificarMetricas(ramCh, cpuCh)
	go enviarAPI()

	// Iniciar el servidor con Fiber
	app := fiber.New()

	app.Get("/metrics", func(c *fiber.Ctx) error {
		metrics := <-metricsChan // Obtener las métricas del canal
		return c.JSON(metrics)
	})

	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("Recolector en ejecución. Endpoint disponible en /metrics ✅ ")
	})

	port := 8080
	fmt.Printf("Servidor Fiber escuchando en http://localhost:%d\n", port)
	log.Fatal(app.Listen(fmt.Sprintf(":%d", port)))
}

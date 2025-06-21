package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
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
	Total      uint64 `json:"total"`
	Uso        uint64 `json:"uso"`
	Libre      uint64 `json:"libre"`
	Porcentaje uint64 `json:"porcentaje"`
}


type MetricsPayload struct {
	CPU CpuInfo `json:"cpu"`
	RAM RamInfo `json:"ram"`
}

var metricsChan = make(chan MetricsPayload, 1)

func leerArchivoJSON(path string, target interface{}) error {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return err
	}
	return json.Unmarshal(data, target)
}

func recolectorRam(ch chan<- RamInfo) {
	for {
		var ram RamInfo
		err := leerArchivoJSON("/proc/ram_201904013", &ram)
		if err != nil {
			log.Println("Error leyendo módulo RAM:", err)
		}
		ch <- ram
		time.Sleep(5 * time.Second)
	}
}

func recolectorCpu(ch chan<- CpuInfo) {
	for {
		var cpu CpuInfo
		err := leerArchivoJSON("/proc/cpu_201904013", &cpu)
		if err != nil {
			log.Println("Error leyendo módulo CPU:", err)
		}
		ch <- cpu
		time.Sleep(5 * time.Second)
	}
}

func unificarMetricas(ramCh <-chan RamInfo, cpuCh <-chan CpuInfo) {
	for {
		ram := <-ramCh
		cpu := <-cpuCh
		metrics := MetricsPayload{
			CPU: cpu,
			RAM: ram,
		}
		metricsChan <- metrics
	}
}

func enviarAPI() {
	apiHost := os.Getenv("API_HOST")
	apiPort := os.Getenv("API_PORT")
	apiURL := fmt.Sprintf("http://%s:%s/metrics", apiHost, apiPort)

	for {
		time.Sleep(5 * time.Second)
		metrics := <-metricsChan

		jsonData, err := json.Marshal(metrics)
		if err != nil {
			log.Println("Error serializando JSON:", err)
			continue
		}

		resp, err := http.Post(apiURL, "application/json", bytes.NewBuffer(jsonData))
		if err != nil {
			log.Println("Error enviando a la API:", err)
			continue
		}

		defer resp.Body.Close()
		log.Println("Métricas enviadas correctamente ✅")
	}
}

func main() {
	ramCh := make(chan RamInfo)
	cpuCh := make(chan CpuInfo)

	go recolectorRam(ramCh)
	go recolectorCpu(cpuCh)
	go unificarMetricas(ramCh, cpuCh)
	go enviarAPI()

	app := fiber.New()

	app.Get("/metrics", func(c *fiber.Ctx) error {
		metrics := <-metricsChan
		return c.JSON(metrics)
	})

	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("Recolector en ejecución. Endpoint disponible en /metrics ✅ ")
	})

	port := os.Getenv("RECOLECTOR_PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Printf("Servidor Fiber escuchando en http://localhost:%s\n", port)
	log.Fatal(app.Listen(":" + port))
}

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

// Definir estructuras para los datos de los módulos
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

type ProcesosInfo struct {
	ProcesosCorriendo  uint64 `json:"procesos_corriendo"`
	TotalProcesos      uint64 `json:"total_procesos"`
	ProcesosDurmiendo  uint64 `json:"procesos_durmiendo"`
	ProcesosZombie     uint64 `json:"procesos_zombie"`
	ProcesosParados    uint64 `json:"procesos_parados"`
}

type MetricsPayload struct {
	CPU      CpuInfo      `json:"cpu"`
	RAM      RamInfo      `json:"ram"`
	Procesos ProcesosInfo `json:"procesos"`
}

// Canal de métricas
var metricsChan = make(chan MetricsPayload, 1)

// Función para leer los archivos JSON generados por los módulos
func leerArchivoJSON(path string, target interface{}) error {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return err
	}
	return json.Unmarshal(data, target)
}

// Función recolectora de RAM
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

// Función recolectora de CPU
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

// Función recolectora de Procesos
func recolectorProcesos(ch chan<- ProcesosInfo) {
	for {
		var procesos ProcesosInfo
		err := leerArchivoJSON("/proc/procesos_201904013", &procesos)
		if err != nil {
			log.Println("Error leyendo módulo Procesos:", err)
		}
		ch <- procesos
		time.Sleep(5 * time.Second)
	}
}

// Función para unificar las métricas
func unificarMetricas(ramCh <-chan RamInfo, cpuCh <-chan CpuInfo, procesosCh <-chan ProcesosInfo) {
	for {
		ram := <-ramCh
		cpu := <-cpuCh
		procesos := <-procesosCh
		metrics := MetricsPayload{
			CPU:      cpu,
			RAM:      ram,
			Procesos: procesos,
		}
		metricsChan <- metrics
	}
}

// Función para enviar las métricas a la API
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
	procesosCh := make(chan ProcesosInfo)

	go recolectorRam(ramCh)
	go recolectorCpu(cpuCh)
	go recolectorProcesos(procesosCh)
	go unificarMetricas(ramCh, cpuCh, procesosCh)
	go enviarAPI()

	app := fiber.New()

	// Endpoint para mostrar métricas
	app.Get("/metrics", func(c *fiber.Ctx) error {
		metrics := <-metricsChan
		return c.JSON(metrics)
	})

	// Endpoint raíz para verificar que el servicio está en ejecución
	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("Recolector en ejecución. Endpoint disponible en /metrics ✅ ")
	})

	// Iniciar servidor
	port := os.Getenv("RECOLECTOR_PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Printf("Servidor Fiber escuchando en http://localhost:%s\n", port)
	log.Fatal(app.Listen(":" + port))
}

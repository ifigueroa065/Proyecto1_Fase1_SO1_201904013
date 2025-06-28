package main

import (
	"log"
	"fmt"
	"time"
	"sync"
	"io/ioutil"
	"encoding/json"
	"github.com/gofiber/fiber/v2"
)

// Estructuras para las métricas
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
	ProcesosCorriendo uint64 `json:"procesos_corriendo"`
	TotalProcesos     uint64 `json:"total_procesos"`
	ProcesosDurmiendo uint64 `json:"procesos_durmiendo"`
	ProcesosZombie    uint64 `json:"procesos_zombie"`
	ProcesosParados   uint64 `json:"procesos_parados"`
}

type MetricsPayload struct {
	CPU      CpuInfo      `json:"cpu"`
	RAM      RamInfo      `json:"ram"`
	Procesos ProcesosInfo `json:"procesos"`
}

// Canal de métricas
var metricsChan = make(chan MetricsPayload, 10)

// Función para leer los archivos JSON generados por los módulos
func leerArchivoJSON(path string, target interface{}) error {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		log.Printf("Error leyendo archivo %s: %v\n", path, err)
		return err
	}
	if err := json.Unmarshal(data, target); err != nil {
		log.Printf("Error deserializando archivo %s: %v\n", path, err)
		return err
	}
	return nil
}

// Función recolectora de RAM
func recolectorRam(ch chan<- RamInfo, wg *sync.WaitGroup) {
	defer wg.Done()
	for {
		var ram RamInfo
		if err := leerArchivoJSON("/proc/ram_201904013", &ram); err != nil {
			log.Println("Error leyendo módulo RAM:", err)
		} else {
			ch <- ram
		}
		time.Sleep(5 * time.Second)
	}
}

// Función recolectora de CPU
func recolectorCpu(ch chan<- CpuInfo, wg *sync.WaitGroup) {
	defer wg.Done()
	for {
		var cpu CpuInfo
		if err := leerArchivoJSON("/proc/cpu_201904013", &cpu); err != nil {
			log.Println("Error leyendo módulo CPU:", err)
		} else {
			ch <- cpu
		}
		time.Sleep(5 * time.Second)
	}
}

// Función recolectora de Procesos
func recolectorProcesos(ch chan<- ProcesosInfo, wg *sync.WaitGroup) {
	defer wg.Done()
	for {
		var procesos ProcesosInfo
		if err := leerArchivoJSON("/proc/procesos_201904013", &procesos); err != nil {
			log.Println("Error leyendo módulo Procesos:", err)
		} else {
			ch <- procesos
		}
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

func main() {
	var wg sync.WaitGroup
	ramCh := make(chan RamInfo, 10)
	cpuCh := make(chan CpuInfo, 10)
	procesosCh := make(chan ProcesosInfo, 10)

	// Iniciar los recolectores en goroutines
	wg.Add(3)
	go recolectorRam(ramCh, &wg)
	go recolectorCpu(cpuCh, &wg)
	go recolectorProcesos(procesosCh, &wg)
	go unificarMetricas(ramCh, cpuCh, procesosCh)

	// Iniciar servidor Fiber
	app := fiber.New()

	// Endpoint para mostrar métricas
	app.Get("/metrics", func(c *fiber.Ctx) error {
		metrics := <-metricsChan
		return c.JSON(metrics)  // Aquí se expone el JSON de métricas a quien haga la petición GET
	})

	// Endpoint raíz
	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("Recolector en ejecución. Endpoint disponible en /metrics ✅ ")
	})

	// Iniciar el servidor
	port := "8080" // Puerto fijo para pruebas
	fmt.Printf("Servidor Fiber escuchando en http://localhost:%s\n", port)
	log.Fatal(app.Listen(":" + port))

	// Esperar a que los recolectores terminen (aunque en este caso, el programa sigue corriendo)
	wg.Wait()
}

import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import {
  ApexChart,
  ApexNonAxisChartSeries,
  ApexTitleSubtitle,
  NgApexchartsModule
} from 'ng-apexcharts';
import { MetricsService, Metrics } from '../services/metrics.service';
import { CommonModule } from '@angular/common';
import { MatToolbarModule } from '@angular/material/toolbar';

export interface ChartOptions {
  series: ApexNonAxisChartSeries;
  chart: ApexChart;
  labels: string[];
  title: ApexTitleSubtitle;
}

@Component({
  selector: 'app-inicio',
  standalone: true,
  imports: [
    CommonModule,
    NgApexchartsModule,
    MatToolbarModule
  ],
  templateUrl: './inicio.component.html',
  styleUrls: ['./inicio.component.scss']
})
export class InicioComponent implements OnInit, OnDestroy {
  public ramChartOptions: ChartOptions = {
    series: [0, 100],
    chart: {
      type: 'donut',
      width: 380
    },
    labels: ['RAM Usada', 'RAM Libre'],
    title: {
      text: 'RAM: 0% en uso'
    }
  };

  public cpuChartOptions: ChartOptions = {
    series: [0, 100],
    chart: {
      type: 'donut',
      width: 380
    },
    labels: ['CPU Usada', 'CPU Libre'],
    title: {
      text: 'CPU: 0% en uso'
    }
  };

  private intervalId: any;

  constructor(
    private metricsService: MetricsService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.loadMetrics();
    this.intervalId = setInterval(() => this.loadMetrics(), 5000);
  }

  ngOnDestroy(): void {
    clearInterval(this.intervalId);
  }

 loadMetrics(): void {
  this.metricsService.getUltimaMetrica().subscribe({
    next: (data: any) => {
      console.log('Respuesta cruda de la API:', data);

      // Validación de estructura
      if (!data || typeof data !== 'object' || !('cpu_total' in data)) {
        console.warn('Estructura inválida:', data);
        return;
      }

      const ramTotal = Number(data.ram_total);
      const ramUso = Number(data.ram_uso);
      const cpuTotal = Number(data.cpu_total);
      const cpuUso = Number(data.cpu_uso);

      if (
        isNaN(ramTotal) || isNaN(ramUso) ||
        isNaN(cpuTotal) || isNaN(cpuUso) ||
        ramTotal === 0 || cpuTotal === 0
      ) {
        console.warn('Datos incompletos o inválidos recibidos:', data);
        return;
      }

      const ramPorcentaje = +(ramUso / ramTotal * 100).toFixed(2);
      const cpuPorcentaje = +(cpuUso / cpuTotal * 100).toFixed(2);

      this.ramChartOptions = {
        ...this.ramChartOptions,
        series: [ramPorcentaje, 100 - ramPorcentaje],
        title: {
          text: `RAM: ${ramPorcentaje}% en uso`
        }
      };

      this.cpuChartOptions = {
        ...this.cpuChartOptions,
        series: [cpuPorcentaje, 100 - cpuPorcentaje],
        title: {
          text: `CPU: ${cpuPorcentaje}% en uso`
        }
      };

      this.cdr.detectChanges();
    },
    error: (err) => {
      console.error('Error al cargar métricas', err);
    }
  });
}

}

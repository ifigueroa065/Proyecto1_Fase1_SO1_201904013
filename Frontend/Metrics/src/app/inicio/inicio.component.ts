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
      next: (data: Metrics) => {
        const { ram, cpu } = data;

        const ramUso = Number(ram.uso);
        const ramTotal = Number(ram.total);
        const ramPorcentaje = ramTotal > 0
          ? +(ramUso / ramTotal * 100).toFixed(2)
          : 0;

        const cpuUso = Number(cpu.uso);
        const cpuTotal = Number(cpu.total);
        const cpuPorcentaje = cpuTotal > 0
          ? +(cpuUso / cpuTotal * 100).toFixed(2)
          : 0;

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

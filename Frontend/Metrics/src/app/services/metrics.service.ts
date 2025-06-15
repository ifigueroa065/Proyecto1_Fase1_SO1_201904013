import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Metrics {
  cpu: {
    total: number;
  uso: number;
  libre: number;
  porcentaje: number;
  };
  ram: {
    total: number;
    libre: number;
    uso: number;
    porcentaje: number;
  };
}

@Injectable({
  providedIn: 'root'
})
export class MetricsService {
  private apiUrl = `${environment.apiUrl}/metrics`; // Se leerá desde .env

  constructor(private http: HttpClient) {}

  getMetrics(): Observable<Metrics> {
    return this.http.get<Metrics>(this.apiUrl);
  }

  getUltimaMetrica(): Observable<Metrics> {
  return this.http.get<Metrics>(this.apiUrl); // <-- GET /metrics ya debe retornar la última
}



}

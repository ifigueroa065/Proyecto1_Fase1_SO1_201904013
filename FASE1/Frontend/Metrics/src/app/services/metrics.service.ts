import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
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
  private readonly apiUrl: string = `${environment.apiUrl}/metrics`;

  constructor(private http: HttpClient) {
    if (!environment.apiUrl) {
      console.warn('Advertencia: environment.apiUrl está vacío. Revisa tu archivo environment.ts');
    }
  }

  /**
   * Obtiene la última métrica desde el backend
   */
  getUltimaMetrica(): Observable<Metrics> {
    return this.http.get<Metrics>(this.apiUrl).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * Manejador de errores HTTP
   */
  private handleError(error: HttpErrorResponse) {
    if (error.error instanceof ErrorEvent) {
      console.error('Error de cliente:', error.error.message);
    } else {
      console.error(`Error del backend: Código ${error.status}, cuerpo:`, error.error);
    }
    return throwError(() => new Error('No se pudo obtener métricas del servidor.'));
  }
}

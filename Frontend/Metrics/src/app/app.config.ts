import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { NgApexchartsModule } from 'ng-apexcharts'; // Asegúrate de importar NgApexchartsModule
import { routes } from './app.routes';
import { provideHttpClient } from '@angular/common/http';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    provideHttpClient(),
    NgApexchartsModule  // Importar NgApexchartsModule dentro de `providers`
  ]
};

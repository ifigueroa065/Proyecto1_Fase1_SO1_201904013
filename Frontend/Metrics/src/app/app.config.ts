import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { NgApexchartsModule } from 'ng-apexcharts'; // Asegúrate de importar NgApexchartsModule
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(routes),
    NgApexchartsModule  // Importar NgApexchartsModule dentro de `providers`
  ]
};

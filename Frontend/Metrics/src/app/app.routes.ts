import { Routes } from '@angular/router';
import { InicioComponent } from './inicio/inicio.component';

export const routes: Routes = [
     {
    path: '',
    component: InicioComponent,  // Configura el componente Home como la página inicial
    pathMatch: 'full'
  }
];

import { Routes } from '@angular/router';
import { GestionInventarioComponent } from './gestion-inventario/gestion-inventario.component';
import { VentasComponent } from './ventas/ventas.component';
import { AdministracionUsuariosComponent } from './administracion-usuarios/administracion-usuarios.component';
import { BusquedaProductosComponent } from './busqueda-productos/busqueda-productos.component';
import { ReportesComponent } from './reportes/reportes.component';
import { RegistroComponent } from './registro/registro.component';

export const routes: Routes = [
    { path: 'gestion-inventario-component', component: GestionInventarioComponent, title: 'gestion inventario' },
    { path: 'ventas-component', component: VentasComponent, title: 'ventas' },
    { path: 'administracion-usuarios-component', component: AdministracionUsuariosComponent, title: 'administracion de ususarios' },
    { path: 'busqueda-productos-component', component: BusquedaProductosComponent, title: 'busqueda productos' },
    { path: 'reportes-component', component: ReportesComponent, title: 'reportes'},
    { path: 'registro-component', component: RegistroComponent, title: 'registro' }
];
import { Component } from '@angular/core';

@Component({
  selector: 'app-venta-form',
  templateUrl: './busqueda-productos.component.html',
  styleUrl: './busqueda-productos.component.scss',
})
export class BusquedaProductosComponent {
  productos: any[] = [
    { id: 1, nombre: 'Producto 1', precio: 10 },
    { id: 2, nombre: 'Producto 2', precio: 20 },
    { id: 3, nombre: 'Producto 3', precio: 30 },
  ];
  selectedProduct: any;
  cantidad: number = 1;
  total: number = 0;
  metodoPago: string = 'tarjeta';

  calcularTotal() {
    if (this.selectedProduct && this.cantidad) {
      this.total = this.selectedProduct.precio * this.cantidad;
    } else {
      this.total = 0;
    }
  }

  realizarVenta() {
    // Implementar la lógica para realizar la venta
    // (enviar datos al servidor, procesar el pago, etc.)
    console.log('Venta realizada:', {
      producto: this.selectedProduct,
      cantidad: this.cantidad,
      total: this.total,
      metodoPago: this.metodoPago,
    });
  }
}

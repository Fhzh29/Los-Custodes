import { Component, OnInit } from '@angular/core';
import { DataService } from '../data.service';
import { HttpClientModule } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-ventas',
  standalone: true,
  imports: [CommonModule, HttpClientModule, FormsModule],
  templateUrl: './ventas.component.html',
  styleUrls: ['./ventas.component.scss']
})
export class VentasComponent implements OnInit {
  title = 'menu';
  data: any[] = [];
  errorMessage: string = '';
  newItem: any = {};
  selectedItem: any = {};
  products: any[] = [];
  cartItems: any[] = [];
  totalPrice: number = 0;

  constructor(private dataService: DataService) {}

  ngOnInit() {
    this.loadData();
  }

  loadData() {
    this.dataService.getData('Product').subscribe(
      (response) => {
        this.products = response.map((product: { UnitPrice: string; }) => ({
          ...product,
          UnitPrice: parseFloat(product.UnitPrice),
          CurrencyCode: 'PEN'
        }));
      },
      (error) => {
        console.error('Error fetching data:', error);
        this.errorMessage = 'Error fetching data';
      }
    );
  }
  
  
  

  addToCart(product: any): void {
    this.cartItems.push(product);
    this.totalPrice += product.UnitPrice;
  }

  generateReceipt(): void {
    alert('Proof of purchase generated!');
    // Add functionality to generate and display proof of purchase
  }

  isValidPrice(price: any): boolean {
    return typeof price === 'number' && !isNaN(price);
  }
  
}

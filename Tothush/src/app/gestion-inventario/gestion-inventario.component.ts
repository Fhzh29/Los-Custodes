import { HttpClientModule } from '@angular/common/http';
import { Component, ElementRef, ViewChild } from '@angular/core';
import { DataService } from '../data.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-gestion-inventario',
  standalone: true,
  imports: [CommonModule, HttpClientModule, FormsModule],
  templateUrl: './gestion-inventario.component.html',
  styleUrl: './gestion-inventario.component.scss',
  providers: [DataService]
})
export class GestionInventarioComponent {
  title = 'menu';
  data: any[] = [];
  errorMessage: string = '';
  newItem: any = {};
  selectedItem: any = {};

  constructor(private dataService: DataService) {}

  ngOnInit() {
    this.loadData();
  }

  loadData() {
    this.dataService.getData('Product').subscribe(
      (response) => {
        this.data = response;
      },
      (error) => {
        console.error('Error fetching data:', error);
        this.errorMessage = 'Error fetching data';
      }
    );
  }

  openEditModal(item: any): void {
    this.selectedItem = { ...item };
    document.getElementById('editModal')!.style.display = 'block';
  }

  closeEditModal(): void {
    document.getElementById('editModal')!.style.display = 'none';
  }

  updateItem(): void {
    this.dataService.updateData('Product', this.selectedItem.ProductID, this.selectedItem).subscribe(
      (response) => {
        this.loadData(); // Refresh the data
        this.closeEditModal();
      },
      (error) => {
        this.loadData();
        this.closeEditModal();
        // console.error('Error updating item:', error);
        // this.errorMessage = 'Error updating item';
      }
    );
  }  

  openAddModal(): void {
    document.getElementById('addModal')!.style.display = 'block';
  }

  closeAddModal(): void {
    document.getElementById('addModal')!.style.display = 'none';
  }

  addItem(): void {
    this.dataService.insertData('Product', this.newItem).subscribe(
      (response) => {
        this.loadData(); // Refresh the data
        this.closeAddModal();
        this.newItem = {}; // Clear the new item form
      },
      (error) => {
        this.loadData();
        this.closeEditModal();
        // console.error('Error updating item:', error);
        // this.errorMessage = 'Error updating item';
      }
    );
  }

  deleteItem(id: number): void {
    this.dataService.deleteData('Product', id).subscribe(
      (response) => {
        this.loadData(); // Refresh the data
      },
      (error) => {
        this.loadData();
        this.closeEditModal();
        // console.error('Error updating item:', error);
        // this.errorMessage = 'Error updating item';
      }
    );
  }
}

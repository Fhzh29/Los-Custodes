import { HttpClientModule } from '@angular/common/http';
import { Component } from '@angular/core';
import { DataService } from '../data.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-gestion-usuarios',
  standalone: true,
  imports: [CommonModule, HttpClientModule, FormsModule],
  templateUrl: './administracion-usuarios.component.html',
  styleUrl: './administracion-usuarios.component.scss',
  providers: [DataService]
})
export class AdministracionUsuariosComponent {
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
    this.dataService.getData('User').subscribe(
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
    this.dataService.updateData('User', this.selectedItem.UserID, this.selectedItem).subscribe(
      (response) => {
        this.loadData(); // Refresh the data
        this.closeEditModal();
      },
      (error) => {
        console.error('Error updating item:', error);
        this.errorMessage = 'Error updating item';
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
    this.dataService.insertData('User', this.newItem).subscribe(
      (response) => {
        this.loadData(); // Refresh the data
        this.closeAddModal();
        this.newItem = {}; // Clear the new item form
      },
      (error) => {
        console.error('Error adding item:', error);
        this.errorMessage = 'Error adding item';
      }
    );
  }

  deleteItem(id: number): void {
    this.dataService.deleteData('User', id).subscribe(
      (response) => {
        this.loadData(); // Refresh the data
      },
      (error) => {
        console.error('Error deleting item:', error);
        this.errorMessage = 'Error deleting item';
      }
    );
  }
}

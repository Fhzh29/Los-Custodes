import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { Component } from '@angular/core';
import { DataService } from '../data.service';

@Component({
  selector: 'app-registro',
  standalone: true,
  imports: [CommonModule, HttpClientModule],
  templateUrl: './registro.component.html',
  styleUrl: './registro.component.scss'
})
export class RegistroComponent {
  data: any[] = [];
  errorMessage: string = '';

  constructor(private dataService: DataService) {}

  ngOnInit() {
    this.loadData();
  }

  loadData() {
    this.dataService.getData('ActivityLog').subscribe(
      (response) => {
        this.data = response;
      },
      (error) => {
        console.error('Error fetching data:', error);
        this.errorMessage = 'Error fetching data';
      }
    );
  }
}

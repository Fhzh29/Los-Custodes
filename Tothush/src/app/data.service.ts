import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DataService {
  private baseUrl = 'http://localhost:3000/api';

  constructor(private http: HttpClient) {}

  // Get all data from a specific table
  getData(tableName: string): Observable<any> {
    return this.http.get<any>(`${this.baseUrl}/${tableName}`);
  }

  // Insert data into a specific table
  insertData(tableName: string, data: any): Observable<any> {
    return this.http.post<any>(`${this.baseUrl}/${tableName}`, data);
  }

  // Update data in a specific table by id
  updateData(tableName: string, id: number, data: any): Observable<any> {
    return this.http.put<any>(`${this.baseUrl}/${tableName}/${id}`, data);
  }

  // Delete data from a specific table by id
  deleteData(tableName: string, id: number): Observable<any> {
    return this.http.delete<any>(`${this.baseUrl}/${tableName}/${id}`);
  }
}

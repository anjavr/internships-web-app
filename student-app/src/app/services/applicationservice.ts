import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { MyApplication } from '../models/application';

@Injectable({
  providedIn: 'root'
})
export class ApplicationService {

  private apiUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) {}

  getByStudent(studentId: string): Observable<MyApplication[]> {
    return this.http.get<MyApplication[]>(`${this.apiUrl}/applications/student/${studentId}`);
  }
}
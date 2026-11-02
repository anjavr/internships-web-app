import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Internship } from '../models/internship';

@Injectable({
  providedIn: 'root',
})
export class InternshipService {

  private apiURL = 'http://localhost:8080/api';

  constructor(private http: HttpClient) { };

  getAll(): Observable<Internship[]> {
    return this.http.get<Internship[]>(`${this.apiURL}/internships`);
  }

  getById(id: string): Observable<Internship> {
    return this.http.get<Internship>(`${this.apiURL}/internships/${id}`);
  }

  apply(studentId: string, internshipId: string): Observable<any> {
    return this.http.post(`${this.apiURL}/applications`, {
      studentId: studentId,
      internshipId: internshipId
    });
  }

  getApplicationsByStudent(studentId: string): Observable<any[]> {
    return this.http.get<any[]>(`http://localhost:8080/api/applications/student/${studentId}`);
  }
}

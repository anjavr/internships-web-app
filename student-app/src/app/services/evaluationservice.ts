import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Evaluation {
  id: string;
  studentId: string;
  studentName: string;
  internshipId: string;
  internshipTitle: string;
  rating: number;
  comments: string;
  createdAt: string;
}

@Injectable({
  providedIn: 'root'
})
export class EvaluationService {

  private apiUrl = 'http://localhost:8080/api/evaluations';

  constructor(private http: HttpClient) {}

  getByStudentAndInternship(studentId: string, internshipId: string): Observable<Evaluation> {
    return this.http.get<Evaluation>(`${this.apiUrl}/student/${studentId}/internship/${internshipId}`);
  }
}
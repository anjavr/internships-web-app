import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AiRecommendation } from '../models/ai-recommendation';

@Injectable({ providedIn: 'root' })
export class AiRecommendationService {

  private apiUrl = 'http://localhost:8080/api/recommendations';

  constructor(private http: HttpClient) {}

  getRecommendations(studentId: string): Observable<AiRecommendation[]> {
    return this.http.get<AiRecommendation[]>(`${this.apiUrl}/student/${studentId}`);
  }

  generateRecommendations(studentId: string): Observable<AiRecommendation[]> {
    return this.http.post<AiRecommendation[]>(`${this.apiUrl}/student/${studentId}/generate`, {});
  }
}
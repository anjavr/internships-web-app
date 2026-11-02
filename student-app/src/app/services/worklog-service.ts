import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { WorkLog } from '../models/worklog';

@Injectable({
  providedIn: 'root'
})
export class WorkLogService {

  private apiUrl = 'http://localhost:8080/api/worklogs';

  constructor(private http: HttpClient) {}

  fillLog(id: string, worklog: Partial<WorkLog>): Observable<WorkLog> {
    return this.http.put<WorkLog>(`${this.apiUrl}/${id}`, worklog);
  }

  getByStudent(studentId: string): Observable<WorkLog[]> {
    return this.http.get<WorkLog[]>(`${this.apiUrl}/student/${studentId}`);
  }

  getByInternship(internshipId: string): Observable<WorkLog[]> {
    return this.http.get<WorkLog[]>(`${this.apiUrl}/internship/${internshipId}`);
  }

  getByDiary(diaryId: string): Observable<WorkLog[]> {
    return this.http.get<WorkLog[]>(`${this.apiUrl}/diary/${diaryId}`);
  }

  addFeedback(id: string, feedback: string): Observable<WorkLog> {
    return this.http.patch<WorkLog>(`${this.apiUrl}/${id}/feedback`, { feedback });
  }
}
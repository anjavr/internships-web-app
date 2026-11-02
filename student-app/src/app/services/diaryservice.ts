import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface InternshipDiary {
  id: string;
  studentId: string;
  studentName: string;
  internshipId: string;
  internshipTitle: string;
  companyName: string;
  status: 'IN_PROGRESS' | 'FEEDBACK_DONE' | 'SUBMITTED' | 'EVALUATED';
  submittedAt?: string;
  createdAt: string;
}

@Injectable({
  providedIn: 'root'
})
export class DiaryService {

  private apiUrl = 'http://localhost:8080/api/diaries';

  constructor(private http: HttpClient) {}

  getByStudent(studentId: string): Observable<InternshipDiary[]> {
    return this.http.get<InternshipDiary[]>(`${this.apiUrl}/student/${studentId}`);
  }

  getByStudentAndInternship(studentId: string, internshipId: string): Observable<InternshipDiary> {
    return this.http.get<InternshipDiary>(`${this.apiUrl}/student/${studentId}/internship/${internshipId}`);
  }

  submit(diaryId: string): Observable<InternshipDiary> {
    return this.http.patch<InternshipDiary>(`${this.apiUrl}/${diaryId}/submit`, {});
  }
}
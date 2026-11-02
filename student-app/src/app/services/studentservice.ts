import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Student, Skill, Interest } from '../models/student';
import { HttpInterceptorFn } from '@angular/common/http';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const token = localStorage.getItem('token');
  if (token) {
    const cloned = req.clone({
      headers: req.headers.set('Authorization', `Bearer ${token}`)
    });
    return next(cloned);
  }
  return next(req);
};

@Injectable({
  providedIn: 'root'
})
export class StudentService {

  private apiUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) {}

  getById(id: string): Observable<Student> {
    return this.http.get<Student>(`${this.apiUrl}/students/${id}`);
  }

  update(id: string, student: Student): Observable<Student> {
    return this.http.put<Student>(`${this.apiUrl}/students/${id}`, student);
  }

  uploadPhoto(id: string, file: File): Observable<string> {
    const formData = new FormData();
    formData.append('file', file);
    return this.http.post(`${this.apiUrl}/students/${id}/photo`, formData,
        { responseType: 'text' });
  }

  addSkill(studentId: string, skill: Skill): Observable<Skill> {
    return this.http.post<Skill>(`${this.apiUrl}/students/${studentId}/skills`, skill);
  }

  deleteSkill(studentId: string, skillId: string): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/students/${studentId}/skills/${skillId}`);
  }

  addInterest(studentId: string, interest: Interest): Observable<Interest> {
    return this.http.post<Interest>(`${this.apiUrl}/students/${studentId}/interests`, interest);
  }

  deleteInterest(studentId: string, interestId: string): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/students/${studentId}/interests/${interestId}`);
  }
}
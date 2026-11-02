import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private apiUrl = 'http://localhost:8080/api/auth';

  constructor(private http: HttpClient) { }

  login(username: string, password: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/login`, { username, password, role: 'STUDENT' }).pipe(
      tap((response: any) => {
        console.log('LOGIN RESPONSE:', response);
        localStorage.setItem('token', response.token);
        localStorage.setItem('studentId', response.userId);
        localStorage.setItem('username', username);
      })
    );
  }

  logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('studentId');
  }

  isLoggedIn(): boolean {
    return !!localStorage.getItem('token');
  }

  getUsername(): string {
    return localStorage.getItem('username') || '';
  }
}
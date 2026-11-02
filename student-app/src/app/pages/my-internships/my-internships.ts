import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTabsModule } from '@angular/material/tabs';
import { MatChipsModule } from '@angular/material/chips';
import { MatDividerModule } from '@angular/material/divider';
import { DatePipe } from '@angular/common';

import { ApplicationService } from '../../services/applicationservice';
import { MyApplication } from '../../models/application';

@Component({
  selector: 'app-my-internships',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatTabsModule,
    MatChipsModule,
    MatDividerModule,
  ],
  providers: [DatePipe],
  templateUrl: './my-internships.html',
  styleUrl: './my-internships.css'
})
export class MyInternshipsComponent implements OnInit {

  applications: MyApplication[] = [];
  studentId: string = localStorage.getItem('studentId') || '';

  constructor(private applicationService: ApplicationService, private datePipe: DatePipe, private cdr: ChangeDetectorRef) { }

  ngOnInit() {
    this.loadApplications();
  }

  loadApplications() {
    this.applicationService.getByStudent(this.studentId).subscribe({
      next: (data) => {
        this.applications = data;
        this.cdr.detectChanges();
      },
      error: () => console.error('Greška pri učitavanju prijava')
    });
  }

  formatDate(date: string): string {
    if (!date) return '-';
    return this.datePipe.transform(date, 'dd.MM.yyyy') || date;
  }

  get applied() {
    return this.applications.filter(a => a.applicationStatus === 'APPLIED');
  }

  get accepted() {
    return this.applications.filter(a => a.applicationStatus === 'ACCEPTED');
  }

  get rejected() {
    return this.applications.filter(a => a.applicationStatus === 'REJECTED');
  }

  getStatusLabel(status: string): string {
    const map: any = {
      'APPLIED': 'U razmatranju',
      'ACCEPTED': 'Prihvaćena',
      'REJECTED': 'Odbijena'
    };
    return map[status] || status;
  }

  getStatusClass(status: string): string {
    const map: any = {
      'APPLIED': 'status-applied',
      'ACCEPTED': 'status-accepted',
      'REJECTED': 'status-rejected'
    };
    return map[status] || '';
  }

  getStatusIcon(status: string): string {
    const map: any = {
      'APPLIED': 'hourglass_empty',
      'ACCEPTED': 'check_circle',
      'REJECTED': 'cancel'
    };
    return map[status] || 'info';
  }

  getWorkTypeLabel(type: string): string {
    const map: any = {
      'ON_SITE': 'Na licu mjesta',
      'REMOTE': 'Remote',
      'HYBRID': 'Hibridno'
    };
    return map[type] || type;
  }

  getWorkTypeClass(type: string): string {
    const map: any = {
      'ON_SITE': 'badge-onsite',
      'REMOTE': 'badge-remote',
      'HYBRID': 'badge-hybrid'
    };
    return map[type] || '';
  }
}
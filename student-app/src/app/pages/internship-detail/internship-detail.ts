// internship-detail.ts
import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterModule } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatChipsModule } from '@angular/material/chips';
import { MatDividerModule } from '@angular/material/divider';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { Internship } from '../../models/internship';
import { InternshipService } from '../../services/internshipservice';

@Component({
  selector: 'app-internship-detail',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatButtonModule,
    MatIconModule,
    MatCardModule,
    MatChipsModule,
    MatDividerModule,
    MatSnackBarModule
  ],
  templateUrl: './internship-detail.html',
  styleUrl: './internship-detail.css'
})
export class InternshipDetailComponent implements OnInit {

  internship!: Internship;
  applied: boolean = false;
  studentId: string = localStorage.getItem('studentId') || '';

  constructor(
    private route: ActivatedRoute,
    private internshipService: InternshipService,
    private snackBar: MatSnackBar,
    private cdr: ChangeDetectorRef
  ) { }

  ngOnInit() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.internshipService.getById(id).subscribe({
        next: (data) => {
          this.internship = data;
          this.checkIfApplied(id);
          this.cdr.detectChanges();
        },
        error: () => {
          this.snackBar.open('Greška pri učitavanju prakse', 'OK', { duration: 3000 });
        }
      });
    }
  }

  checkIfApplied(internshipId: string) {
    this.internshipService.getApplicationsByStudent(this.studentId).subscribe({
      next: (applications) => {
        this.applied = applications.some(a => a.internshipId === internshipId);
        this.cdr.detectChanges();
      },
      error: () => { }
    });
  }

  apply() {
    this.internshipService.apply(this.studentId, this.internship.id).subscribe({
      next: () => {
        this.applied = true;
        this.snackBar.open('Uspješno ste se prijavili!', 'OK', { duration: 3000 });
      },
      error: () => this.snackBar.open('Greška pri prijavi', 'OK', { duration: 3000 })
    });
  }

  getTechnologies(): string[] {
    if (!this.internship?.technologies) return [];
    try { return JSON.parse(this.internship.technologies); }
    catch { return this.internship.technologies.split(',').map(t => t.trim()); }
  }

  getLanguages(): string[] {
    if (!this.internship?.requiredLanguages) return [];
    try { return JSON.parse(this.internship.requiredLanguages); }
    catch { return this.internship.requiredLanguages.split(',').map(l => l.trim()); }
  }

  getAdditionalRequirements(): string[] {
    if (!this.internship?.additionalRequirements) return [];
    try { return JSON.parse(this.internship.additionalRequirements); }
    catch { return [this.internship.additionalRequirements]; }
  }

  getWorkTypeLabel(): string {
    const map: any = {
      'ON_SITE': 'Na lokaciji',
      'REMOTE': 'Remote',
      'HYBRID': 'Hibridno'
    };
    return map[this.internship?.workType] || this.internship?.workType || '';
  }

  getWorkTypeClass(): string {
    const map: any = {
      'ON_SITE': 'badge-onsite',
      'REMOTE': 'badge-remote',
      'HYBRID': 'badge-hybrid'
    };
    return map[this.internship?.workType] || '';
  }

  getRequiredYearLabel(): string {
    const map: any = {
      '1': 'I godina',
      '2': 'II godina',
      '3': 'III godina',
      '4': 'IV godina',
      'ANY': 'Bilo koja godina'
    };
    return map[this.internship?.requiredYear] || this.internship?.requiredYear || '';
  }

  getAvailablePositions(): number {
    if (!this.internship) return 0;
    return (this.internship.positions || 0) - (this.internship.takenPositions || 0);
  }
}
import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { AiRecommendation } from '../../models/ai-recommendation';
import { AiRecommendationService } from '../../services/airecommendationservice';
import { MatDividerModule } from '@angular/material/divider';

@Component({
  selector: 'app-ai-recommendations',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    MatDividerModule
  ],
  templateUrl: './ai-recommendations.html',
  styleUrl: './ai-recommendations.css'
})
export class AiRecommendationsComponent implements OnInit {

  recommendations: AiRecommendation[] = [];
  loading = false;
  generating = false;
  studentId = localStorage.getItem('studentId') || '';

  constructor(
    private aiService: AiRecommendationService,
    private snackBar: MatSnackBar,
    private cdr: ChangeDetectorRef
  ) { }

  ngOnInit() {
    this.loadRecommendations();
  }

  loadRecommendations() {
    this.loading = true;
    this.aiService.getRecommendations(this.studentId).subscribe({
      next: (data) => {
        this.recommendations = data;
        this.loading = false;
        this.cdr.detectChanges();
      },
      error: () => {
        this.loading = false;
        this.cdr.detectChanges();
        this.snackBar.open('Greška pri učitavanju preporuka', 'OK', { duration: 3000 });
      }
    });
  }

  generate() {
    this.generating = true;
    this.aiService.generateRecommendations(this.studentId).subscribe({
      next: (data) => {
        this.recommendations = data;
        this.generating = false;
        this.cdr.detectChanges();
        this.snackBar.open('Preporuke generisane!', 'OK', { duration: 3000 });
      },
      error: () => {
        this.generating = false;
        this.cdr.detectChanges();
        this.snackBar.open('Greška pri generisanju preporuka', 'OK', { duration: 3000 });
      }
    });
  }

  getScorePercent(score: number): number {
    return Math.round(score * 100);
  }

  getScoreColor(score: number): string {
    if (score >= 0.8) return '#2e7d32';
    if (score >= 0.6) return '#f57c00';
    return '#c62828';
  }

  getTechnologies(tech: string): string[] {
    if (!tech) return [];
    try { return JSON.parse(tech); }
    catch { return tech.split(',').map(t => t.trim()); }
  }

  getWorkTypeLabel(type: string): string {
    const map: any = {
      'ON_SITE': 'Na lokaciji',
      'REMOTE': 'Remote',
      'HYBRID': 'Hibridno'
    };
    return map[type] || type;
  }
}
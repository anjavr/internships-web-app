import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatDividerModule } from '@angular/material/divider';
import { MatChipsModule } from '@angular/material/chips';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { WorkLog } from '../../models/worklog';
import { WorkLogService } from '../../services/worklog-service';
import { ApplicationService } from '../../services/applicationservice';
import { DiaryService, InternshipDiary } from '../../services/diaryservice';
import { EvaluationService, Evaluation } from '../../services/evaluationservice';
import { MatTooltipModule } from '@angular/material/tooltip';
import { Subscription } from 'rxjs';

interface AcceptedInternship {
  id: string;
  title: string;
  companyName: string;
  startDate: string;
  endDate: string;
}

@Component({
  selector: 'app-worklog',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatDividerModule,
    MatChipsModule,
    MatSnackBarModule,
    MatTooltipModule
  ],
  templateUrl: './worklog.html',
  styleUrl: './worklog.css'
})
export class WorklogComponent implements OnInit, OnDestroy {

  studentId: string = localStorage.getItem('studentId') || '';
  selectedInternshipId: string = '';
  worklogForm: FormGroup;

  acceptedInternships: AcceptedInternship[] = [];
  worklogs: WorkLog[] = [];
  currentDiary: InternshipDiary | null = null;
  currentEvaluation: Evaluation | null = null;

  editingLogId: string | null = null;
  loading: boolean = true;
  loadingWorklogs: boolean = false;

  private subs: Subscription = new Subscription();

  constructor(
    private fb: FormBuilder,
    private workLogService: WorkLogService,
    private applicationService: ApplicationService,
    private diaryService: DiaryService,
    private evaluationService: EvaluationService,
    private snackBar: MatSnackBar,
    private cdr: ChangeDetectorRef
  ) {
    this.worklogForm = this.fb.group({
      activities: ['', [Validators.required, Validators.minLength(20)]],
      hours: [null, [Validators.required, Validators.min(1), Validators.max(60)]]
    });
  }

  ngOnInit() {
    this.loadAcceptedInternships();
  }

  ngOnDestroy() {
    this.subs.unsubscribe();
  }

  loadAcceptedInternships() {
    this.loading = true;
    this.acceptedInternships = [];
    this.worklogs = [];
    this.currentDiary = null;
    this.currentEvaluation = null;
    this.selectedInternshipId = '';

    const sub = this.applicationService.getByStudent(this.studentId).subscribe({
      next: (applications) => {
        this.acceptedInternships = applications
          .filter(a => a.applicationStatus === 'ACCEPTED')
          .map(a => ({
            id: a.internshipId,
            title: a.internshipTitle,
            companyName: a.companyName,
            startDate: a.startDate,
            endDate: a.endDate
          }));
        this.loading = false;
        this.cdr.detectChanges(); // dodaj ovo
      },
      error: () => {
        this.showMessage('Greška pri učitavanju praksi');
        this.loading = false;
        this.cdr.detectChanges(); // dodaj ovo
      }
    });
    this.subs.add(sub);
  }

  loadDiary() {
    if (!this.selectedInternshipId) return;
    const sub = this.diaryService.getByStudentAndInternship(this.studentId, this.selectedInternshipId).subscribe({
      next: (diary) => {
        this.currentDiary = diary;
        if (diary.status === 'EVALUATED') {
          this.loadEvaluation();
        }
      },
      error: () => this.showMessage('Greška pri učitavanju dnevnika')
    });
    this.subs.add(sub);
  }

  loadWorklogs() {
    if (!this.selectedInternshipId) return;
    this.loadingWorklogs = true;
    const sub = this.workLogService.getByStudent(this.studentId).subscribe({
      next: (data) => {
        this.worklogs = data.filter(w => w.internshipId === this.selectedInternshipId);
        this.loadingWorklogs = false;
      },
      error: () => {
        this.showMessage('Greška pri učitavanju dnevnika');
        this.loadingWorklogs = false;
      }
    });
    this.subs.add(sub);
  }

  loadEvaluation() {
    if (!this.selectedInternshipId) return;
    const sub = this.evaluationService.getByStudentAndInternship(
      this.studentId, this.selectedInternshipId
    ).subscribe({
      next: (evaluation) => this.currentEvaluation = evaluation,
      error: () => this.currentEvaluation = null
    });
    this.subs.add(sub);
  }

  onInternshipChange() {
    this.worklogForm.reset();
    this.editingLogId = null;
    this.currentDiary = null;
    this.currentEvaluation = null;
    this.worklogs = [];
    this.loadDiary();
    this.loadWorklogs();
  }

  saveLog(log: WorkLog) {
    if (this.worklogForm.valid && log.id) {
      const sub = this.workLogService.fillLog(log.id, {
        activities: this.worklogForm.value.activities,
        hours: this.worklogForm.value.hours
      }).subscribe({
        next: (saved) => {
          this.worklogs = this.worklogs.map(w => w.id === saved.id ? saved : w);
          this.worklogForm.reset();
          this.editingLogId = null;
          this.showMessage('Unos sačuvan');
        },
        error: () => this.showMessage('Greška pri čuvanju')
      });
      this.subs.add(sub);
    }
  }

  submitDiary() {
    if (!this.currentDiary) return;
    const sub = this.diaryService.submit(this.currentDiary.id).subscribe({
      next: (diary) => {
        this.currentDiary = diary;
        this.showMessage('Dnevnik uspješno predan');
      },
      error: () => this.showMessage('Greška pri predaji dnevnika')
    });
    this.subs.add(sub);
  }

  isDiaryEditable(): boolean {
    return this.currentDiary?.status === 'IN_PROGRESS' ||
      this.currentDiary?.status === 'FEEDBACK_DONE';
  }

  isFilled(log: WorkLog): boolean {
    return !!(log.activities && log.hours);
  }

  isFuture(log: WorkLog): boolean {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    return new Date(log.weekStartDate) > today;
  }

  getSortedLogs(): WorkLog[] {
    return [...this.worklogs].sort((a, b) =>
      new Date(a.weekStartDate).getTime() - new Date(b.weekStartDate).getTime()
    );
  }

  getFilledLogsCount(): number {
    return this.worklogs.filter(w => this.isFilled(w)).length;
  }

  startEditLog(log: WorkLog) {
    this.editingLogId = log.id || null;
    this.worklogForm.patchValue({
      activities: log.activities,
      hours: log.hours
    });
  }

  cancelEditLog() {
    this.editingLogId = null;
    this.worklogForm.reset();
  }

  getWeekNumber(dateStr: string): number {
    if (!this.selectedInternshipId) return 0;
    const internship = this.acceptedInternships.find(i => i.id === this.selectedInternshipId);
    if (!internship) return 0;
    const start = new Date(internship.startDate);
    const logDate = new Date(dateStr);
    const diff = Math.floor((logDate.getTime() - start.getTime()) / (7 * 24 * 60 * 60 * 1000));
    return diff + 1;
  }

  getSelectedInternship(): AcceptedInternship | undefined {
    return this.acceptedInternships.find(i => i.id === this.selectedInternshipId);
  }

  formatDate(dateStr: string): string {
    const d = new Date(dateStr);
    return d.toLocaleDateString('sr-Latn-BA', { day: 'numeric', month: 'short', year: 'numeric' });
  }

  showMessage(msg: string) {
    this.snackBar.open(msg, 'OK', { duration: 3000 });
  }

  isDiarySubmittable(): boolean {
    if (!this.currentDiary) return false;

    const status = this.currentDiary.status;
    if (status !== 'IN_PROGRESS' && status !== 'FEEDBACK_DONE') return false;

    const internship = this.getSelectedInternship();
    if (!internship) return false;

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const endDate = new Date(internship.endDate);
    if (endDate >= today) return false;

    const allFilled = this.worklogs.every(w => this.isFilled(w));
    if (!allFilled) return false;

    return true;
  }

  isPracticeStarted(): boolean {
    const internship = this.getSelectedInternship();
    if (!internship) return false;
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    return new Date(internship.startDate) <= today;
  }

  getRatingStars(rating: number): number[] {
    return Array(rating).fill(0);
  }
}
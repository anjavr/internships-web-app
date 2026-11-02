import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { MatTabsModule } from '@angular/material/tabs';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatCardModule } from '@angular/material/card';
import { MatSelectModule } from '@angular/material/select';
import { MatSnackBarModule, MatSnackBar } from '@angular/material/snack-bar';
import { MatDividerModule } from '@angular/material/divider';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatNativeDateModule } from '@angular/material/core';
import { ChangeDetectorRef } from '@angular/core';
import { Observable } from 'rxjs';
import { StudentService } from '../../services/studentservice';
import { Student, Skill, Interest, EuropassJson, Education, Experience } from '../../models/student';

@Component({
  selector: 'app-cv',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatTabsModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatIconModule,
    MatCardModule,
    MatSelectModule,
    MatSnackBarModule,
    MatDividerModule,
    MatDatepickerModule,
    MatNativeDateModule
  ],
  templateUrl: './cv.html',
  styleUrl: './cv.css'
})
export class CvComponent implements OnInit {

  studentId: string = localStorage.getItem('studentId') || '';
  student!: Student;

  generalForm!: FormGroup;
  educationForm!: FormGroup;
  experienceForm!: FormGroup;
  skillForm!: FormGroup;
  interestForm!: FormGroup;

  educationList: Education[] = [];
  experienceList: Experience[] = [];
  skills: Skill[] = [];
  interests: Interest[] = [];

  selectedPhoto: File | null = null;
  photoPreview: string | null = null;


  constructor(
    private fb: FormBuilder,
    private studentService: StudentService,
    private snackBar: MatSnackBar,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit() {
    this.initForms();
    this.loadStudent();
  }

  initForms() {
    this.generalForm = this.fb.group({
      fullName: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      phone: [''],
      address: [''],
      summary: ['']
    });

    this.educationForm = this.fb.group({
      institution: ['', Validators.required],
      degree: ['', Validators.required],
      field: ['', Validators.required],
      startDate: ['', Validators.required],
      endDate: ['']
    });

    this.experienceForm = this.fb.group({
      company: ['', Validators.required],
      position: ['', Validators.required],
      startDate: ['', Validators.required],
      endDate: [''],
      description: ['']
    });

    this.skillForm = this.fb.group({
      name: ['', Validators.required],
      level: ['', Validators.required]
    });

    this.interestForm = this.fb.group({
      name: ['', Validators.required]
    });
  }

  loadStudent() {
    this.studentService.getById(this.studentId).subscribe({
      next: (student) => {
        this.student = student;
        this.skills = student.skills || [];
        this.interests = student.interests || [];

        this.generalForm.patchValue({
          fullName: student.fullName,
          email: student.email,
          phone: student.phone,
          address: student.address,
          summary: student.summary
        });

        if (student.photoPath) {
          this.photoPreview = `http://localhost:8080/${student.photoPath}`;
          console.log('PHOTO URL:', this.photoPreview);
        }

        if (student.europassJson) {
          const europass: EuropassJson = JSON.parse(student.europassJson);
          this.educationList = europass.education || [];
          this.experienceList = europass.experience || [];
        }
      },
      error: () => this.showMessage('Greška pri učitavanju podataka')
    });
  }

  saveGeneral() {
    if (this.generalForm.valid) {
      const updated: Student = {
        ...this.student,
        ...this.generalForm.value
      };

      this.studentService.update(this.studentId, updated).subscribe({
        next: () => this.showMessage('Podaci sačuvani'),
        error: () => this.showMessage('Greška pri čuvanju')
      });
    }
  }

  onPhotoSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.selectedPhoto = file;

      const reader = new FileReader();
      reader.onload = (e) => this.photoPreview = e.target?.result as string;
      reader.readAsDataURL(file);
    }
  }

  uploadPhoto() {
    if (this.selectedPhoto) {
      this.studentService.uploadPhoto(this.studentId, this.selectedPhoto).subscribe({
        next: (path: string) => {
          this.photoPreview = `http://localhost:8080/${path}`;
          this.selectedPhoto = null;
          this.showMessage('Slika uspješno uploadovana');
        },
        error: (err) => {
          console.log('UPLOAD ERROR:', err);
          this.showMessage('Greška pri uploadu slike');
        }
      });
    }
  }

  addEducation() {
    if (this.educationForm.valid) {
      this.educationList.push(this.educationForm.value);
      this.saveEuropass();
      this.educationForm.reset();
    }
  }

  removeEducation(index: number) {
    this.educationList.splice(index, 1);
    this.saveEuropass();
  }

  addExperience() {
    if (this.experienceForm.valid) {
      this.experienceList.push(this.experienceForm.value);
      this.saveEuropass();
      this.experienceForm.reset();
    }
  }

  removeExperience(index: number) {
    this.experienceList.splice(index, 1);
    this.saveEuropass();
  }

  saveEuropass() {
    const europass: EuropassJson = {
      education: this.educationList,
      experience: this.experienceList
    };

    const updated: Student = {
      ...this.student,
      europassJson: JSON.stringify(europass)
    };

    this.studentService.update(this.studentId, updated).subscribe({
      next: () => this.showMessage('Sačuvano'),
      error: () => this.showMessage('Greška')
    });
  }

  addSkill() {
    if (this.skillForm.valid) {
      const skill: Skill = this.skillForm.value;

      this.studentService.addSkill(this.studentId, skill).subscribe({
        next: (saved) => {
          this.skills = [...this.skills, saved];
          this.skillForm.reset();
          this.showMessage('Vještina dodana');
        },
        error: () => this.showMessage('Greška')
      });
    }
  }

  removeSkill(skill: Skill) {
  if (skill.id) {
    this.studentService.deleteSkill(this.studentId, skill.id).subscribe({
      next: () => {
        this.skills = this.skills.filter(s => s.id !== skill.id);
        this.cdr.detectChanges();
        this.showMessage('Obrisano');
      },
      error: () => this.showMessage('Greška pri brisanju')
    });
  }
}


  addInterest() {
    if (this.interestForm.valid) {
      const interest: Interest = this.interestForm.value;

      this.studentService.addInterest(this.studentId, interest).subscribe({
        next: (saved) => {
          this.interests.push(saved);
          this.interestForm.reset();
          this.showMessage('Dodano');
        }
      });
    }
  }

  removeInterest(interest: Interest) {
  if (interest.id) {
    this.studentService.deleteInterest(this.studentId, interest.id).subscribe({
      next: () => {
        this.interests = this.interests.filter(i => i.id !== interest.id);
        this.cdr.detectChanges();
        this.showMessage('Obrisano');
      },
      error: () => this.showMessage('Greška pri brisanju')
    });
  }
}

  showMessage(msg: string) {
    this.snackBar.open(msg, 'OK', { duration: 3000 });
  }

}
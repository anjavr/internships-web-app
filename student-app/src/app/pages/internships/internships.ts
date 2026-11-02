import { Component, OnInit, ViewChild, AfterViewInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { MatTableModule, MatTableDataSource } from '@angular/material/table';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatChipsModule } from '@angular/material/chips';
import { MatSelectModule } from '@angular/material/select';
import { MatPaginatorModule, MatPaginator } from '@angular/material/paginator';
import { MatTooltipModule } from '@angular/material/tooltip';

import { Internship } from '../../models/internship';
import { InternshipService } from '../../services/internshipservice';

@Component({
  selector: 'app-internships',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    FormsModule,
    MatTableModule,
    MatInputModule,
    MatFormFieldModule,
    MatButtonModule,
    MatIconModule,
    MatChipsModule,
    MatSelectModule,
    MatPaginatorModule,
    MatTooltipModule
  ],
  templateUrl: './internships.html',
  styleUrl: './internships.css'
})
export class InternshipsComponent implements OnInit, AfterViewInit {

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  searchQuery: string = '';
  selectedCompany: string = '';
  selectedTechnology: string = '';
  showFilters: boolean = false;
  technologies: string[] = [];

  displayedColumns: string[] = ['title', 'company', 'location', 'workType', 'period', 'positions', 'actions'];

  allInternships: Internship[] = [];
  dataSource = new MatTableDataSource<Internship>();
  companies: string[] = [];

  constructor(private internshipService: InternshipService) {}

  ngOnInit() {
    this.loadInternships();
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
  }

  loadInternships() {
    this.internshipService.getAll().subscribe({
      next: (data) => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  this.allInternships = data.filter(i => {
    if (!i.applicationDeadline) return false;
    return new Date(i.applicationDeadline) >= today;
  });
  
  this.dataSource.data = this.allInternships;
  this.dataSource.paginator = this.paginator;
  this.companies = [...new Set(this.allInternships.map(i => i.companyName).filter(c => !!c))].sort();
  this.technologies = [...new Set(
    this.allInternships.flatMap(i => this.getTechnologies(i.technologies)).filter(t => t.length > 0)
  )].sort();
},
      error: (err) => console.error('Greška pri učitavanju praksi', err)
    });
  }

  applyFilters() {
    this.dataSource.data = this.allInternships.filter(internship => {
      const query = this.searchQuery.toLowerCase();

      const matchesSearch = !query ||
        internship.title?.toLowerCase().includes(query) ||
        internship.companyName?.toLowerCase().includes(query) ||
        (internship.location || '').toLowerCase().includes(query) ||
        this.getWorkTypeLabel(internship.workType).toLowerCase().includes(query) ||
        this.getTechnologies(internship.technologies)
          .some(t => t.toLowerCase().includes(query));

      const matchesCompany = !this.selectedCompany ||
        internship.companyName === this.selectedCompany;

      const matchesTechnology = !this.selectedTechnology ||
        this.getTechnologies(internship.technologies)
            .some(t => t.toLowerCase() === this.selectedTechnology.toLowerCase());

      return matchesSearch && matchesCompany && matchesTechnology;
    });

    if (this.paginator) {
      this.paginator.firstPage();
    }
  }

  resetFilters() {
    this.searchQuery = '';
    this.selectedCompany = '';
    this.selectedTechnology = '';
    this.dataSource.data = [...this.allInternships];
    if (this.paginator) {
      this.paginator.firstPage();
    }
  }

  getTechnologies(tech: string): string[] {
    if (!tech) return [];
    try { return JSON.parse(tech); }
    catch { return tech.split(',').map(t => t.trim()).filter(t => t.length > 0); }
  }

  getWorkTypeLabel(type: string): string {
    const map: any = {
      'ON_SITE': 'Na lokaciji',
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

  getAvailablePositions(internship: Internship): number {
    return (internship.positions || 0) - (internship.takenPositions || 0);
  }
}
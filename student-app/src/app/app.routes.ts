import { Routes } from '@angular/router';
import { LoginComponent } from './pages/login/login';
import { DashboardComponent } from './pages/dashboard/dashboard';
import { CvComponent } from './pages/cv/cv';
import { InternshipsComponent } from './pages/internships/internships';
import { MyInternshipsComponent } from './pages/my-internships/my-internships';
import { AiRecommendationsComponent } from './pages/ai-recommendations/ai-recommendations';
import { WorklogComponent } from './pages/worklog/worklog';
import { InternshipDetailComponent } from './pages/internship-detail/internship-detail';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from './services/auth';
import { authGuard } from './guards/auth.guard';


export const routes: Routes = [
    { path: '', redirectTo: 'login', pathMatch: 'full' },
    { path: 'login', component: LoginComponent },
    {
        path: 'dashboard',
        component: DashboardComponent,
        canActivate: [authGuard],
        children: [
            { path: '', redirectTo: 'cv', pathMatch: 'full' },
            { path: 'cv', component: CvComponent },
            { path: 'internships', component: InternshipsComponent },
            { path: 'internships/:id', component: InternshipDetailComponent },
            { path: 'my-internships', component: MyInternshipsComponent },
            { path: 'ai-recommendations', component: AiRecommendationsComponent },
            { path: 'worklog', component: WorklogComponent },
        ]
    }
];
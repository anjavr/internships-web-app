export interface WorkLog {
  id?: string;
  studentId: string;
  internshipId: string;
  internshipTitle?: string;
  weekStartDate: string;
  activities: string;
  hours: number;
  supervisorFeedback?: string;
  createdAt?: string;
}
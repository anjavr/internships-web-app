export interface MyApplication {
  id: string;
  internshipId: string;
  internshipTitle: string;
  companyName: string;
  location: string;
  workType: string;
  startDate: string;
  endDate: string;
  appliedAt: string;
  applicationStatus: 'APPLIED' | 'ACCEPTED' | 'REJECTED';
  note: string;
}
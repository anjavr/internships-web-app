export interface AiRecommendation {
  id: string;
  internshipId: string;
  internshipTitle: string;
  companyName: string;
  score: number;
  explanation: string;
  location: string;
  workType: string;
  technologies: string;
}
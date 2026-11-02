export interface Internship{
    id: string;
    title: string;
    shortDesc: string;
    description: string;
    technologies: string;
    requirements: string;
    minGpa: number;
    requiredYear: string;
    requiredLanguages: string;
    additionalRequirements: string;
    startDate: string;
    endDate: string;
    applicationDeadline: string;
    positions: number;
    takenPositions: number;
    location: string;
    workType: string;
    isActive: boolean;
    companyId: string;
    companyName: string;
}
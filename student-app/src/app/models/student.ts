export interface Skill {
  id?: string;
  name: string;
  level: string;
}

export interface Interest {
  id?: string;
  name: string;
}

export interface Education {
  institution: string;
  degree: string;
  field: string;
  startDate: string;
  endDate?: string;
}

export interface Experience {
  company: string;
  position: string;
  startDate: string;
  endDate?: string;
  description?: string;
}

export interface EuropassJson {
  education: Education[];
  experience: Experience[];
}

export interface Student {
  id?: string;
  fullName: string;
  phone: string;
  address: string;
  summary: string;
  europassJson: string;
  photoPath: string;
  username?: string;
  email?: string;
  skills: Skill[];
  interests: Interest[];
}
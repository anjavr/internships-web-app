CREATE DATABASE praksa_db;
USE praksa_db;

CREATE TABLE users (
  id CHAR(36) PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  role ENUM('STUDENT','COMPANY','FACULTY', 'ADMIN') NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  INDEX idx_users_username (username),
  INDEX idx_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE students (
  id CHAR(36) PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  phone VARCHAR(50) DEFAULT NULL,
  address TEXT DEFAULT NULL,
  summary TEXT DEFAULT NULL,
  europass_json JSON DEFAULT NULL,
  photo_path VARCHAR(500) DEFAULT NULL,
  CONSTRAINT fk_students_user FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_students_full_name (full_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE companies (
  id CHAR(36) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  contact_email VARCHAR(255) DEFAULT NULL,
  contact_phone VARCHAR(50) DEFAULT NULL,
  address TEXT DEFAULT NULL,
  CONSTRAINT fk_companies_user FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_companies_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE faculties (
  id CHAR(36) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50) UNIQUE,
  contact_email VARCHAR(255),
  CONSTRAINT fk_faculties_user FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE internships (
  id CHAR(36) PRIMARY KEY,
  company_id CHAR(36) NOT NULL,
  title VARCHAR(255) NOT NULL,
  short_desc VARCHAR(500) DEFAULT NULL,
  description TEXT DEFAULT NULL,
  technologies JSON DEFAULT NULL,
  requirements TEXT DEFAULT NULL,
  min_gpa DECIMAL(3,2) DEFAULT NULL,
  required_year ENUM('1', '2', '3', '4', 'ANY') DEFAULT 'ANY',
  required_languages JSON DEFAULT NULL,
  additional_requirements JSON DEFAULT NULL, /* ako bude potrebno poslije */
  start_date DATE DEFAULT NULL,
  end_date DATE DEFAULT NULL,
  application_deadline DATE DEFAULT NULL,
  positions INT DEFAULT 1,
  taken_positions INT DEFAULT 0,
  location VARCHAR(255) DEFAULT NULL,
  work_type ENUM('REMOTE', 'ON_SITE', 'HYBRID') DEFAULT 'ON_SITE',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_internships_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
  INDEX idx_internships_company (company_id),
  INDEX idx_internships_filters (is_active, required_year, min_gpa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE applications (
  id CHAR(36) PRIMARY KEY,
  internship_id CHAR(36) NOT NULL,
  student_id CHAR(36) NOT NULL,
  status ENUM('APPLIED','ACCEPTED','REJECTED','WITHDRAWN') NOT NULL DEFAULT 'APPLIED',
  applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  decision_at TIMESTAMP NULL DEFAULT NULL,
  note TEXT DEFAULT NULL,
  CONSTRAINT fk_applications_internship FOREIGN KEY (internship_id) REFERENCES internships(id) ON DELETE CASCADE,
  CONSTRAINT fk_applications_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  UNIQUE KEY uq_application_internship_student (internship_id, student_id),
  INDEX idx_applications_internship (internship_id),
  INDEX idx_applications_student (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE work_logs (
  id CHAR(36) PRIMARY KEY,
  student_id CHAR(36) NOT NULL,
  internship_id CHAR(36) NOT NULL,
  week_start_date DATE NOT NULL,
  activities TEXT NOT NULL,
  hours INT DEFAULT NULL,
  supervisor_feedback TEXT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_worklogs_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_worklogs_internship FOREIGN KEY (internship_id) REFERENCES internships(id) ON DELETE CASCADE,
  UNIQUE KEY uq_worklog_student_internship_week (student_id, internship_id, week_start_date),
  INDEX idx_worklogs_student (student_id),
  INDEX idx_worklogs_internship (internship_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE internship_diaries (
  id CHAR(36) PRIMARY KEY,
  student_id CHAR(36) NOT NULL,
  internship_id CHAR(36) NOT NULL,
  status ENUM('IN_PROGRESS', 'SUBMITTED', 'EVALUATED') DEFAULT 'IN_PROGRESS',
  submitted_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_diary (student_id, internship_id),
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (internship_id) REFERENCES internships(id) ON DELETE CASCADE
);

ALTER TABLE work_logs ADD COLUMN diary_id CHAR(36) NULL;
ALTER TABLE work_logs ADD CONSTRAINT fk_worklogs_diary 
    FOREIGN KEY (diary_id) REFERENCES internship_diaries(id) ON DELETE CASCADE;
    
CREATE TABLE evaluations (
  id CHAR(36) PRIMARY KEY,
  student_id CHAR(36) NOT NULL,
  internship_id CHAR(36) NOT NULL,
  evaluator_id CHAR(36) DEFAULT NULL,
  rating SMALLINT DEFAULT NULL,
  comments TEXT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_evaluations_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_evaluations_internship FOREIGN KEY (internship_id) REFERENCES internships(id) ON DELETE CASCADE,
  CONSTRAINT fk_evaluations_evaluator FOREIGN KEY (evaluator_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_evaluations_student (student_id),
  INDEX idx_evaluations_internship (internship_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE evaluations ADD COLUMN diary_id CHAR(36) NULL;
ALTER TABLE evaluations ADD CONSTRAINT fk_evaluations_diary
    FOREIGN KEY (diary_id) REFERENCES internship_diaries(id) ON DELETE SET NULL;
    
CREATE TABLE skills (
  id CHAR(36) PRIMARY KEY,
  student_id CHAR(36) NOT NULL,
  name VARCHAR(150) NOT NULL,
  level VARCHAR(50) NOT NULL,
  CONSTRAINT fk_skills_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  UNIQUE KEY uq_skill_per_student (student_id, name),
  INDEX idx_skills_student (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE interests (
  id CHAR(36) PRIMARY KEY,
  student_id CHAR(36) NOT NULL,
  name VARCHAR(150) NOT NULL,
  CONSTRAINT fk_interests_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  UNIQUE KEY uq_interest_per_student (student_id, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE ai_recommendations (
  id CHAR(36) PRIMARY KEY,
  student_id CHAR(36) NOT NULL,
  internship_id CHAR(36) NOT NULL,
  score DECIMAL(5,4) NOT NULL,
  explanation TEXT DEFAULT NULL,
  generated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ai_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_ai_internship FOREIGN KEY (internship_id) REFERENCES internships(id) ON DELETE CASCADE,
  UNIQUE KEY uq_ai_student_internship (student_id, internship_id),
  INDEX idx_ai_student (student_id),
  INDEX idx_ai_internship (internship_id),
  INDEX idx_ai_score (score)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE uploads (
  id CHAR(36) PRIMARY KEY,
  owner_id CHAR(36) NOT NULL,
  file_path VARCHAR(1000) NOT NULL,
  file_type VARCHAR(100) DEFAULT NULL,
  original_name VARCHAR(500) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_uploads_owner FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_uploads_owner (owner_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO users (id, username, password_hash, email, role, active) 
VALUES (
    UUID(),
    'admin',
    '$2a$12$dLpUK3vOa1uASjptS6MwyOWFdEsneKTiqx1n8DkCP5kBeqiVM5bi6',
    'admin@fakultet.ba',
    'FACULTY',
    true
);

INSERT INTO users (id, username, password_hash, email, role, active) 
VALUES (
    UUID(),
    'admin2',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhy8',
    'admin2@fakultet.ba',
    'FACULTY',
    true
);


INSERT INTO internships (
    id,
    company_id,
    title,
    short_desc,
    description,
    technologies,
    requirements,
    min_gpa,
    required_year,
    required_languages,
    start_date,
    end_date,
    application_deadline,
    positions,
    location,
    work_type,
    is_active
)
VALUES
(
    UUID(),
    '5e983d0c-2dd7-425c-9774-117c3ad5f603',
    'Java Backend Internship',
    'Praksa za studente zainteresovane za razvoj backend aplikacija.',
    'Tokom prakse studenti će raditi na razvoju REST API servisa koristeći Java i Spring Boot tehnologije. Polaznici će imati priliku da učestvuju u razvoju poslovnih aplikacija, radu sa bazama podataka i modernim alatima za razvoj softvera.',
    '["Java", "Spring Boot", "MySQL", "Git", "Maven"]',
    'Osnovno poznavanje objektno orijentisanog programiranja, Java jezika i relacionih baza podataka.',
    7.50,
    '3',
    '["Engleski"]',
    '2026-07-01',
    '2026-08-31',
    '2026-06-20',
    8,
    'Banja Luka',
    'HYBRID',
    TRUE
),
(
    UUID(),
    '5e983d0c-2dd7-425c-9774-117c3ad5f603',
    'Frontend Development Internship',
    'Praksa za studente zainteresovane za razvoj modernih web aplikacija.',
    'Praksa obuhvata razvoj korisničkih interfejsa korištenjem React tehnologije. Studenti će učiti rad sa REST servisima, upravljanje stanjem aplikacije i razvoj responzivnih web rješenja.',
    '["React", "JavaScript", "HTML", "CSS", "TypeScript"]',
    'Poznavanje osnova web programiranja i rada sa JavaScript tehnologijama.',
    7.00,
    '2',
    '["Engleski"]',
    '2026-10-01',
    '2026-11-30',
    '2026-09-15',
    10,
    'Banja Luka',
    'ON_SITE',
    TRUE
);

INSERT INTO internships (
    id,
    company_id,
    title,
    short_desc,
    description,
    technologies,
    requirements,
    min_gpa,
    required_year,
    required_languages,
    start_date,
    end_date,
    application_deadline,
    positions,
    taken_positions,
    location,
    work_type,
    is_active
)
VALUES

-- AKTIVNA / NADOLAZEĆA PRAKSA

(
    UUID(),
    '5fc4f69a-d25f-4c1b-83cd-0cb45ffba448',
    'Cloud & DevOps Internship',
    'Praksa za studente zainteresovane za cloud tehnologije i DevOps procese.',
    'Tokom prakse studenti će učestvovati u radu na cloud infrastrukturi, automatizaciji procesa isporuke softvera i radu sa kontejnerskim tehnologijama. Mentori iz ProductDock tima pružiće podršku kroz praktične zadatke i rad na stvarnim projektima.',
    '["Docker","Kubernetes","AWS","GitHub Actions","Linux"]',
    'Osnovno poznavanje operativnih sistema, mreža i Git alata.',
    7.50,
    '3',
    '["Engleski"]',
    '2026-09-01',
    '2026-10-31',
    '2026-08-15',
    6,
    0,
    'Banja Luka',
    'HYBRID',
    TRUE
),

-- ZAVRŠENA PRAKSA 1

(
    UUID(),
    '5fc4f69a-d25f-4c1b-83cd-0cb45ffba448',
    'Full Stack Development Internship',
    'Praksa iz razvoja web aplikacija korištenjem modernih tehnologija.',
    'Studenti su radili na razvoju modernih web aplikacija koristeći React i Spring Boot. Fokus je bio na timskom radu, razvoju REST servisa i radu sa bazama podataka.',
    '["React","Java","Spring Boot","MySQL","Git"]',
    'Poznavanje osnova web razvoja i objektno orijentisanog programiranja.',
    7.00,
    '2',
    '["Engleski"]',
    '2026-03-01',
    '2026-04-30',
    '2026-02-15',
    10,
    10,
    'Banja Luka',
    'HYBRID',
    FALSE
),

-- ZAVRŠENA PRAKSA 2

(
    UUID(),
    '5fc4f69a-d25f-4c1b-83cd-0cb45ffba448',
    'Software Quality Assurance Internship',
    'Praksa iz oblasti testiranja i osiguranja kvaliteta softvera.',
    'Polaznici su učestvovali u planiranju testova, automatizaciji testiranja i verifikaciji funkcionalnosti poslovnih aplikacija. Praksa je uključivala rad sa QA timovima i upoznavanje sa Agile metodologijama.',
    '["Selenium","Postman","JUnit","Jira","Git"]',
    'Osnovno poznavanje procesa razvoja softvera i testiranja aplikacija.',
    6.50,
    '2',
    '["Engleski"]',
    '2025-11-01',
    '2025-12-31',
    '2025-10-15',
    8,
    8,
    'Banja Luka',
    'ON_SITE',
    FALSE
);

INSERT INTO internships (
    id,
    company_id,
    title,
    short_desc,
    description,
    technologies,
    requirements,
    min_gpa,
    required_year,
    required_languages,
    start_date,
    end_date,
    application_deadline,
    positions,
    taken_positions,
    location,
    work_type,
    is_active
)
VALUES

-- NADOLAZEĆA PRAKSA

(
    UUID(),
    'de639f84-1b0b-4982-bc86-d4696db90309',
    'FinTech Software Development Internship',
    'Praksa za studente zainteresovane za razvoj finansijskih softverskih rješenja.',
    'Praksa omogućava studentima rad na razvoju modernih finansijskih aplikacija, implementaciji poslovne logike i integraciji sa eksternim servisima. Učesnici sarađuju sa iskusnim mentorima i upoznaju se sa procesima razvoja softvera u FinTech industriji.',
    '["Java","Spring Boot","PostgreSQL","Docker","Git"]',
    'Poznavanje objektno orijentisanog programiranja, rada sa bazama podataka i osnova web tehnologija.',
    7.50,
    '3',
    '["Engleski"]',
    '2026-09-15',
    '2026-11-15',
    '2026-08-31',
    6,
    0,
    'Banja Luka',
    'HYBRID',
    TRUE
),

-- PROŠLA PRAKSA

(
    UUID(),
    'de639f84-1b0b-4982-bc86-d4696db90309',
    'Mobile Application Development Internship',
    'Praksa iz razvoja mobilnih aplikacija za Android i iOS platforme.',
    'Praksa pruža priliku za rad na razvoju mobilnih aplikacija, implementaciji korisničkih interfejsa i povezivanju sa backend servisima. Studenti stiču iskustvo u radu sa modernim mobilnim tehnologijama i alatima za razvoj softvera.',
    '["Flutter","Dart","REST API","Firebase","Git"]',
    'Osnovno poznavanje mobilnog razvoja i principa objektno orijentisanog programiranja.',
    7.00,
    '2',
    '["Engleski"]',
    '2026-02-01',
    '2026-03-31',
    '2026-01-15',
    8,
    8,
    'Banja Luka',
    'ON_SITE',
    FALSE
);

INSERT INTO internships (
    id,
    company_id,
    title,
    short_desc,
    description,
    technologies,
    requirements,
    min_gpa,
    required_year,
    required_languages,
    start_date,
    end_date,
    application_deadline,
    positions,
    taken_positions,
    location,
    work_type,
    is_active
)
VALUES
(
    UUID(),
    'aafa4b5d-ad5f-42ab-9218-f3e9700e01a0',
    'Telecom Network Engineering Internship',
    'Praksa za studente zainteresovane za razvoj i upravljanje telekomunikacionim mrežama.',
    'Tokom prakse studenti će imati priliku da rade na projektima razvoja i optimizacije telekomunikacione infrastrukture kompanije m:tel. Učesnici će se upoznati sa tehnologijama mobilnih i fiksnih mreža, sistemima prenosa podataka i naprednim ICT rješenjima. Rad se odvija u timovima uz podršku iskusnih mentora koji će voditi studente kroz stvarne poslovne procese i tehnološke izazove u telekomunikacionoj industriji.',
    '["4G/5G", "IP mreže", "Linux", "Cisco", "Python"]',
    'Osnovno poznavanje računarskih mreža i telekomunikacionih sistema. Prednost imaju studenti elektrotehnike, računarstva ili srodnih tehničkih smjerova.',
    7.00,
    '3',
    '["Engleski"]',
    '2026-09-01',
    '2026-10-31',
    '2026-08-20',
    8,
    0,
    'Banja Luka',
    'ON_SITE',
    TRUE
);

INSERT INTO internships (
    id,
    company_id,
    title,
    short_desc,
    description,
    technologies,
    requirements,
    min_gpa,
    required_year,
    required_languages,
    start_date,
    end_date,
    application_deadline,
    positions,
    taken_positions,
    location,
    work_type,
    is_active
)
VALUES
(
    UUID(),
    'f9d6d246-1bc9-4c94-909b-f33e99f11f40',
    'Data Science & Machine Learning Internship',
    'Praksa za studente zainteresovane za oblast mašinskog učenja i analize podataka.',
    'Tokom prakse studenti će raditi na razvoju modela mašinskog učenja, analizi i vizuelizaciji podataka te implementaciji rješenja za automatizaciju poslovnih procesa. Učesnici će imati priliku da rade sa stvarnim skupovima podataka, primijene moderne ML tehnike i steknu iskustvo u timu koji razvija data-driven rješenja za klijente iz različitih industrija.',
    '["Python", "TensorFlow", "Pandas", "scikit-learn", "SQL"]',
    'Poznavanje osnova programiranja u Pythonu, statistike i linearne algebre. Prednost imaju studenti koji su radili na projektima iz oblasti analize podataka.',
    7.50,
    '3',
    '["Engleski"]',
    '2026-10-01',
    '2026-11-30',
    '2026-09-15',
    5,
    0,
    'Banja Luka',
    'HYBRID',
    TRUE
);

SELECT student_id, internship_id FROM applications 
WHERE status = 'ACCEPTED';

INSERT INTO internship_diaries (id, student_id, internship_id, status, created_at)
VALUES (
    UUID(),
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '41e2c86b-602f-11f1-bb3a-adf4bedd19e2',
    'IN_PROGRESS',
    NOW()
);


ALTER TABLE work_logs MODIFY COLUMN activities TEXT NULL;
ALTER TABLE work_logs MODIFY COLUMN hours INT NULL;

-- Kreiraj praksu koja je već počela
INSERT INTO internships (
    id, company_id, title, short_desc, description,
    technologies, requirements, min_gpa, required_year,
    required_languages, start_date, end_date,
    application_deadline, positions, taken_positions,
    location, work_type, is_active
) VALUES (
    '11111111-1111-1111-1111-111111111111',
    'aafa4b5d-ad5f-42ab-9218-f3e9700e01a0',
    'Mtel IoT & Cloud Internship 2026',
    'Praksa iz oblasti interneta stvari i cloud platformi.',
    'Studenti će raditi na projektima razvoja IoT rješenja i integracije sa cloud platformama. Fokus je na prikupljanju i obradi podataka sa senzora, razvoju backend servisa i vizualizaciji podataka.',
    '["IoT", "AWS", "Python", "MQTT", "Linux"]',
    'Osnovno poznavanje Pythona i Linux okruženja.',
    7.00, '3', '["Engleski"]',
    '2026-05-26',
    '2026-07-18',
    '2026-05-10',
    10, 1,
    'Banja Luka', 'ON_SITE', TRUE
);

-- Prijava studenta
INSERT INTO applications (
    id, internship_id, student_id, status, applied_at, decision_at
) VALUES (
    UUID(),
    '11111111-1111-1111-1111-111111111111',
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    'ACCEPTED',
    '2026-05-15 10:00:00',
    '2026-05-20 10:00:00'
);

-- Kreiraj diary
INSERT INTO internship_diaries (
    id, student_id, internship_id, status, created_at
) VALUES (
    '22222222-2222-2222-2222-222222222222',
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '11111111-1111-1111-1111-111111111111',
    'IN_PROGRESS',
    NOW()
);

-- Kreiraj work logove za svaki ponedeljak od 26.05. do 18.07.
INSERT INTO work_logs (id, student_id, internship_id, diary_id, week_start_date, created_at) VALUES
(UUID(), '2850acba-ff69-4ab5-9176-6dcc5ae3008f', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', '2026-05-25', NOW()),
(UUID(), '2850acba-ff69-4ab5-9176-6dcc5ae3008f', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', '2026-06-01', NOW()),
(UUID(), '2850acba-ff69-4ab5-9176-6dcc5ae3008f', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', '2026-06-08', NOW()),
(UUID(), '2850acba-ff69-4ab5-9176-6dcc5ae3008f', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', '2026-06-15', NOW()),
(UUID(), '2850acba-ff69-4ab5-9176-6dcc5ae3008f', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', '2026-06-22', NOW()),
(UUID(), '2850acba-ff69-4ab5-9176-6dcc5ae3008f', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', '2026-06-29', NOW()),
(UUID(), '2850acba-ff69-4ab5-9176-6dcc5ae3008f', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', '2026-07-06', NOW()),
(UUID(), '2850acba-ff69-4ab5-9176-6dcc5ae3008f', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', '2026-07-13', NOW());


-- Nova završena praksa
INSERT INTO internships (
    id, company_id, title, short_desc, description,
    technologies, requirements, min_gpa, required_year,
    required_languages, start_date, end_date,
    application_deadline, positions, taken_positions,
    location, work_type, is_active
) VALUES (
    '33333333-3333-3333-3333-333333333333',
    '5e983d0c-2dd7-425c-9774-117c3ad5f603',
    'Java Spring Boot Internship 2026',
    'Praksa iz razvoja backend aplikacija u Java Spring Boot tehnologiji.',
    'Studenti su radili na razvoju REST API servisa, integraciji sa bazama podataka i implementaciji poslovne logike. Fokus je bio na clean code principima, pisanju testova i timskom radu uz korišćenje Git verzionisanja.',
    '["Java", "Spring Boot", "MySQL", "Git", "JUnit"]',
    'Osnovno poznavanje Java programiranja i objektno orijentisanog programiranja.',
    7.00, '3', '["Engleski"]',
    '2026-03-03',
    '2026-04-25',
    '2026-02-20',
    5, 1,
    'Banja Luka', 'HYBRID', FALSE
);

-- Prijava studenta
INSERT INTO applications (
    id, internship_id, student_id, status, applied_at, decision_at
) VALUES (
    UUID(),
    '33333333-3333-3333-3333-333333333333',
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    'ACCEPTED',
    '2026-02-10 10:00:00',
    '2026-02-25 10:00:00'
);

-- Kreiraj diary sa statusom SUBMITTED
INSERT INTO internship_diaries (
    id, student_id, internship_id, status, submitted_at, created_at
) VALUES (
    '44444444-4444-4444-4444-444444444444',
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '33333333-3333-3333-3333-333333333333',
    'SUBMITTED',
    '2026-04-28 14:00:00',
    '2026-02-25 10:00:00'
);

-- Work logovi sa aktivnostima i feedbackom
INSERT INTO work_logs (id, student_id, internship_id, diary_id, week_start_date, activities, hours, supervisor_feedback, created_at) VALUES
(
    UUID(),
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '2026-03-02',
    'Tokom prve sedmice prakse upoznala sam se sa projektnom strukturom i tehnologijama koje se koriste u kompaniji. Prisustvovala sam uvodnim sastancima sa timom i mentorom koji su mi objasnili radne procese i očekivanja. Postavila sam razvojno okruženje, konfigurisala potrebne alate i pregledala postojeću dokumentaciju projekta.',
    40,
    'Studentica je pokazala izuzetnu posvećenost tokom prve sedmice. Brzo se snašla u novom okruženju i aktivno učestvovala u svim aktivnostima tima.',
    '2026-03-08 17:00:00'
),
(
    UUID(),
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '2026-03-09',
    'Tokom druge sedmice počela sam sa implementacijom REST API endpointa za upravljanje korisnicima. Naučila sam kako se koristi Spring Security za autentifikaciju i autorizaciju. Implementirala sam CRUD operacije za entitet korisnika i napisala osnovne unit testove koristeći JUnit i Mockito.',
    38,
    'Odličan napredak u razumijevanju Spring Boot arhitekture. Kod je čist i testovi su dobro napisani. Preporučujem nastavak u istom tempu.',
    '2026-03-15 16:30:00'
),
(
    UUID(),
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '2026-03-16',
    'U trećoj sedmici radila sam na integraciji sa MySQL bazom podataka koristeći Spring Data JPA. Kreirala sam entitete, repozitorijume i servisni sloj za upravljanje podacima. Naišla sam na probleme sa Hibernate lazy loading ali sam ih uz pomoć mentora uspješno riješila.',
    42,
    'Studentica pokazuje inicijativu u rješavanju problema. Dobro razumije JPA koncepte i uspješno je implementirala složenije upite.',
    '2026-03-22 15:00:00'
),
(
    UUID(),
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '2026-03-23',
    'Četvrta sedmica bila je posvećena razvoju poslovne logike za modul upravljanja narudžbinama. Implementirala sam validaciju podataka, hendlovanje grešaka i kreiranje prilagođenih izuzetaka. Takođe sam radila na dokumentovanju API-ja koristeći Swagger.',
    40,
    'Izvanredan rad na dokumentaciji i hendlovanju grešaka. API je čisto dizajniran i lako razumljiv. Swagger dokumentacija je kompletna i precizna.',
    '2026-03-29 14:00:00'
),
(
    UUID(),
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '2026-03-30',
    'Peta sedmica bila je posvećena integracionom testiranju i otklanjanju grešaka. Pisala sam integracione testove za ključne API endpointe i popravila nekoliko bugova otkrivenih tokom testiranja. Radila sam i na optimizaciji SQL upita koji su bili spori.',
    35,
    'Studentica demonstrira zrelost u pristupu testiranju. Bugovi su brzo identifikovani i riješeni. Optimizacija upita pokazuje razumijevanje performansnih aspekata.',
    '2026-04-05 16:00:00'
),
(
    UUID(),
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '2026-04-06',
    'U šestoj sedmici fokusirala sam se na implementaciju notifikacionog sistema putem emaila. Koristila sam Spring Mail za slanje emailova i kreirala HTML predloške za različite tipove notifikacija. Implementirala sam i asinhrono slanje emailova koristeći Spring async.',
    40,
    'Odlična implementacija notifikacionog sistema. Asinhronost je pravilno implementirana i email predlošci su profesionalni.',
    '2026-04-12 15:30:00'
),
(
    UUID(),
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '2026-04-13',
    'Sedma sedmica bila je posvećena code review-u i pripremi projekta za produkciju. Učestvovala sam u code review sesijama sa timom, primijenila komentare i poboljšala kvalitet koda. Radila sam i na konfiguraciji aplikacije za različita okruženja koristeći Spring profiles.',
    38,
    'Studentica aktivno učestvuje u code review procesu i prihvata povratne informacije na profesionalan način. Odlična priprema za produkcijsko okruženje.',
    '2026-04-19 14:00:00'
),
(
    UUID(),
    '2850acba-ff69-4ab5-9176-6dcc5ae3008f',
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '2026-04-20',
    'Posljednja sedmica prakse bila je posvećena finalnoj prezentaciji projekta i predaji dokumentacije. Pripremila sam tehničku dokumentaciju za sve implementirane module i prezentovala rezultate rada pred timom. Dobila sam izuzetno pozitivne povratne informacije od mentora i ostatka tima.',
    36,
    'Studentica je završila praksu na izuzetan način. Prezentacija je bila profesionalna i sveobuhvatna. Toplo preporučujem za buduće prilike u kompaniji.',
    '2026-04-26 13:00:00'
);
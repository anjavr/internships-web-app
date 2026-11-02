
# Sistem za upravljanje studentskim praksama

## Opis projekta

Projekat predstavlja informacioni sistem za upravljanje studentskim praksama, razvijen s ciljem digitalizacije i pojednostavljivanja procesa povezivanja studenata, kompanija i fakulteta.

Sistem omogućava studentima pregled dostupnih praksi, prijavljivanje na oglase, kreiranje i upravljanje biografijom (CV), kao i praćenje aktivnosti tokom obavljanja prakse. Kompanijama omogućava objavljivanje oglasa, pregled prijava i evaluaciju studenata, dok fakultetskoj službi pruža mogućnost upravljanja podacima o studentima i kompanijama, praćenja realizacije praksi i evidencije studentskih aktivnosti.

Sistem se sastoji od tri korisničke aplikacije i centralnog backend servisa koji omogućava komunikaciju sa zajedničkom bazom podataka.

## Arhitektura i tehnologije

Projekat je realizovan korištenjem sljedećih tehnologija:

- **Backend:** Java, Spring Boot, REST API
- **Baze podataka:** MySQL
- **Student aplikacija:** Angular
- **Company aplikacija:** JSP, Java
- **Faculty aplikacija:** JSP, Java
- **Dodatne tehnologije i servisi:** AI integracija putem Groq API-ja

## Implementirane aplikacije

### 1. Studentska aplikacija (student-app)

Web aplikacija namijenjena studentima, razvijena korištenjem Angular frameworka.

Omogućava:
- Kreiranje i uređivanje korisničkog profila i biografije (CV).
- Pregled dostupnih oglasa za studentske prakse.
- Prijavljivanje na oglase za praksu.
- Pregled preporučenih praksi uz podršku AI servisa.
- Evidenciju sedmičnih aktivnosti i rada tokom obavljanja prakse.

### 2. Aplikacija za kompanije (company-app)

Web aplikacija namijenjena kompanijama, realizovana korištenjem Java tehnologije i JSP stranica.

Omogućava:
- Kreiranje, izmjenu i upravljanje oglasima za studentske prakse.
- Pregled pristiglih prijava studenata.
- Pregled i preuzimanje biografija (CV) prijavljenih kandidata.
- Praćenje studenata na praksi i evidentiranje njihove evaluacije.

### 3. Aplikacija za fakultetsku službu (faculty-app)

Web aplikacija namijenjena fakultetskoj službi, realizovana korištenjem Java tehnologije i JSP stranica.

Omogućava:
- Upravljanje evidencijom studenata i kompanija.
- Uvoz podataka o studentima putem CSV fajla.
- Pregled i praćenje realizacije studentskih praksi.
- Evidenciju i pregled studentskih aktivnosti i evaluacija.

### 4. Backend servis (praksa-backend)

Centralni backend servis razvijen korištenjem Java Spring Boot frameworka.

Zadužen je za:
- Implementaciju REST API-ja i obradu zahtjeva korisničkih aplikacija.
- Poslovnu logiku sistema.
- Komunikaciju sa MySQL bazom podataka.
- Autentifikaciju i autorizaciju korisnika.
- Integraciju sa Groq API servisom za generisanje preporuka praksi.

## Baza podataka i testni podaci

U direktorijumu `database` nalazi se SQL skripta za kreiranje i inicijalizaciju baze podataka potrebne za rad sistema.

U korijenskom direktorijumu projekta nalazi se i `students.csv` fajl koji služi za demonstraciju funkcionalnosti uvoza podataka o studentima putem fakultetske aplikacije.

**Napomena:** Podaci sadržani u SQL skriptama i CSV fajlu služe isključivo za potrebe testiranja i demonstracije funkcionalnosti sistema. Svi podaci su izmišljeni i ne predstavljaju stvarne studente, kompanije ili oglase za prakse.

## Struktura projekta

```text
internships-web-app/
├── praksa-backend/   # Spring Boot backend servis
├── student-app/     # Angular aplikacija za studente
├── company-app/     # JSP aplikacija za kompanije
├── faculty-app/     # JSP aplikacija za fakultetsku službu
├── database/        # SQL skripta za inicijalizaciju baze
└── students.csv     # Testni podaci za uvoz studenata
```

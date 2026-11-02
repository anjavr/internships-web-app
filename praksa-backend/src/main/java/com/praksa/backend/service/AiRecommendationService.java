package com.praksa.backend.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.praksa.backend.dto.AiRecommendationDTO;
import com.praksa.backend.entity.AiRecommendation;
import com.praksa.backend.entity.Internship;
import com.praksa.backend.entity.Student;
import com.praksa.backend.repository.AiRecommendationRepository;
import com.praksa.backend.repository.InternshipRepository;
import com.praksa.backend.repository.StudentRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class AiRecommendationService {

    @Value("${groq.api.key}")
    private String apiKey;

    private final StudentRepository studentRepository;
    private final InternshipRepository internshipRepository;
    private final AiRecommendationRepository aiRecommendationRepository;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public AiRecommendationService(StudentRepository studentRepository,
                                   InternshipRepository internshipRepository,
                                   AiRecommendationRepository aiRecommendationRepository) {
        this.studentRepository = studentRepository;
        this.internshipRepository = internshipRepository;
        this.aiRecommendationRepository = aiRecommendationRepository;
    }

    @Transactional
    public List<AiRecommendationDTO> getRecommendations(String studentId) {
        List<AiRecommendation> existing = aiRecommendationRepository.findByStudentIdOrderByScoreDesc(studentId);
        if (!existing.isEmpty()) {
            return existing.stream().map(this::toDTO).toList();
        }
        return generateRecommendations(studentId);
    }

    @Transactional
    public List<AiRecommendationDTO> generateRecommendations(String studentId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        List<Internship> internships = internshipRepository.findByIsActiveTrue();
        if (internships.isEmpty()) return List.of();

        // brisanje starih preporuka
        aiRecommendationRepository.deleteByStudentId(studentId);

        StringBuilder studentDesc = new StringBuilder();
        studentDesc.append("Student: ").append(student.getFullName()).append("\n");
        if (student.getSummary() != null) studentDesc.append("Summary: ").append(student.getSummary()).append("\n");
        if (student.getSkills() != null && !student.getSkills().isEmpty()) {
            studentDesc.append("Skills: ");
            student.getSkills().forEach(s -> studentDesc.append(s.getName()).append("(").append(s.getLevel()).append("), "));
            studentDesc.append("\n");
        }
        if (student.getInterests() != null && !student.getInterests().isEmpty()) {
            studentDesc.append("Interests: ");
            student.getInterests().forEach(i -> studentDesc.append(i.getName()).append(", "));
            studentDesc.append("\n");
        }

        StringBuilder internshipsDesc = new StringBuilder();
        for (Internship i : internships) {
            internshipsDesc.append("ID: ").append(i.getId()).append("\n");
            internshipsDesc.append("Title: ").append(i.getTitle()).append("\n");
            internshipsDesc.append("Company: ").append(i.getCompany().getName()).append("\n");
            if (i.getDescription() != null) internshipsDesc.append("Description: ").append(i.getDescription()).append("\n");
            if (i.getTechnologies() != null) internshipsDesc.append("Technologies: ").append(i.getTechnologies()).append("\n");
            internshipsDesc.append("---\n");
        }

        String prompt = """
            You are a career advisor. Based on the student profile and available internships below, 
            rate each internship's compatibility with the student from 0.0 to 1.0.
            
            STUDENT PROFILE:
            """ + studentDesc + """
            
            INTERNSHIPS:
            """ + internshipsDesc + """
            
            Return ONLY a JSON array (no markdown, no explanation) in this exact format:
            [
              {"internshipId": "...", "score": 0.95, "explanation": "Short explanation in Bosnian"},
              ...
            ]
            Return maximum 5 internships with highest scores, sorted by score descending.
            """;

        try {
            RestClient client = RestClient.create("https://api.groq.com/openai/v1");

            String requestBody = objectMapper.writeValueAsString(new GroqRequest(
                    "llama-3.3-70b-versatile",
                    List.of(new GroqMessage("user", prompt))
            ));

            GroqResponse response = client.post()
                    .uri("/chat/completions")
                    .header("Authorization", "Bearer " + apiKey)
                    .header("Content-Type", "application/json")
                    .body(requestBody)
                    .retrieve()
                    .body(GroqResponse.class);

            String content = response.getChoices().get(0).getMessage().getContent();

            // parse
            List<AiResultItem> results = objectMapper.readValue(
                    content,
                    objectMapper.getTypeFactory().constructCollectionType(List.class, AiResultItem.class)
            );

            List<AiRecommendationDTO> dtos = new ArrayList<>();
            for (AiResultItem item : results) {
                internships.stream()
                        .filter(i -> i.getId().equals(item.getInternshipId()))
                        .findFirst()
                        .ifPresent(internship -> {
                            AiRecommendation rec = new AiRecommendation();
                            rec.setId(UUID.randomUUID().toString());
                            rec.setStudent(student);
                            rec.setInternship(internship);
                            rec.setScore(java.math.BigDecimal.valueOf(item.getScore()));
                            rec.setExplanation(item.getExplanation());
                            aiRecommendationRepository.save(rec);
                            dtos.add(toDTO(rec));
                        });
            }
            return dtos;

        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    private AiRecommendationDTO toDTO(AiRecommendation rec) {
        AiRecommendationDTO dto = new AiRecommendationDTO();
        dto.setId(rec.getId());
        dto.setInternshipId(rec.getInternship().getId());
        dto.setInternshipTitle(rec.getInternship().getTitle());
        dto.setCompanyName(rec.getInternship().getCompany().getName());
        dto.setScore(rec.getScore().doubleValue());
        dto.setExplanation(rec.getExplanation());
        dto.setLocation(rec.getInternship().getLocation());
        dto.setWorkType(rec.getInternship().getWorkType().name());
        dto.setTechnologies(rec.getInternship().getTechnologies());
        return dto;
    }

    // inner classes
    static class GroqRequest {
        public String model;
        public List<GroqMessage> messages;
        GroqRequest(String model, List<GroqMessage> messages) {
            this.model = model;
            this.messages = messages;
        }
    }

    static class GroqMessage {
        public String role;
        public String content;

        public GroqMessage() {}

        GroqMessage(String role, String content) {
            this.role = role;
            this.content = content;
        }

        public String getRole() { return role; }
        public void setRole(String role) { this.role = role; }
        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }
    }

    static class GroqResponse {
        private List<Choice> choices;
        public List<Choice> getChoices() { return choices; }
        public void setChoices(List<Choice> choices) { this.choices = choices; }
    }

    static class Choice {
        private GroqMessage message;
        public GroqMessage getMessage() { return message; }
        public void setMessage(GroqMessage message) { this.message = message; }
    }

    static class AiResultItem {
        private String internshipId;
        private double score;
        private String explanation;
        public String getInternshipId() { return internshipId; }
        public void setInternshipId(String internshipId) { this.internshipId = internshipId; }
        public double getScore() { return score; }
        public void setScore(double score) { this.score = score; }
        public String getExplanation() { return explanation; }
        public void setExplanation(String explanation) { this.explanation = explanation; }
    }
}
package com.praksa.backend.service;

import com.praksa.backend.dto.InternshipDiaryDTO;
import com.praksa.backend.entity.*;
import com.praksa.backend.mapper.InternshipDiaryMapper;
import com.praksa.backend.repository.*;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class InternshipDiaryService {

    private final InternshipDiaryRepository diaryRepository;
    private final StudentRepository studentRepository;
    private final InternshipRepository internshipRepository;
    private final WorkLogRepository workLogRepository;

    public InternshipDiaryService(InternshipDiaryRepository diaryRepository,
                                  StudentRepository studentRepository,
                                  InternshipRepository internshipRepository,
                                  WorkLogRepository workLogRepository) {
        this.diaryRepository = diaryRepository;
        this.studentRepository = studentRepository;
        this.internshipRepository = internshipRepository;
        this.workLogRepository = workLogRepository;
    }

    public InternshipDiaryDTO createDiary(String studentId, String internshipId) {
        if (diaryRepository.findByStudentIdAndInternshipId(studentId, internshipId).isPresent()) {
            return InternshipDiaryMapper.toDTO(
                    diaryRepository.findByStudentIdAndInternshipId(studentId, internshipId).get()
            );
        }

        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        Internship internship = internshipRepository.findById(internshipId)
                .orElseThrow(() -> new RuntimeException("Internship not found"));

        InternshipDiary diary = new InternshipDiary();
        diary.setId(UUID.randomUUID().toString());
        diary.setStudent(student);
        diary.setInternship(internship);
        diary.setStatus(DiaryStatus.IN_PROGRESS);
        InternshipDiary savedDiary = diaryRepository.save(diary);

        if (internship.getStartDate() != null && internship.getEndDate() != null) {
            LocalDate current = internship.getStartDate();

            while (current.getDayOfWeek() != DayOfWeek.MONDAY) {
                current = current.plusDays(1);
            }

            while (!current.isAfter(internship.getEndDate())) {
                WorkLog workLog = new WorkLog();
                workLog.setId(UUID.randomUUID().toString());
                workLog.setStudent(student);
                workLog.setInternship(internship);
                workLog.setDiary(savedDiary);
                workLog.setWeekStartDate(current);
                workLogRepository.save(workLog);

                current = current.plusDays(7);
            }
        }

        return InternshipDiaryMapper.toDTO(savedDiary);
    }

    public List<InternshipDiaryDTO> getByStudent(String studentId) {
        return diaryRepository.findByStudentId(studentId)
                .stream().map(InternshipDiaryMapper::toDTO).collect(Collectors.toList());
    }

    public List<InternshipDiaryDTO> getByInternship(String internshipId) {
        return diaryRepository.findByInternshipId(internshipId)
                .stream().map(InternshipDiaryMapper::toDTO).collect(Collectors.toList());
    }

    public InternshipDiaryDTO getByStudentAndInternship(String studentId, String internshipId) {
        return diaryRepository.findByStudentIdAndInternshipId(studentId, internshipId)
                .map(InternshipDiaryMapper::toDTO)
                .orElseThrow(() -> new RuntimeException("Diary not found"));
    }

    public InternshipDiaryDTO submit(String diaryId) {
        InternshipDiary diary = diaryRepository.findById(diaryId)
                .orElseThrow(() -> new RuntimeException("Diary not found"));

        if (diary.getStatus() != DiaryStatus.IN_PROGRESS &&
                diary.getStatus() != DiaryStatus.FEEDBACK_DONE) {
            throw new RuntimeException("Diary cannot be submitted in current status");
        }

        diary.setStatus(DiaryStatus.SUBMITTED);
        diary.setSubmittedAt(LocalDateTime.now());
        return InternshipDiaryMapper.toDTO(diaryRepository.save(diary));
    }

    public InternshipDiaryDTO markFeedbackDone(String diaryId) {
        InternshipDiary diary = diaryRepository.findById(diaryId)
                .orElseThrow(() -> new RuntimeException("Diary not found"));

        if (diary.getStatus() != DiaryStatus.IN_PROGRESS) {
            throw new RuntimeException("Diary nije u statusu IN_PROGRESS");
        }

        diary.setStatus(DiaryStatus.FEEDBACK_DONE);
        return InternshipDiaryMapper.toDTO(diaryRepository.save(diary));
    }

    public InternshipDiaryDTO evaluate(String diaryId) {
        InternshipDiary diary = diaryRepository.findById(diaryId)
                .orElseThrow(() -> new RuntimeException("Diary not found"));

        diary.setStatus(DiaryStatus.EVALUATED);
        return InternshipDiaryMapper.toDTO(diaryRepository.save(diary));
    }
}
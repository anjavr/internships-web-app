package com.praksa.backend.service;

import com.praksa.backend.dto.WorkLogDTO;
import com.praksa.backend.entity.*;
import com.praksa.backend.mapper.WorkLogMapper;
import com.praksa.backend.repository.*;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class WorkLogService {

    private final WorkLogRepository workLogRepository;
    private final StudentRepository studentRepository;
    private final InternshipRepository internshipRepository;
    private final InternshipDiaryRepository diaryRepository;

    public WorkLogService(WorkLogRepository workLogRepository,
                          StudentRepository studentRepository,
                          InternshipRepository internshipRepository,
                          InternshipDiaryRepository diaryRepository) {
        this.workLogRepository = workLogRepository;
        this.studentRepository = studentRepository;
        this.internshipRepository = internshipRepository;
        this.diaryRepository = diaryRepository;
    }

    public WorkLogDTO fillLog(String id, WorkLogDTO dto) {
        WorkLog workLog = workLogRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("WorkLog not found"));

        if (workLog.getDiary() != null) {
            DiaryStatus status = workLog.getDiary().getStatus();
            if (status != DiaryStatus.IN_PROGRESS && status != DiaryStatus.FEEDBACK_DONE) {
                throw new RuntimeException("Dnevnik je predan i ne može se mijenjati");
            }
        }

        if (workLog.getWeekStartDate().isAfter(LocalDate.now())) {
            throw new RuntimeException("Ne možete unositi za buduće sedmice");
        }

        workLog.setActivities(dto.getActivities());
        workLog.setHours(dto.getHours());

        return WorkLogMapper.toDTO(workLogRepository.save(workLog));
    }

    public List<WorkLogDTO> getByStudent(String studentId) {
        return workLogRepository.findByStudentId(studentId)
                .stream()
                .map(WorkLogMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<WorkLogDTO> getByInternship(String internshipId) {
        return workLogRepository.findByInternshipId(internshipId)
                .stream()
                .map(WorkLogMapper::toDTO)
                .collect(Collectors.toList());
    }

    public List<WorkLogDTO> getByDiary(String diaryId) {
        return workLogRepository.findByDiaryId(diaryId)
                .stream()
                .map(WorkLogMapper::toDTO)
                .collect(Collectors.toList());
    }

    public WorkLogDTO addFeedback(String id, String feedback) {
        WorkLog workLog = workLogRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("WorkLog not found"));

        if (workLog.getDiary() != null &&
                workLog.getDiary().getStatus() != DiaryStatus.IN_PROGRESS) {
            throw new RuntimeException("Feedback se može dodati samo dok je dnevnik IN_PROGRESS");
        }

        workLog.setSupervisorFeedback(feedback);
        return WorkLogMapper.toDTO(workLogRepository.save(workLog));
    }
}
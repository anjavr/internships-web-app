package com.praksa.beans;

import com.praksa.dto.ApplicationDTO;
import com.praksa.dto.EvaluationDTO;
import com.praksa.dto.WorkLogDTO;
import com.praksa.service.EvaluationService;
import com.praksa.service.WorkLogService;
import java.util.List;
import java.util.ArrayList;

public class EvaluationBean {

    private final WorkLogService workLogService = new WorkLogService();
    private final EvaluationService evaluationService = new EvaluationService();

    private ApplicationDTO selectedApplication;
    private List<ApplicationDTO> applications;
    private List<WorkLogDTO> workLogs;
    private EvaluationDTO evaluation;

    public List<ApplicationDTO> getAccepted(String token) {
        applications = evaluationService.getAccepted(token);
        return applications;
    }

    public List<WorkLogDTO> getWorkLogs(String studentId, String token) {
        workLogs = workLogService.getByStudent(studentId, token);
        return workLogs;
    }

    public EvaluationDTO getEvaluation(String studentId,
            String internshipId, String token) {
        evaluation = evaluationService.getEvaluation(
                studentId, internshipId, token);
        return evaluation;
    }

    public EvaluationDTO saveEvaluation(EvaluationDTO dto, String token) {
        evaluation = evaluationService.save(dto, token);
        return evaluation;
    }

    public List<WorkLogDTO> getWorkLogsByInternship(String studentId, String internshipId, String token) {
        List<WorkLogDTO> all = workLogService.getByStudent(studentId, token);
        workLogs = new ArrayList<>();
        for (WorkLogDTO log : all) {
            if (internshipId.equals(log.getInternshipId()) &&
                log.getActivities() != null && !log.getActivities().isEmpty()) {
                workLogs.add(log);
            }
        }
        workLogs.sort((a, b) -> a.getWeekStartDate().compareTo(b.getWeekStartDate()));
        return workLogs;
    }
    
    public ApplicationDTO getSelectedApplication() { return selectedApplication; }
    public void setSelectedApplication(ApplicationDTO selectedApplication) {
        this.selectedApplication = selectedApplication;
    }
    public List<ApplicationDTO> getApplications() { return applications; }
    public void setApplications(List<ApplicationDTO> applications) {
        this.applications = applications;
    }
    public List<WorkLogDTO> getWorkLogs() { return workLogs; }
    public void setWorkLogs(List<WorkLogDTO> workLogs) { this.workLogs = workLogs; }
    public EvaluationDTO getEvaluation() { return evaluation; }
    public void setEvaluation(EvaluationDTO evaluation) { this.evaluation = evaluation; }
}
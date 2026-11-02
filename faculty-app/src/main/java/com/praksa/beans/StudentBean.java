package com.praksa.beans;

import com.praksa.dto.StudentDTO;
import com.praksa.service.StudentService;
import java.util.List;

public class StudentBean {
	
	private List<StudentDTO> students;
	private StudentDTO student;
	
	private final StudentService studentService = new StudentService();

	//getters and setters
	public List<StudentDTO> getStudents() {
		return students;
	}

	public void setStudents(List<StudentDTO> students) {
		this.students = students;
	}

	public StudentDTO getStudent() {
		return student;
	}

	public void setStudent(StudentDTO student) {
		this.student = student;
	}

	public StudentService getStudentService() {
		return studentService;
	}
	
	
	public List<StudentDTO> getAll(String token) {
	    this.students = studentService.getAll(token);
	    this.students.sort((a, b) -> {
	        if (a.getFullName() == null) return 1;
	        if (b.getFullName() == null) return -1;
	        return a.getFullName().compareToIgnoreCase(b.getFullName());
	    });
	    return this.students;
	}

    public StudentDTO getById(String id, String token) {
        this.student = studentService.getById(id, token);
        return this.student;
    }

    public void create(StudentDTO student, String token) {
        studentService.create(student, token);
        getAll(token);
    }

    public StudentDTO update(String id, StudentDTO student, String token) {
        this.student = studentService.update(id, student, token);
        getAll(token);
        return this.student;
    }

    public void setActive(String id, boolean active, String token) {
        studentService.setActive(id, active, token);
        getAll(token);
    }
    
    public void delete(String id, String token) {
        studentService.deleteStudent(id, token);
        getAll(token);
    }
    
    public void uploadCsv(byte[] bytes, String token) {
        studentService.uploadCsv(bytes, token);
    }
}

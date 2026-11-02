<%@ page language="java" contentType="application/pdf"
	pageEncoding="UTF-8"%>
<%@ page import="com.praksa.service.StudentService"%>
<%@ page import="com.praksa.dto.*"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@ page import="com.itextpdf.text.*"%>
<%@ page import="com.itextpdf.text.pdf.*"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.Instant"%>
<%@ page import="java.time.ZoneId"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%
response.reset();
response.setContentType("application/pdf");

String token = (String) session.getAttribute("token");
if (token == null) {
	response.sendRedirect("login.jsp");
	return;
}

String studentId = request.getParameter("studentId");
StudentService studentService = new StudentService();
StudentDTO student = studentService.getById(studentId, token);

String fileName = "cv-" + student.getFullName()
.replace(" ", "-")
.replace("š", "s").replace("Š", "S")
.replace("č", "c").replace("Č", "C")
.replace("ć", "c").replace("Ć", "C")
.replace("ž", "z").replace("Ž", "Z")
.replace("đ", "dj").replace("Đ", "Dj");
response.setHeader("Content-Disposition",
"attachment; filename=\"" + fileName + ".pdf\"");

EuropassJson europass = null;
if (student.getEuropassJson() != null && !student.getEuropassJson().isEmpty()) {
	ObjectMapper mapper = new ObjectMapper();
	europass = mapper.readValue(student.getEuropassJson(), EuropassJson.class);
}

DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd.MM.yyyy");

java.util.function.Function<String, String> parseDate = (dateStr) -> {
	if (dateStr == null || dateStr.isEmpty())
		return "";
	try {
		if (dateStr.contains("T")) {
	return Instant.parse(dateStr).atZone(ZoneId.of("Europe/Sarajevo")).toLocalDate().format(fmt);
		}
		return LocalDate.parse(dateStr).format(fmt);
	} catch (Exception e) {
		return dateStr;
	}
};

Document document = new Document(PageSize.A4, 50, 50, 50, 50);
ByteArrayOutputStream baos = new ByteArrayOutputStream();
PdfWriter.getInstance(document, baos);
document.open();

BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.CP1250, BaseFont.EMBEDDED);
BaseFont bfBold = BaseFont.createFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1250, BaseFont.EMBEDDED);
Font titleFont = new Font(bfBold, 20, Font.BOLD, new BaseColor(44, 62, 80));
Font sectionFont = new Font(bfBold, 13, Font.BOLD, new BaseColor(125, 170, 203));
Font normalFont = new Font(bf, 11, Font.NORMAL, BaseColor.DARK_GRAY);
Font smallFont = new Font(bf, 10, Font.NORMAL, BaseColor.GRAY);
Font boldSmall = new Font(bfBold, 11);

com.itextpdf.text.pdf.draw.LineSeparator line = new com.itextpdf.text.pdf.draw.LineSeparator();
line.setLineColor(new BaseColor(125, 170, 203));

//header
Paragraph name = new Paragraph(student.getFullName(), titleFont);
name.setSpacingAfter(4);
document.add(name);

if (student.getEmail() != null && !student.getEmail().isEmpty())
	document.add(new Paragraph(student.getEmail(), smallFont));
if (student.getPhone() != null && !student.getPhone().isEmpty())
	document.add(new Paragraph(student.getPhone(), smallFont));
if (student.getAddress() != null && !student.getAddress().isEmpty())
	document.add(new Paragraph(student.getAddress(), smallFont));

document.add(new Chunk(line));
document.add(new Paragraph(" "));


//slika
if (student.getPhotoPath() != null && !student.getPhotoPath().isEmpty()) {
    try {
        String imagePath = "C:/Users/vranj/Desktop/praksa-backend/" + student.getPhotoPath();
        Image photo = Image.getInstance(imagePath);
        photo.scaleToFit(100, 100);
        photo.setAlignment(Image.ALIGN_LEFT);
        document.add(photo);
        document.add(new Paragraph(" "));
    } catch (Exception e) {
        System.out.println("Slika nije učitana: " + e.getMessage());
    }
}

// abt me
if (student.getSummary() != null && !student.getSummary().isEmpty()) {
	Paragraph sectionTitle = new Paragraph("O MENI", sectionFont);
	sectionTitle.setSpacingAfter(6);
	document.add(sectionTitle);
	Paragraph summary = new Paragraph(student.getSummary(), normalFont);
	summary.setSpacingAfter(12);
	document.add(summary);
	document.add(new Chunk(line));
	document.add(new Paragraph(" "));
}

// obrazovanje
if (europass != null && europass.getEducation() != null && !europass.getEducation().isEmpty()) {
	Paragraph sectionTitle = new Paragraph("OBRAZOVANJE", sectionFont);
	sectionTitle.setSpacingAfter(6);
	document.add(sectionTitle);

	for (EducationDTO edu : europass.getEducation()) {
		Paragraph institution = new Paragraph(edu.getInstitution(), boldSmall);
		institution.setSpacingAfter(2);
		document.add(institution);

		document.add(new Paragraph(edu.getDegree() + " — " + edu.getField(), normalFont));

		String eduStart = parseDate.apply(edu.getStartDate());
		String eduEnd = edu.getEndDate() != null && !edu.getEndDate().isEmpty() ? parseDate.apply(edu.getEndDate())
		: "danas";
		Paragraph periodP = new Paragraph(eduStart + " — " + eduEnd, smallFont);
		periodP.setSpacingAfter(10);
		document.add(periodP);
	}

	document.add(new Chunk(line));
	document.add(new Paragraph(" "));
}

//iskustvo
if (europass != null && europass.getExperience() != null && !europass.getExperience().isEmpty()) {
	Paragraph sectionTitle = new Paragraph("RADNO ISKUSTVO", sectionFont);
	sectionTitle.setSpacingAfter(6);
	document.add(sectionTitle);

	for (ExperienceDTO exp : europass.getExperience()) {
		Paragraph position = new Paragraph(exp.getPosition(), boldSmall);
		position.setSpacingAfter(2);
		document.add(position);

		document.add(new Paragraph(exp.getCompany(), normalFont));

		String expStart = parseDate.apply(exp.getStartDate());
		String expEnd = exp.getEndDate() != null && !exp.getEndDate().isEmpty() ? parseDate.apply(exp.getEndDate())
		: "danas";
		document.add(new Paragraph(expStart + " — " + expEnd, smallFont));

		if (exp.getDescription() != null && !exp.getDescription().isEmpty()) {
	Paragraph desc = new Paragraph(exp.getDescription(), normalFont);
	desc.setSpacingAfter(10);
	document.add(desc);
		} else {
	document.add(new Paragraph(" "));
		}
	}

	document.add(new Chunk(line));
	document.add(new Paragraph(" "));
}

//skills
if (student.getSkills() != null && !student.getSkills().isEmpty()) {
	Paragraph sectionTitle = new Paragraph("VJESTINE", sectionFont);
	sectionTitle.setSpacingAfter(6);
	document.add(sectionTitle);

	for (SkillDTO skill : student.getSkills()) {
		Paragraph skillP = new Paragraph(skill.getName() + "  —  " + skill.getLevel(), normalFont);
		skillP.setSpacingAfter(4);
		document.add(skillP);
	}

	document.add(new Paragraph(" "));
}

//interests
if (student.getInterests() != null && !student.getInterests().isEmpty()) {
	Paragraph sectionTitle = new Paragraph("INTERESOVANJA", sectionFont);
	sectionTitle.setSpacingAfter(6);
	document.add(sectionTitle);

	StringBuilder interests = new StringBuilder();
	for (int i = 0; i < student.getInterests().size(); i++) {
		if (i > 0)
	interests.append(", ");
		interests.append(student.getInterests().get(i).getName());
	}
	document.add(new Paragraph(interests.toString(), normalFont));
}

document.close();


response.setContentLength(baos.size());
response.getOutputStream().write(baos.toByteArray());
response.getOutputStream().flush();
%>
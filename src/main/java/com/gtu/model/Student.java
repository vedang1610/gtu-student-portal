package com.gtu.model;

public class Student {
    private int id;
    private String enrollmentNo;
    private String fullName;
    private String email;
    private String mobile;
    private String dob;
    private String gender;
    private String branch;
    private String program;
    private String collegeName;
    private int currentSemester;
    private String admissionYear;
    private double cgpa;
    private int backlogs;
    private String category;
    private String abcId;
    private String aadhaarNo;
    private String parentMobile;
    private String parentEmail;
    private String accountDetail;
    private String address;
    private String profileImage;

    // Default constructor
    public Student() {}

    // Parameterized constructor (used after login)
    public Student(int id, String enrollmentNo, String fullName, String email,
                   String mobile, String dob, String gender, String branch,
                   String program, String collegeName, int currentSemester,
                   String admissionYear, double cgpa, int backlogs, String category) {
        this.id = id;
        this.enrollmentNo = enrollmentNo;
        this.fullName = fullName;
        this.email = email;
        this.mobile = mobile;
        this.dob = dob;
        this.gender = gender;
        this.branch = branch;
        this.program = program;
        this.collegeName = collegeName;
        this.currentSemester = currentSemester;
        this.admissionYear = admissionYear;
        this.cgpa = cgpa;
        this.backlogs = backlogs;
        this.category = category;
    }

    // Constructor with new profile fields
    public Student(int id, String enrollmentNo, String fullName, String email,
                   String mobile, String dob, String gender, String branch,
                   String program, String collegeName, int currentSemester,
                   String admissionYear, double cgpa, int backlogs, String category,
                   String abcId, String aadhaarNo, String parentMobile, String parentEmail,
                   String accountDetail, String address) {
        this(id, enrollmentNo, fullName, email, mobile, dob, gender, branch, program,
             collegeName, currentSemester, admissionYear, cgpa, backlogs, category);
        this.abcId = abcId;
        this.aadhaarNo = aadhaarNo;
        this.parentMobile = parentMobile;
        this.parentEmail = parentEmail;
        this.accountDetail = accountDetail;
        this.address = address;
    }

    // Constructor with new profile fields and profile image
    public Student(int id, String enrollmentNo, String fullName, String email,
                   String mobile, String dob, String gender, String branch,
                   String program, String collegeName, int currentSemester,
                   String admissionYear, double cgpa, int backlogs, String category,
                   String abcId, String aadhaarNo, String parentMobile, String parentEmail,
                   String accountDetail, String address, String profileImage) {
        this(id, enrollmentNo, fullName, email, mobile, dob, gender, branch, program,
             collegeName, currentSemester, admissionYear, cgpa, backlogs, category,
             abcId, aadhaarNo, parentMobile, parentEmail, accountDetail, address);
        this.profileImage = profileImage;
    }
    public int getId() { return id; }
    public String getEnrollmentNo() { return enrollmentNo; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public String getMobile() { return mobile; }
    public String getDob() { return dob; }
    public String getGender() { return gender; }
    public String getBranch() { return branch; }
    public String getProgram() { return program; }
    public String getCollegeName() { return collegeName; }
    public int getCurrentSemester() { return currentSemester; }
    public String getAdmissionYear() { return admissionYear; }
    public double getCgpa() { return cgpa; }
    public int getBacklogs() { return backlogs; }
    public String getCategory() { return category; }
    public String getAbcId() { return abcId; }
    public String getAadhaarNo() { return aadhaarNo; }
    public String getParentMobile() { return parentMobile; }
    public String getParentEmail() { return parentEmail; }
    public String getAccountDetail() { return accountDetail; }
    public String getAddress() { return address; }
    public String getProfileImage() { return profileImage; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setEnrollmentNo(String enrollmentNo) { this.enrollmentNo = enrollmentNo; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setEmail(String email) { this.email = email; }
    public void setMobile(String mobile) { this.mobile = mobile; }
    public void setDob(String dob) { this.dob = dob; }
    public void setGender(String gender) { this.gender = gender; }
    public void setBranch(String branch) { this.branch = branch; }
    public void setProgram(String program) { this.program = program; }
    public void setCollegeName(String collegeName) { this.collegeName = collegeName; }
    public void setCurrentSemester(int currentSemester) { this.currentSemester = currentSemester; }
    public void setAdmissionYear(String admissionYear) { this.admissionYear = admissionYear; }
    public void setCgpa(double cgpa) { this.cgpa = cgpa; }
    public void setBacklogs(int backlogs) { this.backlogs = backlogs; }
    public void setCategory(String category) { this.category = category; }
    public void setAbcId(String abcId) { this.abcId = abcId; }
    public void setAadhaarNo(String aadhaarNo) { this.aadhaarNo = aadhaarNo; }
    public void setParentMobile(String parentMobile) { this.parentMobile = parentMobile; }
    public void setParentEmail(String parentEmail) { this.parentEmail = parentEmail; }
    public void setAccountDetail(String accountDetail) { this.accountDetail = accountDetail; }
    public void setAddress(String address) { this.address = address; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }
}

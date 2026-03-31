package com.hostel.model;

import java.sql.Timestamp;

public class student {
	private String full_name, username, email, phone, address, dob, role, password, status, mealStatus;
	int room;
	private String course, department;
	private Timestamp createdAt;
	private double mealCharge;

	public student() {
	}

	public student(String full_name, String username, String email, String phone, String address, String dob,
			String role, String password, int room, String status, String mealStatus, String course,
			String department) {
		this.full_name = full_name;
		this.username = username;
		this.email = email;
		this.phone = phone;
		this.address = address;
		this.dob = dob;
		this.course = course;
		this.department = department;
		this.room = room;
		this.password = password;
		this.status = status;
		this.role = role;
		this.mealStatus = mealStatus;
	}

	public String getCourse() {
		return course;
	}

	public void setCourse(String course) {
		this.course = course;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getMealStatus() {
		return mealStatus;
	}

	public void setMealStatus(String mealStatus) {
		this.mealStatus = mealStatus;
	}

	public String getFullname() {
		return full_name;
	}

	public void setFullname(String full_name) {
		this.full_name = full_name;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getDob() {
		return dob;
	}

	public void setDob(String dob) {
		this.dob = dob;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public int getRoom() {
		return room;
	}

	public void setRoom(int room) {
		this.room = room;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public double getMealCharge() {
		return mealCharge;
	}

	public void setMealCharge(double mealCharge) {
		this.mealCharge = mealCharge;
	}

}

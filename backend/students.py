from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr
from typing import Optional, Dict, Any
from bson import ObjectId
from db import get_college_db

router = APIRouter(prefix="/students", tags=["students"])

# Pydantic model for counselor details
class CounselorDetails(BaseModel):
    photo: str
    name: str
    email: EmailStr
    mobile: str
    institute: str

# Pydantic model for a student
class Student(BaseModel):
    enrollment_no: str
    name: str
    dob: str  # You can change this to a date type if needed
    mobile: str
    email: EmailStr
    address: str
    course: str
    branch: str
    institute: str
    profile_photo: str
    emergency_no: str
    counselor: str
    counselor_details: CounselorDetails

# Helper function to convert MongoDB document to dictionary
def student_helper(student: Dict[str, Any]) -> Dict[str, Any]:
    return {
        "id": str(student["_id"]),
        "enrollment_no": student["enrollment_no"],
        "name": student["name"],
        "dob": student["dob"],
        "mobile": student["mobile"],
        "email": student["email"],
        "address": student["address"],
        "course": student["course"],
        "branch": student["branch"],
        "institute": student["institute"],
        "profile_photo": student["profile_photo"],
        "emergency_no": student["emergency_no"],
        "counselor": student["counselor"],
        "counselor_details": student["counselor_details"],
    }

# Get the college_db instance
db = get_college_db()
students_collection = db.get_collection("students")

# Create a new student
@router.post("/", response_model=dict)
async def create_student(student: Student):
    student_data = student.dict()
    result = students_collection.insert_one(student_data)
    new_student = students_collection.find_one({"_id": result.inserted_id})
    return student_helper(new_student)

# Get all students
@router.get("/", response_model=list)
async def get_students():
    students = []
    for student in students_collection.find():
        students.append(student_helper(student))
    return students

# Update a student by ID
@router.put("/{student_id}", response_model=dict)
async def update_student(student_id: str, student: Student):
    update_result = students_collection.update_one(
        {"_id": ObjectId(student_id)},
        {"$set": student.dict()}
    )
    if update_result.modified_count == 1:
        updated_student = students_collection.find_one({"_id": ObjectId(student_id)})
        if updated_student:
            return student_helper(updated_student)
    raise HTTPException(status_code=404, detail="Student not found")

# Delete a student by ID
@router.delete("/{student_id}", response_model=dict)
async def delete_student(student_id: str):
    delete_result = students_collection.delete_one({"_id": ObjectId(student_id)})
    if delete_result.deleted_count == 1:
        return {"message": "Student deleted successfully"}
    raise HTTPException(status_code=404, detail="Student not found")

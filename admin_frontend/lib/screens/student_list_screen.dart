import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final String _baseUrl = "http://127.0.0.1:8000";
  List<dynamic> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response = await Dio().get("$_baseUrl/students/");
      setState(() {
        _students = response.data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching students: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Delete a student
  Future<void> _deleteStudent(String id) async {
    try {
      await Dio().delete("$_baseUrl/students/$id");
      _fetchStudents(); // Refresh the list after deletion
    } catch (e) {
      print("Error deleting student: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Students")),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _fetchStudents,
                child: ListView.builder(
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    return ListTile(
                      title: Text(student['name']),
                      subtitle: Text(
                        "Enrollment: ${student['enrollment_no']}\nCourse: ${student['course']}",
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteStudent(student['id']);
                        },
                      ),
                      onTap: () {
                        // Navigate to the student form for update (passing current student data)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    StudentFormScreen(student: student),
                          ),
                        ).then((value) {
                          _fetchStudents(); // Refresh after returning from the form
                        });
                      },
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the student form for creating a new student
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentFormScreen()),
          ).then((value) {
            _fetchStudents(); // Refresh after returning from the form
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

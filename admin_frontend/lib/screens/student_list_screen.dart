import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  // final String _baseUrl = "http://127.0.0.1:8084";
  final String _baseUrl = "https://admin-panel-hmwu.onrender.com";
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

  Future<void> _deleteStudent(String id) async {
    try {
      await Dio().delete("$_baseUrl/students/$id");
      _fetchStudents();
    } catch (e) {
      print("Error deleting student: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error deleting student"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildStudentItem(dynamic student) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          radius: 16,
          child: Text(
            (student['name'] != null && student['name'].toString().isNotEmpty)
                ? student['name'][0]
                : "?",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          student['name'] ?? "No Name",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Enrollment: ${student['enrollment_no']}\nCourse: ${student['course']}",
          style: const TextStyle(fontSize: 10),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 16),
          onPressed: () {
            _deleteStudent(student['id']);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentFormScreen(student: student),
            ),
          ).then((value) {
            _fetchStudents();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students", style: TextStyle(fontSize: 16)),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf5f5f5), Color(0xFFe0e0e0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                    onRefresh: _fetchStudents,
                    child:
                        _students.isNotEmpty
                            ? ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              itemCount: _students.length,
                              itemBuilder: (context, index) {
                                final student = _students[index];
                                return _buildStudentItem(student);
                              },
                            )
                            : Center(
                              child: Text(
                                "No students found",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                  ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentFormScreen()),
          ).then((value) {
            _fetchStudents();
          });
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 16),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class StudentFormScreen extends StatefulWidget {
  final Map<String, dynamic>? student; // If null, it's a new student

  const StudentFormScreen({super.key, this.student});
  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final String _baseUrl = "http://192.168.198.214:8000";

  // Controllers for student fields
  late TextEditingController _enrollmentController;
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _courseController;
  late TextEditingController _branchController;
  late TextEditingController _instituteController;
  late TextEditingController _profilePhotoController;
  late TextEditingController _emergencyNoController;
  late TextEditingController _counselorPhotoController;
  late TextEditingController _counselorNameController;
  late TextEditingController _counselorEmailController;
  late TextEditingController _counselorMobileController;
  late TextEditingController _counselorInstituteController;

  @override
  void initState() {
    super.initState();
    final student = widget.student;
    _enrollmentController = TextEditingController(
      text: student?['enrollment_no'] ?? '',
    );
    _nameController = TextEditingController(text: student?['name'] ?? '');
    _dobController = TextEditingController(text: student?['dob'] ?? '');
    _mobileController = TextEditingController(text: student?['mobile'] ?? '');
    _emailController = TextEditingController(text: student?['email'] ?? '');
    _addressController = TextEditingController(text: student?['address'] ?? '');
    _courseController = TextEditingController(text: student?['course'] ?? '');
    _branchController = TextEditingController(text: student?['branch'] ?? '');
    _instituteController = TextEditingController(
      text: student?['institute'] ?? '',
    );
    _profilePhotoController = TextEditingController(
      text: student?['profile_photo'] ?? '',
    );
    _emergencyNoController = TextEditingController(
      text: student?['emergency_no'] ?? '',
    );
    final counselorDetails = student?['counselor_details'] ?? {};
    _counselorPhotoController = TextEditingController(
      text: counselorDetails['photo'] ?? '',
    );
    _counselorNameController = TextEditingController(
      text: counselorDetails['name'] ?? '',
    );
    _counselorEmailController = TextEditingController(
      text: counselorDetails['email'] ?? '',
    );
    _counselorMobileController = TextEditingController(
      text: counselorDetails['mobile'] ?? '',
    );
    _counselorInstituteController = TextEditingController(
      text: counselorDetails['institute'] ?? '',
    );
  }

  @override
  void dispose() {
    _enrollmentController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _courseController.dispose();
    _branchController.dispose();
    _instituteController.dispose();
    _profilePhotoController.dispose();
    _emergencyNoController.dispose();
    _counselorPhotoController.dispose();
    _counselorNameController.dispose();
    _counselorEmailController.dispose();
    _counselorMobileController.dispose();
    _counselorInstituteController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Gather data from controllers into a JSON-like map
      final Map<String, dynamic> studentData = {
        "enrollment_no": _enrollmentController.text,
        "name": _nameController.text,
        "dob": _dobController.text,
        "mobile": _mobileController.text,
        "email": _emailController.text,
        "address": _addressController.text,
        "course": _courseController.text,
        "branch": _branchController.text,
        "institute": _instituteController.text,
        "profile_photo": _profilePhotoController.text,
        "emergency_no": _emergencyNoController.text,
        "counselor_details": {
          "photo": _counselorPhotoController.text,
          "name": _counselorNameController.text,
          "email": _counselorEmailController.text,
          "mobile": _counselorMobileController.text,
          "institute": _counselorInstituteController.text,
        },
      };

      try {
        if (widget.student == null) {
          // Create new student (POST)
          await Dio().post("$_baseUrl/students/", data: studentData);
        } else {
          // Update existing student (PUT)
          final String studentId = widget.student!['id'];
          await Dio().put("$_baseUrl/students/$studentId", data: studentData);
        }
        Navigator.pop(context);
      } catch (e) {
        print("Error submitting form: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error saving student data")),
        );
      }
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? "Please enter $label" : null,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.student != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Student" : "Add Student")),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(
                          child: SizedBox(
                            width: 600, // Adjust the width as desired
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Center(
                                        child: Text(
                                          "Student Form",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildTextField(
                                        "Enrollment No",
                                        _enrollmentController,
                                      ),
                                      _buildTextField("Name", _nameController),
                                      _buildTextField(
                                        "DOB (YYYY-MM-DD)",
                                        _dobController,
                                      ),
                                      _buildTextField(
                                        "Mobile",
                                        _mobileController,
                                      ),
                                      _buildTextField(
                                        "Email",
                                        _emailController,
                                        isEmail: true,
                                      ),
                                      _buildTextField(
                                        "Address",
                                        _addressController,
                                      ),
                                      _buildTextField(
                                        "Course",
                                        _courseController,
                                      ),
                                      _buildTextField(
                                        "Branch",
                                        _branchController,
                                      ),
                                      _buildTextField(
                                        "Institute",
                                        _instituteController,
                                      ),
                                      _buildTextField(
                                        "Profile Photo URL",
                                        _profilePhotoController,
                                      ),
                                      _buildTextField(
                                        "Emergency No",
                                        _emergencyNoController,
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        "Counselor Details",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      _buildTextField(
                                        "Counselor Photo URL",
                                        _counselorPhotoController,
                                      ),
                                      _buildTextField(
                                        "Counselor Name",
                                        _counselorNameController,
                                      ),
                                      _buildTextField(
                                        "Counselor Email",
                                        _counselorEmailController,
                                        isEmail: true,
                                      ),
                                      _buildTextField(
                                        "Counselor Mobile",
                                        _counselorMobileController,
                                      ),
                                      _buildTextField(
                                        "Counselor Institute",
                                        _counselorInstituteController,
                                      ),
                                      const SizedBox(height: 30),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _submitForm,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            backgroundColor: Colors.blue,
                                          ),
                                          child: Text(
                                            isEditing
                                                ? "Update Student"
                                                : "Add Student",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

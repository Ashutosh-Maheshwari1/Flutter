import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const StudentRegistrationApp());
}

class StudentRegistrationApp extends StatelessWidget {
  const StudentRegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4B2AC9);
    return MaterialApp(
      title: 'Student Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const StudentRegistrationForm(),
    );
  }
}

class StudentRegistrationForm extends StatefulWidget {
  const StudentRegistrationForm({super.key});

  @override
  State<StudentRegistrationForm> createState() => _StudentRegistrationFormState();
}

class _StudentRegistrationFormState extends State<StudentRegistrationForm> {
  static const Color primaryColor = Color(0xFF4B2AC9);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  String? _selectedCourse;

  final List<String> _courses = const [
    'B.Tech Computer Science',
    'B.Tech Mechanical',
    'B.Tech Electrical',
    'B.Tech Civil',
    'BCA',
    'MCA',
    'B.Sc IT',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _rollNumberController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _emailController.clear();
    _mobileController.clear();
    _rollNumberController.clear();
    _cityController.clear();
    setState(() {
      _selectedCourse = null;
    });
  }

  void _submitForm() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (isFormValid) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDFF5E3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.green, size: 36),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Student Registered\nSuccessfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                _summaryRow(Icons.person, 'Name', _fullNameController.text),
                _summaryRow(Icons.email, 'Email', _emailController.text),
                _summaryRow(Icons.phone, 'Mobile', _mobileController.text),
                _summaryRow(Icons.badge, 'Roll No', _rollNumberController.text),
                _summaryRow(Icons.school, 'Course', _selectedCourse ?? ''),
                _summaryRow(Icons.location_on, 'City', _cityController.text),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetForm();
                    },
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: primaryColor),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          const Text(':  ', style: TextStyle(color: Colors.black54)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Student Registration'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                CircleAvatar(
                  radius: 44,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  child: Icon(Icons.school, size: 44, color: primaryColor),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Student Registration',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Please fill in the details to register',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name *',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address *',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email address';
                    }
                    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}\$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _mobileController,
                  label: 'Mobile Number *',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (value.trim().length != 10) {
                      return 'Please enter 10 digit mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _rollNumberController,
                  label: 'Roll Number *',
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your roll number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _buildCourseDropdown(),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _cityController,
                  label: 'City *',
                  icon: Icons.location_on_outlined,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _resetForm,
                        icon: const Icon(Icons.refresh, color: primaryColor),
                        label: const Text('Reset', style: TextStyle(color: primaryColor)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.send, size: 18),
                        label: const Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildCourseDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCourse,
      icon: const Icon(Icons.keyboard_arrow_down),
      decoration: InputDecoration(
        labelText: 'Course *',
        prefixIcon: const Icon(Icons.menu_book_outlined, color: primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 1.6),
        ),
      ),
      items: _courses
          .map((course) => DropdownMenuItem(
                value: course,
                child: Text(course, overflow: TextOverflow.ellipsis),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCourse = value;
        });
      },
      validator: (value) {
        if (value == null) return 'Please select your course';
        return null;
      },
    );
  }
}

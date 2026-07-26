import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// THEME
// ---------------------------------------------------------------------------

class AppColors {
  static const blue = Color(0xFF1565C0);
  static const green = Color(0xFF2E7D32);
  static const orange = Color(0xFFF57C00);
}

// ---------------------------------------------------------------------------
// APP ROOT
// ---------------------------------------------------------------------------

class StudentNavigatorApp extends StatelessWidget {
  const StudentNavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Information Navigator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      ),
      home: const HomeScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == EditCourseScreen.routeName) {
          final currentCourse = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => EditCourseScreen(initialCourse: currentCourse),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN 1: HOME SCREEN — Enter Student Details
// ---------------------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController(text: 'Pankaj Kapoor');
  final _rollController = TextEditingController(text: '101');
  String _selectedCourse = 'Flutter';
  String? _updatedCourse;

  final _courses = const ['Flutter', 'Java', 'Python', 'AI'];

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  Future<void> _viewDetails() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => StudentDetailsScreen(
          name: _nameController.text,
          rollNo: _rollController.text,
          course: _selectedCourse,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _updatedCourse = result;
        _selectedCourse = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        title: const Text('Student Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Center(
              child: Icon(Icons.school, size: 70, color: AppColors.blue),
            ),
            const SizedBox(height: 24),
            const Text('Student Name', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: _fieldDecoration(),
            ),
            const SizedBox(height: 16),
            const Text('Roll Number', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _rollController,
              keyboardType: TextInputType.number,
              decoration: _fieldDecoration(),
            ),
            const SizedBox(height: 16),
            const Text('Select Course', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedCourse,
              decoration: _fieldDecoration(),
              items: _courses.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCourse = value);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _viewDetails,
              icon: const Icon(Icons.visibility),
              label: const Text('View Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            if (_updatedCourse != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text('Updated Course :', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 4),
                    Text(
                      _updatedCourse!,
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN 2: STUDENT DETAILS SCREEN — View Student Details
// ---------------------------------------------------------------------------

class StudentDetailsScreen extends StatefulWidget {
  final String name;
  final String rollNo;
  final String course;

  const StudentDetailsScreen({
    super.key,
    required this.name,
    required this.rollNo,
    required this.course,
  });

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late String _currentCourse;

  @override
  void initState() {
    super.initState();
    _currentCourse = widget.course;
  }

  Future<void> _editCourse() async {
    final result = await Navigator.pushNamed<String>(
      context,
      EditCourseScreen.routeName,
      arguments: _currentCourse,
    );

    if (result != null) {
      setState(() => _currentCourse = result);
    }
  }

  void _goBack() {
    Navigator.pop(context, _currentCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        title: const Text('Student Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student Details',
                      style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    _detailRow(Icons.person, 'Name', widget.name, Colors.blue),
                    const SizedBox(height: 14),
                    _detailRow(Icons.badge, 'Roll No', widget.rollNo, Colors.teal),
                    const SizedBox(height: 14),
                    _detailRow(Icons.school, 'Course', _currentCourse, AppColors.blue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _editCourse,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Course'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E35B1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _goBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN 3: EDIT COURSE SCREEN — Select New Course
// ---------------------------------------------------------------------------

class EditCourseScreen extends StatefulWidget {
  static const routeName = '/editCourse';

  final String initialCourse;

  const EditCourseScreen({super.key, required this.initialCourse});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  late String _selectedCourse;

  final _courses = const ['Flutter', 'Java', 'Python', 'AI'];

  @override
  void initState() {
    super.initState();
    _selectedCourse = widget.initialCourse;
  }

  void _saveChanges() {
    Navigator.pop(context, _selectedCourse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        title: const Text('Edit Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select New Course',
              style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: _courses
                    .map(
                      (course) => RadioListTile<String>(
                        title: Text(course),
                        value: course,
                        groupValue: _selectedCourse,
                        activeColor: AppColors.orange,
                        onChanged: (value) {
                          if (value != null) setState(() => _selectedCourse = value);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.check),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

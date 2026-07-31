import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const Color kPrimaryPurple = Color(0xFF4B3FBF);

void main() {
  runApp(const StudentRegistrationApp());
}

class StudentRegistrationApp extends StatelessWidget {
  const StudentRegistrationApp({super.key});

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Registration System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: kPrimaryPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const RegistrationScreen(),
    );
  }
}

// =======================================================================
// MODEL — plain data class for a single student record.
// =======================================================================
class Student {
  final int? id;
  final String studentName;
  final String rollNumber;
  final String email;
  final String mobile;
  final String department;
  final String semester;
  final double cgpa;

  const Student({
    this.id,
    required this.studentName,
    required this.rollNumber,
    required this.email,
    required this.mobile,
    required this.department,
    required this.semester,
    required this.cgpa,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'studentName': studentName,
      'rollNumber': rollNumber,
      'email': email,
      'mobile': mobile,
      'department': department,
      'semester': semester,
      'cgpa': cgpa,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int?,
      studentName: map['studentName'] as String,

      rollNumber: map['rollNumber'] as String,
      email: map['email'] as String,
      mobile: map['mobile'] as String,
      department: map['department'] as String,
      semester: map['semester'] as String,
      cgpa: (map['cgpa'] as num).toDouble(),
    );
  }

  Student copyWith({
    int? id,
    String? studentName,
    String? rollNumber,
    String? email,
    String? mobile,
    String? department,
    String? semester,
    double? cgpa,
  }) {
    return Student(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      rollNumber: rollNumber ?? this.rollNumber,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      cgpa: cgpa ?? this.cgpa,
    );
  }

}

// =======================================================================
// DATABASE — all SQLite access in one place.
// =======================================================================
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;
  static const String tableName = 'students';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'students.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentName TEXT NOT NULL,
            rollNumber TEXT NOT NULL,

            email TEXT NOT NULL,
            mobile TEXT NOT NULL,
            department TEXT NOT NULL,
            semester TEXT NOT NULL,
            cgpa REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertStudent(Student student) async {
    final db = await database;
    return db.insert(tableName, student.toMap());
  }

  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final maps = await db.query(tableName, orderBy: 'id DESC');
    return maps.map((m) => Student.fromMap(m)).toList();
  }

  Future<int> updateStudent(Student student) async {
    final db = await database;
    return db.update(
      tableName,
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );

  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

// =======================================================================
// SCREEN — Registration Form (also doubles as Edit Student)
// =======================================================================
const _departments = [
  'Computer Science',
  'Information Technology',
  'Electronics',
  'Mechanical',
  'Civil',
  'Electrical',
];

const _semesters = [
  'Semester 1',
  'Semester 2',
  'Semester 3',
  'Semester 4',
  'Semester 5',
  'Semester 6',
  'Semester 7',
  'Semester 8',
];

class RegistrationScreen extends StatefulWidget {
  /// Pass an existing student to edit it. Leave null to register a new
  /// student.
  final Student? existing;

  const RegistrationScreen({super.key, this.existing});

  bool get isEdit => existing != null;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _rollCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _cgpaCtrl;

  late String _department;
  late String _semester;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.existing;

    _nameCtrl = TextEditingController(text: s?.studentName ?? '');
    _rollCtrl = TextEditingController(text: s?.rollNumber ?? '');
    _emailCtrl = TextEditingController(text: s?.email ?? '');
    _mobileCtrl = TextEditingController(text: s?.mobile ?? '');
    _cgpaCtrl = TextEditingController(text: s?.cgpa.toString() ?? '');
    _department = s?.department ?? _departments.first;
    _semester = s?.semester ?? _semesters.last;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rollCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _cgpaCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final student = Student(
      studentName: _nameCtrl.text.trim(),
      rollNumber: _rollCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      department: _department,
      semester: _semester,

      cgpa: double.parse(_cgpaCtrl.text.trim()),
    );

    final newId = await DatabaseHelper.instance.insertStudent(student);

    if (!mounted) return;
    setState(() => _saving = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => StudentRegisteredScreen(
          student: student.copyWith(id: newId),
        ),
      ),
    );
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final updated = widget.existing!.copyWith(
      studentName: _nameCtrl.text.trim(),
      rollNumber: _rollCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      department: _department,
      semester: _semester,
      cgpa: double.parse(_cgpaCtrl.text.trim()),

    );

    await DatabaseHelper.instance.updateStudent(updated);

    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Student' : 'Student Registration'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _Field(
                    icon: Icons.person_outline,
                    label: 'Student Name',
                    controller: _nameCtrl,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),

                  const SizedBox(height: 14),
                  _Field(
                    icon: Icons.badge_outlined,
                    label: 'Roll Number',
                    controller: _rollCtrl,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  _Field(
                    icon: Icons.email_outlined,
                    label: 'Email Address',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _Field(
                    icon: Icons.phone_outlined,
                    label: 'Mobile Number',
                    controller: _mobileCtrl,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  _Dropdown(
                    icon: Icons.account_balance_outlined,
                    label: 'Department',
                    value: _department,
                    items: _departments,
                    onChanged: (v) => setState(() => _department = v!),
                  ),
                  const SizedBox(height: 14),
                  _Dropdown(
                    icon: Icons.calendar_today_outlined,
                    label: 'Semester',
                    value: _semester,
                    items: _semesters,
                    onChanged: (v) => setState(() => _semester = v!),
                  ),
                  const SizedBox(height: 14),
                  _Field(
                    icon: Icons.bar_chart,
                    label: 'CGPA',
                    controller: _cgpaCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final n = double.tryParse(v);
                      if (n == null || n < 0 || n > 10) return '0 - 10 only';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  if (widget.isEdit)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.save_outlined, size: 18),
                            label: Text(_saving ? 'Saving...' : 'Update Student'),
                            onPressed: _saving ? null : _update,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.close, size: 18),
                            label: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(

                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.check, size: 18),
                            label: Text(
                                _saving ? 'Registering...' : 'Register Student'),
                            onPressed: _saving ? null : _register,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.list, size: 18),
                            label: const Text('View Students'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const StudentListScreen(),
                                ),
                              );
                            },

                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.validator,
  });

  @override

  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kPrimaryPurple, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override

  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kPrimaryPurple, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// =======================================================================
// SCREEN — Student Registered (success screen)
// =======================================================================
class StudentRegisteredScreen extends StatelessWidget {
  final Student student;
  const StudentRegisteredScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Registration')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),

            const CircleAvatar(
              radius: 36,
              backgroundColor: Color(0xFFDFF5E1),
              child: Icon(Icons.check, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Student Registered\nSuccessfully!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _SummaryRow('Name', student.studentName),
                    _SummaryRow('Roll No', student.rollNumber),
                    _SummaryRow('Department', student.department),
                    _SummaryRow('Semester', student.semester),
                    _SummaryRow('CGPA', student.cgpa.toString()),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(

                backgroundColor: kPrimaryPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentListScreen()),
                );
              },
              child: const Text('View All Students'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RegistrationScreen()),
                );
              },
              child: const Text('Add Another Student'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {

  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// =======================================================================
// SCREEN — View All Students (DataTable + search + delete dialog)
// =======================================================================
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {

  List<Student> _all = [];
  List<Student> _filtered = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudents();
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    setState(() => _loading = true);
    final students = await DatabaseHelper.instance.getAllStudents();
    setState(() {
      _all = students;
      _applyFilter();
      _loading = false;
    });
  }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();

    setState(() {
      _filtered = q.isEmpty
          ? _all
          : _all
              .where((s) =>
                  s.studentName.toLowerCase().contains(q) ||
                  s.rollNumber.toLowerCase().contains(q))
              .toList();
    });
  }

  Future<void> _editStudent(Student s) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => RegistrationScreen(existing: s)),
    );
    if (changed == true) _loadStudents();
  }

  Future<void> _deleteStudent(Student s) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
        title: const Text('Delete Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this student record?'),

            const SizedBox(height: 12),
            Text('Name   : ${s.studentName}'),
            Text('Roll No : ${s.rollNumber}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && s.id != null) {
      await DatabaseHelper.instance.deleteStudent(s.id!);
      _loadStudents();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Registered Students')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStudents,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search by name or roll number...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total Students: ${_filtered.length}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  if (_filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('No students found.')),
                    )

                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Roll No')),
                          DataColumn(label: Text('Dept.')),
                          DataColumn(label: Text('Sem')),
                          DataColumn(label: Text('CGPA')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _filtered.map((s) {
                          return DataRow(cells: [
                            DataCell(Text(s.studentName)),
                            DataCell(Text(s.rollNumber)),
                            DataCell(Text(_shortDept(s.department))),
                            DataCell(Text(_shortSem(s.semester))),
                            DataCell(Text(s.cgpa.toString())),
                            DataCell(Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: kPrimaryPurple, size: 20),
                                  onPressed: () => _editStudent(s),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 20),

                                  onPressed: () => _deleteStudent(s),
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (_filtered.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.swipe, size: 16, color: Colors.grey),
                        SizedBox(width: 6),
                        Text('Swipe left or right to see more columns',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Add Student'),
        onPressed: () async {
          await Navigator.push(
            context,

            MaterialPageRoute(builder: (_) => const RegistrationScreen()),
          );
          _loadStudents();
        },
      ),
    );
  }

  String _shortDept(String d) {
    switch (d) {
      case 'Computer Science':
        return 'CSE';
      case 'Information Technology':
        return 'IT';
      case 'Electronics':
        return 'ECE';
      case 'Mechanical':
        return 'ME';
      case 'Civil':
        return 'CE';
      case 'Electrical':
        return 'EE';
      default:
        return d;
    }
  }

  String _shortSem(String s) => s.replaceFirst('Semester ', 'Sem ');
}

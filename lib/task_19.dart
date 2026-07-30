import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String studentsBoxName = 'students';

Future<void> initHiveForTask19() async {
  await Hive.initFlutter();
  final box = await Hive.openBox(studentsBoxName);

  // Seed with the same 5 students shown in the reference screenshot,
  // but only the first time the app ever runs (box starts empty).
  if (box.isEmpty) {
    await box.put(1, {'name': 'Rahul', 'course': 'BCA', 'age': 20});

    await box.put(2, {'name': 'Aman', 'course': 'B.Tech', 'age': 21});
    await box.put(3, {'name': 'Priya', 'course': 'MBA', 'age': 23});
    await box.put(4, {'name': 'Neha', 'course': 'MCA', 'age': 22});
    await box.put(5, {'name': 'Rohit', 'course': 'BBA', 'age': 19});
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForTask19();
  runApp(const Task19App());
}

class Task19App extends StatelessWidget {
  const Task19App({super.key});

  static const Color primaryPurple = Color(0xFF4B3FBF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive CRUD Students',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,

        ),
      ),
      home: const HiveScreen(),
    );
  }
}

// ---------------------------------------------------------------------
// 1 & 3. Hive Screen (list, shown before AND after the update — same
// screen, it just re-renders automatically because ValueListenableBuilder
// is watching the Hive box).
// ---------------------------------------------------------------------
class HiveScreen extends StatelessWidget {
  const HiveScreen({super.key});

  Future<void> _addStudent(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StudentFormScreen()),
    );
  }

  Future<void> _editStudent(BuildContext context, dynamic hiveKey,
      Map student) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentFormScreen(hiveKey: hiveKey, existing: student),
      ),
    );

    // No manual refresh needed here — ValueListenableBuilder below
    // rebuilds automatically the instant the Hive box changes.
  }

  Future<void> _deleteStudent(
      BuildContext context, dynamic hiveKey, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Student?'),
        content: Text('Remove $name from the list? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await Hive.box(studentsBoxName).delete(hiveKey);
    }
  }

  @override
  Widget build(BuildContext context) {

    final box = Hive.box(studentsBoxName);

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Hive CRUD Students'),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box b, _) {
          final keys = b.keys.toList();
          if (keys.isEmpty) {
            return const Center(child: Text('No students yet. Tap + to add one.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: keys.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final key = keys[i];
              final student = Map<String, dynamic>.from(b.get(key) as Map);
              return ListTile(
                title: Text(
                  student['name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${student['course']} | Age : ${student['age']} | ID : $key',
                ),
                trailing: Row(

                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Task19App.primaryPurple),
                      onPressed: () => _editStudent(context, key, student),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _deleteStudent(context, key, student['name'] ?? ''),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Task19App.primaryPurple,
        onPressed: () => _addStudent(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// 2. Update Student Screen (also doubles as "Add Student" when no
// existing record / hiveKey is passed in).

// ---------------------------------------------------------------------
class StudentFormScreen extends StatefulWidget {
  /// The Hive key of the record being edited. Null when adding a new
  /// student.
  final dynamic hiveKey;

  /// The student's current data, used to pre-fill the fields when editing.
  final Map? existing;

  const StudentFormScreen({super.key, this.hiveKey, this.existing});

  bool get isEdit => hiveKey != null;

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _courseCtrl;
  late final TextEditingController _ageCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?['name'] ?? '');
    _courseCtrl = TextEditingController(text: widget.existing?['course'] ?? '');
    _ageCtrl =
        TextEditingController(text: widget.existing?['age']?.toString() ?? '');

  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _courseCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'name': _nameCtrl.text.trim(),
      'course': _courseCtrl.text.trim(),
      'age': int.parse(_ageCtrl.text.trim()),
    };

    final box = Hive.box(studentsBoxName);
    if (widget.isEdit) {
      // Same key -> overwrites the existing record in place.
      await box.put(widget.hiveKey, data);
    } else {
      await box.add(data);
    }

    if (!mounted) return;
    // Pop back to the Hive Screen; its ValueListenableBuilder picks up
    // the change automatically, so no data needs to be passed back here.

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Update Student' : 'Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Course'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _courseCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder()),

                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Age'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (int.tryParse(v.trim()) == null) return 'Numbers only';
                  return null;
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Task19App.primaryPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _save,
                child: Text(widget.isEdit ? 'UPDATE STUDENT' : 'ADD STUDENT'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),

                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

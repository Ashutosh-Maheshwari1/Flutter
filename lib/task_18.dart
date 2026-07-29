import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Task18App());
}

class Task18App extends StatelessWidget {
  const Task18App({super.key});

  static const Color primaryPurple = Color(0xFF4B3FBF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Placement Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
      home: const StartupRouter(),
    );
  }
}

// ---------------------------------------------------------------------

// Data model + SharedPreferences storage helper
// ---------------------------------------------------------------------
class PlacementRecord {
  String name;
  String rollNumber;
  String email;
  String mobile;
  String branch;
  String cgpa;
  bool interested;

  PlacementRecord({
    this.name = '',
    this.rollNumber = '',
    this.email = '',
    this.mobile = '',
    this.branch = 'Computer Science',
    this.cgpa = '',
    this.interested = true,
  });
}

class PlacementStorage {
  static const _kName = 'sp_name';
  static const _kRoll = 'sp_roll';
  static const _kEmail = 'sp_email';
  static const _kMobile = 'sp_mobile';
  static const _kBranch = 'sp_branch';
  static const _kCgpa = 'sp_cgpa';
  static const _kInterested = 'sp_interested';

  static const _kHasData = 'sp_has_data';

  /// Writes every field to SharedPreferences (device-local, persists
  /// across app restarts).
  static Future<void> save(PlacementRecord r) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, r.name);
    await prefs.setString(_kRoll, r.rollNumber);
    await prefs.setString(_kEmail, r.email);
    await prefs.setString(_kMobile, r.mobile);
    await prefs.setString(_kBranch, r.branch);
    await prefs.setString(_kCgpa, r.cgpa);
    await prefs.setBool(_kInterested, r.interested);
    await prefs.setBool(_kHasData, true);
  }

  /// Returns null if nothing has been saved yet.
  static Future<PlacementRecord?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final hasData = prefs.getBool(_kHasData) ?? false;
    if (!hasData) return null;
    return PlacementRecord(
      name: prefs.getString(_kName) ?? '',
      rollNumber: prefs.getString(_kRoll) ?? '',
      email: prefs.getString(_kEmail) ?? '',
      mobile: prefs.getString(_kMobile) ?? '',
      branch: prefs.getString(_kBranch) ?? 'Computer Science',
      cgpa: prefs.getString(_kCgpa) ?? '',
      interested: prefs.getBool(_kInterested) ?? true,
    );

  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kName);
    await prefs.remove(_kRoll);
    await prefs.remove(_kEmail);
    await prefs.remove(_kMobile);
    await prefs.remove(_kBranch);
    await prefs.remove(_kCgpa);
    await prefs.remove(_kInterested);
    await prefs.remove(_kHasData);
  }
}

// ---------------------------------------------------------------------
// Decides, on app start, whether to show the empty Registration Form
// or the Dashboard with previously saved details.
// ---------------------------------------------------------------------
class StartupRouter extends StatelessWidget {
  const StartupRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlacementRecord?>(
      future: PlacementStorage.load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final saved = snapshot.data;
        if (saved == null) {
          return const RegistrationFormScreen();
        }
        return DashboardScreen(record: saved);
      },
    );
  }
}

// ---------------------------------------------------------------------
// 1 & 3. Registration Form  /  Edit Details (same widget, reused)
// ---------------------------------------------------------------------
class RegistrationFormScreen extends StatefulWidget {
  /// When editing, pass the currently saved record to pre-fill the form
  /// and show a back arrow instead of a plain title bar.
  final PlacementRecord? existing;

  const RegistrationFormScreen({super.key, this.existing});

  bool get isEdit => existing != null;

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;

  late final TextEditingController _rollCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _cgpaCtrl;

  String _branch = 'Computer Science';
  bool _interested = true;
  bool _showSavedBanner = false;

  static const _branches = [
    'Computer Science',
    'Information Technology',
    'Electronics',
    'Mechanical',
    'Civil',
    'Electrical',
  ];

  @override
  void initState() {
    super.initState();
    final r = widget.existing;
    _nameCtrl = TextEditingController(text: r?.name ?? '');
    _rollCtrl = TextEditingController(text: r?.rollNumber ?? '');
    _emailCtrl = TextEditingController(text: r?.email ?? '');
    _mobileCtrl = TextEditingController(text: r?.mobile ?? '');
    _cgpaCtrl = TextEditingController(text: r?.cgpa ?? '');
    _branch = r?.branch ?? 'Computer Science';
    _interested = r?.interested ?? true;
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

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _rollCtrl.clear();
    _emailCtrl.clear();
    _mobileCtrl.clear();
    _cgpaCtrl.clear();
    setState(() {
      _branch = 'Computer Science';
      _interested = true;
      _showSavedBanner = false;
    });
  }

  Future<void> _saveDetails() async {
    if (!_formKey.currentState!.validate()) return;

    final record = PlacementRecord(
      name: _nameCtrl.text.trim(),

      rollNumber: _rollCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      branch: _branch,
      cgpa: _cgpaCtrl.text.trim(),
      interested: _interested,
    );

    await PlacementStorage.save(record);

    if (!mounted) return;

    if (widget.isEdit) {
      // Editing: go back to the Dashboard with the updated record.
      Navigator.pop(context, record);
    } else {
      // First-time registration: briefly show the success banner, then
      // move on to the Dashboard.
      setState(() => _showSavedBanner = true);
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen(record: record)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: widget.isEdit
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('Student Placement Registration'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(Icons.school, size: 90, color: Task18App.primaryPurple),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Register Your Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Task18App.primaryPurple,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(

                children: [
                  _LabeledField(
                    icon: Icons.person_outline,
                    label: 'Student Name',
                    controller: _nameCtrl,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  _LabeledField(
                    icon: Icons.badge_outlined,
                    label: 'Roll Number',
                    controller: _rollCtrl,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  _LabeledField(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _LabeledField(

                    icon: Icons.phone_outlined,
                    label: 'Mobile Number',
                    controller: _mobileCtrl,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  _LabeledDropdown(
                    icon: Icons.account_balance_outlined,
                    label: 'Branch',
                    value: _branch,
                    items: _branches,
                    onChanged: (v) => setState(() => _branch = v!),
                  ),
                  const SizedBox(height: 12),
                  _LabeledField(
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
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(Icons.person_pin_outlined,
                          color: Task18App.primaryPurple, size: 20),
                      const SizedBox(width: 10),
                      const Expanded(child: Text('Interested in Placement')),
                      Switch(
                        value: _interested,
                        onChanged: (v) => setState(() => _interested = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Task18App.primaryPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.save_outlined, size: 18),
                          label: const Text('SAVE DETAILS'),
                          onPressed: _saveDetails,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(

                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('CLEAR FORM'),
                          onPressed: _clearForm,
                        ),
                      ),
                    ],
                  ),
                  if (_showSavedBanner) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFF5E1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 18),
                          SizedBox(width: 8),
                          Text('Registration Saved Successfully!',
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  ],
                ],

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _LabeledField({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Task18App.primaryPurple, size: 20),

        const SizedBox(width: 10),
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
          ),
        ),
      ],
    );
  }
}

class _LabeledDropdown extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _LabeledDropdown({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,

  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Task18App.primaryPurple, size: 20),
        const SizedBox(width: 10),
        SizedBox(
          width: 110,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: value,
            items: items
                .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------
// 2. Dashboard (View Saved Details)
// ---------------------------------------------------------------------

class DashboardScreen extends StatefulWidget {
  final PlacementRecord record;
  const DashboardScreen({super.key, required this.record});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PlacementRecord record;

  @override
  void initState() {
    super.initState();
    record = widget.record;
  }

  Future<void> _editDetails() async {
    final updated = await Navigator.push<PlacementRecord>(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationFormScreen(existing: record),
      ),
    );
    if (updated != null) setState(() => record = updated);
  }

  Future<void> _deleteDetails() async {
    final confirm = await showDialog<bool>(
      context: context,

      builder: (_) => AlertDialog(
        title: const Text('Delete Details?'),
        content: const Text(
            'This will permanently remove your saved placement details from this\ndevice.'),
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
      await PlacementStorage.clear();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegistrationFormScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Placement Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F7EC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome, ${record.name}!',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text('Your placement details are saved.',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              ],

            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                children: [
                  _DashRow(icon: Icons.person_outline, label: 'Student Name', value:
record.name),
                  _DashRow(icon: Icons.badge_outlined, label: 'Roll Number', value:
record.rollNumber),
                  _DashRow(icon: Icons.email_outlined, label: 'Email', value:
record.email),
                  _DashRow(icon: Icons.phone_outlined, label: 'Mobile Number', value:
record.mobile),
                  _DashRow(icon: Icons.account_balance_outlined, label: 'Branch',
value: record.branch),
                  _DashRow(icon: Icons.bar_chart, label: 'CGPA', value: record.cgpa),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events_outlined,
                            color: Task18App.primaryPurple, size: 20),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text('Placement Status', style: TextStyle(color:
Colors.grey)),
                        ),

                        Icon(
                          record.interested ? Icons.check_circle : Icons.cancel,
                          color: record.interested ? Colors.green : Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          record.interested ? 'Interested' : 'Not Interested',
                          style: TextStyle(
                            color: record.interested ? Colors.green : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('EDIT DETAILS'),
            onPressed: _editDetails,

          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            icon: const Icon(Icons.delete_outline),
            label: const Text('DELETE DETAILS'),
            onPressed: _deleteDetails,
          ),
        ],
      ),
    );
  }
}

class _DashRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DashRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          Icon(icon, color: Task18App.primaryPurple, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

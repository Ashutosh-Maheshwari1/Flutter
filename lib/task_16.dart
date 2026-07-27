import 'package:flutter/material.dart';

// Optional: keep this app wrapper if you want to run Task_16.dart standalone.
// Otherwise just import StudentInfoScreen into your main.dart as shown above.
class Task16App extends StatelessWidget {
  const Task16App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Information Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        fontFamily: 'Roboto',
      ),
      home: const StudentInfoScreen(),
    );
  }
}

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  int _currentTab = 0;

  // ---- Student data ----
  final String studentName = 'Rahul Sharma';
  final String email = 'rahul@gmail.com';
  final String mobile = '+91 9876543210';
  final String rollNumber = 'CS202501';
  final String collegeWebsite = 'www.fluttercollege.com';

  final List<Map<String, dynamic>> subjects = const [
    {'subject': 'Mathematics', 'max': 100, 'obtained': 95},
    {'subject': 'Science', 'max': 100, 'obtained': 90},
    {'subject': 'English', 'max': 100, 'obtained': 88},
    {'subject': 'Computer', 'max': 100, 'obtained': 98},
    {'subject': 'Hindi', 'max': 100, 'obtained': 85},
  ];

  int get totalMax => subjects.fold(0, (sum, s) => sum + (s['max'] as int));
  int get totalObtained => subjects.fold(0, (sum, s) => sum + (s['obtained'] as int));
  double get percentage => (totalObtained / totalMax) * 100;
  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 75) return 'A';
    if (percentage >= 60) return 'B';
    if (percentage >= 40) return 'C';
    return 'F';
  }

  void _showSnackBar(String message, {IconData icon = Icons.check_circle, Color color = Colors.green}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _openStudentActionsSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Student Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text('Send Email'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showSnackBar('Email sent to $studentName!');
                },
              ),
              ListTile(
                leading: const Icon(Icons.call, color: Colors.green),
                title: const Text('Call Student'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showSnackBar('Calling $studentName...');
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.orange),
                title: const Text('View Address'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showSnackBar('Displaying student address.');
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.deepPurple),
                title: const Text('Share Profile'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showSnackBar('Student Profile Shared Successfully!');
                },
              ),
              ListTile(
                leading: const Icon(Icons.download, color: Colors.blue),
                title: const Text('Download Marksheet'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showSnackBar('Marksheet downloaded!');
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.red),
                title: const Text('Close'),
                onTap: () => Navigator.pop(ctx),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(color: Colors.grey.shade700)),
          ),
          Expanded(
            flex: 3,
            child: SelectableText(
              value,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  TableRow _marksheetHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.deepPurple.shade50),
      children: const [
        _TableHeaderCell('Subject'),
        _TableHeaderCell('Max Marks'),
        _TableHeaderCell('Obtained'),
      ],
    );
  }

  TableRow _marksheetDataRow(Map<String, dynamic> row) {
    final obtained = row['obtained'] as int;
    final max = row['max'] as int;
    final good = obtained >= (max * 0.6);
    return TableRow(
      children: [
        _TableDataCell(row['subject'] as String, align: TextAlign.left),
        _TableDataCell(max.toString()),
        _TableDataCell(
          obtained.toString(),
          color: good ? Colors.green : Colors.red,
          bold: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.school, color: Colors.white),
            SizedBox(width: 10),
            Text('Student Information Portal', style: TextStyle(fontSize: 18)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 8),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      child: const Icon(Icons.person, color: Colors.deepPurple),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Student Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _detailRow(Icons.person_outline, 'Student Name', studentName),
                _detailRow(Icons.email_outlined, 'Email', email),
                _detailRow(Icons.phone_outlined, 'Mobile', mobile),
                _detailRow(Icons.badge_outlined, 'Roll Number', rollNumber),
                _detailRow(Icons.public, 'College Website', collegeWebsite),
              ],
            ),
          ),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      child: const Icon(Icons.grid_on, color: Colors.deepPurple),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Student Marksheet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Table(
                  border: TableBorder.all(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1.3),
                    2: FlexColumnWidth(1.3),
                  },
                  children: [
                    _marksheetHeaderRow(),
                    ...subjects.map(_marksheetDataRow),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _summaryTile(Icons.assignment_outlined, 'Total Marks', '$totalObtained / $totalMax'),
                    _summaryTile(Icons.percent, 'Percentage', '${percentage.toStringAsFixed(1)}%'),
                    _summaryTile(Icons.star_outline, 'Grade', grade),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _openStudentActionsSheet,
                icon: const Icon(Icons.list),
                label: const Text('Show Student Actions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _currentTab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _summaryTile(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.deepPurple),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  const _TableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}

class _TableDataCell extends StatelessWidget {
  final String text;
  final Color? color;
  final bool bold;
  final TextAlign align;

  const _TableDataCell(
    this.text, {
    this.color,
    this.bold = false,
    this.align = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: SelectableText(
        text,
        textAlign: align,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

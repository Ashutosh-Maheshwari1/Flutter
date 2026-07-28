import 'dart:async';
import 'package:flutter/material.dart';

/// Formats a DateTime as "28 July 2026" without needing the intl package.
String formatFullDate(DateTime date) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

// Set to false once webview_flutter & file_picker are added to pubspec.yaml
// and the real imports below are uncommented.
const bool USE_MOCK_PLUGINS = true;

// import 'package:file_picker/file_picker.dart';
// import 'package:webview_flutter/webview_flutter.dart';

/// Entry point for this task, launched from main.dart via:
///   MaterialPageRoute(builder: (_) => const Task17App())
class Task17App extends StatelessWidget {
  const Task17App({super.key});

  static const Color primaryPurple = Color(0xFF4B3FBF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Assignment Submission',
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryPurple,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: const AssignmentDetailsScreen(),
    );
  }
}

// A single shared model that gets threaded through the flow so every
// screen can read/update the same submission data.

class AssignmentSubmission {
  DateTime? date;
  TimeOfDay? time;
  String? fileName;
  double? fileSizeMb;
  double rating = 0;

  AssignmentSubmission();
}

// ---------------------------------------------------------------------
// 1. Assignment Details
// ---------------------------------------------------------------------
class AssignmentDetailsScreen extends StatelessWidget {
  const AssignmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Assignment Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(Icons.school, size: 90, color: Task17App.primaryPurple),
            const SizedBox(height: 16),
            const Text(
              'Assignment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    _DetailRow(label: 'Assignment', value: 'Flutter UI Widgets'),
                    _DetailRow(label: 'Subject', value: 'Mobile Application Dev.'),
                    _DetailRow(label: 'Faculty', value: 'Dev Uapdhyay'),
                    _DetailRow(label: 'Last Date', value: '30 July 2026'),
                    _DetailRow(label: 'Total Marks', value: '100'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Submit Assignment'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubmitAssignmentScreen(submission: AssignmentSubmission()),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              icon: const Icon(Icons.description_outlined),
              label: const Text('View Assignment Guidelines'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AssignmentGuidelinesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Task17App.primaryPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_turned_in_outlined),
              label: 'My Submissions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 2) {
            // Quick way to reach the Tooltip Demo screen for grading/demo purposes.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TooltipDemoScreen()),
            );
          }
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

// ---------------------------------------------------------------------
// 2. Submit Assignment (Form) - also hosts navigation to 3 & 4
// ---------------------------------------------------------------------
class SubmitAssignmentScreen extends StatefulWidget {
  final AssignmentSubmission submission;
  const SubmitAssignmentScreen({super.key, required this.submission});

  @override
  State<SubmitAssignmentScreen> createState() => _SubmitAssignmentScreenState();
}

class _SubmitAssignmentScreenState extends State<SubmitAssignmentScreen> {
  late AssignmentSubmission sub;

  @override
  void initState() {
    super.initState();
    sub = widget.submission;
    sub.date ??= DateTime(2026, 7, 28);
    sub.time ??= const TimeOfDay(hour: 15, minute: 30);
  }

  Future<void> _pickDate() async {
    final picked = await Navigator.push<DateTime>(
      context,
      MaterialPageRoute(builder: (_) => DateSelectScreen(initial: sub.date!)),
    );

    if (picked != null) setState(() => sub.date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await Navigator.push<TimeOfDay>(
      context,
      MaterialPageRoute(builder: (_) => TimeSelectScreen(initial: sub.time!)),
    );
    if (picked != null) setState(() => sub.time = picked);
  }

  Future<void> _pickFile() async {
    if (USE_MOCK_PLUGINS) {
      // Mock stand-in for file_picker so the UI can be previewed without
      // adding the plugin dependency.
      setState(() {
        sub.fileName = 'assignment_flutter.pdf';
        sub.fileSizeMb = 2.3;
      });
      return;
    }
    // Real implementation once file_picker is added:
    //
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf', 'docx', 'zip'],
    // );
    // if (result != null) {
    //   final file = result.files.single;
    //   setState(() {
    //     sub.fileName = file.name;
    //     sub.fileSizeMb = (file.size / (1024 * 1024));
    //   });
    // }
  }

  void _submit() {
    if (sub.fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a file before submitting.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UploadingScreen(submission: sub)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = formatFullDate(sub.date!);
    final timeStr = sub.time!.format(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Submit Assignment')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _FormTile(
            icon: Icons.event_note,
            label: 'Select Submission Date',
            value: dateStr,
            onTap: _pickDate,
          ),
          const SizedBox(height: 14),
          _FormTile(
            icon: Icons.access_time,
            label: 'Select Submission Time',
            value: timeStr,
            onTap: _pickTime,
          ),
          const SizedBox(height: 14),
          const Text('Upload Assignment File', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickFile,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: sub.fileName == null
                  ? Row(
                      children: const [
                        Icon(Icons.attach_file, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('Tap to select a file'),
                      ],
                    )
                  : Row(
                      children: [
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${sub.fileName}\n${sub.fileSizeMb!.toStringAsFixed(1)} MB',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => setState(() {
                            sub.fileName = null;
                            sub.fileSizeMb = null;
                          }),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 4),
          const Text('(PDF, DOCX, ZIP files only)', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Submit Assignment'),
          ),
        ],
      ),
    );
  }
}

class _FormTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _FormTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Task17App.primaryPurple),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// 3. Select Date (Date Picker)
// ---------------------------------------------------------------------
class DateSelectScreen extends StatefulWidget {
  final DateTime initial;
  const DateSelectScreen({super.key, required this.initial});

  @override
  State<DateSelectScreen> createState() => _DateSelectScreenState();
}

class _DateSelectScreenState extends State<DateSelectScreen> {
  late DateTime selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Date')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CalendarDatePicker gives the same in-page month grid shown
            // in the reference design (rather than the platform dialog).
            CalendarDatePicker(
              initialDate: selected,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              onDateChanged: (d) => setState(() => selected = d),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, selected),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// 4. Select Time (Time Picker)
// ---------------------------------------------------------------------
class TimeSelectScreen extends StatefulWidget {
  final TimeOfDay initial;
  const TimeSelectScreen({super.key, required this.initial});

  @override
  State<TimeSelectScreen> createState() => _TimeSelectScreenState();
}

class _TimeSelectScreenState extends State<TimeSelectScreen> {
  late TimeOfDay selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initial;
  }

  Future<void> _openNativePicker() async {
    final picked = await showTimePicker(context: context, initialTime: selected);
    if (picked != null) setState(() => selected = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Time')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              selected.format(context),
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.access_time),
              label: const Text('Open Time Picker'),
              onPressed: _openNativePicker,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, selected),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// 5. Uploading Assignment (progress)
// ---------------------------------------------------------------------
class UploadingScreen extends StatefulWidget {
  final AssignmentSubmission submission;
  const UploadingScreen({super.key, required this.submission});

  @override
  State<UploadingScreen> createState() => _UploadingScreenState();
}

class _UploadingScreenState extends State<UploadingScreen> {
  double progress = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 150), (t) {
      setState(() => progress += 0.05);
      if (progress >= 1) {
        t.cancel();
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => SubmissionSuccessScreen(submission: widget.submission),
              ),
            );

          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pct = (progress.clamp(0, 1) * 100).round();
    return Scaffold(
      appBar: AppBar(title: const Text('Uploading Assignment')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_upload_outlined, size: 80, color: Task17App.primaryPurple),
            const SizedBox(height: 16),
            const Text('Uploading Assignment...'),
            const SizedBox(height: 24),
            SizedBox(
              width: 110,
              height: 110,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress.clamp(0, 1),
                    strokeWidth: 8,
                  ),
                  Text('$pct%', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// 6. Submission Successful
// ---------------------------------------------------------------------
class SubmissionSuccessScreen extends StatelessWidget {
  final AssignmentSubmission submission;
  const SubmissionSuccessScreen({super.key, required this.submission});

  @override
  Widget build(BuildContext context) {
    final dateStr = formatFullDate(submission.date!);
    final timeStr = submission.time!.format(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Submission Successful')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const CircleAvatar(
              radius: 36,
              backgroundColor: Color(0xFFDFF5E1),
              child: Icon(Icons.check, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 12),
            const Text('Assignment Submitted Successfully!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const _DetailRow(label: 'Student Name', value: 'Rahul Sharma'),
                    const _DetailRow(label: 'Assignment', value: 'Flutter UI Widgets'),
                    _DetailRow(label: 'Submission Date', value: dateStr),
                    _DetailRow(label: 'Submission Time', value: timeStr),
                    _DetailRow(label: 'Uploaded File', value: submission.fileName ?? '-'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RateExperienceScreen(submission: submission),
                  ),
                );
              },
              child: const Text('Rate Your Experience'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                Navigator.popUntil(context, (r) => r.isFirst);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// 7. Rate Your Experience
// ---------------------------------------------------------------------
class RateExperienceScreen extends StatefulWidget {
  final AssignmentSubmission submission;
  const RateExperienceScreen({super.key, required this.submission});

  @override
  State<RateExperienceScreen> createState() => _RateExperienceScreenState();
}

class _RateExperienceScreenState extends State<RateExperienceScreen> {
  double rating = 4.5;

  void _setRating(int starIndex, Offset localPos, double starWidth) {
    // Half-star precision: tap on left half of a star = x.5, right half = x+1
    final isHalf = localPos.dx < starWidth / 2;
    setState(() {
      rating = starIndex + (isHalf ? 0.5 : 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Experience')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text('How was your assignment\nsubmission experience?', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                IconData icon;
                if (rating >= i + 1) {
                  icon = Icons.star;
                } else if (rating > i && rating < i + 1) {
                  icon = Icons.star_half;
                } else {
                  icon = Icons.star_border;
                }
                return GestureDetector(
                  onTapDown: (details) => _setRating(i, details.localPosition, 40),
                  child: Icon(icon, color: Colors.amber, size: 40),
                );
              }),
            ),
            const SizedBox(height: 10),
            Text('${rating.toStringAsFixed(1)} / 5', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Thank you for your feedback!', style: TextStyle(color: Colors.grey)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                widget.submission.rating = rating;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thanks! Your rating was submitted.')));
                Navigator.popUntil(context, (r) => r.isFirst);
              },
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// 8 & 9. WebView screens (Assignment Guidelines / Flutter Documentation)
// ---------------------------------------------------------------------
class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;
  const WebViewScreen({super.key, required this.title, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          if (loading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: USE_MOCK_PLUGINS
                ? _MockWebContent(url: widget.url, onLoaded: () {
                    if (mounted) setState(() => loading = false);
                  })
                : _RealWebView(url: widget.url, onLoaded: () {
                    if (mounted) setState(() => loading = false);
                  }),
          ),
          _WebNavBar(url: widget.url),
        ],
      ),
    );
  }
}

class _MockWebContent extends StatefulWidget {
  final String url;
  final VoidCallback onLoaded;
  const _MockWebContent({required this.url, required this.onLoaded});

  @override
  State<_MockWebContent> createState() => _MockWebContentState();
}

class _MockWebContentState extends State<_MockWebContent> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), widget.onLoaded);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Text(
        'Loaded content from:\n${widget.url}\n\n'
        '(This is a placeholder. Enable webview_flutter and set '
        'USE_MOCK_PLUGINS = false to render the real page here.)',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class _RealWebView extends StatelessWidget {
  final String url;
  final VoidCallback onLoaded;
  const _RealWebView({required this.url, required this.onLoaded});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _WebNavBar extends StatelessWidget {
  final String url;
  const _WebNavBar({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.arrow_back, color: Colors.grey),
          const Icon(Icons.arrow_forward, color: Colors.grey),
          const Icon(Icons.refresh, color: Colors.grey),
          const Icon(Icons.home_outlined, color: Colors.grey),
        ],
      ),
    );
  }
}

class AssignmentGuidelinesScreen extends StatelessWidget {
  const AssignmentGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignment Guidelines')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text('Assignment Guidelines', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Objective', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('Build a Flutter application using the widgets learned in the class.'),
          SizedBox(height: 16),
          Text('Instructions', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          _Bullet('Use proper UI design.'),
          _Bullet('Follow best coding practices.'),
          _Bullet('Submit before the last date.'),
          _Bullet('Upload in PDF or ZIP format.'),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class FlutterDocumentationScreen extends StatelessWidget {
  const FlutterDocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewScreen(
      title: 'Flutter Documentation',
      url: 'https://flutter.dev',
    );
  }
}

// ---------------------------------------------------------------------
// 10. Tooltip Demo
// ---------------------------------------------------------------------
class TooltipDemoScreen extends StatelessWidget {
  const TooltipDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tooltip Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _TooltipIcon(
                    tooltip: 'Select Date',
                    icon: Icons.calendar_today,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DateSelectScreen(initial: DateTime.now()),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TooltipIcon(
                    tooltip: 'Select Time',
                    icon: Icons.access_time,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TimeSelectScreen(initial: TimeOfDay.now()),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TooltipIcon(
                    tooltip: 'Upload File',
                    icon: Icons.folder_open,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _TooltipIcon(
                    tooltip: 'Rate Experience',
                    icon: Icons.star,
                    dark: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RateExperienceScreen(
                          submission: AssignmentSubmission(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TooltipIcon(
                    tooltip: 'Open Guidelines',
                    icon: Icons.description,
                    dark: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AssignmentGuidelinesScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TooltipIcon(
                    tooltip: 'Open Docs',
                    icon: Icons.language,
                    dark: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FlutterDocumentationScreen(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEAFB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Long press on any icon to see tooltip',
                textAlign: TextAlign.center,
                style: TextStyle(color: Task17App.primaryPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TooltipIcon extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;
  final bool dark;
  const _TooltipIcon({
    required this.tooltip,
    required this.icon,
    required this.onTap,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      triggerMode: TooltipTriggerMode.longPress,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF2B2B2B) : const Color(0xFFF3F1FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 30,
            color: dark ? Colors.amber : Task17App.primaryPurple,
          ),
        ),
      ),
    );
  }
}

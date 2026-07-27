import 'package:flutter/material.dart';

class AppColors {
  static const purple = Color(0xFF6A1B9A);
  static const teal = Color(0xFF00897B);
  static const green = Color(0xFF2E7D32);
  static const orange = Color(0xFFEF6C00);
}

class Student {
  static const name = 'Dev Upadhyay';
  static const course = 'B.Tech CSE';
  static const roll = '2415000503';
  static const branch = 'Computer Science';
  static const year = '3rd Year';
  static const email = 'upadhyaydev31@gmail.com';
}

// ---------------------------------------------------------------------------
// APP ROOT
// ---------------------------------------------------------------------------

class CollegePortalApp extends StatelessWidget {
  const CollegePortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Student Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purple),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      ),
      home: const MainScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// MAIN SCREEN — holds the Drawer + Bottom Navigation
// ---------------------------------------------------------------------------

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomIndex = 0;

  static const _titles = [
    'College Student Portal',
    'My Attendance',
    'My Assignments',
    'My Profile',
  ];

  void _switchTab(int index) {
    setState(() => _bottomIndex = index);
  }

  void _openCoursesTabs(int initialTab) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoursesTabScreen(
          initialTab: initialTab,
          onBottomNavTap: (i) {
            Navigator.pop(context);
            _switchTab(i);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeDashboardPage(
        onOpenCourses: () => _openCoursesTabs(0),
        onOpenNotices: () => _openCoursesTabs(1),
        onOpenAssignments: () => _switchTab(2),
        onOpenResults: () => _openCoursesTabs(2),
      ),
      const AttendancePage(),
      const AssignmentsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
        title: Text(_titles[_bottomIndex]),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      drawer: CustomDrawer(
        onDashboard: () {
          Navigator.pop(context);
          _switchTab(0);
        },
        onProfile: () {
          Navigator.pop(context);
          _switchTab(3);
        },
      ),
      body: IndexedStack(index: _bottomIndex, children: pages),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _bottomIndex,
        onTap: _switchTab,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// REUSABLE: Bottom Navigation Bar
// ---------------------------------------------------------------------------

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.purple,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Attendance'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Assignments'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// DRAWER NAVIGATION
// ---------------------------------------------------------------------------

class CustomDrawer extends StatelessWidget {
  final VoidCallback onDashboard;
  final VoidCallback onProfile;

  const CustomDrawer({super.key, required this.onDashboard, required this.onProfile});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.purple.withOpacity(0.08),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.purple,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        Student.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '${Student.course}',
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      Text(
                        'Roll No: ${Student.roll}',
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _drawerTile(context, Icons.dashboard, 'Dashboard', onDashboard, selected: true),
            _drawerTile(context, Icons.person_outline, 'Profile', onProfile),
            _drawerTile(context, Icons.settings_outlined, 'Settings', () {
              Navigator.pop(context);
              _showSnack(context, 'Settings coming soon');
            }),
            _drawerTile(context, Icons.help_outline, 'Help', () {
              Navigator.pop(context);
              _showSnack(context, 'Need help? Contact support@college.edu.in');
            }),
            const Spacer(),
            const Divider(height: 1),
            _drawerTile(context, Icons.logout, 'Logout', () => _confirmLogout(context)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(BuildContext context, IconData icon, String label, VoidCallback onTap, {bool selected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: selected ? AppColors.purple.withOpacity(0.12) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: selected ? AppColors.purple : Colors.black54),
        title: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.purple : Colors.black87,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _confirmLogout(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HOME DASHBOARD PAGE (Bottom Nav -> Home)
// ---------------------------------------------------------------------------

class HomeDashboardPage extends StatelessWidget {
  final VoidCallback onOpenCourses;
  final VoidCallback onOpenNotices;
  final VoidCallback onOpenAssignments;
  final VoidCallback onOpenResults;

  const HomeDashboardPage({
    super.key,
    required this.onOpenCourses,
    required this.onOpenNotices,
    required this.onOpenAssignments,
    required this.onOpenResults,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.teal, Color(0xFF26A69A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome Back 👋', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              const Text(
                Student.name,
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${Student.course} | Roll No: ${Student.roll}',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Quick Links', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _quickLink(Icons.menu_book, 'Courses', const Color(0xFFFFE0B2), const Color(0xFFEF6C00), onOpenCourses),
                  _quickLink(Icons.campaign, 'Notices', const Color(0xFFE1BEE7), const Color(0xFF8E24AA), onOpenNotices),
                  _quickLink(Icons.assignment, 'Assignments', const Color(0xFFC8E6C9), const Color(0xFF2E7D32), onOpenAssignments),
                  _quickLink(Icons.bar_chart, 'Results', const Color(0xFFF8BBD0), const Color(0xFFC2185B), onOpenResults),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickLink(IconData icon, String label, Color bg, Color fg, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 30),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ATTENDANCE PAGE
// ---------------------------------------------------------------------------

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    const percent = 0.85;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: SizedBox(
            width: 170,
            height: 170,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 170,
                  height: 170,
                  child: CircularProgressIndicator(
                    value: percent,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(AppColors.teal),
                  ),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('85%', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Text('Present', style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        _statCard(Icons.school, 'Total Classes', '120', Colors.blueGrey),
        _statCard(Icons.check_circle, 'Classes Attended', '102', Colors.green),
        _statCard(Icons.cancel, 'Classes Remaining', '18', Colors.red),
      ],
    );
  }

  Widget _statCard(IconData icon, String label, String value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ASSIGNMENTS PAGE
// ---------------------------------------------------------------------------

class AssignmentItem {
  final String title;
  final String subtitle;
  final String due;
  final String badge;
  final Color badgeColor;
  final IconData icon;
  final Color iconColor;

  AssignmentItem(this.title, this.subtitle, this.due, this.badge, this.badgeColor, this.icon, this.iconColor);
}

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      AssignmentItem('Flutter Assignment-13', 'Build Navigation UI', 'Due: 22 May 2025', 'Due Tomorrow', Colors.red, Icons.flutter_dash, Colors.blue),
      AssignmentItem('Java Assignment-7', 'OOPs Concepts', 'Due: 25 May 2025', '3 Days Left', Colors.orange, Icons.code, Colors.green),
      AssignmentItem('Python Assignment-5', 'Functions & Modules', 'Due: 28 May 2025', '6 Days Left', Colors.green, Icons.article, Colors.blue),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, i) => _assignmentCard(items[i]),
    );
  }

  Widget _assignmentCard(AssignmentItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: item.badgeColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.badge,
                          style: TextStyle(color: item.badgeColor, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(item.subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(item.due, style: TextStyle(color: item.badgeColor, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PROFILE PAGE
// ---------------------------------------------------------------------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.green, Color(0xFF43A047)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: const [
              CircleAvatar(
                radius: 42,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 46, color: AppColors.green),
              ),
              SizedBox(height: 12),
              Text('My Profile', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoRow('Name', Student.name),
                  _infoRow('Roll Number', Student.roll),
                  _infoRow('Branch', Student.branch),
                  _infoRow('Year', Student.year),
                  _infoRow('Email', Student.email),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Colors.black54))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TAB NAVIGATION — Courses / Notices / Results
// ---------------------------------------------------------------------------

class CoursesTabScreen extends StatefulWidget {
  final int initialTab;
  final ValueChanged<int> onBottomNavTap;

  const CoursesTabScreen({super.key, this.initialTab = 0, required this.onBottomNavTap});

  @override
  State<CoursesTabScreen> createState() => _CoursesTabScreenState();
}

class _CoursesTabScreenState extends State<CoursesTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
        title: const Text('College Student Portal'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_none),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Courses'),
            Tab(text: 'Notices'),
            Tab(text: 'Results'),
          ],
        ),
      ),
      drawer: CustomDrawer(
        onDashboard: () => Navigator.pop(context),
        onProfile: () {
          Navigator.pop(context);
          widget.onBottomNavTap(3);
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CoursesTabBody(),
          NoticesTabBody(),
          ResultsTabBody(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: 0, onTap: widget.onBottomNavTap),
    );
  }
}

class CourseItem {
  final String title;
  final String subtitle;
  final String instructor;
  final IconData icon;
  final Color color;
  CourseItem(this.title, this.subtitle, this.instructor, this.icon, this.color);
}

class CoursesTabBody extends StatelessWidget {
  const CoursesTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      CourseItem('Flutter Development', 'Learn Flutter from Basics', 'Instructor: Mr. Sharma', Icons.flutter_dash, Colors.blue),
      CourseItem('Java Programming', 'Core Java and OOPs', 'Instructor: Ms. Joshi', Icons.coffee, Colors.green),
      CourseItem('Python Programming', 'Python for Beginners', 'Instructor: Mr. Verma', Icons.terminal, Colors.amber.shade800),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, i) {
        final c = courses[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: c.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(c.icon, color: c.color),
            ),
            title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${c.subtitle}\n${c.instructor}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

class NoticeItem {
  final String title;
  final String date;
  final String description;
  final IconData icon;
  final Color color;
  NoticeItem(this.title, this.date, this.description, this.icon, this.color);
}

class NoticesTabBody extends StatelessWidget {
  const NoticesTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    final notices = [
      NoticeItem('Holiday Tomorrow', '20 May 2025', 'College will remain closed tomorrow on account of Local Holiday.', Icons.campaign, Colors.red),
      NoticeItem('Flutter Assignment Submission', '18 May 2025', 'Submit your Flutter Assignment-13 before 22 May 2025.', Icons.assignment, Colors.blue),
      NoticeItem('Mid Semester Exam', '15 May 2025', 'Mid Semester Exams will start from 1st June 2025.', Icons.event, Colors.orange),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notices.length,
      itemBuilder: (context, i) {
        final n = notices[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: n.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(n.icon, color: n.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(n.date, style: const TextStyle(color: Colors.black45, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(n.description, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ResultItem {
  final String subject;
  final String marks;
  final String grade;
  ResultItem(this.subject, this.marks, this.grade);
}

class ResultsTabBody extends StatelessWidget {
  const ResultsTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    final results = [
      ResultItem('Flutter Development', '92 / 100', 'A+'),
      ResultItem('Java Programming', '85 / 100', 'A'),
      ResultItem('Python Programming', '88 / 100', 'A'),
      ResultItem('Database Systems', '79 / 100', 'B+'),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, i) {
        final r = results[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            title: Text(r.subject, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(r.marks),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(r.grade, style: const TextStyle(color: AppColors.purple, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }
}

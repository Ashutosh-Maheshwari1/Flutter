import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// THEME
// ---------------------------------------------------------------------------

class AppColors {
  static const purple = Color(0xFF4B2AC9);
}

// ---------------------------------------------------------------------------
// APP ROOT
// ---------------------------------------------------------------------------

class UserPreferencesApp extends StatelessWidget {
  const UserPreferencesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Preferences',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purple),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const PreferencesScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// PREFERENCES SCREEN
// ---------------------------------------------------------------------------

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _notificationsEnabled = true;
  int _themeIndex = 1;
  String _selectedGender = 'Female';
  bool _acceptedTerms = true;
  double _fontSize = 20;
  String _selectedInterest = 'Flutter';
  bool _showSavedBanner = false;

  final _interests = const ['Flutter', 'AI', 'Web Development', 'Game Development'];

  void _resetAll() {
    setState(() {
      _notificationsEnabled = true;
      _themeIndex = 1;
      _selectedGender = 'Female';
      _acceptedTerms = true;
      _fontSize = 20;
      _selectedInterest = 'Flutter';
      _showSavedBanner = false;
    });
  }

  void _saveChanges() {
    setState(() => _showSavedBanner = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
        title: const Text('User Preferences'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _notificationsSection(),
          const Divider(height: 32),
          _themeSection(),
          const Divider(height: 32),
          _genderSection(),
          const Divider(height: 32),
          _termsSection(),
          const Divider(height: 32),
          _fontSizeSection(),
          const Divider(height: 32),
          _interestsSection(),
          const Divider(height: 32),
          _quickActionsSection(),
          const Divider(height: 32),
          _profileCompletionSection(),
          const SizedBox(height: 20),
          _bottomButtons(),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, Color color, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  Widget _captionRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 42),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black54, fontSize: 13),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(text: value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _notificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _sectionHeader(Icons.notifications, AppColors.purple, 'Enable Notifications')),
            Switch(
              value: _notificationsEnabled,
              activeColor: AppColors.purple,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
            ),
          ],
        ),
        _captionRow(
          'Notifications',
          _notificationsEnabled ? 'Enabled' : 'Disabled',
          _notificationsEnabled ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget _themeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.palette, Colors.orange, 'Choose Theme'),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 42),
          child: ToggleButtons(
            isSelected: [_themeIndex == 0, _themeIndex == 1],
            borderRadius: BorderRadius.circular(10),
            selectedColor: Colors.white,
            fillColor: AppColors.purple,
            color: Colors.black54,
            constraints: const BoxConstraints(minHeight: 44, minWidth: 100),
            onPressed: (index) => setState(() => _themeIndex = index),
            children: const [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.wb_sunny, size: 18),
                SizedBox(width: 6),
                Text('Light'),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.nightlight_round, size: 18),
                SizedBox(width: 6),
                Text('Dark'),
              ]),
            ],
          ),
        ),
        _captionRow('Selected Mode', _themeIndex == 0 ? 'Light' : 'Dark', AppColors.purple),
      ],
    );
  }

  Widget _genderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.person, Colors.pink, 'Select Gender'),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: ['Male', 'Female', 'Other'].map((gender) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: gender,
                    groupValue: _selectedGender,
                    activeColor: AppColors.purple,
                    onChanged: (value) => setState(() => _selectedGender = value!),
                  ),
                  Text(gender),
                  const SizedBox(width: 8),
                ],
              );
            }).toList(),
          ),
        ),
        _captionRow('Selected Gender', _selectedGender, AppColors.purple),
      ],
    );
  }

  Widget _termsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _acceptedTerms,
              activeColor: Colors.green,
              onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
            ),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                  children: [
                    TextSpan(text: 'I accept the '),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        color: AppColors.purple,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        _captionRow('Status', _acceptedTerms ? 'Accepted' : 'Not Accepted', _acceptedTerms ? Colors.green : Colors.red),
      ],
    );
  }

  Widget _fontSizeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.text_fields, Colors.blue, 'Font Size (Sample Text)'),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: [
              const Text('10'),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 10,
                  max: 30,
                  divisions: 20,
                  activeColor: AppColors.purple,
                  label: _fontSize.round().toString(),
                  onChanged: (value) => setState(() => _fontSize = value),
                ),
              ),
              const Text('30'),
            ],
          ),
        ),
        _captionRow('Current Size', _fontSize.round().toString(), AppColors.purple),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Flutter is Awesome!',
            style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _interestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.favorite, Colors.purple, 'Choose Your Interests (Select One)'),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 42),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _interests.map((interest) {
              final selected = interest == _selectedInterest;
              return ChoiceChip(
                label: Text(interest),
                selected: selected,
                selectedColor: AppColors.purple,
                labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                avatar: selected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                onSelected: (_) => setState(() => _selectedInterest = interest),
              );
            }).toList(),
          ),
        ),
        _captionRow('Selected Interest', _selectedInterest, AppColors.purple),
      ],
    );
  }

  Widget _quickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.bolt, Colors.amber, 'Quick Actions'),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 42),
          child: Row(
            children: [
              ActionChip(
                avatar: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset'),
                onPressed: _resetAll,
              ),
              const SizedBox(width: 10),
              ActionChip(
                avatar: const Icon(Icons.save, size: 18, color: Colors.white),
                label: const Text('Save', style: TextStyle(color: Colors.white)),
                backgroundColor: AppColors.purple,
                onPressed: _saveChanges,
              ),
            ],
          ),
        ),
        if (_showSavedBanner) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Preferences Saved Successfully!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showSavedBanner = false),
                  child: const Text(
                    'DISMISS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _profileCompletionSection() {
    const labels = ['Personal Details', 'Preferences', 'Finish'];
    const currentStep = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(Icons.list_alt, Colors.grey, 'Profile Completion'),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: List.generate(labels.length * 2 - 1, (i) {
              if (i.isOdd) {
                final lineDone = (i ~/ 2) < currentStep;
                return Expanded(
                  child: Container(height: 3, color: lineDone ? AppColors.purple : Colors.grey.shade300),
                );
              }
              final step = i ~/ 2;
              final done = step < currentStep;
              final active = step == currentStep;
              final circleColor = (done || active) ? AppColors.purple : Colors.grey.shade400;
              return Column(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: circleColor,
                    child: done
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            '${step + 1}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: List.generate(labels.length, (step) {
              final done = step < currentStep;
              final active = step == currentStep;
              final color = (done || active) ? AppColors.purple : Colors.grey;
              return Expanded(
                child: Text(
                  labels[step],
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _bottomButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.maybePop(context),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            child: const Text('CANCEL'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('CONTINUE'),
          ),
        ),
      ],
    );
  }
}

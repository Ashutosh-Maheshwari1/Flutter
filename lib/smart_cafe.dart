import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// THEME / DATA
// ---------------------------------------------------------------------------

class AppColors {
  static const purple = Color(0xFF4B2AC9);
}

class MenuItem {
  final String name;
  final String description;
  final int price;
  final String emoji;
  const MenuItem(this.name, this.description, this.price, this.emoji);
}

const Map<String, MenuItem> kMenu = {
  'Burger': MenuItem('Veg Burger', 'Delicious veg burger with fresh veggies and cheese.', 120, '🍔'),
  'Pizza': MenuItem('Margherita Pizza', 'Classic pizza with cheese and tomato sauce.', 180, '🍕'),
  'Sandwich': MenuItem('Club Sandwich', 'Triple-layer sandwich loaded with veggies.', 90, '🥪'),
  'Cold Coffee': MenuItem('Cold Coffee', 'Chilled coffee blended with ice cream.', 80, '🥤'),
  'French Fries': MenuItem('French Fries', 'Crispy golden fries with seasoning.', 70, '🍟'),
};

// ---------------------------------------------------------------------------
// APP ROOT
// ---------------------------------------------------------------------------

class SmartCafeApp extends StatelessWidget {
  const SmartCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Café',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purple),
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
      ),
      home: const CafeHomeScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// HOME SCREEN
// ---------------------------------------------------------------------------

class CafeHomeScreen extends StatefulWidget {
  const CafeHomeScreen({super.key});

  @override
  State<CafeHomeScreen> createState() => _CafeHomeScreenState();
}

class _CafeHomeScreenState extends State<CafeHomeScreen> {
  String _category = 'Burger';
  int _quantity = 1;
  bool _orderPlaced = false;

  MenuItem get _selectedItem => kMenu[_category]!;

  void _incrementQty() {
    if (_quantity < 10) setState(() => _quantity++);
  }

  void _decrementQty() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _placeOrder() {
    setState(() => _orderPlaced = true);
  }

  void _clearSelection() {
    setState(() {
      _category = 'Burger';
      _quantity = 1;
      _orderPlaced = false;
    });
    _toast('Selection cleared');
  }

  void _saveForLater() {
    _toast('${_selectedItem.name} saved for later');
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _openTodaySpecial() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Text('🍔', style: TextStyle(fontSize: 40)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Today's Special",
                      style: TextStyle(
                        color: AppColors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Veg Burger', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 2),
                    Text(
                      '₹99',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(sheetContext),
                icon: const Icon(Icons.close),
                label: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Smart Café'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _toast(value),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Help', child: Text('Help')),
              PopupMenuItem(value: 'About', child: Text('About')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Choose Category',
            style: TextStyle(
              color: AppColors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.purple.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _category,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.purple),
                items: kMenu.keys.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        Text(kMenu[cat]!.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Text(cat),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _category = value;
                    _quantity = 1;
                    _orderPlaced = false;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Selected Item',
            style: TextStyle(
              color: AppColors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_selectedItem.emoji, style: const TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedItem.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedItem.description,
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹${_selectedItem.price}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) => _toast(value),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'Cheese added',
                        child: Row(children: [
                          Icon(Icons.local_pizza, color: Colors.amber, size: 18),
                          SizedBox(width: 8),
                          Text('Add Cheese'),
                        ]),
                      ),
                      PopupMenuItem(
                        value: 'Extra sauce added',
                        child: Row(children: [
                          Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 18),
                          SizedBox(width: 8),
                          Text('Extra Sauce'),
                        ]),
                      ),
                      PopupMenuItem(
                        value: 'Showing nutrition info',
                        child: Row(children: [
                          Icon(Icons.eco, color: Colors.green, size: 18),
                          SizedBox(width: 8),
                          Text('View Nutrition'),
                        ]),
                      ),
                      PopupMenuItem(
                        value: 'Item shared',
                        child: Row(children: [
                          Icon(Icons.share, color: Colors.blue, size: 18),
                          SizedBox(width: 8),
                          Text('Share Item'),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Quantity',
            style: TextStyle(
              color: AppColors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _roundIconButton(Icons.remove, _decrementQty),
              SizedBox(
                width: 50,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _roundIconButton(Icons.add, _incrementQty),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _placeOrder,
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Place Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _saveForLater,
              icon: const Icon(Icons.bookmark_border),
              label: const Text('Save for Later'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.purple,
                side: const BorderSide(color: AppColors.purple),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: _clearSelection,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Clear Selection',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              _todaySpecialButton(),
            ],
          ),
          const Divider(height: 36),
          const Center(
            child: Text(
              'Order on iPhone Style',
              style: TextStyle(
                color: AppColors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _iphoneStyleButton(),
          if (_orderPlaced) ...[
            const SizedBox(height: 18),
            _orderPlacedBanner(),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _roundIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.purple.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.purple),
        onPressed: onPressed,
      ),
    );
  }

  Widget _todaySpecialButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: _openTodaySpecial,
      child: Container(
        width: 78,
        height: 78,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: AppColors.purple, shape: BoxShape.circle),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, color: Colors.white, size: 20),
            SizedBox(height: 2),
            Text(
              "Today's\nSpecial",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iphoneStyleButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _toast('iPhone-style ordering coming soon!'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF00B4DB), Color(0xFF0083B0)]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apple, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Order on iPhone Style',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderPlacedBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Order Placed Successfully!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _orderPlaced = false),
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
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const FoodMenuApp());
}

class FoodMenuApp extends StatelessWidget {
  const FoodMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListView Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const FoodMenuScreen(),
    );
  }
}

class FoodMenuScreen extends StatelessWidget {
  const FoodMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> foodItems = [
      {"name": "Cheese Burger", "price": "₹149", "icon": "🍔"},
      {"name": "Veg Pizza", "price": "₹199", "icon": "🍕"},
      {"name": "Pasta", "price": "₹179", "icon": "🍝"},
      {"name": "Sandwich", "price": "₹99", "icon": "🥪"},
      {"name": "Cold Drink", "price": "₹49", "icon": "🥤"},
      {"name": "Ice Cream", "price": "₹69", "icon": "🍨"},
      {"name": "Chocolate Cake", "price": "₹149", "icon": "🎂"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView Example'),
        backgroundColor: Colors.green,
        leading: const Icon(Icons.arrow_back),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 16),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: foodItems.length,
          separatorBuilder: (context, index) => const Divider(
            color: Colors.grey,
            thickness: 0.5,
            height: 1,
          ),
          itemBuilder: (context, index) {
            final item = foodItems[index];
            return Card(
              elevation: 0,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                leading: Text(
                  item["icon"]!,
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(
                  item["name"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  item["price"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.green,
                ),
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'main.dart';
import 'FoodDetailScreen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final VoidCallback onCartUpdated;

  final List<Map<String, dynamic>> allFoods = [
    {'name': 'Nasi Lemak Daun Pisang', 'price': 2.50, 'category': 'Rice'},
    {'name': 'Nasi Kerabu', 'price': 6.50, 'category': 'Rice'},
    {'name': 'Nasi Kukus Ayam Berempah', 'price': 8.50, 'category': 'Rice'},
    {'name': 'Nasi Goreng Kampung', 'price': 5.50, 'category': 'Rice'},
    {'name': 'Mee Goreng Pak Tam', 'price': 4.50, 'category': 'Noodles'},
  ];

  HomeScreen({
    super.key,
    required this.username,
    required this.onCartUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8), // Small padding from the top edge

              // FIXED: Clean Search Field is now the very first element
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search food details...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Best Seller Grid Section
              const Text('Best Seller', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: allFoods.length,
                itemBuilder: (context, index) {
                  final food = allFoods[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(child: Icon(Icons.fastfood, color: Colors.grey, size: 40)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(food['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('RM ${food['price'].toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFFE76F2F), fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle, color: Color(0xFFE76F2F)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FoodDetailScreen(
                                        food: FoodItem(
                                          name: food['name'],
                                          price: food['price'],
                                          imagePath: 'https://via.placeholder.com/150',
                                          category: food['category'],
                                        ),
                                        onCartUpdated: onCartUpdated,
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
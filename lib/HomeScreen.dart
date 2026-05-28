import 'package:flutter/material.dart';
import 'main.dart';
import 'FoodDetailScreen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final VoidCallback onCartUpdated;

  final List<Map<String, dynamic>> allFoods = [
    {
      'name': 'Nasi Lemak Daun Pisang',
      'price': 2.50,
      'category': 'Rice',
      'image': 'assets/images/nasi_lemak.jpeg',
    },
    {
      'name': 'Nasi Kerabu',
      'price': 6.50,
      'category': 'Rice',
      'image': 'assets/images/nasi_kerabu.jpeg',
    },
    {
      'name': 'Nasi Kukus Ayam Berempah',
      'price': 8.50,
      'category': 'Rice',
      'image': 'assets/images/nasi_kukus_ayam.jpg',
    },
    {
      'name': 'Nasi Goreng Kampung',
      'price': 5.50,
      'category': 'Rice',
      'image': 'assets/images/ngk.jpg',
    },
    {
      'name': 'Mee Goreng Pak Tam',
      'price': 4.50,
      'category': 'Noodles',
      'image': 'assets/images/mg.jpeg',
    },
    {
      'name': 'Milo Ais',
      'price': 3.50,
      'category': 'Drinks',
      'image': 'assets/images/milo_ice.jpeg',
    },
    {
      'name': 'Teh O',
      'price': 2.00,
      'category': 'Drinks',
      'image': 'assets/images/teh_o.jpg',
    },
    {
      'name': 'Teh Ais',
      'price': 2.50,
      'category': 'Drinks',
      'image': 'assets/images/TEH_AIS.png',
    },
    {
      'name': 'Teh Tarik',
      'price': 2.50,
      'category': 'Drinks',
      'image': 'assets/images/teh_tarik.jpg',
    },
    {
      'name': 'Sky Juice',
      'price': 1.00,
      'category': 'Drinks',
      'image': 'assets/images/sky_juice.jpg',
    },
  ];

  HomeScreen({
    super.key,
    required this.username,
    required this.onCartUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                food['image'],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                // Fallback placeholder in case a filename gets misspelled later
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(Icons.fastfood, color: Colors.grey, size: 40),
                                    ),
                                  );
                                },
                              ),
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
                                          imagePath: food['image'],
                                          category: food['category'] ?? 'Rice',
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
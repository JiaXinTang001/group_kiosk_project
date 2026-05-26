import 'package:flutter/material.dart';
import 'main.dart';
import 'FoodDetailScreen.dart';

class MenuScreen extends StatefulWidget {
  final VoidCallback onCartUpdated;

  const MenuScreen({super.key, required this.onCartUpdated});

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late TabController _timeTabController;
  String _selectedSubCategory = 'All';
  String _activeMealSession = 'Breakfast';

  final List<Map<String, dynamic>> mockFoods = [
    {'name': 'Nasi Lemak Daun Pisang', 'price': 2.50, 'category': 'Rice', 'session': 'Breakfast'},
    {'name': 'Nasi Kerabu', 'price': 6.50, 'category': 'Rice', 'session': 'Lunch'},
    {'name': 'Nasi Kukus Ayam Berempah', 'price': 8.50, 'category': 'Rice', 'session': 'Lunch'},
    {'name': 'Nasi Goreng Kampung', 'price': 5.50, 'category': 'Rice', 'session': 'Dinner'},
    {'name': 'Mee Goreng Pak Tam', 'price': 4.50, 'category': 'Noodles', 'session': 'Dinner'},
    {'name': 'Milo Ais', 'price': 2.50, 'category': 'Drinks', 'session': 'Lunch'},
    {'name': 'Teh Tarik', 'price': 2.00, 'category': 'Drinks', 'session': 'Breakfast'},
  ];

  @override
  void initState() {
    super.initState();
    _timeTabController = TabController(length: 3, vsync: this, initialIndex: 0);

    _timeTabController.addListener(() {
      if (!_timeTabController.indexIsChanging) {
        setState(() {
          if (_timeTabController.index == 0) _activeMealSession = 'Breakfast';
          if (_timeTabController.index == 1) _activeMealSession = 'Lunch';
          if (_timeTabController.index == 2) _activeMealSession = 'Dinner';
        });
      }
    });
  }

  @override
  void dispose() {
    _timeTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = mockFoods.where((food) {
      bool matchesSession = food['session'] == _activeMealSession;
      bool matchesCategory = _selectedSubCategory == 'All' || food['category'] == _selectedSubCategory;
      return matchesSession && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        title: const Text('Menu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _timeTabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Breakfast', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('8.00am-10.00am', style: TextStyle(fontSize: 9, color: Colors.white70)),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lunch', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('10.00am-4.00pm', style: TextStyle(fontSize: 9, color: Colors.white70)),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dinner', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('4.00pm-9.00pm', style: TextStyle(fontSize: 9, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              children: ['All', 'Rice', 'Noodles', 'Drinks'].map((cat) {
                bool isSelected = _selectedSubCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFFE76F2F),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    onSelected: (val) {
                      setState(() => _selectedSubCategory = cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filteredFoods.isEmpty
                ? Center(
              child: Text(
                'No items available for $_activeMealSession yet.',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final item = filteredFoods[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.fastfood_outlined, color: Colors.grey),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 6),
                              Text('RM ${item['price'].toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFFE76F2F), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        FloatingActionButton.small(
                          heroTag: 'add_${item['name']}',
                          backgroundColor: const Color(0xFFE76F2F),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodDetailScreen(
                                  food: FoodItem(
                                    name: item['name'],
                                    price: item['price'],
                                    imagePath: 'https://via.placeholder.com/150',
                                    category: item['category'],
                                  ),
                                  // FIXED: We removed the local cart items parameters from here entirely!
                                  onCartUpdated: widget.onCartUpdated,
                                ),
                              ),
                            );
                          },
                          child: const Icon(Icons.add, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
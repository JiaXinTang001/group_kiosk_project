import 'package:flutter/material.dart';
import 'main.dart';
import 'AppData.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem food;
  final VoidCallback onCartUpdated;

  const FoodDetailScreen({
    super.key,
    required this.food,
    required this.onCartUpdated
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;

  // Restored your original static checkbox variables
  bool _extraSambal = true;
  bool _telurMata = false;
  bool _telurRebus = false;
  bool _extraNasi = false;

  final TextEditingController _specialRequestController = TextEditingController();

  // FIXED: Cleaned up structural brackets and added the mandatory fallback return string
  String _getDynamicDescription(String foodName) {
    if (foodName.contains('Nasi Lemak')) {
      return 'Nasi lemak dengan ayam berempah, sambal, ikan bilis, kacang dan timun.';
    }
    else if (foodName.contains('Nasi Kerabu'))
    {
      return 'Nasi kerabu tradisional disajikan dengan ulam-ulaman segar, solok lada, dan kerupuk.';
    }
    else if (foodName.contains('Nasi Kukus'))
    {
      return 'Nasi kukus gembur dihidangkan bersama ayam goreng berempah panas dan kuah gulai pekat.';
    }
    else if (foodName.contains('Nasi Goreng Kampung'))
    {

      return 'Nasi goreng kampung klasik yang digoreng bersama kangkung, ikan bilis garing, dan cili padi pekat.';
    }
    else if (foodName.contains('Mee Goreng'))
    {
      return 'Mee goreng mamak klasik yang digoreng garing bersama telur, taugeh, dan bumbu istimewa.';
    }
    else if (foodName.contains('Milo Ais'))
    {
      return 'Minuman coklat malt premium dibancuh kaw bersama susu dan dihidangkan sejuk.';
    }
    else if (foodName.contains('Teh O'))
    {
      return 'Teh merah jernih yang menyegarkan, dibancuh sempurna dengan kemanisan yang seimbang.';
    } else if (foodName.contains('Teh Ais'))
    {
      return 'Teh susu manis berkrim yang dihidangkan bersama ais batu hancur untuk kesegaran maksima.';
    }
    else if (foodName.contains('Teh Tarik'))
    {
      return 'Teh wangi berkualiti tinggi yang ditarik sempurna bersama susu manis berkrim.';
    }
    else if (foodName.contains('Sky Juice'))
    {
      return 'Air yang baik dan manfaat untuk badan.';
    }

    return 'Hidangan premium yang disediakan segar dari dapur kiosk untuk anda.';
  }

  void _confirmAddToCart() {
    double finalPricePerItem = widget.food.price;
    List<String> selectedAddons = []; // Track names of selected add-ons

    // Check which add-ons are selected, update price, and add to the text list
    if (_extraSambal) {
      finalPricePerItem += 0.20;
      selectedAddons.add("Extra sambal");
    }
    if (_telurMata) {
      finalPricePerItem += 1.00;
      selectedAddons.add("Telur mata");
    }
    if (_telurRebus) {
      finalPricePerItem += 0.50;
      selectedAddons.add("Telur rebus");
    }
    if (_extraNasi) {
      finalPricePerItem += 0.50;
      selectedAddons.add("Nasi");
    }

    setState(() {
      // OPTION B FIX: Directly inserts item into global storage list
      // This ensures every add-on order creates a brand-new separate line in the cart!
      AppData.globalCartItems.add({
        'name': widget.food.name,
        'price': finalPricePerItem,
        'qty': _quantity,
        'addons': selectedAddons,
      });
    });

    widget.onCartUpdated();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.food.name} added to cart!'),
        backgroundColor: const Color(0xFFE76F2F),
        duration: const Duration(milliseconds: 800),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _specialRequestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE76F2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Food detail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Icon(Icons.fastfood_outlined, size: 80, color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 16),
              Text(widget.food.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('RM ${widget.food.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, color: Color(0xFFE76F2F), fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // Successfully references the internal matching method block
              Text(
                _getDynamicDescription(widget.food.name),
                style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 20),

              // Add-ons section title
              // Wrap the add-ons inside an 'if' statement so they only show up for Rice category dishes!
              if (widget.food.category == 'Rice' || widget.food.name.contains('Nasi')) ...[
                const Text('Add-ons (optional)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                _buildAddonRow('Extra sambal', '+ RM 0.20', _extraSambal, (val) => setState(() => _extraSambal = val!)),
                _buildAddonRow('Telur mata', '+ RM 1.00', _telurMata, (val) => setState(() => _telurMata = val!)),
                _buildAddonRow('Telur rebus', '+ RM 0.50', _telurRebus, (val) => setState(() => _telurRebus = val!)),
                _buildAddonRow('Nasi', '+ RM 0.50', _extraNasi, (val) => setState(() => _extraNasi = val!)),

                const SizedBox(height: 20),
              ],
              const Text('Special request', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _specialRequestController,
                maxLines: 2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffEFEFEF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  hintText: 'E.g., No onions, extra spicy...',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFE76F2F), size: 28),
                  onPressed: () { if (_quantity > 1) setState(() => _quantity--); }
              ),
              const SizedBox(width: 4),
              Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFFE76F2F), size: 28),
                  onPressed: () => setState(() => _quantity++)
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE76F2F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ),
                  onPressed: _confirmAddToCart,
                  child: const Text('Add to cart', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddonRow(String title, String priceLabel, bool currentValue, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(value: currentValue, onChanged: onChanged, activeColor: const Color(0xFFE76F2F))
              ),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Text(priceLabel, style: const TextStyle(fontSize: 13, color: Color(0xFFE76F2F), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
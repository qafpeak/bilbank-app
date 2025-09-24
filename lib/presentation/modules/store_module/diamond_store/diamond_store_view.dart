import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiamondStoreView extends StatelessWidget {
  DiamondStoreView({super.key});

  final List<DiamondItem> wheelItems = [
    DiamondItem(name: "Elmas x1", price: 50, ),
    DiamondItem(name: "Elmas x3", price: 120, ),
    DiamondItem(name: "Elmas x5", price: 180, ),
    DiamondItem(name: "Elmas x10", price: 250, ),
    DiamondItem(name: "Elmas x20", price: 300,),
    DiamondItem(name: "Elmas x50", price: 500, ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(
      appBar: AppBar(
        title: const Text("Elmas Satın Al",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: wheelItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 sütun
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final item = wheelItems[index];
              return _buildWheelCard(context, item);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWheelCard(BuildContext context, DiamondItem item) {
    return GestureDetector(
      onTap: () {
        // satın alma işlemi burada yapılabilir
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("${item.name} Satın Al"),
            content: Text("${item.price} coin karşılığında satın almak istiyor musunuz?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("İptal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${item.name} satın alındı!")),
                  );
                },
                child: const Text("Satın Al"),
              ),
            ],
          ),
        );
      },
      child: Card(
        color: Colors.green.withAlpha((0.4 * 255).toInt()), // yani 102,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             SvgPicture.asset("assets/svg/ic_diamond.svg",width: 50,height: 50,fit: BoxFit.fill),
              const SizedBox(height: 12),
              Text(
                item.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text("${item.price} TL",
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 8),
              const Icon(Icons.shopping_cart, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class DiamondItem {
  final String name;
  final int price;


  DiamondItem({required this.name, required this.price, });
}

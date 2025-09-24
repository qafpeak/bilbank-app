import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WheelStoreView extends StatelessWidget {
  WheelStoreView({super.key});

  final List<WheelItem> wheelItems = [
    WheelItem(name: "Çark x1", price: 50,id: "aslkdjalskd" ),
    WheelItem(name: "Çark x3", price: 120,id: "alksjdlaksdjlasd" ),
    WheelItem(name: "Çark x5", price: 180,id:"alksdjalskd" ),
    WheelItem(name: "Çark x10", price: 250,id:"laksdlaksd" ),
    WheelItem(name: "Çark x20", price: 300,id:"lkajsdlkasd"),
    WheelItem(name: "Çark x50", price: 500,id:"askdjlaskd" ),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(
      appBar: AppBar(
        title: const Text("Çark Satın Al",style: TextStyle(color: Colors.white),),
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

  Widget _buildWheelCard(BuildContext context, WheelItem item) {
    return GestureDetector(
      onTap: () {
        // satın alma işlemi burada yapılabilir
        showDialog(
          context: context,
          builder: (alertContext) => CustomAlertDialog(
            title: "${item.name} Satın Al",
            message: "${item.price} coin karşılığında satın almak istiyor musunuz?",
            confirmText: "Satın Al",
            cancelText: "İptal Et",
            onConfirm: () {
              Navigator.pop(alertContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${item.name} satın alındı!")),
                  );
            },
            onCancel: () {
              Navigator.pop(alertContext);
              
            },
           
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
             SvgPicture.asset("assets/svg/ic_wheel_lucky.svg",width: 50,height: 50,fit: BoxFit.fill,),
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




class WheelItem {
  final String name;
  final int price;
  final String id;
  WheelItem({required this.name, required this.price,required this.id });
}


class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;

  final String confirmText;
  final String? cancelText;

  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  final bool barrierDismissible;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    this.message,
    this.icon,
    this.confirmText = 'Tamam',
    this.cancelText,
    this.onCancel,
    this.barrierDismissible = true,
  });

  static const List<Color> _gradientColors = <Color>[
    Color(0xFF4F46E5), // morumsu mavi
    Color(0xFF3B82F6), // parlak mavi
    Color(0xFF06B6D4), // cam göbeği
  ];

  static Future<void> show(
    BuildContext context, {
    required String title,
    String? message,
    IconData? icon,
    String confirmText = 'Tamam',
    String? cancelText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomAlertDialog(
        title: title,
        message: message,
        icon: icon,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 16.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: _gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
            if (icon != null) const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            if (message != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                if (cancelText?.isNotEmpty == true) ...<Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).maybePop();
                        onCancel?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.white24,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(cancelText!),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).maybePop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.white,
                      foregroundColor: _gradientColors.first,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


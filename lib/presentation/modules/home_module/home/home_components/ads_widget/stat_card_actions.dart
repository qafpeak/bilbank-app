import 'package:flutter/material.dart';

class StatCardActions extends StatelessWidget {
  final VoidCallback onShopTap;
  final VoidCallback onRefreshTap;

  const StatCardActions({
    Key? key,
    required this.onShopTap,
    required this.onRefreshTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        _ActionButton(
          icon: Icons.shopping_cart_outlined,
          onTap: onShopTap,
        ),
        _ActionButton(
          icon: Icons.refresh_outlined,
          onTap: onRefreshTap,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.15),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withOpacity(0.4)),
        ),
        fixedSize: const Size(24, 24),
        padding: EdgeInsets.zero,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

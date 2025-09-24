import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    super.key,
    required this.notificationCount,
    required this.onNotificationTap,

  });

  final int notificationCount ;
  final VoidCallback onNotificationTap;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            IconButton(
              onPressed: onNotificationTap,
              icon: const Icon(Icons.notifications),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child:  Text(
                  notificationCount.toString(), 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const Text("Duyurular"),
      ],
    );
  }
}

import 'package:bilbank_app/presentation/modules/home_module/notifications/notifications_view_mixin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:provider/provider.dart';

import 'notifications_view_model.dart';

class NotificationsView extends StatefulWidget {
   NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> with NotificationsViewMixin {
  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(
      appBar: AppBar(
        title: Text(
          "Bildirimler",
          style: GoogleFonts.headlandOne(fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Consumer<NotificationsViewModel>(
        
        builder: (context, vm, child) =>  ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: vm.notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final notification = vm.notifications[index];
        
            if (notification.isDismissed == true) {
              return const SizedBox.shrink(); // Atla
            }
        
            return Dismissible(
              key: Key(notification.id ?? index.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                // TODO: Kalıcı olarak silme veya "dismiss" olarak işaretleme işlemi
                // Örn: notificationService.dismiss(notification.id);
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.red.withOpacity(0.9),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: notification.isRead == true ? Colors.grey[100] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: notification.isRead == true
                        ? Colors.grey.shade300
                        : Colors.blue.shade100,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      notification.isRead == true
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: notification.isRead == true
                          ? Colors.grey
                          : Colors.blueAccent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead == true
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: notification.isRead == true
                                  ? Colors.grey[800]
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notification.body ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

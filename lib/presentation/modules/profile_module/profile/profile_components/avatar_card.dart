import 'package:flutter/material.dart';

class AvatarCard extends StatelessWidget {
  final VoidCallback onSettingsTap;
  final VoidCallback onEditAvatarTap;
  final String? avatarUrl;
  
  const AvatarCard({
    super.key,
    required this.onSettingsTap,
    required this.onEditAvatarTap,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140, // avatar yüksekliği + biraz boşluk
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: MediaQuery.sizeOf(context).width, height: 140),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: avatarUrl != null 
                    ? NetworkImage(avatarUrl!) 
                    : null,
                child: avatarUrl == null 
                    ? const Icon(Icons.person, size: 60, color: Colors.white70)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: onEditAvatarTap,
                  ),
                ),
              ),
            ],
          ),
          // Sağ üstteki settings ikonu
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 30,
              ),
              onPressed: onSettingsTap,
            ),
          ),
        ],
      ),
    );
  }
}

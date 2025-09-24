class AvatarModel {
  final String id;
  final String fileName;
  final String displayName;
  final String networkUrl;
  final bool isSelected;

  const AvatarModel({
    required this.id,
    required this.fileName,
    required this.displayName,
    required this.networkUrl,
    this.isSelected = false,
  });

  AvatarModel copyWith({
    String? id,
    String? fileName,
    String? displayName,
    String? networkUrl,
    bool? isSelected,
  }) {
    return AvatarModel(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      displayName: displayName ?? this.displayName,
      networkUrl: networkUrl ?? this.networkUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      id: json['id']?.toString() ?? '',
      fileName: json['file_name']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? '',
      networkUrl: json['network_url']?.toString() ?? '',
      isSelected: json['is_selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_name': fileName,
      'display_name': displayName,
      'network_url': networkUrl,
      'is_selected': isSelected,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AvatarModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class AvatarListResponse {
  final List<AvatarModel> avatars;
  final String? currentAvatarId;

  const AvatarListResponse({
    required this.avatars,
    this.currentAvatarId,
  });

  factory AvatarListResponse.fromJson(Map<String, dynamic> json) {
    return AvatarListResponse(
      avatars: (json['avatars'] as List?)
          ?.map((avatar) => AvatarModel.fromJson(avatar))
          .toList() ?? [],
      currentAvatarId: json['current_avatar_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatars': avatars.map((avatar) => avatar.toJson()).toList(),
      'current_avatar_id': currentAvatarId,
    };
  }

  // Backend assets klasöründen varsayılan avatar listesi oluştur
  static AvatarListResponse createDefaultAvatars({
    required String baseUrl,
    String? currentAvatarId,
  }) {
    final List<AvatarModel> avatars = [];
    
    // pp1.png - pp12.png dosyaları için avatar listesi oluştur
    for (int i = 1; i <= 12; i++) {
      final fileName = 'pp$i.png';
      final avatar = AvatarModel(
        id: i.toString(),
        fileName: fileName,
        displayName: 'Avatar $i',
        networkUrl: '$baseUrl/assets/pp/$fileName',
        isSelected: currentAvatarId == i.toString(),
      );
      avatars.add(avatar);
    }

    return AvatarListResponse(
      avatars: avatars,
      currentAvatarId: currentAvatarId,
    );
  }
}
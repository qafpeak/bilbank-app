class NotificationModel {
  String? id;
  String? userId;
  String? title;
  String? body;
  bool? isRead;
  bool? isDismissed;

  NotificationModel(
      {this.id,
      this.userId,
      this.title,
      this.body,
      this.isRead,
      this.isDismissed});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    body = json['body'];
    isRead = json['is_read'];
    isDismissed = json['is_dismissed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['is_read'] = this.isRead;
    data['is_dismissed'] = this.isDismissed;
    return data;
  }
}

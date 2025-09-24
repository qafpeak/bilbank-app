class RankModel {
  bool? ok;
  List<Rankings>? rankings;
  MyRank? myRank;

  RankModel({this.ok, this.rankings, this.myRank});

  RankModel.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['rankings'] != null) {
      rankings = <Rankings>[];
      json['rankings'].forEach((v) {
        rankings!.add(new Rankings.fromJson(v));
      });
    }
    myRank =
        json['myRank'] != null ? new MyRank.fromJson(json['myRank']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.rankings != null) {
      data['rankings'] = this.rankings!.map((v) => v.toJson()).toList();
    }
    if (this.myRank != null) {
      data['myRank'] = this.myRank!.toJson();
    }
    return data;
  }
}

class Rankings {
  String? userId;
  int? score;
  int? rank;
  bool? isMe;

  Rankings({this.userId, this.score, this.rank, this.isMe});

  Rankings.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    score = json['score'];
    rank = json['rank'];
    isMe = json['isMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['score'] = this.score;
    data['rank'] = this.rank;
    data['isMe'] = this.isMe;
    return data;
  }
}

class MyRank {
  int? rank;
  int? score;

  MyRank({this.rank, this.score});

  MyRank.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['score'] = this.score;
    return data;
  }
}

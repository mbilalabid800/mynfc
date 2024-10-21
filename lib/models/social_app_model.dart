class SocialAppModel {
  final String name;
  final String icon;
  String profileLink;
  String userName;
  bool isVisible;
  int index;

  SocialAppModel({
    required this.name,
    required this.icon,
    required this.profileLink,
    required this.userName,
    this.isVisible = true,
    this.index = 0,
  });

  factory SocialAppModel.fromFirestore(Map<String, dynamic> json) {
    return SocialAppModel(
      name: json['name'] as String,
      icon: json['icon'] as String,
      profileLink: json['link'] as String,
      userName: json['userName'] as String,
      isVisible: json['isVisible'] ?? true,
      index: json['index'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'icon': icon,
      'link': profileLink,
      'userName': userName,
      'isVisible': isVisible,
      'index': index,
    };
  }

  SocialAppModel copyWith({String? userName, bool? isVisible, int? index}) {
    return SocialAppModel(
      name: name,
      icon: icon,
      profileLink: profileLink,
      userName: userName ?? this.userName,
      isVisible: isVisible ?? this.isVisible,
      index: index ?? this.index,
    );
  }
}

class AppDataModel {
  final String title;
  final String descriptions;

  AppDataModel({
    required this.title,
    required this.descriptions,
  });

  factory AppDataModel.fromFirestore(Map<String, dynamic> map) {
    return AppDataModel(
      title: map['title'] ?? '',
      descriptions: map['content'] ?? '',
    );
  }
}

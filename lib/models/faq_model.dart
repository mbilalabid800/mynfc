// faq_model.dart
class FaqModel {
  final String title;
  final String description;

  FaqModel({required this.title, required this.description});

  // Factory method to create a FaqModel from a Firebase document
  factory FaqModel.fromFirestore(Map<String, dynamic> data) {
    return FaqModel(
      title: data['question'] ?? '',
      description: data['answer'] ?? '',
    );
  }
}

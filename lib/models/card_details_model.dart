import 'package:cloud_firestore/cloud_firestore.dart';

class CardDetailsModel {
  final String cardName;
  final List<CardColorOption> cardColorOptions;
  final List<String> cardImages;
  final String cardDescription;
  final double cardPrice;
  final String cardFinish;
  final String cardWeight;
  final String cardDimension;
  final String cardPrinting;

  CardDetailsModel({
    required this.cardName,
    required this.cardColorOptions,
    required this.cardImages,
    required this.cardDescription,
    required this.cardPrice,
    required this.cardFinish,
    required this.cardWeight,
    required this.cardDimension,
    required this.cardPrinting,
  });

  factory CardDetailsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CardDetailsModel(
      cardName: data['cardName'] as String,
      cardColorOptions: (data['cardColorOptions'] as List<dynamic>?)
              ?.map((e) => CardColorOption.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      cardImages: List<String>.from(data['cardImages'] ?? []),
      cardDescription: data['cardDescription'],
      cardPrice: (data['cardPrice'] as num?)?.toDouble() ?? 0.0,
      cardFinish: data['cardFinish'],
      cardWeight: data['cardWeight'],
      cardDimension: data['cardDimension'],
      cardPrinting: data['cardPrinting'],
    );
  }
}

class CardColorOption {
  final String colorName;
  final String colorImage;

  CardColorOption({
    required this.colorName,
    required this.colorImage,
  });
  factory CardColorOption.fromMap(Map<String, dynamic> map) {
    return CardColorOption(
      colorName: map['colorName'] as String,
      colorImage: map['colorImage'] as String,
    );
  }
}

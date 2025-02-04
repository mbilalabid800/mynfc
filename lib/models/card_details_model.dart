import 'package:cloud_firestore/cloud_firestore.dart';

class CardDetailsModel {
  final String cardName;
  final List<CardColorOption> cardColorOptions;
  final List<String> cardImages;
  final String cardDescription;
  final double cardPrice;
  final String cardFinish;
  final String cardWeight;
  final String CardDimension;
  final String cardPrinting;

  CardDetailsModel({
    required this.cardName,
    required this.cardColorOptions,
    required this.cardImages,
    required this.cardDescription,
    required this.cardPrice,
    required this.cardFinish,
    required this.cardWeight,
    required this.CardDimension,
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
      CardDimension: data['CardDimension'],
      cardPrinting: data['cardPrinting'],
    );
  }
}

class CardColorOption {
  final String type;
  final String url;

  CardColorOption({
    required this.type,
    required this.url,
  });
  factory CardColorOption.fromMap(Map<String, dynamic> map) {
    return CardColorOption(
      type: map['type'] as String,
      url: map['url'] as String,
    );
  }
}

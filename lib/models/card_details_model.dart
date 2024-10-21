class CardDetailsModel {
  final String cardName;
  final List<CardColorOption> cardColorOptions;
  List<String> cardImages;
  final String cardDescription;
  final String cardPrice;
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
}

class CardColorOption {
  final String colorName;
  final String colorImage;

  CardColorOption({
    required this.colorName,
    required this.colorImage,
  });
}

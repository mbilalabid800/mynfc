import 'package:flutter/material.dart';
import 'package:nfc_app/models/card_details_model.dart';

class CardDetailsProvider extends ChangeNotifier {
  final List<CardDetailsModel> _cards = [
    CardDetailsModel(
      cardName: 'Classic',
      cardColorOptions: [
        CardColorOption(
            colorName: 'Black', colorImage: 'assets/images/classiccolor1.png'),
        CardColorOption(
            colorName: 'White', colorImage: 'assets/images/classiccolor2.png'),
        CardColorOption(
            colorName: 'Grey', colorImage: 'assets/images/classiccolor3.png'),
      ],
      cardImages: [
        'assets/images/classic_black.png',
        'assets/images/classic_white.png',
        'assets/images/classic_grey.png',
      ],
      cardDescription:
          'The most popular option for digital business cards. Made from durable, 8 times recyclable plastic. Designed for longevity and produced with precision: the perfect choice for any occasion.',
      cardPrice: '57.00 OMR',
      cardFinish: 'Glossy, Plastic Type: PET',
      cardWeight: '0.8mm',
      cardDimension: '85.60 x 53.98 mm',
      cardPrinting:
          'Printed in 600 DPI resolution:\nPrintable area: 100%\n(over the edge)',
    ),
    CardDetailsModel(
      cardName: 'Wood',
      cardColorOptions: [
        CardColorOption(
            colorName: 'Brown', colorImage: 'assets/images/woodcolor1.png'),
        CardColorOption(
            colorName: 'Yellow', colorImage: 'assets/images/woodcolor2.png'),
        CardColorOption(
            colorName: 'Woody', colorImage: 'assets/images/woodcolor3.png'),
      ],
      cardImages: [
        'assets/images/wood_brown.png',
        'assets/images/wood_yellow.png',
        'assets/images/wood_woody.png',
      ],
      cardDescription:
          'This eco-friendly approach to networking is sure to make an impression. And we plant a tree for every card sold. Available in Birch (light) and Sapele (dark) from carefully sourced woods.',
      cardPrice: '78.00 OMR',
      cardFinish: 'Polished finish\nAvailable in Birch and Sapele',
      cardWeight: '0.8mm',
      cardDimension: '85.60 x 53.98 mm',
      cardPrinting:
          'Printed in 600 DPI resolution:\nPrintable area: 100%\n(over the edge)',
    ),
    CardDetailsModel(
      cardName: 'Metal',
      cardColorOptions: [
        CardColorOption(
            colorName: 'Black', colorImage: 'assets/images/metalcolor1.png'),
        CardColorOption(
            colorName: 'Golden', colorImage: 'assets/images/metalcolor2.png'),
        CardColorOption(
            colorName: 'Silver', colorImage: 'assets/images/metalcolor3.png'),
      ],
      cardImages: [
        'assets/images/metal_black.png',
        'assets/images/metal_golden.png',
        'assets/images/metal_silver.png',
      ],
      cardDescription:
          'Made from stainless steel and laser-engraved, this card demands attention. Available in Black, Gold, and Silver. Gold and Silver cards are engraved in black. Black cards will be engraved showing the stainless steel.',
      cardPrice: '99.00 OMR',
      cardFinish: 'Brushed finish\nAvailable in Black, Silver, & Gold',
      cardWeight: '0.8mm',
      cardDimension: '85.60 x 53.98 mm',
      cardPrinting:
          'Printed in 600 DPI resolution:\nPrintable area: 100%\n(over the edge)',
    ),
  ];

  late CardDetailsModel _selectedCard = _cards.first;
  late CardColorOption _selectedColorOption =
      _selectedCard.cardColorOptions.first;
  String _filteredCardImages = '';

  CardDetailsProvider() {
    updateCardImages();
  }

  List<CardDetailsModel> get cards => _cards;

  CardDetailsModel get selectedCard => _selectedCard;
  CardColorOption get selectedColorOption => _selectedColorOption;
  String get filtercardImages => _filteredCardImages;

  void setSelectedColor(CardColorOption colorOption) {
    _selectedColorOption = colorOption;
    updateCardImages();
    notifyListeners();
  }

  void updateCardImages() {
    _filteredCardImages = selectedCard.cardImages.firstWhere((image) {
      return image.contains(_selectedColorOption.colorName.toLowerCase());
    });
  }

  void setSelectedCard(CardDetailsModel card) {
    _selectedCard = card;
    _selectedColorOption = card.cardColorOptions.first;
    updateCardImages();
    notifyListeners();
  }

  void clear() {
    _selectedCard = _cards.first;
    _selectedColorOption = _selectedCard.cardColorOptions.first;
    updateCardImages();
    notifyListeners();
  }
}

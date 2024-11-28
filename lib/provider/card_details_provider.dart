import 'package:flutter/material.dart';
import 'package:nfc_app/models/card_details_model.dart';

class CardDetailsProvider extends ChangeNotifier {
  final List<CardDetailsModel> _cards = [
    CardDetailsModel(
      cardName: 'Classic',
      cardColorOptions: [
        CardColorOption(
            colorName: 'Black',
            colorImage: 'assets/images/classic_picker_black.png'),
        CardColorOption(
            colorName: 'Grey',
            colorImage: 'assets/images/classic_picker_grey.png'),
        CardColorOption(
            colorName: 'Blue',
            colorImage: 'assets/images/classic_picker_blue.png'),
        CardColorOption(
            colorName: 'Greenish',
            colorImage: 'assets/images/classic_picker_greenish.png'),
        CardColorOption(
            colorName: 'Magic Gradient',
            colorImage: 'assets/images/classic_picker_magic gradient.png'),
        CardColorOption(
            colorName: 'Multi Gradient',
            colorImage: 'assets/images/classic_picker_multi gradient.png'),
        CardColorOption(
            colorName: 'Pink Gradient',
            colorImage: 'assets/images/classic_picker_pink gradient.png'),
        CardColorOption(
            colorName: 'Purple',
            colorImage: 'assets/images/classic_picker_purple.png'),
        CardColorOption(
            colorName: 'Soft Blue',
            colorImage: 'assets/images/classic_picker_soft blue.png'),
        CardColorOption(
            colorName: 'Black Premium',
            colorImage: 'assets/images/classic_picker_black premium.png'),
      ],
      cardImages: [
        'assets/images/classic_black.png',
        'assets/images/classic_grey.png',
        'assets/images/classic_blue.png',
        'assets/images/classic_greenish.png',
        'assets/images/classic_magic gradient.png',
        'assets/images/classic_multi gradient.png',
        'assets/images/classic_pink gradient.png',
        'assets/images/classic_purple.png',
        'assets/images/classic_soft blue.png',
        'assets/images/classic_black premium.png',
      ],
      cardDescription:
          'The most popular option for digital business cards. Made from durable, 8 times recyclable plastic. Designed for longevity and produced with precision: the perfect choice for any occasion.',
      cardPrice: 57.00,
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
            colorName: 'Brown',
            colorImage: 'assets/images/wood_picker_brown.png'),
        CardColorOption(
            colorName: 'Beige',
            colorImage: 'assets/images/wood_picker_beige.png'),
        CardColorOption(
            colorName: 'Chocolate',
            colorImage: 'assets/images/wood_picker_chocolate.png'),
        CardColorOption(
            colorName: 'Coffee',
            colorImage: 'assets/images/wood_picker_coffee.png'),
        CardColorOption(
            colorName: 'Dark',
            colorImage: 'assets/images/wood_picker_dark.png'),
        CardColorOption(
            colorName: 'Marble',
            colorImage: 'assets/images/wood_picker_marble.png'),
        CardColorOption(
            colorName: 'Peach',
            colorImage: 'assets/images/wood_picker_peach.png'),
        CardColorOption(
            colorName: 'Tree',
            colorImage: 'assets/images/wood_picker_tree.png'),
        CardColorOption(
            colorName: 'White',
            colorImage: 'assets/images/wood_picker_white.png'),
        CardColorOption(
            colorName: 'Yellow',
            colorImage: 'assets/images/wood_picker_yellow.png'),
      ],
      cardImages: [
        'assets/images/wood_brown.png',
        'assets/images/wood_beige.png',
        'assets/images/wood_chocolate.png',
        'assets/images/wood_coffee.png',
        'assets/images/wood_dark.png',
        'assets/images/wood_marble.png',
        'assets/images/wood_peach.png',
        'assets/images/wood_tree.png',
        'assets/images/wood_white.png',
        'assets/images/wood_yellow.png',
      ],
      cardDescription:
          'This eco-friendly approach to networking is sure to make an impression. And we plant a tree for every card sold. Available in Birch (light) and Sapele (dark) from carefully sourced woods.',
      cardPrice: 78.00,
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
            colorName: 'Black',
            colorImage: 'assets/images/metal_picker_black.png'),
        CardColorOption(
            colorName: 'Golden',
            colorImage: 'assets/images/metal_picker_golden.png'),
        CardColorOption(
            colorName: 'Blue Steel',
            colorImage: 'assets/images/metal_picker_blue steel.png'),
        CardColorOption(
            colorName: 'Golden Premium',
            colorImage: 'assets/images/metal_picker_golden premium.png'),
        CardColorOption(
            colorName: 'Grey Steel',
            colorImage: 'assets/images/metal_picker_grey steel.png'),
        CardColorOption(
            colorName: 'Light Golden',
            colorImage: 'assets/images/metal_picker_light golden.png'),
        CardColorOption(
            colorName: 'Silver',
            colorImage: 'assets/images/metal_picker_silver.png'),
        CardColorOption(
            colorName: 'Soft Blue',
            colorImage: 'assets/images/metal_picker_soft blue.png'),
        CardColorOption(
            colorName: 'Silver Premium',
            colorImage: 'assets/images/metal_picker_silver premium.png'),
        CardColorOption(
            colorName: 'Black Premium',
            colorImage: 'assets/images/metal_picker_black premium.png'),
      ],
      cardImages: [
        'assets/images/metal_black.png',
        'assets/images/metal_golden.png',
        'assets/images/metal_blue steel.png',
        'assets/images/metal_golden premium.png',
        'assets/images/metal_grey steel.png',
        'assets/images/metal_light golden.png',
        'assets/images/metal_silver.png',
        'assets/images/metal_soft blue.png',
        'assets/images/metal_silver premium.png',
        'assets/images/metal_black premium.png',
      ],
      cardDescription:
          'Made from stainless steel and laser-engraved, this card demands attention. Available in Black, Gold, and Silver. Gold and Silver cards are engraved in black. Black cards will be engraved showing the stainless steel.',
      cardPrice: 99.00,
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
  int _visibleStartIndex = 0;

  bool get isMoreUpEnabled => _visibleStartIndex > 0;
  bool get isMoreDownEnabled =>
      _visibleStartIndex + 4 < _selectedCard.cardColorOptions.length;

  CardDetailsProvider() {
    updateCardImages();
  }

  List<CardDetailsModel> get cards => _cards;
  CardDetailsModel get selectedCard => _selectedCard;
  CardColorOption get selectedColorOption => _selectedColorOption;
  String get filtercardImages => _filteredCardImages;

  List<CardColorOption> get visibleColorOptions {
    int endIndex = _visibleStartIndex + 4;
    endIndex = endIndex > _selectedCard.cardColorOptions.length
        ? _selectedCard.cardColorOptions.length
        : endIndex;
    return _selectedCard.cardColorOptions.sublist(_visibleStartIndex, endIndex);
  }

  void setSelectedColor(CardColorOption colorOption) {
    _selectedColorOption = colorOption;
    updateCardImages();
    notifyListeners();
  }

  void updateCardImages() {
    _filteredCardImages = selectedCard.cardImages.firstWhere(
      (image) {
        return image.contains(_selectedColorOption.colorName.toLowerCase());
      },
    );
  }

  void setSelectedCard(CardDetailsModel card) {
    _selectedCard = card;
    _selectedColorOption = card.cardColorOptions.first;
    _visibleStartIndex = 0;
    updateCardImages();
    notifyListeners();
  }

  void scrollColorUp() {
    if (_visibleStartIndex > 0) {
      _visibleStartIndex -= 1;
      notifyListeners();
    }
  }

  void scrollColorDown() {
    if (_visibleStartIndex + 4 < _selectedCard.cardColorOptions.length) {
      _visibleStartIndex += 1;
      notifyListeners();
    }
  }

  void clear() {
    _selectedCard = _cards.first;
    _selectedColorOption = _selectedCard.cardColorOptions.first;
    _visibleStartIndex = 0;
    updateCardImages();
    notifyListeners();
  }
}

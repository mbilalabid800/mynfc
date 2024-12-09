// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/models/card_details_model.dart';

class CardDetailsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<CardDetailsModel> _cards = [];
  CardDetailsModel? _selectedCard;
  CardColorOption? _selectedColorOption;
  String _filteredCardImages = '';
  int _visibleStartIndex = 0;
  bool _isLoading = true;

  /// Getters
  List<CardDetailsModel> get cards => _cards;
  CardDetailsModel? get selectedCard => _selectedCard;
  CardColorOption? get selectedColorOption => _selectedColorOption;
  String get filteredCardImages => _filteredCardImages;
  bool get isLoading => _isLoading;
  bool get isMoreUpEnabled => _visibleStartIndex > 0;
  bool get isMoreDownEnabled =>
      _selectedCard != null &&
      _visibleStartIndex + 4 < _selectedCard!.cardColorOptions.length;

  /// Fetch data from Firestore
  Future<void> fetchCardsFromFirestore(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore.collection('cards').get();
      final List<CardDetailsModel> fetchedCards = snapshot.docs
          .map((doc) => CardDetailsModel.fromFirestore(doc))
          .toList();

      _cards.clear();
      _cards.addAll(fetchedCards);
      if (_cards.isNotEmpty) {
        setSelectedCard(_cards.first);
      }

      // Preload all images
      await _preloadCardImages(context);
    } catch (e) {
      print('Error fetching cards: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Preload all card images
  Future<void> _preloadCardImages(BuildContext context) async {
    List<Future> preloadFutures = [];

    for (var card in _cards) {
      for (var imageUrl in card.cardImages) {
        preloadFutures.add(
          precacheImage(NetworkImage(imageUrl), context),
        );
      }
    }

    await Future.wait(preloadFutures); // Wait for all images to load
  }

  /// Set the selected card
  void setSelectedCard(CardDetailsModel card) {
    _isLoading = true;
    notifyListeners();
    _selectedCard = card;
    _selectedColorOption =
        card.cardColorOptions.isNotEmpty ? card.cardColorOptions.first : null;
    _filteredCardImages =
        card.cardImages.isNotEmpty ? card.cardImages.first : '';
    _visibleStartIndex = 0;
    _isLoading = false;
    notifyListeners();
  }

  /// Set the selected color option
  void setSelectedColor(CardColorOption colorOption) {
    _isLoading = true;
    notifyListeners();
    _selectedColorOption = colorOption;
    _filteredCardImages = _selectedCard?.cardImages.firstWhere(
          (image) =>
              image.toLowerCase().contains(colorOption.colorName.toLowerCase()),
          orElse: () => '',
        ) ??
        '';
    _isLoading = false;
    notifyListeners();
  }

  /// Scroll up through the visible color options
  void scrollColorUp() {
    if (_visibleStartIndex > 0) {
      _visibleStartIndex -= 1;
      notifyListeners();
    }
  }

  /// Scroll down through the visible color options
  void scrollColorDown() {
    if (_selectedCard != null &&
        _visibleStartIndex + 4 < _selectedCard!.cardColorOptions.length) {
      _visibleStartIndex += 1;
      notifyListeners();
    }
  }

  /// Get visible color options for pagination
  List<CardColorOption> get visibleColorOptions {
    if (_selectedCard == null) return [];
    int endIndex = _visibleStartIndex + 4;
    endIndex = endIndex > _selectedCard!.cardColorOptions.length
        ? _selectedCard!.cardColorOptions.length
        : endIndex;
    return _selectedCard!.cardColorOptions
        .sublist(_visibleStartIndex, endIndex);
  }

  /// Clear the current selection and reset to the first card
  void clear() {
    if (_cards.isNotEmpty) {
      _selectedCard = _cards.first;
      _selectedColorOption = _selectedCard!.cardColorOptions.first;
      _filteredCardImages = _selectedCard!.cardImages.first;
      _visibleStartIndex = 0;
      notifyListeners();
    }
  }
}

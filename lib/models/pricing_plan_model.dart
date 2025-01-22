import 'package:flutter/material.dart';

class PricingPlan {
  final String title;
  final String category;
  final String currency;
  final String price;
  final String description;
  final List<String> features;
  final List<String>? nofeatures;
  final String buttonText; // Text for the button
  final void Function(BuildContext context, dynamic selectedCard,
      dynamic selectedColorOption) buttonAction;
  final String assetImagePath;
  final IconData icon; // Add the IconData field

  // Action to perform on button press

  PricingPlan({
    required this.title,
    required this.icon,
    required this.category,
    required this.currency,
    required this.price,
    required this.description,
    required this.features,
    required this.buttonText,
    required this.buttonAction,
    required this.assetImagePath,
    this.nofeatures,
  });
}

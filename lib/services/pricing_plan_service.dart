// services/pricing_plan_service.dart

import 'package:flutter/material.dart';
import 'package:nfc_app/models/pricing_plan_model.dart';

class PricingPlanService {
  List<PricingPlan> getPlans() {
    return [
      PricingPlan(
        icon: Icons.person,
        title: 'For Individuals',
        category: 'Individuals',
        price: '49.90 ',
        assetImagePath: 'assets/icons/cardpopular.png',
        currency: 'OMR',
        description: 'per card, one-time payment',
        features: [
          'Custom NFC Card',
          'NFC Free Plan',
          'One Digital business Card',
          'Unlimited Shares (NFC, QR, Link)',
          'Public Mode: t.link/username',
          'In App QR- code sharing',
          'Offline QR Code (vcard)',
          'NameDrop Share (iOS)',
        ],
        nofeatures: [
          'WorkFlow Automation',
          'CRM Integrations (Hubspot, Zapier, Pipedrive)'
        ],
        buttonText: 'Order NFC Card',
        buttonAction: (context) {
          //dummy link
          Navigator.pushNamed(context, '/privacy-policy');
        },
      ),
      PricingPlan(
        icon: Icons.groups,
        title: 'For Teams & Business',
        category: 'Teams',
        price: '49.90 ',
        currency: 'OMR',
        assetImagePath: 'assets/icons/teamcard.png',
        description: 'per user, per year',
        features: [
          'Custom NFC Card',
          'NFC Free Plan',
          'One Digital business Card',
          'Unlimited Shares (NFC, QR, Link)',
          'Public Mode: t.link/username',
          'In App QR- code sharing',
          'Offline QR Code (vcard)',
          'NameDrop Share (iOS)',
          'WorkFlow Automation',
          'CRM Integrations (Hubspot, Zapier, Pipedrive)'
        ],
        nofeatures: [],
        buttonText: 'Book a Demo',
        buttonAction: (context) {
          //dummy link
          Navigator.pushNamed(context, '/privacy-policy');
        },
      ),
      PricingPlan(
        icon: Icons.apartment,
        title: 'For Enterprise',
        category: 'Companies',
        price: 'Contact Us',
        currency: '',
        assetImagePath: 'assets/icons/teamcard.png',
        description: '100+ users',
        features: [
          'Custom NFC Card',
          'NFC Free Plan',
          'One Digital business Card',
          'Unlimited Shares (NFC, QR, Link)',
          'Public Mode: t.link/username',
          'In App QR- code sharing',
          'Offline QR Code (vcard)',
          'NameDrop Share (iOS)',
          'WorkFlow Automation',
          'CRM Integrations (Hubspot, Zapier, Pipedrive)'
        ],
        nofeatures: [],
        buttonText: 'Talk to Sale',
        buttonAction: (context) {
          //dummy link
          Navigator.pushNamed(context, '/privacy-policy');
        },
      ),
    ];
  }
}

class CardPicturesLinks {
  Map<String, String> cardImages = {
    'classic_black':
        'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/card_pictures%2Fclassic_black.png?alt=media&token=ac8e872d-67bd-4fd6-ae69-ce4ce404a63b',
    'classic_white':
        'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/card_pictures%2Fclassic_white.png?alt=media&token=1717b7d3-da52-4932-8aaf-58b781a5dfd5',
    'classic_grey':
        'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/card_pictures%2Fclassic_grey.png?alt=media&token=7750b380-c39b-4d03-bf49-7459d6af2635',
    'wood_brown':
        'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/card_pictures%2Fwood_brown.png?alt=media&token=2566e07e-c5fb-408d-8cd2-6c52315f0a65',
    'wood_yellow':
        'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/card_pictures%2Fwood_yellow.png?alt=media&token=3f78869e-1356-4329-b6f6-679754e6d0a5',
    'wood_woody':
        'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/card_pictures%2Fwood_woody.png?alt=media&token=2293842a-746f-40ae-83f3-5fe1609fe370',
    'metal_black':
        'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/card_pictures%2Fmetal_black.png?alt=media&token=10d74166-646f-4236-be8b-7b246987afae',
    'metal_golden':
        'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/card_pictures%2Fmetal_golden.png?alt=media&token=cd1a6f12-90ad-4c8f-9dfc-d633ceedd7c3',
    'metal_silver':
        'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/card_pictures%2Fmetal_silver.png?alt=media&token=c1623c5d-edb5-4c38-aa00-d622141210e4',
  };

  String getCardUrl(String cardName) {
    return cardImages[cardName] ?? '';
  }
}

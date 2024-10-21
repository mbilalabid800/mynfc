// ignore_for_file: dead_code, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/card_details_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:provider/provider.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({super.key});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  bool _showDetails = false;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardProvider =
          Provider.of<CardDetailsProvider>(context, listen: false);
      cardProvider.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        // appBar: const CustomAppBar(title: 'Card options'),
        body: Consumer<CardDetailsProvider>(
          builder: (context, cardDetailsProvider, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.020),
                  // Center(
                  //   child: Text(
                  //     "Card options",
                  //     style: TextStyle(
                  //       fontFamily: 'Barlow-Regular',
                  //       fontWeight: FontWeight.w600,
                  //       fontSize:
                  //           DeviceDimensions.responsiveSize(context) * 0.055,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.025),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      "SELECT YOUR CARD",
                      style: TextStyle(
                        fontFamily: 'Barlow-Bold',
                        fontWeight: FontWeight.bold,
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.055,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.005),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      "Select your customizable cards and choose according to the options suit to your needs.",
                      style: TextStyle(
                        fontFamily: 'Barlow-Regular',
                        fontWeight: FontWeight.bold,
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.033,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.025),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 17.0),
                        child: Column(
                          children: cardDetailsProvider
                              .selectedCard.cardColorOptions
                              .map(
                                (colorOption) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      cardDetailsProvider
                                          .setSelectedColor(colorOption);
                                    },
                                    child: Container(
                                      width: DeviceDimensions.screenWidth(
                                              context) *
                                          0.16,
                                      decoration: BoxDecoration(
                                          color: cardDetailsProvider
                                                      .selectedColorOption ==
                                                  colorOption
                                              ? const Color.fromARGB(
                                                      255, 100, 100, 100)
                                                  .withOpacity(0.2)
                                              : Colors.transparent,
                                          borderRadius: cardDetailsProvider
                                                      .selectedColorOption ==
                                                  colorOption
                                              ? BorderRadius.circular(10.0)
                                              : null),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            colorOption.colorName,
                                            style: TextStyle(
                                              fontFamily: cardDetailsProvider
                                                          .selectedColorOption ==
                                                      colorOption
                                                  ? 'Barlow-Bold'
                                                  : 'Barlow-Regular',
                                              fontWeight: cardDetailsProvider
                                                          .selectedColorOption ==
                                                      colorOption
                                                  ? FontWeight.w600
                                                  : null,
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.033,
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  DeviceDimensions.screenHeight(
                                                          context) *
                                                      0.005),
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Image.asset(
                                              colorOption.colorImage,
                                              height: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Expanded(
                          child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 60.0),
                            child: SvgPicture.asset(
                              "assets/icons/cardplaceholder.svg",
                              height:
                                  DeviceDimensions.screenHeight(context) * 0.33,
                            ),
                          ),
                          Positioned(
                            right: -50,
                            bottom: 38,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: Image.asset(
                                cardDetailsProvider.filtercardImages,
                                height: DeviceDimensions.screenHeight(context) *
                                    0.23,
                                key: ValueKey<String>(
                                    cardDetailsProvider.filtercardImages),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                  SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.035,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) {
                        bool isSelected = _currentPage == index;

                        return AnimatedContainer(
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          duration: const Duration(milliseconds: 500),
                          width: isSelected ? 40 : 10,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.grey,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.020,
                  ),
                  Center(
                    child: Container(
                      height: _showDetails
                          ? DeviceDimensions.screenHeight(context) * 0.62
                          : DeviceDimensions.screenHeight(context) * 0.29,
                      width: DeviceDimensions.screenWidth(context) * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: PageView.builder(
                          itemCount: cardDetailsProvider.cards.length,
                          onPageChanged: (index) {
                            _currentPage = index;
                            cardDetailsProvider.setSelectedCard(
                                cardDetailsProvider.cards[index]);
                          },
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.020,
                                ),
                                Text(
                                  cardDetailsProvider.cards[index].cardName,
                                  style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.064,
                                    letterSpacing: 1,
                                    fontFamily: 'Barlow-Bold',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.015,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13),
                                  child: Text(
                                    cardDetailsProvider
                                        .cards[index].cardDescription,
                                    style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.037,
                                      fontFamily: 'Barlow-Regular',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 5,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.020,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showDetails = !_showDetails;
                                    });
                                  },
                                  child: Text(
                                    _showDetails
                                        ? "Hide details"
                                        : "Show details",
                                    style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.038,
                                      fontFamily: 'Barlow-Regular',
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.025,
                                ),
                                if (_showDetails)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Column(
                                      children: [
                                        _buildDetailRow(
                                          context,
                                          "Price",
                                          cardDetailsProvider
                                              .cards[index].cardPrice,
                                        ),
                                        _buildDetailRow(
                                          context,
                                          "Finishes",
                                          cardDetailsProvider
                                              .cards[index].cardFinish,
                                        ),
                                        _buildDetailRow(
                                          context,
                                          "Weight & Thickness",
                                          cardDetailsProvider
                                              .cards[index].cardWeight,
                                        ),
                                        _buildDetailRow(
                                          context,
                                          "Dimensions",
                                          cardDetailsProvider
                                              .cards[index].cardDimension,
                                        ),
                                        _buildDetailRow(
                                          context,
                                          "Printing",
                                          cardDetailsProvider
                                              .cards[index].cardPrinting,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          }),
                    ),
                  ),
                  SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.040,
                  ),
                  Center(
                    child: SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.058,
                      width: DeviceDimensions.screenWidth(context) * 0.40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/order-screen",
                              arguments: {
                                'selectedCard':
                                    cardDetailsProvider.selectedCard,
                                'selectedColorOption':
                                    cardDetailsProvider.selectedColorOption,
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Order",
                          style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.050,
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.030,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildDetailRow(BuildContext context, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: DeviceDimensions.responsiveSize(context) * 0.042,
            fontFamily: 'Barlow-Regular',
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: DeviceDimensions.responsiveSize(context) * 0.036,
            fontFamily: 'Barlow-Regular',
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    ),
  );
}

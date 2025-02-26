// ignore_for_file: dead_code, unrelated_type_equality_checks, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/card_details_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';
import 'package:provider/provider.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({super.key});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  bool _showDetails = false;
  int _currentPage = 0;
  late ScrollController _scrollController;
  String screenType = "Order NFC Card";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardProvider =
          Provider.of<CardDetailsProvider>(context, listen: false);
      cardProvider.clear();
      cardProvider.fetchCardsFromFirestore(context);
    });
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map<String, dynamic>) {
      screenType = args['screenType'] ?? "Order NFC Card";
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GlobalBackButtonHandler(
        child: Scaffold(
          backgroundColor: AppColors.screenBackground,
          body: Consumer<CardDetailsProvider>(
            builder: (context, cardDetailsProvider, child) {
              return Column(
                children: [
                  AbsherAppBar(
                    title: screenType == "NFC Cards"
                        ? "NFC Cards"
                        : "Select Your Card",
                    onLeftButtonTap: () {
                      Navigator.pop(context);
                    },
                    rightButton: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                          width: DeviceDimensions.screenWidth(context) * 0.035),
                    ),
                  ),
                  Flexible(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.010),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Text(
                                  screenType == "NFC Cards"
                                      ? "Discover Our Global Portfolio of Premium NFC Card Templates, Expertly Crafted to Represent Your Brand with Distinction"
                                      : "Select your customizable cards and choose according to the options suit to your needs.",
                                  style: TextStyle(
                                    fontFamily: 'Barlow-Regular',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColorBlue,
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.035,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.020),
                              Padding(
                                padding: const EdgeInsets.only(left: 33.0),
                                child: InkWell(
                                  onTap: cardDetailsProvider.isMoreUpEnabled
                                      ? () {
                                          cardDetailsProvider.scrollColorUp();
                                        }
                                      : null,
                                  child: SvgPicture.asset(
                                    "assets/icons/moreup.svg",
                                    height: 31,
                                    color: cardDetailsProvider.isMoreUpEnabled
                                        ? null
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 22.0),
                                    child: GestureDetector(
                                      onVerticalDragUpdate: (details) {
                                        if (details.delta.dy > 0) {
                                          cardDetailsProvider.scrollColorUp();
                                        } else if (details.delta.dy < 0) {
                                          cardDetailsProvider.scrollColorDown();
                                        }
                                      },
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        child: Column(
                                          children: cardDetailsProvider
                                              .visibleColorOptions
                                              .map(
                                                (colorOption) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 14.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      cardDetailsProvider
                                                          .setSelectedColor(
                                                              colorOption);
                                                    },
                                                    child: Container(
                                                      width: DeviceDimensions
                                                              .screenWidth(
                                                                  context) *
                                                          0.13,
                                                      decoration: BoxDecoration(
                                                          color: cardDetailsProvider
                                                                      .selectedColorOption ==
                                                                  colorOption
                                                              ? const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      100,
                                                                      100,
                                                                      100)
                                                                  .withOpacity(
                                                                      0.2)
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              cardDetailsProvider
                                                                          .selectedColorOption ==
                                                                      colorOption
                                                                  ? BorderRadius
                                                                      .circular(
                                                                          10.0)
                                                                  : null),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              9.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: AppColors
                                                                .appBlueColor,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        child: Image.network(
                                                          colorOption.url,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: SvgPicture.asset(
                                            "assets/icons/cardplaceholder.svg",
                                            height:
                                                DeviceDimensions.screenHeight(
                                                        context) *
                                                    0.33,
                                          ),
                                        ),
                                        Positioned(
                                          right: -50,
                                          bottom: 39,
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            transitionBuilder: (Widget child,
                                                Animation<double> animation) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                            child: Image.network(
                                              cardDetailsProvider
                                                  .filteredCardImages,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Icon(Icons.error),
                                              height:
                                                  DeviceDimensions.screenHeight(
                                                          context) *
                                                      0.23,
                                              key: ValueKey<String>(
                                                  cardDetailsProvider
                                                      .filteredCardImages),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 32.0),
                                child: InkWell(
                                  onTap: cardDetailsProvider.isMoreDownEnabled
                                      ? () {
                                          cardDetailsProvider.scrollColorDown();
                                        }
                                      : null,
                                  child: SvgPicture.asset(
                                    "assets/icons/more5.svg",
                                    height: 33,
                                    color: cardDetailsProvider.isMoreDownEnabled
                                        ? null
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.020),
                              Center(
                                child: Container(
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.95,
                                  height: _showDetails ? 510 : 230,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(26, 0, 0, 0)
                                            .withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(0, 1.5),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            3,
                                            (index) {
                                              bool isSelected =
                                                  _currentPage == index;

                                              return AnimatedContainer(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3.0),
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                width: isSelected ? 20 : 7,
                                                height: 7,
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? AppColors.appBlueColor
                                                      : Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: PageView.builder(
                                            itemCount: cardDetailsProvider
                                                .cards.length,
                                            onPageChanged: (index) {
                                              setState(() {
                                                _currentPage = index;
                                              });
                                              cardDetailsProvider
                                                  .setSelectedCard(
                                                cardDetailsProvider
                                                    .cards[index],
                                              );
                                            },
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  SizedBox(
                                                    height: DeviceDimensions
                                                            .screenHeight(
                                                                context) *
                                                        0.010,
                                                  ),
                                                  Text(
                                                    cardDetailsProvider
                                                        .cards[index].cardName,
                                                    style: TextStyle(
                                                      fontSize: DeviceDimensions
                                                              .responsiveSize(
                                                                  context) *
                                                          0.064,
                                                      letterSpacing: 1,
                                                      fontFamily: 'Barlow-Bold',
                                                      color: AppColors
                                                          .textColorBlue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: DeviceDimensions
                                                            .screenHeight(
                                                                context) *
                                                        0.015,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 13),
                                                    child: Text(
                                                      cardDetailsProvider
                                                          .cards[index]
                                                          .cardDescription,
                                                      style: TextStyle(
                                                        fontSize: DeviceDimensions
                                                                .responsiveSize(
                                                                    context) *
                                                            0.0345,
                                                        fontFamily:
                                                            'Barlow-Regular',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 5,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: DeviceDimensions
                                                              .screenHeight(
                                                                  context) *
                                                          0.020),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _showDetails =
                                                            !_showDetails;
                                                      });
                                                    },
                                                    child: Text(
                                                      _showDetails
                                                          ? "Hide details"
                                                          : "Show details",
                                                      style: TextStyle(
                                                        fontSize: DeviceDimensions
                                                                .responsiveSize(
                                                                    context) *
                                                            0.038,
                                                        fontFamily:
                                                            'Barlow-Regular',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: DeviceDimensions
                                                            .screenHeight(
                                                                context) *
                                                        0.020,
                                                  ),
                                                  if (_showDetails)
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 25.0),
                                                      child: Column(
                                                        children: [
                                                          _buildDetailRow(
                                                            context,
                                                            "Price",
                                                            "${cardDetailsProvider.cards[index].cardPrice.toString()}0  OMR",
                                                          ),
                                                          _buildDetailRow(
                                                            context,
                                                            "Finishes",
                                                            cardDetailsProvider
                                                                .cards[index]
                                                                .cardFinish,
                                                          ),
                                                          _buildDetailRow(
                                                            context,
                                                            "Weight & Thickness",
                                                            cardDetailsProvider
                                                                .cards[index]
                                                                .cardWeight,
                                                          ),
                                                          _buildDetailRow(
                                                            context,
                                                            "Dimensions",
                                                            cardDetailsProvider
                                                                .cards[index]
                                                                .CardDimension,
                                                          ),
                                                          _buildDetailRow(
                                                            context,
                                                            "Printing",
                                                            cardDetailsProvider
                                                                .cards[index]
                                                                .cardPrinting,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.030,
                              ),
                              screenType == "NFC Cards"
                                  ? SizedBox.shrink()
                                  : Center(
                                      child: SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.058,
                                        width: DeviceDimensions.screenWidth(
                                                context) *
                                            0.40,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, "/place-order-screen",
                                                arguments: {
                                                  'selectedCard':
                                                      cardDetailsProvider
                                                          .selectedCard,
                                                  'selectedColorOption':
                                                      cardDetailsProvider
                                                          .selectedColorOption,
                                                });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.buttonColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            "Order",
                                            style: TextStyle(
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
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
                                height: DeviceDimensions.screenHeight(context) *
                                    0.035,
                              ),
                            ],
                          ),
                        ),
                        if (cardDetailsProvider.isLoading)
                          Container(
                            color: Colors.white70,
                            child: const Center(
                              child: CardLoader(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
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
            color: AppColors.textColorBlue,
            letterSpacing: 1,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              value,
              style: TextStyle(
                fontSize: DeviceDimensions.responsiveSize(context) * 0.036,
                fontFamily: 'Barlow-Regular',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              softWrap: true,
              maxLines: 3,
            ),
          ),
        ),
      ],
    ),
  );
}

// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/order_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/screens/mainScreen.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.screenBackground,
          body: Column(
            children: [
              SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.0001,
              ),
              AbsherAppBar(
                title: 'Order Details',
                leftButton: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/mainNav-screen');
                    // Navigator.pop(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 9),
                      decoration: const BoxDecoration(
                          //color: Color(0xFFFFFFFF),
                          //shape: BoxShape.circle,
                          ),
                      child: Icon(Icons.arrow_back,
                          color: AppColors.appBlueColor)),
                ),
                rightButton: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                      width: DeviceDimensions.screenWidth(context) * 0.035),
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
              Flexible(
                child: SingleChildScrollView(
                  child: Consumer<OrderProvider>(
                    builder: (context, provider, child) {
                      return Center(
                        child: Column(
                          children: [
                            Container(
                              height:
                                  DeviceDimensions.screenHeight(context) * 0.85,
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 17),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.020),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFD9D9D9),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0,
                                                right: 7,
                                                top: 13,
                                                bottom: 10),
                                            child: SizedBox(
                                              height: 70,
                                              width: 80,
                                              child: CachedNetworkImage(
                                                  imageUrl: provider
                                                      .currentOrder!.cardImage,
                                                  placeholder: (context, url) =>
                                                      SmallThreeBounceLoader(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: DeviceDimensions.screenWidth(
                                                    context) *
                                                0.030),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.51,
                                              child: Text(
                                                "FURSA NFC Black Classic Card - Custom Embossed",
                                                style: TextStyle(
                                                  fontFamily: 'Barlow-Bold',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: DeviceDimensions
                                                          .responsiveSize(
                                                              context) *
                                                      0.039,
                                                  color:
                                                      AppColors.textColorBlue,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                            SizedBox(
                                                height: DeviceDimensions
                                                        .screenHeight(context) *
                                                    0.003),
                                            Text(
                                              "Business Card |  Classic Black",
                                              style: TextStyle(
                                                fontFamily: 'Barlow-Regular',
                                                fontWeight: FontWeight.w600,
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.036,
                                                color: const Color(0xFF727272),
                                              ),
                                            ),
                                            SizedBox(
                                                height: DeviceDimensions
                                                        .screenHeight(context) *
                                                    0.015),
                                            Text(
                                              provider.currentOrder!.orderPrice,
                                              style: TextStyle(
                                                fontFamily: 'Barlow-Bold',
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textColorBlue,
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.045,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.020),
                                    Divider(),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.020),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Order Details:",
                                        style: TextStyle(
                                          fontFamily: 'Barlow-Bold',
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              DeviceDimensions.responsiveSize(
                                                      context) *
                                                  0.050,
                                          color: AppColors.textColorBlue,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.007),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Expected Delivery Date",
                                          style: TextStyle(
                                            fontFamily: 'Barlow-Regular',
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.040,
                                            color: const Color(0xFF727272),
                                          ),
                                        ),
                                        Text(
                                          provider.currentOrder!.deliveryDate,
                                          style: TextStyle(
                                            fontFamily: 'Barlow-Bold',
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textColorBlue,
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.043,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.010),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Order ID",
                                          style: TextStyle(
                                            fontFamily: 'Barlow-Regular',
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.040,
                                            color: const Color(0xFF727272),
                                          ),
                                        ),
                                        Text(
                                          provider.currentOrder!.orderId,
                                          style: TextStyle(
                                            fontFamily: 'Barlow-Bold',
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textColorBlue,
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.043,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.030),
                                    Divider(),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.020),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Order Status:",
                                        style: TextStyle(
                                          fontFamily: 'Barlow-Bold',
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              DeviceDimensions.responsiveSize(
                                                      context) *
                                                  0.050,
                                          color: AppColors.textColorBlue,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.020),
                                    Expanded(
                                      child: ListView(
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          _orderStatusTimeline(
                                            context,
                                            title: "Order Placed",
                                            date: "July 14, 2024  |  11:33 AM",
                                            icon:
                                                "assets/icons/orderplaced.svg",
                                            isComplete: true,
                                            isFirst: true,
                                          ),
                                          _orderStatusTimeline(context,
                                              title: "In  Progress",
                                              date:
                                                  "July 15, 2024  |  08:33 PM",
                                              icon:
                                                  "assets/icons/inprogress.svg",
                                              isComplete: false),
                                          _orderStatusTimeline(context,
                                              title: "Shipped",
                                              date:
                                                  "July 16, 2024  |  01:33 AM",
                                              icon: "assets/icons/shipped.svg",
                                              isComplete: false,
                                              isBeforeLast: true),
                                          _orderStatusTimeline(context,
                                              title: "Delivered",
                                              date:
                                                  "July 17, 2024  |  12:33 AM",
                                              icon:
                                                  "assets/icons/delivered.svg",
                                              isComplete: false,
                                              isLast: true),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderStatusTimeline(
    BuildContext context, {
    required String title,
    required String date,
    required String icon,
    required bool isComplete,
    bool isFirst = false,
    bool isLast = false,
    bool isBeforeLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(
                height: isFirst
                    ? DeviceDimensions.screenHeight(context) * 0.010
                    : null),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: isComplete ? AppColors.appBlueColor : Colors.grey[300],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isComplete
                      ? AppColors.appBlueColor
                      : Colors.grey[300] ?? Colors.grey,
                  width: 2.0,
                ),
              ),
              child: Icon(
                Icons.check,
                size: 12,
                color: Colors.white,
              ),
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 50,
                color: isBeforeLast
                    ? Colors.grey[300]
                    : (isComplete ? AppColors.appBlueColor : Colors.grey[300]),
              )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Barlow-Bold',
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColorBlue,
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.050,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontFamily: 'Barlow-Regular',
                  fontWeight: FontWeight.w600,
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.040,
                  color: const Color(0xFF727272),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: SvgPicture.asset(
            icon,
            width: 28,
            color: isComplete ? AppColors.appBlueColor : Colors.grey,
          ),
        ),
      ],
    );
  }
}

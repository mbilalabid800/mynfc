// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/order_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';
import 'package:provider/provider.dart';

import '../provider/user_info_form_state_provider.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String? orderId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is String) {
      orderId = args;
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProvider.fetchOrderById(orderId);
      });
    } else {
      debugPrint("Invalid arguments passed to OrderDetails screen");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
// Ensure args is a Map before casting
    Map<String, dynamic>? arguments;
    if (args is Map<String, dynamic>) {
      arguments = args;
    }

    bool fromOrderPlacement = arguments?['fromOrderPlacement'] ?? false;

    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);
    return SafeArea(
      child: GlobalBackButtonHandler(
        child: Scaffold(
          backgroundColor: AppColors.screenBackground,
          body: Column(
            children: [
              SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.0001,
              ),
              AbsherAppBar3(
                title: 'Order Details',
                onLeftButtonTap: () {
                  // Navigator.pushNamed(context, '/order-history-screen');
                  //Navigator.pop(context);
                  // Navigator.pushNamedAndRemoveUntil(
                  //   context,
                  //   '/mainNav-screen', // Replace with your target screen
                  //   (Route<dynamic> route) =>
                  //       false, // This removes all previous routes
                  // );
                  if (fromOrderPlacement) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/mainNav-screen',
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
                rightButton: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                      width: DeviceDimensions.screenWidth(context) * 0.035),
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
              Flexible(
                child: Consumer<OrderProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: DualRingLoader(),
                      );
                    }
                    if (provider.currentOrder == null) {
                      return const Center(
                          child: Text("No order details found."));
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height:
                                DeviceDimensions.screenHeight(context) * 1.25,
                            width: DeviceDimensions.screenWidth(context) * 0.90,
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
                                              left: 7.0,
                                              right: 8,
                                              top: 2,
                                              bottom: 2),
                                          child: SizedBox(
                                            height: 70,
                                            width: 80,
                                            child: provider.currentOrder == null
                                                ? SmallThreeBounceLoader() // Show a loader or placeholder if currentOrder or cardImage is null
                                                : CachedNetworkImage(
                                                    imageUrl: provider
                                                        .currentOrder!
                                                        .cardImage,
                                                    placeholder: (context,
                                                            url) =>
                                                        SmallThreeBounceLoader(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
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
                                              provider.currentOrder!.cardName,
                                              style: TextStyle(
                                                fontFamily: 'Barlow-Bold',
                                                fontWeight: FontWeight.w500,
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.039,
                                                color: AppColors.textColorBlue,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  DeviceDimensions.screenHeight(
                                                          context) *
                                                      0.003),
                                          Text(
                                            provider.currentOrder!.cardColor,
                                            style: TextStyle(
                                              fontFamily: 'Barlow-Regular',
                                              fontWeight: FontWeight.w600,
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.036,
                                              color: const Color(0xFF727272),
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  DeviceDimensions.screenHeight(
                                                          context) *
                                                      0.015),
                                          Text(
                                            provider.currentOrder!.orderPrice,
                                            style: TextStyle(
                                              fontFamily: 'Barlow-Bold',
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textColorBlue,
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
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
                                  orderInfo(context, "Order ID:",
                                      provider.currentOrder!.orderId),
                                  orderInfo(context, "Your Name:",
                                      "${userProvider.firstName} ${userProvider.lastName}"),
                                  orderInfo(context, "Title (optional):",
                                      "Business Cards"),
                                  orderInfo(context, "Delivery Method:",
                                      provider.currentOrder!.shippingMethod),
                                  orderInfo(context, "Shipping Address:",
                                      provider.currentOrder!.address),
                                  orderInfo(context, "Payment Method:",
                                      "Cash on Delivery"),
                                  orderInfo(
                                    context,
                                    "Order Date:",
                                    provider.currentOrder!.orderStatus[0]
                                        ['updatedAt'],
                                  ),
                                  orderInfo(context, "Expected Delivery Date:",
                                      provider.currentOrder!.deliveryDate),
                                  orderInfo(
                                      context,
                                      "Total Employee:",
                                      provider.currentOrder!.cardQuantity
                                          .toString()),
                                  orderInfo(context, "Order Price:",
                                      provider.currentOrder!.orderPrice),
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
                                          date: provider.currentOrder!
                                                  .orderStatus.isNotEmpty
                                              ? provider.currentOrder!
                                                  .orderStatus[0]['updatedAt']
                                              : "Pending",
                                          icon: "assets/icons/orderplaced.svg",
                                          isComplete: provider.currentOrder!
                                              .orderStatus.isNotEmpty,
                                          isFirst: true,
                                        ),
                                        _orderStatusTimeline(
                                          context,
                                          title: "In  Progress",
                                          date: provider.currentOrder!
                                                      .orderStatus.length >
                                                  1
                                              ? provider.currentOrder!
                                                  .orderStatus[1]['updatedAt']
                                              : "Pending",
                                          icon: "assets/icons/inprogress.svg",
                                          isComplete: provider.currentOrder!
                                                  .orderStatus.length >
                                              1,
                                        ),
                                        _orderStatusTimeline(
                                          context,
                                          title: "Shipped",
                                          date: provider.currentOrder!
                                                      .orderStatus.length >
                                                  2
                                              ? provider.currentOrder!
                                                  .orderStatus[2]['updatedAt']
                                              : "Pending",
                                          icon: "assets/icons/shipped.svg",
                                          isComplete: provider.currentOrder!
                                                  .orderStatus.length >
                                              2,
                                          isBeforeLast: false,
                                        ),
                                        _orderStatusTimeline(context,
                                            title: "Delivered",
                                            date: provider.currentOrder!
                                                        .orderStatus.length >
                                                    3
                                                ? provider.currentOrder!
                                                    .orderStatus[3]['updatedAt']
                                                : "Pending",
                                            icon: "assets/icons/delivered.svg",
                                            isComplete: provider.currentOrder!
                                                    .orderStatus.length >
                                                3,
                                            isLast: true),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding orderInfo(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Barlow-Regular',
              fontWeight: FontWeight.w600,
              color: AppColors.textColorBlue,
              fontSize: DeviceDimensions.responsiveSize(context) * 0.039,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Barlow-Regular',
                fontWeight: FontWeight.w500,
                fontSize: DeviceDimensions.responsiveSize(context) * 0.035,
              ),
              maxLines: 3,
              softWrap: true,
            ),
          ),
        ],
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

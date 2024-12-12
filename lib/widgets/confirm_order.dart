// ignore_for_file: use_build_context_synchronously
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/card_details_model.dart';
import 'package:nfc_app/models/order_model.dart';
import 'package:nfc_app/models/shipping_address_model.dart';
import 'package:nfc_app/provider/employee_provider.dart';
import 'package:nfc_app/provider/order_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/firestore_service/card_pictures_links.dart';
import 'package:nfc_app/widgets/custom_loader_widget.dart';
import 'package:nfc_app/widgets/custom_snackbar_widget.dart';
import 'package:nfc_app/widgets/payment_successful.dart';
import 'package:provider/provider.dart';

class ConfirmOrder {
  const ConfirmOrder();
  String generateOrderId() {
    var randno = Random();
    int randonPart = randno.nextInt(200000) + 100000;
    int timestampPart = DateTime.now().millisecondsSinceEpoch % 1000000000;
    return '$timestampPart$randonPart';
  }

  void showConfirmOrderDialog(
      BuildContext context,
      int employeeCount,
      CardDetailsModel selectedCard,
      CardColorOption selectedColorOption,
      int colorIndex,
      String shippingMethod,
      ShippingAddressModel shippingDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            color: AppColors.appBlueColor,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              child: SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.43,
                width: DeviceDimensions.screenWidth(context) * 0.85,
                child: Column(
                  children: [
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.030),
                    SvgPicture.asset("assets/icons/confirmorder.svg"),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.010),
                    Text(
                      "Confirm Your Order",
                      style: TextStyle(
                        fontFamily: 'Barlow-Bold',
                        fontWeight: FontWeight.w600,
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.050,
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.002),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Are you ready to confirm  your order and payment or cancel it.",
                        style: TextStyle(
                          fontFamily: 'Barlow-Regular',
                          fontWeight: FontWeight.w500,
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.036,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.030),
                    SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.048,
                      width: DeviceDimensions.screenWidth(context) * 0.62,
                      child: ElevatedButton(
                        onPressed: () {
                          String orderId = generateOrderId();
                          // PaymentSuccessful()
                          //     .showPaymentSuccessfulDialog(context, orderId);
                          orderPlaced(
                              context,
                              employeeCount,
                              orderId,
                              selectedCard,
                              selectedColorOption,
                              colorIndex,
                              shippingMethod,
                              shippingDetails);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          "Yes, Confirm & Pay",
                          style: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.040,
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                    SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.048,
                      width: DeviceDimensions.screenWidth(context) * 0.62,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                                color: AppColors.appBlueColor, width: 1),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            "No, Cancel",
                            style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.040,
                              fontFamily: 'Barlow-Regular',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: AppColors.textColorBlue,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> orderPlaced(
      BuildContext context,
      int employeeCount,
      String orderId,
      CardDetailsModel selectedCard,
      CardColorOption selectedColorOption,
      int colorIndex,
      String shippingMethod,
      ShippingAddressModel shippingDetails) async {
    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);
    String orderDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String deliveryDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 7)));

    CardPicturesLinks cardLink = CardPicturesLinks();
    String makeCardLink =
        "${selectedCard.cardName}_${selectedColorOption.colorName}"
            .toLowerCase();
    String cardImageUrl = cardLink.getCardUrl(makeCardLink);

    OrderModel newOrder = OrderModel(
        orderId: orderId,
        orderPrice: "${selectedCard.cardPrice * employeeCount}0 OMR",
        orderStatus: "Pending",
        shippingMethod: shippingMethod,
        orderHistory: "active",
        address:
            "${shippingDetails.streetAddress} ${shippingDetails.city} ${shippingDetails.state} ${shippingDetails.country}",
        deliveryDate: deliveryDate,
        orderDateTime: orderDate,
        cardName: selectedCard.cardName,
        cardColor: selectedColorOption.colorName,
        cardImage: cardImageUrl,
        cardQuantity: employeeCount,
        userEmail: userProvider.email,
        userUid: userProvider.uid);

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: OrderLoader(),
          );
        });

    await Future.delayed(Duration(seconds: 3));
    try {
      await orderProvider.placeOrder(newOrder);
      await Provider.of<EmployeeProvider>(context, listen: false)
          .saveEmployeesToFirestore();
      PaymentSuccessful().showPaymentSuccessfulDialog(context, orderId);
    } catch (e) {
      CustomSnackbar()
          .snakBarError(context, 'Failed to place order. Please try again.');
    }
  }
}

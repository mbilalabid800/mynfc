// ignore_for_file: use_build_context_synchronously
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
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:nfc_app/shared/utils/order_id.dart';
import 'package:nfc_app/widgets/payment_successful.dart';
import 'package:provider/provider.dart';

class ConfirmOrder {
  const ConfirmOrder();
  void showConfirmOrderDialog(
      BuildContext context,
      int employeeCount,
      CardDetailsModel selectedCard,
      CardColorOption selectedColorOption,
      int colorIndex,
      String shippingMethod,
      ShippingAddressModel shippingDetails,
      String selectedPlan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            color: Colors.black54,
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
                        color: AppColors.textColorBlue,
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.050,
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.002),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Are you ready to confirm  your order ?",
                        style: TextStyle(
                          fontFamily: 'Barlow-Regular',
                          fontWeight: FontWeight.w500,
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.036,
                          color: AppColors.textColorBlue,
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
                        onPressed: () async {
                          String orderId = await generateOrderId();
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
                              shippingDetails,
                              selectedPlan);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          "Yes, Confirm",
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
      ShippingAddressModel shippingDetails,
      String selectedPlan) async {
    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);
    String orderDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    String deliveryDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().add(const Duration(days: 7)));

    // CardPicturesLinks cardLink = CardPicturesLinks();
    // String makeCardLink =
    //     "${selectedCard.cardName}_${selectedColorOption.type}".toLowerCase();
    // String cardImageUrl = cardLink.getCardUrl(makeCardLink);

    OrderModel newOrder = OrderModel(
        orderId: orderId,
        orderPrice: "${selectedCard.cardPrice * employeeCount + 2}0 OMR",
        orderStatus: "Pending",
        shippingMethod: shippingMethod,
        orderHistory: "active",
        selectedPlan: selectedPlan,
        address:
            "${shippingDetails.streetAddress} ${shippingDetails.city} ${shippingDetails.state} ${shippingDetails.country}",
        deliveryDate: deliveryDate,
        orderDateTime: orderDate,
        cardName: selectedCard.cardName,
        cardColor: selectedColorOption.type,
        cardImage: selectedCard.cardImages.first,
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

    await Future.delayed(const Duration(seconds: 3));
    try {
      await orderProvider.placeOrder(newOrder);
      Provider.of<UserInfoFormStateProvider>(context, listen: false)
          .updateIsCardOrdered(true);
      await Provider.of<EmployeeProvider>(context, listen: false)
          .saveEmployeesToFirestore();
      PaymentSuccessful().showPaymentSuccessfulDialog(context, orderId);
    } catch (e) {
      CustomSnackbar()
          .snakBarError(context, 'Failed to place order. Please try again.');
    }
  }
}

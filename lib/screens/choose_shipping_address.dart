import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/shipping_address_model.dart';
import 'package:nfc_app/provider/shipping_address_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';
import 'package:provider/provider.dart';

class ChooseShippingAddress extends StatelessWidget {
  const ChooseShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar(
              title: 'Shipping Address',
              onLeftButtonTap: () {
                Navigator.pop(context);
              },
              rightButton: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.035),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            Flexible(
              child: Center(
                child: Consumer<ShippingAddressProvider>(
                  builder: (context, provider, child) {
                    bool isLoading = provider.isLoading;
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: provider.shippingAddress.length,
                                itemBuilder: (context, index) {
                                  final address =
                                      provider.shippingAddress[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        provider.updateShippingAddress(address);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            width: 1.5,
                                            color:
                                                provider.selectedShippingAddress ==
                                                        address
                                                    ? AppColors.appBlueColor
                                                    : const Color(0xFFD7D9DD),
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Row(
                                            children: [
                                              Radio(
                                                activeColor:
                                                    AppColors.appBlueColor,
                                                value: address,
                                                groupValue: provider
                                                    .selectedShippingAddress,
                                                onChanged:
                                                    (ShippingAddressModel?
                                                        value) {
                                                  if (value != null) {
                                                    provider
                                                        .updateShippingAddress(
                                                            value);
                                                  }
                                                },
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        address.locationName,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Barlow-Regular',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: DeviceDimensions
                                                                  .responsiveSize(
                                                                      context) *
                                                              0.047,
                                                        ),
                                                      ),
                                                      LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          return ConstrainedBox(
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxWidth:
                                                                        constraints
                                                                            .maxWidth),
                                                            child: Text(
                                                              address
                                                                  .streetAddress,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Barlow-Regular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: DeviceDimensions
                                                                        .responsiveSize(
                                                                            context) *
                                                                    0.037,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              softWrap: true,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      "/add-shipping-address",
                                                      arguments: provider
                                                              .shippingAddress[
                                                          index]);
                                                },
                                                child: SvgPicture.asset(
                                                    "assets/icons/editfield.svg",
                                                    height: 23,
                                                    color:
                                                        AppColors.appBlueColor),
                                              ),
                                              SizedBox(
                                                  width: DeviceDimensions
                                                          .screenWidth(
                                                              context) *
                                                      0.025),
                                              GestureDetector(
                                                onTap: () {
                                                  provider
                                                      .deleteShippingAddress(
                                                          address);
                                                },
                                                child: const Icon(
                                                    Icons
                                                        .delete_outline_outlined,
                                                    size: 28,
                                                    color:
                                                        AppColors.appBlueColor),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.020),
                            SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.057,
                              width:
                                  DeviceDimensions.screenWidth(context) * 0.80,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "/add-shipping-address");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/location.svg",
                                      height: 20,
                                      // ignore: deprecated_member_use
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                        width: DeviceDimensions.screenWidth(
                                                context) *
                                            0.020),
                                    Text(
                                      "Add New Address",
                                      style: TextStyle(
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.042,
                                        fontFamily: 'Barlow-Regular',
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.025)
                          ],
                        ),
                        if (isLoading)
                          Container(
                            color: Colors.white54,
                            child: const Center(
                              child: DualRingLoader(),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

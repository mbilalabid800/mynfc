import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';

class CompletedOrdersWidget extends StatefulWidget {
  const CompletedOrdersWidget({super.key});

  @override
  State<CompletedOrdersWidget> createState() => _CompletedOrdersWidgetState();
}

class _CompletedOrdersWidgetState extends State<CompletedOrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.green,
      ),
      child: Column(
        children: [
          Container(
            color: Colors.amber,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6),
                    child: SizedBox(
                      height: 70,
                      width: 80,
                      child: SvgPicture.asset('assets/icons/order_card.svg',
                          height: 20),
                    ),
                  ),
                ),
                SizedBox(width: DeviceDimensions.screenWidth(context) * 0.030),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.51,
                      child: Text(
                        "FURSA NFC Black Classic Card - Custom Embossed",
                        style: TextStyle(
                          fontFamily: 'Barlow-Bold',
                          fontWeight: FontWeight.w500,
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.038,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                    Row(
                      children: [
                        Text(
                          "Price:",
                          style: TextStyle(
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w600,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.042,
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                            width:
                                DeviceDimensions.screenWidth(context) * 0.085),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text('xxx'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6),
                    child: SizedBox(
                      height: 70,
                      width: 80,
                      child: SvgPicture.asset('assets/icons/order_card.svg',
                          height: 20),
                    ),
                  ),
                ),
                SizedBox(width: DeviceDimensions.screenWidth(context) * 0.030),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.51,
                      child: Text(
                        "FURSA NFC Black Classic Card - Custom Embossed",
                        style: TextStyle(
                          fontFamily: 'Barlow-Bold',
                          fontWeight: FontWeight.w500,
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.038,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.020),
                    Row(
                      children: [
                        Text(
                          "Price:",
                          style: TextStyle(
                            fontFamily: 'Barlow-Regular',
                            fontWeight: FontWeight.w600,
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.042,
                          ),
                        ),
                        SizedBox(
                            width:
                                DeviceDimensions.screenWidth(context) * 0.085),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text('xxx'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}

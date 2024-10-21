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
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: DeviceDimensions.screenHeight(context) * 0.14,
                  width: DeviceDimensions.screenWidth(context) * 0.85,
                  //decoration: BoxDecoration(),
                  //color: Colors.yellow,
                  child: Row(
                    children: [
                      Container(
                          color: Colors.grey,
                          height: DeviceDimensions.screenHeight(context) * 0.1,
                          width: DeviceDimensions.screenWidth(context) * 0.3),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: DeviceDimensions.screenWidth(context) * 0.53,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'FURSA NFC Black Classic Card -Custom Embossed names',
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Text('OMR 57.00'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Container(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.032,
                                    width:
                                        DeviceDimensions.screenWidth(context) *
                                            0.25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.black),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Center(
                                        child: Text('Review',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.030)),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

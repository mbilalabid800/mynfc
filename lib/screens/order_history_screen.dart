// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/order_model.dart';
import 'package:nfc_app/provider/order_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    //Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    // Fetch orders after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: CustomAppBarTwo(
          title: 'Order History',
          tabController: _tabController,
        ),
        body: Column(
          children: [
            // SizedBox(
            //   height: DeviceDimensions.screenHeight(context) * 0.0001,
            // ),
            // AbsherAppBar(title: 'Choose Machine'),
            // SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, orderProvider, _) {
                  if (orderProvider.isLoading) {
                    return const Center(child: SmallThreeBounceLoader());
                  }
                  if (orderProvider.orders.isEmpty) {
                    return const Center(child: Text('No order found.'));
                  }
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrderList(orderProvider.orders, 'active'),
                      _buildOrderList(orderProvider.orders, 'completed'),
                      _buildOrderList(orderProvider.orders, 'cancelled'),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build the list of orders based on status
  Widget _buildOrderList(List<OrderModel> orders, String orderHistory) {
    final filteredOrders = orders.where((order) {
      return order.orderHistory ==
          orderHistory; // Compare with the passed orderHistory
    }).toList();

    filteredOrders.sort((a, b) => b.orderDateTime.compareTo(a.orderDateTime));
    if (filteredOrders.isEmpty) {
      debugPrint('No $orderHistory orders found for');

      return Center(child: Text('No $orderHistory orders found.'));
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
          child: Container(
            width: DeviceDimensions.screenWidth(context) * 0.7,
            //height: DeviceDimensions.screenHeight(context) * 0.12,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.appBlueColor),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            // child: ListTile(
            //   leading: SizedBox(
            //       width: DeviceDimensions.responsiveSize(context) * 0.26,
            //       height: DeviceDimensions.responsiveSize(context) * 0.28,
            //       child: order.cardImage != null
            //           ? Align(
            //               alignment: Alignment.centerLeft,
            //               child: Image.network(
            //                 order.cardImage,
            //                 // width:
            //                 //     DeviceDimensions.responsiveSize(context) * 0.1,
            //                 // height:
            //                 //     DeviceDimensions.responsiveSize(context) * 0.1,
            //                 // fit: BoxFit.fitWidth,
            //               ),
            //             )
            //           : SmallThreeBounceLoader()),
            // )
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/order-details',
                    arguments: order.orderId);
              },
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Order No. ',
                                style: TextStyle(
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.038,
                                ),
                              ),
                              TextSpan(
                                text: order.orderId.toString(),
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold, // Make "Status:" bold
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.038,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(order.orderDateTime,
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.030)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width:
                              DeviceDimensions.responsiveSize(context) * 0.22,
                          height:
                              DeviceDimensions.responsiveSize(context) * 0.24,
                          child: Image.network(order.cardImage),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Name: ',
                                      style: TextStyle(
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.032,
                                      ),
                                    ),
                                    TextSpan(
                                      text: order.cardName.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold, // Make "Status:" bold
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.032,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Color: ',
                                      style: TextStyle(
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.032,
                                      ),
                                    ),
                                    TextSpan(
                                      text: order.cardColor.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold, // Make "Status:" bold
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.032,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Price: ',
                                      style: TextStyle(
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.032,
                                      ),
                                    ),
                                    TextSpan(
                                      text: order.orderPrice.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold, // Make "Status:" bold
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.032,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Status: ',
                                  style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.03,
                                  ),
                                ),
                                TextSpan(
                                  text: order.orderStatus.toString(),
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold, // Make "Status:" bold
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.03,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ), // Handle null case for orderId

                // trailing: Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(top: 16.0),
                //       child: GestureDetector(
                //         onTap: () {
                //           Navigator.pushNamed(context, '/order-details',
                //               arguments: order.orderId);
                //         },
                //         child: Container(
                //           width: DeviceDimensions.screenWidth(context) * 0.2,
                //           height: DeviceDimensions.screenHeight(context) * 0.04,
                //           decoration: BoxDecoration(
                //               border: Border.all(color: AppColors.appOrangeColor),
                //               borderRadius: BorderRadius.circular(12),
                //               color: AppColors.appOrangeColor),
                //           child: Center(
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text('Track',
                //                   textAlign: TextAlign.right,
                //                   style: TextStyle(
                //                       fontSize: DeviceDimensions.responsiveSize(
                //                               context) *
                //                           0.03,
                //                       color: Colors.white)),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     // Text('Status: ${order.orderHistory}',
                //     //     style: TextStyle(
                //     //         fontSize: DeviceDimensions.responsiveSize(context) *
                //     //             0.026)),
                //   ],
                // ), // Handle null case for orderHistory
              ),
            ),
          ),
        );
      },
    );
  }
}

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
                    return const Center(child: CircularProgressIndicator());
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
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('Order ID: ${order.orderId}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.038)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: DeviceDimensions.responsiveSize(context) * 0.22,
                        height: DeviceDimensions.responsiveSize(context) * 0.24,
                        child: Image.asset('assets/images/dummycard.png'),
                      ),
                      // child: order.cardImage != null
                      //     ? Image.network(
                      //         order.cardImage,
                      //         width:
                      //             DeviceDimensions.responsiveSize(context) *
                      //                 0.1,
                      //         height:
                      //             DeviceDimensions.responsiveSize(context) *
                      //                 0.1,
                      //         fit: BoxFit.fitWidth,
                      //       )
                      //     : SmallThreeBounceLoader()),
                      //Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(' Name : ${order.cardName}',
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.035)),
                            Text(' Price : ${order.orderPrice.toString()}',
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.03)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ), // Handle null case for orderId

              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/order-details');
                      },
                      child: Container(
                        width: DeviceDimensions.screenWidth(context) * 0.2,
                        height: DeviceDimensions.screenHeight(context) * 0.04,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.appOrangeColor),
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.appOrangeColor),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Track',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.03,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Text('Status: ${order.orderHistory}',
                  //     style: TextStyle(
                  //         fontSize: DeviceDimensions.responsiveSize(context) *
                  //             0.026)),
                ],
              ), // Handle null case for orderHistory
            ),
          ),
        );
      },
    );
  }
}

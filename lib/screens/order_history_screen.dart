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
    Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: CustomAppBarTwo(
        title: 'Order History',
        tabController: _tabController,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, orderProvider, _) {
                  if (orderProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (orderProvider.orders.isEmpty) {
                    return const Center(child: Text('No orders found.'));
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: DeviceDimensions.responsiveSize(context) * 0.15,
                      height: DeviceDimensions.responsiveSize(context) * 0.16,
                      child: order.cardImage != null
                          ? Image.network(
                              order.cardImage,
                              width: DeviceDimensions.responsiveSize(context) *
                                  0.1,
                              height: DeviceDimensions.responsiveSize(context) *
                                  0.1,
                              fit: BoxFit.fitWidth,
                            )
                          : SmallThreeBounceLoader()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('Name: ${order.cardName}',
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.035)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('Order ID: ${order.orderId}',
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.022)),
                      ),
                    ],
                  ),
                ],
              ), // Handle null case for orderId

              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(' Amount ${order.orderPrice.toString()}',
                      style: TextStyle(
                          fontSize: DeviceDimensions.responsiveSize(context) *
                              0.026)),
                  Text('Status: ${order.orderHistory}',
                      style: TextStyle(
                          fontSize: DeviceDimensions.responsiveSize(context) *
                              0.026)),
                ],
              ), // Handle null case for orderHistory
            ),
          ),
        );
      },
    );
  }
}

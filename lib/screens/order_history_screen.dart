import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/order_model.dart';
import 'package:nfc_app/provider/order_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/active_orders_widget.dart';
import 'package:nfc_app/widgets/cancelled_orders_widget.dart';
import 'package:nfc_app/widgets/completed_orders_widget.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';
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
      return order.orderHistory != null &&
          order.orderHistory ==
              orderHistory; // Compare with the passed orderHistory
    }).toList();

    if (filteredOrders.isEmpty) {
      return Center(child: Text('No $orderHistory orders found.'));
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return SizedBox(
          child: Card(
            color: Colors.white,
            child: ListTile(
              title: Text(
                  'Order ID: ${order.cardName ?? "Unknown"}'), // Handle null case for orderId
              subtitle: Text(
                  'Total Amount: \$${order.orderPrice?.toString() ?? "0.00"}'), // Handle null case for orderPrice
              trailing: Column(
                children: [
                  Text(
                      'Total Amount ${order.orderPrice?.toString() ?? "0.00"}'),
                  Text('Status: ${order.orderHistory ?? "Unknown"}'),
                ],
              ), // Handle null case for orderHistory
            ),
          ),
        );
      },
    );
  }
}

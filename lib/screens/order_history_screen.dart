import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/order_model.dart';
import 'package:nfc_app/provider/order_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/active_orders_widget.dart';
import 'package:nfc_app/widgets/cancelled_orders_widget.dart';
import 'package:nfc_app/widgets/completed_orders_widget.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';
import 'package:provider/provider.dart'; //test

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: DeviceDimensions.screenHeight(context),
                    width: DeviceDimensions.screenWidth(context) * 0.95,
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
                          _buildOrderList(orderProvider.orders, 'cancelled')
                          // Padding(
                          //   padding: const EdgeInsets.all(6.0),
                          //   child: ActiveOrdersWidget(),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(6.0),
                          //   child: CompletedOrdersWidget(),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(6.0),
                          //   child: CancelledOrdersWidget(),
                          //),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(
                height: DeviceDimensions.screenHeight(context) * 0.02,
              )
            ],
          ),
        ),
      ),
    );
  }

// Helper function to build the list of orders based on status
  Widget _buildOrderList(List<OrderModel> orders, String orderHistory) {
    final filteredOrders = orders.where((order) {
      return order.orderHistory == 'active';
    }).toList();

    if (filteredOrders.isEmpty) {
      return Center(child: Text('No $orderHistory orders found.'));
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return ListTile(
          title: Text('Order ID: ${order.orderId}'),
          subtitle: Text('Total Amount: \$${order.orderPrice}'),
          trailing: Text('Status: ${order.orderHistory}'),
        );
      },
    );
  }
}

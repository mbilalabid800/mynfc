import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/order_model.dart';
import 'package:nfc_app/provider/order_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
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

    // Fetch orders when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider =
          Provider.of<UserInfoFormStateProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.fetchOrders(userProvider.uid); // Fetch orders by user UID
    });
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
                      if (orderProvider.userOrders.isEmpty) {
                        return const Center(child: Text('No orders found.'));
                      }
                      return TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOrderList(orderProvider.userOrders, 'active'),
                          _buildOrderList(
                              orderProvider.userOrders, 'completed'),
                          _buildOrderList(
                              orderProvider.userOrders, 'cancelled'),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: DeviceDimensions.screenHeight(context) * 0.02)
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build the list of orders based on status
  Widget _buildOrderList(List<OrderModel> orders, String orderStatus) {
    final filteredOrders = orders.where((order) {
      return order.orderHistory == orderStatus;
    }).toList();

    if (filteredOrders.isEmpty) {
      return Center(child: Text('No $orderStatus orders found.'));
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return ListTile(
          title: Text('Order ID: ${order.orderId}'),
          subtitle: Text('Total Amount: ${order.orderPrice}'),
          trailing: Text('Status: ${order.orderHistory}'),
        );
      },
    );
  }
}

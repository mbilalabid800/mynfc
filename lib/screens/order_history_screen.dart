import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/active_orders_widget.dart';
import 'package:nfc_app/widgets/cancelled_orders_widget.dart';
import 'package:nfc_app/widgets/completed_orders_widget.dart';

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
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Order History'),
        ),
        centerTitle: true,
        backgroundColor: AppColors.screenBackground,
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(DeviceDimensions.responsiveSize(context) * 0.15),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.black,
            labelColor: const Color(0xFF202020),
            labelStyle: TextStyle(
              fontSize: DeviceDimensions.responsiveSize(context) * 0.038,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            unselectedLabelColor: const Color(0xFF727272),
            unselectedLabelStyle: TextStyle(
              fontSize: DeviceDimensions.responsiveSize(context) * 0.038,
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
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
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ActiveOrdersWidget(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CompletedOrdersWidget(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CancelledOrdersWidget(),
                        ),
                      ],
                    ),
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
}

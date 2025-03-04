import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/models/card_details_model.dart';
import 'package:nfc_app/models/shipping_address_model.dart';
import 'package:nfc_app/provider/employee_provider.dart';
import 'package:nfc_app/provider/shipping_address_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/firestore_service/firestore_service.dart';
import 'package:nfc_app/widgets/confirm_order.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  bool _showDetails = false;
  String? planNameDb; // Holds the fetched plan

  @override
  void initState() {
    super.initState();
    loadPlan();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final orderProvider =
          Provider.of<ShippingAddressProvider>(context, listen: false);
      orderProvider.loadShippingAddress();
      Provider.of<EmployeeProvider>(context, listen: false).employeesLocal;
    });
  }

  Future<void> loadPlan() async {
    String? plan = await FirestoreService.fetchSelectedPlan();
    if (mounted) {
      setState(() {
        planNameDb = plan;
      });
    }
  }

  /// Function to fetch the selected plan from Firestore
  // Future<void> fetchSelectedPlan() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     try {
  //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.uid)
  //           .get();

  //       if (userDoc.exists) {
  //         setState(() {
  //           planNameDb = userDoc['planName'] ?? "No Plan Selected";
  //         });
  //       }
  //     } catch (e) {
  //       debugPrint("Error fetching plan: $e");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final CardDetailsModel selectedCard = args['selectedCard'];
    final CardColorOption selectedColorOption = args['selectedColorOption'];
    final colorIndex =
        selectedCard.cardColorOptions.indexOf(selectedColorOption);
    final userProvider =
        Provider.of<UserInfoFormStateProvider>(context, listen: false);
    String orderDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String deliveryDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().add(const Duration(days: 7)));
    String selectedPlan = 'Freee';
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    int employeeCount = employeeProvider.employeesLocal.length;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar3(
              title: 'Order',
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
              child: SingleChildScrollView(
                child: Consumer<ShippingAddressProvider>(
                    builder: (context, provider, child) {
                  return Center(
                    child: Column(
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid ??
                                  "") // Get logged-in user ID
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.data == null ||
                                !snapshot.data!.exists) {
                              return _buildNoPlanContainer();
                            }

                            String planNameDb = snapshot.data?['planName'] ??
                                "No Plan Selected";

                            if (planNameDb == "No Plan Selected") {
                              return _buildNoPlanContainer();
                            } else {
                              return _buildSelectedPlanContainer(planNameDb);
                            }
                          },
                        ),

                        userProvider.profileType == "Business"
                            ? SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.025)
                            : SizedBox.shrink(),
                        userProvider.profileType == "Business"
                            ? Container(
                                width: DeviceDimensions.screenWidth(context) *
                                    0.90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: employeeCount == 0
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 17),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Add Employees",
                                                style: TextStyle(
                                                    fontFamily: 'Barlow-Bold',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: DeviceDimensions
                                                            .responsiveSize(
                                                                context) *
                                                        0.055,
                                                    color: AppColors
                                                        .textColorBlue),
                                              ),
                                            ),
                                            SizedBox(
                                                height: DeviceDimensions
                                                        .screenHeight(context) *
                                                    0.005),
                                            Text(
                                              "Add your employees according to your plan and manage your team seamlessly.",
                                              style: TextStyle(
                                                fontFamily: 'Barlow-Regular',
                                                fontWeight: FontWeight.w600,
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.033,
                                                color: const Color(0xFF727272),
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            Divider(),
                                            SizedBox(height: 2),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  "/add-employees",
                                                  arguments: {
                                                    'selectedCard':
                                                        selectedCard,
                                                    'selectedColorOption':
                                                        selectedColorOption,
                                                  },
                                                );
                                              },
                                              child: Text(
                                                "Add Employees",
                                                style: TextStyle(
                                                  fontFamily: 'Barlow-Regular',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: DeviceDimensions
                                                          .responsiveSize(
                                                              context) *
                                                      0.040,
                                                  color:
                                                      AppColors.textColorBlue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 17),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.black12,
                                                  child: Icon(
                                                    Icons.people,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "$employeeCount employees",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Barlow-Regular',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: DeviceDimensions
                                                                      .responsiveSize(
                                                                          context) *
                                                                  0.045,
                                                              color: AppColors
                                                                  .textColorBlue,
                                                            ),
                                                          ),
                                                          Text(
                                                            "$employeeCount  *  ${selectedCard.cardPrice} OMR",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Barlow-Regular',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: DeviceDimensions
                                                                      .responsiveSize(
                                                                          context) *
                                                                  0.045,
                                                              color: AppColors
                                                                  .textColorBlue,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Team",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Barlow-Bold',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: DeviceDimensions
                                                                      .responsiveSize(
                                                                          context) *
                                                                  0.045,
                                                              color: AppColors
                                                                  .textColorBlue,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${employeeCount * selectedCard.cardPrice} OMR",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Barlow-Regular',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: DeviceDimensions
                                                                      .responsiveSize(
                                                                          context) *
                                                                  0.045,
                                                              color: AppColors
                                                                  .textColorBlue,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: DeviceDimensions
                                                        .screenHeight(context) *
                                                    0.005),
                                            Divider(),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  "/add-employees",
                                                  arguments: {
                                                    'selectedCard':
                                                        selectedCard,
                                                    'selectedColorOption':
                                                        selectedColorOption,
                                                  },
                                                );
                                              },
                                              child: Text(
                                                "Add more",
                                                style: TextStyle(
                                                  fontFamily: 'Barlow-Regular',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: DeviceDimensions
                                                          .responsiveSize(
                                                              context) *
                                                      0.040,
                                                  color:
                                                      AppColors.textColorBlue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.025),

                        Container(
                          width: DeviceDimensions.screenWidth(context) * 0.90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 17),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Delivery Method",
                                    style: TextStyle(
                                        fontFamily: 'Barlow-Bold',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.055,
                                        color: AppColors.textColorBlue),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.005),
                                Text(
                                  "Add your shippment method as per your ease and choose whether deliver to machine nearby or delivery at doorstep.",
                                  style: TextStyle(
                                    fontFamily: 'Barlow-Regular',
                                    fontWeight: FontWeight.w600,
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.033,
                                    color: const Color(0xFF727272),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.025),
                                Column(
                                  children: [
                                    // deliveryMethod(context,
                                    //     'Pick from nearby machine', provider),
                                    // SizedBox(
                                    //     height:
                                    //         DeviceDimensions.screenHeight(context) *
                                    //             0.015),
                                    deliveryMethod(
                                        context,
                                        'Deliver to shipping address',
                                        provider),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.015),
                              ],
                            ),
                          ),
                        ),
                        if (provider.selectedMethod ==
                            'Deliver to shipping address')
                          Padding(
                            padding: EdgeInsets.only(
                                top: DeviceDimensions.screenHeight(context) *
                                    0.020),
                            child: deliveryAddressContainer(context),
                          ),
                        // else if (provider.selectedMethod ==
                        //     'Pick from nearby machine')
                        //comment out if the pick up from machine is required
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //       top: DeviceDimensions.screenHeight(context) * 0.020),
                        //   child: chooseMachineContainer(context),
                        // ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.025),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: DeviceDimensions.screenWidth(context) * 0.90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 17),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Order Summary",
                                      style: TextStyle(
                                        fontFamily: 'Barlow-Bold',
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textColorBlue,
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.055,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (_showDetails)
                                      Padding(
                                        padding: const EdgeInsets.only(),
                                        child: SvgPicture.asset(
                                          "assets/icons/more5.svg",
                                          height: 23,
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: SvgPicture.asset(
                                          "assets/icons/more.svg",
                                          height: 15,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.010),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFD9D9D9),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.0, right: 6, top: 1),
                                        child: SizedBox(
                                          height: 70,
                                          width: 80,
                                          child: Image.network(
                                            selectedCard.cardImages[colorIndex],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: DeviceDimensions.screenWidth(
                                                context) *
                                            0.030),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.51,
                                          child: Text(
                                            selectedCard.cardName,
                                            style: TextStyle(
                                              fontFamily: 'Barlow-Bold',
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textColorBlue,
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.038,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                DeviceDimensions.screenHeight(
                                                        context) *
                                                    0.020),
                                        Row(
                                          children: [
                                            Text(
                                              "Price:",
                                              style: TextStyle(
                                                fontFamily: 'Barlow-Regular',
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textColorBlue,
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.042,
                                              ),
                                            ),
                                            SizedBox(
                                                width: DeviceDimensions
                                                        .screenWidth(context) *
                                                    0.085),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFD9D9D9),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                child: Text(
                                                  "${selectedCard.cardPrice}0  OMR",
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textColorBlue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.030,
                                ),
                                if (provider.selectedMethod.isNotEmpty) ...[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showDetails = !_showDetails;
                                      });
                                    },
                                    child: Text(
                                      _showDetails
                                          ? "Hide order details"
                                          : "Show order details",
                                      style: TextStyle(
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.038,
                                        fontFamily: 'Barlow-Regular',
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                                if (_showDetails) ...[
                                  SizedBox(
                                      height: DeviceDimensions.screenHeight(
                                              context) *
                                          0.020),
                                  orderInfo(context, "Your Name:",
                                      "${userProvider.firstName} ${userProvider.lastName}"),
                                  orderInfo(context, "Title (optional):",
                                      "Business Cards"),
                                  orderInfo(context, "Delivery Method:",
                                      provider.selectedMethod),
                                  orderInfo(context, "Payment Method:",
                                      "Cash on Delivery"),
                                  orderInfo(context, "Order Date:", orderDate),
                                  orderInfo(context, "Expected Delivery Date:",
                                      deliveryDate),
                                  Divider(),
                                  orderInfo(
                                    context,
                                    "Subtotal:",
                                    "${selectedCard.cardPrice * (employeeCount == 0 ? 1 : employeeCount)}0 OMR",
                                  ),
                                  orderInfo(
                                      context, "Shipping Charges", "2.00  OMR"),
                                  orderInfo(context, "Total:",
                                      "${selectedCard.cardPrice * (employeeCount == 0 ? 1 : employeeCount) + 2}0  OMR"),
                                ]
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.045),
                        SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.058,
                          width: DeviceDimensions.screenWidth(context) * 0.85,
                          child: ElevatedButton(
                            onPressed: provider.selectedMethod.isEmpty ||
                                    employeeCount == 0
                                ? null
                                : () {
                                    ConfirmOrder confirmOrder =
                                        const ConfirmOrder();
                                    ShippingAddressModel? shippingDetails;

                                    if (provider.selectedMethod ==
                                        'Deliver to shipping address') {
                                      shippingDetails =
                                          provider.selectedShippingAddress;
                                    } else if (provider.selectedMethod ==
                                        'Pick from nearby machine') {
                                      shippingDetails = shippingDetails =
                                          provider.selectedShippingAddress;
                                    }
                                    // final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                                    //  String selectedPlan = orderProvider.selectedPlan;

                                    confirmOrder.showConfirmOrderDialog(
                                        context,
                                        employeeCount,
                                        selectedCard,
                                        selectedColorOption,
                                        colorIndex,
                                        provider.selectedMethod,
                                        shippingDetails!,
                                        selectedPlan);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appBlueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Checkout",
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.048,
                                fontFamily: 'Barlow-Regular',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.045),
                        Container(
                          width: DeviceDimensions.screenWidth(context) * 0.85,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 251, 243, 205),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8, top: 8.0),
                                  child: Row(children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: Colors.amberAccent,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text('Note',
                                          style: TextStyle(
                                            color: AppColors.textColorBlue,
                                          )),
                                    )
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Please check and confirm your delivery method before checkout and payment. Place your order according to delivery method easily & quickly.',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 114, 114, 114),
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.03),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.030),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding orderInfo(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Barlow-Regular',
              fontWeight: FontWeight.w600,
              color: AppColors.textColorBlue,
              fontSize: DeviceDimensions.responsiveSize(context) * 0.039,
            ),
          ),
          Text(value,
              style: TextStyle(
                fontFamily: 'Barlow-Regular',
                fontWeight: FontWeight.w500,
                fontSize: DeviceDimensions.responsiveSize(context) * 0.035,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget deliveryMethod(
      BuildContext context, String location, ShippingAddressProvider provider) {
    bool isSelected = provider.isMethodSelected(location);

    return Container(
      width: DeviceDimensions.screenWidth(context) * 0.80,
      decoration: BoxDecoration(
          color: const Color(0xFFFDFAFA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFD7D9DD))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: InkWell(
          onTap: () async {
            provider.selectMethod(location);
            await provider.loadShippingAddress();
          },
          child: Row(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    isSelected
                        ? "assets/icons/selectdeliveryblack.svg"
                        : "assets/icons/selectdelivery.svg",
                    height: 21,
                  ),
                ],
              ),
              SizedBox(width: DeviceDimensions.screenWidth(context) * 0.020),
              Text(
                location,
                style: TextStyle(
                  fontFamily: 'Barlow-Regular',
                  fontWeight: FontWeight.bold,
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.037,
                  color: const Color(0xFF727272),
                ),
              ),
              const Spacer(),
              // isSelected
              //     ? Padding(
              //         padding: const EdgeInsets.only(),
              //         child: SvgPicture.asset(
              //           "assets/icons/more5.svg",
              //           height: 23,
              //         ),
              //       )
              //     : Padding(
              //         padding: const EdgeInsets.only(right: 5.0),
              //         child: SvgPicture.asset(
              //           "assets/icons/more.svg",
              //           height: 15,
              //         ),
              //       ),
            ],
          ),
        ),
      ),
    );
  }

  deliveryAddressContainer(BuildContext context) {
    return Consumer<ShippingAddressProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading) {
          Container(
            color: Colors.white54,
            child: const Center(
              child: SmallThreeBounceLoader(),
            ),
          );
        }
        final shippingAddress = orderProvider.selectedShippingAddress;

        return Container(
          width: DeviceDimensions.screenWidth(context) * 0.90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                if (shippingAddress == null) ...[
                  SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.042,
                    width: DeviceDimensions.screenWidth(context) * 0.50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/add-shipping-address");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appBlueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        "Add Shipping Address",
                        style: TextStyle(
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.040,
                          fontFamily: 'Barlow-Regular',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/location.svg",
                          height: 33,
                        ),
                        SizedBox(
                          width: DeviceDimensions.screenWidth(context) * 0.020,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shippingAddress.locationName,
                                style: TextStyle(
                                  fontFamily: 'Barlow-Regular',
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColorBlue,
                                  fontSize:
                                      DeviceDimensions.responsiveSize(context) *
                                          0.047,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.001),
                              LayoutBuilder(builder: (context, constraints) {
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: constraints.maxWidth),
                                  child: Text(
                                    shippingAddress.streetAddress,
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 114, 114, 114),
                                        fontSize:
                                            DeviceDimensions.responsiveSize(
                                                    context) *
                                                0.035),
                                    maxLines: 2,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, "/choose-shipping-address");
                            },
                            child: Text(
                              "Change",
                              style: TextStyle(
                                fontFamily: 'Barlow-Regular',
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.040,
                                color: AppColors.textColorBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }
//comment out if the pick up from machine is required
  // chooseMachineContainer(BuildContext context) {
  //   return Container(
  //     width: DeviceDimensions.screenWidth(context) * 0.90,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 15),
  //       child: Column(
  //         children: [
  //           SizedBox(
  //             height: DeviceDimensions.screenHeight(context) * 0.042,
  //             width: DeviceDimensions.screenWidth(context) * 0.40,
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, "/choose-machine");
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: AppColors.appBlueColor,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 padding: EdgeInsets.zero,
  //               ),
  //               child: Text(
  //                 "Choose Machine",
  //                 style: TextStyle(
  //                   fontSize: DeviceDimensions.responsiveSize(context) * 0.040,
  //                   fontFamily: 'Barlow-Regular',
  //                   fontWeight: FontWeight.w600,
  //                   letterSpacing: 1,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSelectedPlanContainer(String planNameDb) {
    return Container(
      width: DeviceDimensions.screenWidth(context) * 0.90,
      decoration: BoxDecoration(
        color: Colors.white, // Change color for selected plan
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Your Plan",
                    style: TextStyle(
                        fontFamily: 'Barlow-Bold',
                        fontWeight: FontWeight.bold,
                        fontSize:
                            DeviceDimensions.responsiveSize(context) * 0.055,
                        color: Colors.black),
                  ),
                ),
                Text(
                  "$planNameDb Plan",
                  style: TextStyle(
                    fontFamily: 'Barlow-Regular',
                    fontWeight: FontWeight.w600,
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.038,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.005),
            Divider(),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/pricing-plan");
              },
              child: Text(
                "Change Plan",
                style: TextStyle(
                  fontFamily: 'Barlow-Regular',
                  fontWeight: FontWeight.w600,
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.040,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoPlanContainer() {
    return Container(
      width: DeviceDimensions.screenWidth(context) * 0.90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 17),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Select Plan",
                style: TextStyle(
                    fontFamily: 'Barlow-Bold',
                    fontWeight: FontWeight.bold,
                    fontSize: DeviceDimensions.responsiveSize(context) * 0.055,
                    color: AppColors.textColorBlue),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.005),
            Text(
              "Select the perfect plan for your needs. Choose from Free, Monthly, or Yearly and place your order!",
              style: TextStyle(
                fontFamily: 'Barlow-Regular',
                fontWeight: FontWeight.w600,
                fontSize: DeviceDimensions.responsiveSize(context) * 0.033,
                color: const Color(0xFF727272),
              ),
            ),
            SizedBox(height: 3),
            Divider(),
            SizedBox(height: 2),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/pricing-plan");
              },
              child: Text(
                "No Plan Selected",
                style: TextStyle(
                  fontFamily: 'Barlow-Regular',
                  fontWeight: FontWeight.w600,
                  fontSize: DeviceDimensions.responsiveSize(context) * 0.040,
                  color: AppColors.textColorBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

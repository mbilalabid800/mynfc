import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/utils/ui_mode_helper.dart';
import 'package:nfc_app/widgets/register_data_widget.dart';
import 'package:nfc_app/widgets/sign_in_data_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _containerHeight = 0.70;

  final Duration _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    enableImmersiveStickyMode();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _containerHeight = 0.70;
      });
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
      body: Stack(
        children: [
          SizedBox(
            height: DeviceDimensions.screenHeight(context) * 0.35,
            width: DeviceDimensions.screenWidth(context),
            child: Image.asset(
              "assets/images/login.png",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: DeviceDimensions.screenHeight(context) * _containerHeight,
              width: DeviceDimensions.screenWidth(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 255, 254, 255),
              ),
              child: Column(
                children: [
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.006),
                  Container(
                    width: DeviceDimensions.screenWidth(context) * 0.14,
                    height: DeviceDimensions.screenHeight(context) * 0.0079,
                    decoration: BoxDecoration(
                        color: const Color(0xFFD7D9DD),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  SizedBox(
                      height: DeviceDimensions.screenHeight(context) * 0.025),
                  Container(
                    height: DeviceDimensions.screenHeight(context) * 0.065,
                    width: DeviceDimensions.screenWidth(context) * 0.891,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 239, 239, 239),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelColor: AppColors.appOrangeColor,
                        labelStyle: TextStyle(
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.045,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1),
                        unselectedLabelColor: AppColors.textColorBlue,
                        unselectedLabelStyle: TextStyle(
                          fontSize:
                              DeviceDimensions.responsiveSize(context) * 0.045,
                          fontWeight: FontWeight.normal,
                        ),
                        tabs: const [
                          Tab(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: 'Barlow-Regular',
                                //color: AppColors.textColorBlue
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontFamily: 'Barlow-Regular',
                                //color: AppColors.textColorBlue
                              ),
                            ),
                          ),
                        ],
                        dividerColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: _animationDuration,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final slideAnimation = Tween<Offset>(
                          begin: const Offset(0, 1.0),
                          end: Offset.zero,
                        ).animate(animation);

                        return SlideTransition(
                          position: slideAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: _tabController.index == 0
                          ? const SigninData(key: ValueKey<int>(0))
                          : const RegisterData(key: ValueKey<int>(1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

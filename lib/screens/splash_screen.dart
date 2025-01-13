import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/splash_screen_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/my_button.dart';
import 'package:nfc_app/shared/utils/ui_mode_helper.dart';
import 'package:provider/provider.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  //late AnimationController _imageAnimationController;
  late AnimationController _containerAnimationController;
  //late Animation<double> _scaleAnimation;
  late Animation<Offset> _containerSlideAnimation;

  final List<String> splashTexts = [
    "Smart is your\nDigital Business\nCard",
    "Share your contact\ninfo & more Instantly\nWith NFC",
    "Grow your business\nand community\nwith Smart",
  ];

  final List<String> splashImages = [
    "assets/images/splash1.png",
    "assets/images/splash2.png",
    "assets/images/splash3.jpeg",
  ];

  @override
  void initState() {
    super.initState();
    enableImmersiveStickyMode();

    // _imageAnimationController = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // );

    _containerAnimationController = AnimationController(
      duration: const Duration(seconds: 2), // Shorter duration for smoothness
      vsync: this,
    );

    // _scaleAnimation = Tween<double>(begin: 1.1, end: 1.0).animate(
    //   CurvedAnimation(
    //     parent: _imageAnimationController,
    //     curve: Curves.easeOut,
    //   ),
    // );

    _containerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start fully below the screen
      end: Offset.zero, // Slide into position
    ).animate(CurvedAnimation(
      parent: _containerAnimationController,
      curve: Curves.easeInCubic,
    ));

    // Start the animations
    _containerAnimationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_imageAnimationController.forward();
    });
  }

  @override
  void dispose() {
    //_imageAnimationController.dispose();
    _containerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background images with animations
          Consumer<SplashScreenProvider>(
            builder: (context, provider, child) {
              return PageView.builder(
                controller: provider.pageController,
                itemCount: splashImages.length,
                physics: ClampingScrollPhysics(),
                onPageChanged: (index) {
                  provider.setPage(index);
                  // _imageAnimationController.reset();
                  //_imageAnimationController.forward();
                },
                itemBuilder: (context, index) {
                  return FadeTransition(
                    opacity: AlwaysStoppedAnimation(1.0),
                    child: SizedBox(
                      height: DeviceDimensions.screenHeight(context),
                      width: DeviceDimensions.screenWidth(context),
                      child: Image.asset(
                        splashImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                  // return AnimatedBuilder(
                  //   animation: _imageAnimationController,
                  //   builder: (context, child) {
                  //     return Transform.scale(
                  //       scale: _scaleAnimation.value,
                  //       child: SizedBox(
                  //         height: DeviceDimensions.screenHeight(context),
                  //         width: DeviceDimensions.screenWidth(context),
                  //         child: Image.asset(
                  //           splashImages[index],
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                },
              );
            },
          ),
          // Sliding container
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _containerSlideAnimation,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
                child: Consumer<SplashScreenProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      height: DeviceDimensions.screenHeight(context) * 0.40,
                      width: DeviceDimensions.screenWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.022),
                          // Dots Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              splashTexts.length,
                              (index) {
                                return AnimatedContainer(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  duration: const Duration(milliseconds: 500),
                                  width: provider.currentDot == index
                                      ? DeviceDimensions.screenHeight(context) *
                                          0.050
                                      : DeviceDimensions.screenHeight(context) *
                                          0.010,
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.010,
                                  decoration: BoxDecoration(
                                    color: provider.currentDot == index
                                        ? AppColors.appBlueColor
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                              height: DeviceDimensions.screenHeight(context) *
                                  0.050),
                          // Animated Text
                          WidgetAnimator(
                            incomingEffect: WidgetTransitionEffects
                                .incomingSlideInFromRight(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeIn,
                            ),
                            outgoingEffect:
                                WidgetTransitionEffects.outgoingSlideOutToLeft(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                            ),
                            child: Text(
                              key: ValueKey<int>(provider.currentDot),
                              splashTexts[provider.currentDot],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.080,
                                fontFamily: "Barlow-Bold",
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColorBlue,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Get Started Button
                          MyButton(
                            text: 'Get Started',
                            onPressed: () {
                              Navigator.of(context).pushNamed('/login-screen');
                            },
                            width: DeviceDimensions.screenWidth(context) * 0.75,
                          ),
                          SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.043,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

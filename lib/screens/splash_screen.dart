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
  late AnimationController _mainAnimationController;
  late Animation<double> _scaleAnimation;
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

    // 1) Loop the animation continuously in both directions:
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true); // <-- repeat with reverse.

    // 2) Start from a “near 1.0” scale to 1.05 so it gently pulses.
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // 3) You can still slide the container if desired, also repeating if needed.
    _containerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Remove _mainAnimationController.forward() to avoid resetting the animation
    // _mainAnimationController.forward();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: Stack(
        children: [
          Consumer<SplashScreenProvider>(
            builder: (context, provider, child) {
              return PageView.builder(
                controller: provider.pageController,
                itemCount: splashImages.length * 4,
                onPageChanged: provider.handlePageChange,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _mainAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: SizedBox(
                          height: DeviceDimensions.screenHeight(context),
                          width: DeviceDimensions.screenWidth(context),
                          child: Image.asset(
                            splashImages[index % splashImages.length],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _mainAnimationController,
              builder: (context, child) {
                return SlideTransition(
                  position: _containerSlideAnimation,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 20),
                    child: Consumer<SplashScreenProvider>(
                      builder: (context, provider, child) {
                        return GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            provider.pageController.position.moveTo(
                              provider.pageController.offset - details.delta.dx,
                            );
                          },
                          onHorizontalDragEnd: (details) {
                            double velocity =
                                details.velocity.pixelsPerSecond.dx;
                            if (velocity > 0) {
                              provider.pageController.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            } else if (velocity < 0) {
                              provider.pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Container(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.40,
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
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.022,
                                ),
                                // Dots row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    splashTexts.length,
                                    (index) {
                                      return AnimatedContainer(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                        ),
                                        duration:
                                            const Duration(milliseconds: 500),
                                        width: provider.currentDot == index
                                            ? DeviceDimensions.screenHeight(
                                                    context) *
                                                0.050
                                            : DeviceDimensions.screenHeight(
                                                    context) *
                                                0.010,
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.010,
                                        decoration: BoxDecoration(
                                          color: provider.currentDot == index
                                              ? AppColors.appBlueColor
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.050,
                                ),
                                // Animating text
                                WidgetAnimator(
                                  incomingEffect: WidgetTransitionEffects
                                      .incomingSlideInFromRight(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  ),
                                  outgoingEffect: WidgetTransitionEffects
                                      .outgoingSlideOutToLeft(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  ),
                                  child: Text(
                                    key: ValueKey<int>(provider.currentDot),
                                    splashTexts[provider.currentDot],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.080,
                                      fontFamily: "Barlow-Bold",
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColorBlue,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                MyButton(
                                  text: 'Get Started',
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/login-screen');
                                  },
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.75,
                                ),
                                SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.043,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/shared/common_widgets/my_button.dart';
import 'package:nfc_app/shared/utils/ui_mode_helper.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late AnimationController _containerAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _containerAnimation;
  int _currentDot = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<String> splashTexts = [
    "Smart is your\nDigital Business\nCard",
    "Share your contact\ninfo & more Instantly\nWith NFC",
    "Grow your business\nand community\nwith Smart",
  ];

  final List<String> splashImages = [
    "assets/images/splash1.png",
    "assets/images/splash2.png",
    "assets/images/splash3.png",
  ];
  late Timer _autoChangeTimer;

  @override
  void initState() {
    super.initState();
    enableImmersiveStickyMode();
    _imageAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _containerAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _containerAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _containerAnimationController, curve: Curves.easeOut));

    _containerAnimationController.forward().then((_) {
      _autoChangeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        int nextPage = (_currentDot + 1) % splashImages.length;
        setState(() {
          _currentDot = nextPage;
        });

        if (mounted) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _imageAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _autoChangeTimer.cancel();
    _imageAnimationController.dispose();
    _containerAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: splashImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentDot = index;
              });
              _imageAnimationController.reset();
              _imageAnimationController.forward();
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _imageAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SizedBox(
                      height: DeviceDimensions.screenHeight(context),
                      width: DeviceDimensions.screenWidth(context),
                      child: Image.asset(
                        splashImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _containerAnimation,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
                child: Container(
                  height: DeviceDimensions.screenHeight(context) * 0.40,
                  width: DeviceDimensions.screenWidth(context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.003),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashTexts.length,
                          (index) {
                            return AnimatedContainer(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              duration: const Duration(milliseconds: 500),
                              width: _currentDot == index
                                  ? DeviceDimensions.screenHeight(context) *
                                      0.050
                                  : DeviceDimensions.screenHeight(context) *
                                      0.010,
                              height: DeviceDimensions.screenHeight(context) *
                                  0.010,
                              decoration: BoxDecoration(
                                color: _currentDot == index
                                    ? AppColors.appBlueColor
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.045),
                      WidgetAnimator(
                        incomingEffect:
                            WidgetTransitionEffects.incomingSlideInFromRight(
                          duration: const Duration(milliseconds: 400),
                        ),
                        outgoingEffect:
                            WidgetTransitionEffects.outgoingSlideOutToLeft(
                          duration: const Duration(milliseconds: 400),
                        ),
                        child: Text(
                          key: ValueKey<int>(_currentDot),
                          splashTexts[_currentDot],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  DeviceDimensions.responsiveSize(context) *
                                      0.080,
                              fontFamily: "Barlow-Bold",
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColorBlue),
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.04),
                      MyButton(
                        text: 'Get Started',
                        onPressed: () {
                          Navigator.pushNamed(context, '/login-screen');
                        },
                        width: DeviceDimensions.screenWidth(context) * 0.75,
                      ),
                      SizedBox(
                        height: DeviceDimensions.screenHeight(context) * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

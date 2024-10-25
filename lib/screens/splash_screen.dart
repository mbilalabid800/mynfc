import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/utils/ui_mode_helper.dart';
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
  late Timer _pageChangeTimer;
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

  @override
  void initState() {
    super.initState();
    enableImmersiveStickyMode();
    _imageAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<UserInfoFormStateProvider>(context, listen: false)
    //       .loadUserData();
    // });

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
      _pageChangeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!mounted) return;
        int nextPage = (_currentDot + 1) % splashImages.length;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _pageController.hasClients) {
            _pageController.jumpToPage(nextPage);
          }
        });

        setState(() {
          _currentDot = nextPage;
        });

        _imageAnimationController.reset();
        _imageAnimationController.forward();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _imageAnimationController.forward();
    });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid calling setState on a disposed widget
    if (_pageChangeTimer.isActive) {
      _pageChangeTimer.cancel();
    }
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
            //physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(
                () {
                  _currentDot = index;
                },
              );

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
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Container(
                  height: DeviceDimensions.screenHeight(context) / 2.5,
                  width: DeviceDimensions.screenWidth(context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
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
                                    ? Colors.black
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
                            fontSize: DeviceDimensions.responsiveSize(context) *
                                0.080,
                            fontFamily: "Barlow-Bold",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.04),
                      SizedBox(
                        width: DeviceDimensions.screenWidth(context) * 0.8,
                        height: DeviceDimensions.screenHeight(context) * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login-screen');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            'Get started',
                            style: TextStyle(
                                fontSize:
                                    DeviceDimensions.responsiveSize(context) *
                                        0.053,
                                color: Colors.white,
                                fontFamily: 'Barlow-Regular',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.02),
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

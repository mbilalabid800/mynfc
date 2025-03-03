// ignore_for_file: avoid_print, depend_on_referenced_packages, unused_import
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_app/chat/chat_screen.dart';
import 'package:nfc_app/chat/chat_screen2.dart';
import 'package:nfc_app/firebase_options.dart';
import 'package:nfc_app/provider/app_data_provider.dart';
import 'package:nfc_app/provider/authenticate_provider.dart';
import 'package:nfc_app/provider/biometric_handler_provider.dart';
import 'package:nfc_app/provider/card_details_provider.dart';
import 'package:nfc_app/provider/chat_provider.dart';
import 'package:nfc_app/provider/connection_details_provider.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/provider/employee_provider.dart';
import 'package:nfc_app/provider/form_validation_provider.dart';
import 'package:nfc_app/provider/order_provider.dart';
import 'package:nfc_app/provider/password_validation_provider.dart';
import 'package:nfc_app/provider/shipping_address_provider.dart';
import 'package:nfc_app/provider/forget_password_email_provider.dart';
import 'package:nfc_app/provider/internet_checker_provider.dart';
import 'package:nfc_app/provider/loading_state_provider.dart';
import 'package:nfc_app/provider/resent_email.dart';
import 'package:nfc_app/provider/splash_screen_provider.dart';
import 'package:nfc_app/screens/active_link_screen.dart';
import 'package:nfc_app/screens/active_product_screen.dart';
import 'package:nfc_app/screens/add_employees.dart';
import 'package:nfc_app/screens/add_shipping_address.dart';
import 'package:nfc_app/screens/auth/email_verified.dart';
import 'package:nfc_app/screens/auth/email_verify.dart';
import 'package:nfc_app/screens/auth/forget_password.dart';
import 'package:nfc_app/screens/auth/login_screen.dart';
import 'package:nfc_app/screens/billing_screen.dart';
import 'package:nfc_app/screens/card_details_screen.dart';
import 'package:nfc_app/screens/choose_machine.dart';
import 'package:nfc_app/screens/choose_shipping_address.dart';
import 'package:nfc_app/screens/connection_profile_preview_screen.dart';
import 'package:nfc_app/screens/connections_request.dart';
import 'package:nfc_app/screens/contact_us_screen.dart';
import 'package:nfc_app/screens/edit_profile_screen.dart';
import 'package:nfc_app/screens/employee_list.dart';
import 'package:nfc_app/screens/error-screen.dart';
import 'package:nfc_app/screens/faq_screen.dart';
import 'package:nfc_app/screens/google_maps_screen.dart';
import 'package:nfc_app/screens/graph_screens/full_screen_graph.dart';
import 'package:nfc_app/screens/graph_screens/graph_screen.dart';
import 'package:nfc_app/screens/home_screen.dart';
import 'package:nfc_app/provider/image_picker_provider.dart';
import 'package:nfc_app/provider/social_app_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/provider/user_info_progress_provider.dart';
import 'package:nfc_app/screens/how_to_use_screen.dart';
import 'package:nfc_app/screens/internet_error_screen.dart';
import 'package:nfc_app/screens/mainScreen.dart';
import 'package:nfc_app/screens/new_splash_screen.dart';
import 'package:nfc_app/screens/order_details.dart';
import 'package:nfc_app/screens/order_history_screen.dart';
import 'package:nfc_app/screens/place_order_screen.dart';
import 'package:nfc_app/screens/pricing_plan_screen.dart';
import 'package:nfc_app/screens/privacy_policy_screen.dart';
import 'package:nfc_app/screens/privacy_settings_screen.dart';
import 'package:nfc_app/screens/profile_preview_screen.dart';
import 'package:nfc_app/screens/qr_code_scanner_screen.dart';
import 'package:nfc_app/screens/recent_connected_screen.dart';
import 'package:nfc_app/screens/settings_screen.dart';
import 'package:nfc_app/screens/share_profile_screen.dart';
import 'package:nfc_app/screens/splash_screen.dart';
import 'package:nfc_app/screens/subscription_screen.dart';
import 'package:nfc_app/screens/terms_conditions.dart';
import 'package:nfc_app/services/internet_status_handler.dart';
import 'package:nfc_app/services/permission_handler.dart';
import 'package:nfc_app/shared/utils/no_back_button_observer.dart';
import 'package:provider/provider.dart';
import 'screens/auth/email_verify_forget_password.dart';
import 'screens/recent_connected_list_screen.dart';
import 'screens/user_info_screen.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // setUrlStrategy(
  //     PathUrlStrategy()); // This ensures clean URLs without the '#' symbol.

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialization passed');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  final permissionHandler = PermissionHandler();
  await permissionHandler.requestPermission();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  final internetCheckerProvider = InternetCheckerProvider();
  internetCheckerProvider.startListeningToConnectivity();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => InternetCheckerProvider()),
      ChangeNotifierProvider(
          create: (_) => SplashScreenProvider(splashImages: [
                "assets/images/splash1.png",
                "assets/images/splash2.png",
                "assets/images/splash3.jpeg",
              ])),
      ChangeNotifierProvider(create: (_) => AuthenticateProvider()),
      ChangeNotifierProvider(create: (_) => PasswordValidationProvider()),
      ChangeNotifierProvider(create: (_) => UserInfoProgressProvider()),
      ChangeNotifierProvider(create: (_) => UserInfoFormStateProvider()),
      ChangeNotifierProvider(create: (_) => ImagePickerProvider()),
      ChangeNotifierProvider(create: (_) => SocialAppProvider()),
      ChangeNotifierProvider(create: (_) => ForgetPasswordEmailProvider()),
      ChangeNotifierProvider(create: (_) => ResentButtonProvider()),
      ChangeNotifierProvider(create: (_) => ConnectionProvider()),
      ChangeNotifierProvider(create: (_) => ConnectionDetailsProvider()),
      ChangeNotifierProvider(create: (_) => LoadingStateProvider()),
      ChangeNotifierProvider(create: (_) => CardDetailsProvider()),
      ChangeNotifierProvider(create: (_) => ShippingAddressProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
      ChangeNotifierProvider(
          create: (_) => EmployeeProvider()..getLocalEmployees()),
      //ChangeNotifierProvider(create: (_) => BiometricHandlerProvider()),
      ChangeNotifierProvider(create: (_) => FormValidationProvider()),
      ChangeNotifierProvider(create: (_) => AppDataProvider()),
      ChangeNotifierProvider(create: (_) => ChatProvider())
    ],
    child: InternetStatusHandler(
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Absher',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
          splashColor: Colors.grey, // or Colors.black
          highlightColor: Colors.grey, // or Colors.black
          primaryColor: Colors.grey,
        ),
        initialRoute: '/new-splash',
        // initialRoute: '/error',
        onGenerateRoute: _onGenerateRoute,
        routes: kIsWeb ? _webRoutes : _appRoutes,
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (_) => const ErrorScreen(
            message: 'Page not found',
          ),
        ),
      ),
    );
  }
}

final Map<String, WidgetBuilder> _webRoutes = {
  '/new-splash': (context) => const ErrorScreen(
        message: 'Page not found',
      ),
};

final Map<String, WidgetBuilder> _appRoutes = {
  '/new-splash': (context) => NewSplashScreen(),
  '/mainNav-screen': (context) => const MainScreen(),
  '/splash': (context) => SplashScreen(),
  '/login-screen': (context) => const LoginScreen(),
  '/forget-password': (context) => const ForgetPassword(),
  '/email-verify-forgot-password': (context) =>
      const EmailVerifyForgetPassword(),
  //'/set-password': (context) => const SetPassword(),
  '/email-verify': (context) => const EmailVerify(),
  '/email-verified': (context) => const EmailVerified(),
  '/user-info': (context) => const UserScreen(),
  '/home-screen': (context) => const HomeScreen(),
  '/profile-preview': (context) => const ProfilePreview(),
  '/recent-connected': (context) => const RecentConnected(),
  '/recent-connected-list': (context) => const RecentConnectedList(),
  '/active-link': (context) => const ActiveLink(),
  '/settings': (context) => const Settings(),
  //'/subscription-screen': (context) => PricingPlansScreen(),
  '/card-details': (context) => const CardDetails(),
  '/edit-profile': (context) => const EditProfile(),
  //'/privacy-settings': (context) => const PrivacySettings(),
  '/activate-product': (context) => const ActiveProductScreen(),
  '/privacy-policy': (context) => const PrivacyPolicy(),
  '/terms-conditions': (context) => const TermsConditions(),
  '/graph-screen': (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return GraphScreen(uid: args['uid']!);
  },
  '/pricing-plan': (context) => const PricingPlan(),
  '/contact-us-screen': (context) => const ContactUsScreen(),
  '/internet-error': (context) => const InternetError(),
  '/how-to-use': (context) => const HowToUseScreen(),
  '/faq-screen': (context) => const FaqScreen(),
  '/full-screen-graph': (context) => const FullScreenGraph(),
  '/place-order-screen': (context) => const PlaceOrderScreen(),
  '/choose-shipping-address': (context) => const ChooseShippingAddress(),
  '/add-shipping-address': (context) => const AddShippingAddress(),
  '/google-maps-screen': (context) => GoogleMapsScreen(),
  '/choose-machine': (context) => const ChooseMachine(),
  '/order-details': (context) => const OrderDetails(),
  '/order-history-screen': (context) => const OrderHistoryScreen(),
  '/share-profile': (context) => ShareProfileScreen(),
  '/add-employees': (context) => AddEmployeeScreen(),
  '/employees-list': (context) => EmployeeListScreen(),
  '/chat-screen': (context) => ChatScreen(),
  //'/chat-screen2': (context) => Chatting(),
  '/connections-request': (context) => ConnectionsRequest(),
  '/billing-screen': (context) => BillingScreen(),
  '/qr-scanner-screen': (context) => QRScannerScreen()
};

Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
  // Parse the route name into a URI object
  final Uri uri = Uri.tryParse(settings.name ?? '') ?? Uri();

  // Handle fragment-based URLs like "https://www.website.myabsher.com/#/profile/12345"
  if (uri.fragment.isNotEmpty) {
    final Uri fragmentUri = Uri.parse(uri.fragment); // Parse the fragment part

    // Check if the fragment starts with 'profile'
    if (fragmentUri.pathSegments.isNotEmpty &&
        fragmentUri.pathSegments.first == 'profile') {
      // Extract the userId from the fragment
      final String userIdFromFragment = fragmentUri.pathSegments.length > 1
          ? fragmentUri.pathSegments[1]
          : '';

      if (userIdFromFragment.isNotEmpty) {
        return MaterialPageRoute(
          builder: (_) => ConnectionProfilePreview(userId: userIdFromFragment),
        );
      }
    }
  }

  // Handle argument-based routes or standard deep links
  if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'profile') {
    // Extract the userId from the URI path segments
    final String userIdFromLink =
        uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';

    if (userIdFromLink.isNotEmpty) {
      return MaterialPageRoute(
        builder: (_) => ConnectionProfilePreview(userId: userIdFromLink),
      );
    }
  }

  if (settings.name == '/profile') {
    final String? userIdFromArgs = settings.arguments as String?;
    if (userIdFromArgs != null && userIdFromArgs.isNotEmpty) {
      return MaterialPageRoute(
        builder: (_) => ConnectionProfilePreview(userId: userIdFromArgs),
      );
    }
  }
  return null;
}

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_app/provider/card_details_provider.dart';
import 'package:nfc_app/provider/connection_details_provider.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/provider/order_provider.dart';
import 'package:nfc_app/provider/shipping_address_provider.dart';
import 'package:nfc_app/provider/forget_password_email_provider.dart';
import 'package:nfc_app/provider/internet_checker_provider.dart';
import 'package:nfc_app/provider/loading_state_provider.dart';
import 'package:nfc_app/provider/resent_email.dart';
import 'package:nfc_app/screens/active_link_screen.dart';
import 'package:nfc_app/screens/active_product_screen.dart';
import 'package:nfc_app/screens/add_shipping_address.dart';
import 'package:nfc_app/screens/auth/email_verified.dart';
import 'package:nfc_app/screens/auth/email_verify.dart';
import 'package:nfc_app/screens/auth/forget_password.dart';
import 'package:nfc_app/screens/auth/login_screen.dart';
import 'package:nfc_app/screens/card_details_screen.dart';
import 'package:nfc_app/screens/choose_machine.dart';
import 'package:nfc_app/screens/choose_shipping_address.dart';
import 'package:nfc_app/screens/connection_profile_preview_screen.dart';
import 'package:nfc_app/screens/contact_us_screen.dart';
import 'package:nfc_app/screens/edit_profile_screen.dart';
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
import 'package:nfc_app/screens/recent_connected_screen.dart';
import 'package:nfc_app/screens/settings_screen.dart';
import 'package:nfc_app/screens/splash_screen.dart';
import 'package:nfc_app/screens/subscription_screen.dart';
import 'package:nfc_app/screens/terms_conditions.dart';
import 'package:nfc_app/services/internet_status_handler.dart';
import 'package:provider/provider.dart';
import 'screens/auth/email_verify_forget_password.dart';
import 'screens/auth/set_password_screen.dart';
import 'screens/recent_connected_list_screen.dart';
import 'screens/user_info_screen.dart';

void main() async {
  //Ensure all bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Initialize Firebase App Check
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity, // For Android
      appleProvider: AppleProvider.deviceCheck, // For iOS
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // Optionally, show a dialog or handle the error gracefully in the app
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    //testtt
  ]);

  runApp(MultiProvider(
    providers: [
      // ChangeNotifierProvider(
      //   create: (_) => InternetCheckerProvider(),
      // ),
      ChangeNotifierProvider(
        create: (_) => UserInfoProgressProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => UserInfoFormStateProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ImagePickerProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => SocialAppProvider()..loadSocialApps(),
      ),
      ChangeNotifierProvider(
        create: (_) => ForgetPasswordEmailProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ResentButtonProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ConnectionProvider()..loadConnections(),
      ),
      ChangeNotifierProvider(
        create: (_) => ConnectionDetailsProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LoadingStateProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => CardDetailsProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ShippingAddressProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => OrderProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        splashColor: Colors.grey, // or Colors.black
        highlightColor: Colors.grey, // or Colors.black
        hoverColor: Colors.grey,
        primaryColor: Colors.grey,
        //accentColor: Colors.grey, // For desktop/web
      ),
      initialRoute: '/new-splash',
      //initialRoute: '/google-maps-screen',
      onGenerateRoute: _onGenerateRoute,
      routes: {
        '/mainNav-screen': (context) => const MainScreen(),
        '/subscription-screen': (context) => PricingPlansScreen(),
        '/new-splash': (context) => NewSplashScreen(),
        '/splash': (context) => const SplashScreen(),
        '/login-screen': (context) => const LoginScreen(),
        '/forget-password': (context) => const ForgetPassword(),
        '/forget2': (context) => const ForgetPassword(),
        '/email-verify-forgot-password': (context) =>
            const EmailVerifyForgetPassword(),
        '/set-password': (context) => const SetPassword(),
        '/email-verify': (context) => const EmailVerify(),
        '/email-verified': (context) => const EmailVerified(),
        '/user-info': (context) => const UserScreen(),
        '/home-screen': (context) => const HomeScreen(),
        '/profile-preview': (context) => const ProfilePreview(),
        '/recent-connected': (context) => const RecentConnected(),
        '/recent-connected-list': (context) => const RecentConnectedList(),
        '/active-link': (context) => const ActiveLink(),
        '/settings': (context) => const Settings(),
        '/card-details': (context) => const CardDetails(),
        '/edit-profile': (context) => const EditProfile(),
        '/privacy-settings': (context) => const PrivacySettings(),
        '/activate-product': (context) => const ActiveProductScreen(),
        '/privacy-policy': (context) => const PrivacyPolicy(),
        '/terms-conditions': (context) => const TermsConditions(),
        '/graph-screen': (context) => const GraphScreen(),
        '/pricing-plan': (context) => const PricingPlan(),
        '/contact-us-screen': (context) => const ContactUsScreen(),
        // '/internet-error': (context) => const InternetError(),
        '/how-to-use': (context) => const HowToUseScreen(),
        '/faq-screen': (context) => const FaqScreen(),
        '/full-screen-graph': (context) => const FullScreenGraph(),
        '/order-screen': (context) => const PlaceOrderScreen(),
        '/choose-shipping-address': (context) => const ChooseShippingAddress(),
        '/add-shipping-address': (context) => const AddShippingAddress(),
        '/google-maps-screen': (context) => GoogleMapsScreen(),
        '/choose-machine': (context) => const ChooseMachine(),
        '/order-details': (context) => const OrderDetails(),
        '/order-history-screen': (context) => const OrderHistoryScreen(),
      },
    );
  }
}

Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
  // Check if the route name contains a deep link URL
  final Uri uri = Uri.parse(settings.name ?? '');

  // Check if the path starts with 'connection-profile-preview'
  if (uri.pathSegments.isNotEmpty &&
      uri.pathSegments.first == 'connection-profile-preview') {
    // Extract the userId from the URI path, if available
    final String userIdFromLink =
        uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';

    // If userId is found in the deep link, use it
    if (userIdFromLink.isNotEmpty) {
      return MaterialPageRoute(
        builder: (_) => ConnectionProfilePreview(userId: userIdFromLink),
      );
    }
  }

  // If no deep link is present, try to get the userId from the arguments
  if (settings.name == '/connection-profile-preview') {
    final String? userIdFromArgs = settings.arguments as String?;
    if (userIdFromArgs != null && userIdFromArgs.isNotEmpty) {
      return MaterialPageRoute(
        builder: (_) => ConnectionProfilePreview(userId: userIdFromArgs),
      );
    }
  }

  return null;
}

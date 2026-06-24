import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jara_vendor/routes/app_routes.dart';
import 'package:jara_vendor/send_token_service.dart';
import 'package:jara_vendor/utils/storage.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'dart:developer' as myLog;

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'screens/onboarding_screen/onboarding_screen.dart';
// import 'screens/profile_setup_screen/profile_setup_screen.dart';
// import 'screens/address_screen/address_screen.dart';
// import 'screens/summary_screen/summary_screen.dart';
// import 'screens/dashboard_screen/dashboard_screen.dart';
// import 'screens/profile_screen/profile_screen.dart';
// import 'screens/earnings_screen/earnings_screen.dart';
// import 'screens/orders_screen/orders_screen.dart';
// import 'screens/wallet_screen/wallet_screen.dart';
// import 'screens/splash_screen/splash_screen.dart';
// import 'screens/create_account/create_account.dart';
// import 'screens/email_verification/email_verification.dart';
// import 'screens/business_screen/business_screen.dart';
// import 'screens/product_selection/product_selection.dart';
// import 'screens/shop_size/shop_size.dart';
// import 'screens/payment_method/payment_method.dart';
// import 'screens/job_details/job_details.dart';
// import 'screens/market_list/market_list.dart';
// import 'screens/withdraw_money/withdraw_money.dart';
// import 'screens/bank_selection/bank_selection.dart';
// import 'screens/order_history/order_history.dart';
// import 'screens/job_progress/job_progress.dart';
// import 'screens/job_completed/job_completed.dart';



// ─── Globals ────────────────────────────────────────────────────────────────

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

const MethodChannel platform = MethodChannel(
  'dexterx.dev/flutter_local_notifications_example',
);

String? selectedNotificationPayload;

const String urlLaunchActionId = 'id_1';
const String navigationActionId = 'id_3';
const String darwinNotificationCategoryText = 'textCategory';
const String darwinNotificationCategoryPlain = 'plainCategory';

// ─── Background notification tap handler (must be top-level) ────────────────

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  myLog.log('Notification tapped in background: ${notificationResponse.id}');
}

// ─── FCM background handler (must be top-level) ─────────────────────────────

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  myLog.log('Handling a background message: ${message.messageId}');

  final FlutterLocalNotificationsPlugin bgPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await bgPlugin.initialize(
    settings: initializationSettings, // named param (v20+)
    onDidReceiveNotificationResponse: selectNotificationStream.add,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  if (message.notification != null) {
    final notification = message.notification!;
    final android = message.notification?.android;

    if (android != null) {
      await bgPlugin.show(
        id: notification.hashCode, // named param (v20+)
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          // renamed param (v20+)
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
            ticker: 'ticker',
          ),
        ),
      );
    }
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

final RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    myLog.log(
      'App launched from terminated state: ${initialMessage.messageId}',
    );
  }
  
  final SendTokenService sendTokenService = Get.put(SendTokenService());
  final fcm = FirebaseMessaging.instance;

  // ── Darwin (iOS/macOS) notification categories ──────────────────────────

  final List<DarwinNotificationCategory> darwinNotificationCategories = [
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: [
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: [
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: {DarwinNotificationActionOption.destructive},
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: {DarwinNotificationActionOption.foreground},
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: {DarwinNotificationActionOption.authenticationRequired},
        ),
      ],
      options: {DarwinNotificationCategoryOption.hiddenPreviewShowTitle},
    ),
  ];

  // ── Platform-specific init settings ─────────────────────────────────────

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // DarwinInitializationSettings replaces the deprecated IOSInitializationSettings
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        notificationCategories: darwinNotificationCategories,
      );

  final DarwinInitializationSettings initializationSettingsMacOS =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        notificationCategories: darwinNotificationCategories,
      );

  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
        defaultActionName: 'Open notification',
        defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
      );

  // Single declaration — no duplicate
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
    linux: initializationSettingsLinux,
  );

  // initialize() now uses named `settings:` parameter (breaking change v20+)
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: selectNotificationStream.add,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  // ── FCM permission & token ───────────────────────────────────────────────

  final NotificationSettings notificationSettings = await fcm.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (notificationSettings.authorizationStatus ==
      AuthorizationStatus.authorized) {
    myLog.log('User granted permission');
    final token = await fcm.getToken();
    if (token != null) {
      myLog.log('FCM Token: $token');
      sendTokenService.registerToken(token, null, null);
    }
  } else if (notificationSettings.authorizationStatus ==
      AuthorizationStatus.provisional) {
    myLog.log('User granted provisional permission');
  } else {
    myLog.log('User declined or has not accepted permission');
  }

  // ── Foreground message handler ───────────────────────────────────────────

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    myLog.log('Received a foreground message!');
    myLog.log('Message data: ${message.data}');

    if (message.notification != null) {
      myLog.log('Notification: ${message.notification}');

      final notification = message.notification!;
      final android = message.notification?.android;

      if (android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          id: notification.hashCode, // named param (v20+)
          title: notification.title,
          body: notification.body,
          notificationDetails: const NotificationDetails(
            // renamed param (v20+)
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
              ticker: 'ticker',
            ),
          ),
        );
      }
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    myLog.log('Message clicked!: $message');
  });

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    myLog.log('FCM Token refreshed: $newToken');
    sendTokenService.registerToken(newToken, null, null);
  });

  // ── Desktop SQLite init ──────────────────────────────────────────────────

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // ── App init ─────────────────────────────────────────────────────────────

  Get.put(DataBase());
  // Get.put(AuthController());
  // Get.put(ThemeController());

  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
  //   _,
  // ) {
  //   // Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
  //   // runApp(const MyApp());
  // });
  
   // await InAppWebViewController.setWebContentsDebuggingEnabled(true); // Optional
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  DataBase dataBase = Get.put(DataBase());
  var token = await dataBase.getToken();
  String initialRoute = token.isNotEmpty ? '/dashboard' : '/splash';
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return OverlayKit(
      child: GetMaterialApp(
        title: 'Jara Market',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF9800),
            primary: const Color(0xFFFF9800),
          ),
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF9800)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        initialRoute: initialRoute,
        // home: const SplashScreen(),
        getPages: AppRoutes.pages,
        // routes: {
        //   '/onboarding': (context) => const OnboardingScreen(),
        //   '/create-account': (context) => const CreateAccountScreen(),
        //   '/email-verification': (context) => const EmailVerificationScreen(),
        //   '/profile-setup': (context) => const ProfileSetupScreen(),
        //   '/business-name': (context) => const BusinessNameScreen(),
        //   '/product-selection': (context) => const ProductSelectionScreen(),
        //   '/shop-size': (context) => const ShopSizeScreen(),
        //   '/address': (context) => const AddressScreen(),
        //   '/payment-method': (context) => const PaymentMethodScreen(),
        //   '/summary': (context) => const SummaryScreen(),
        //   '/dashboard': (context) => const DashboardScreen(),
        //   '/job-details': (context) => const JobDetailsScreen(),
        //   '/job-progress': (context) => const JobProgressScreen(),
        //   '/job-completed': (context) => const JobCompletedScreen(),
        //   '/market-list': (context) => const MarketListScreen(),
        //   '/withdraw-money': (context) => const WithdrawMoneyScreen(),
        //   '/bank-selection': (context) => const BankSelectionScreen(),
        //   '/profile': (context) => const ProfileScreen(),
        //   '/earnings': (context) => const EarningsScreen(),
        //   '/orders': (context) => const OrdersScreen(),
        //   '/order-history': (context) => const OrderHistoryScreen(),
        //   '/wallet': (context) => const WalletScreen(),
        // },
      ),
    );
  }
}

import 'dart:core';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:jara_vendor/screens/add_money_screen/add_money_screen.dart';
import 'package:jara_vendor/screens/add_money_screen/bindings/add_money_bindings.dart';
import 'package:jara_vendor/screens/address_screen/address_screen.dart';
import 'package:jara_vendor/screens/address_screen/bindings/address_bindings.dart';
import 'package:jara_vendor/screens/bank_selection/bank_selection.dart';
import 'package:jara_vendor/screens/bank_selection/bindings/bank_selection_bindings.dart';
import 'package:jara_vendor/screens/business_screen/bindings/business_bindings.dart';
import 'package:jara_vendor/screens/business_screen/business_screen.dart';
import 'package:jara_vendor/screens/checkout_address_change/bindings/checkout_address_change_binding.dart';
import 'package:jara_vendor/screens/checkout_address_change/checkout_address_change.dart';
import 'package:jara_vendor/screens/create_account/create_account.dart';
import 'package:jara_vendor/screens/create_account/bindings/create_account_bindings.dart';
import 'package:jara_vendor/screens/dashboard_screen/bindings/dashboard_bindings.dart';
import 'package:jara_vendor/screens/dashboard_screen/dashboard_screen.dart';
import 'package:jara_vendor/screens/earnings_screen/bindings/earnings_bindings.dart';
import 'package:jara_vendor/screens/earnings_screen/earnings_screen.dart';
import 'package:jara_vendor/screens/email_verification/bindings/email_verification_bindings.dart';
import 'package:jara_vendor/screens/email_verification/email_verification.dart';
import 'package:jara_vendor/screens/faq_screen/bindings/faq_bindings.dart';
import 'package:jara_vendor/screens/faq_screen/faq_screen.dart';
import 'package:jara_vendor/screens/job_completed/bindings/job_completed_bindings.dart';
import 'package:jara_vendor/screens/job_completed/job_completed.dart';
import 'package:jara_vendor/screens/job_details/bindings/job_details_bindings.dart';
import 'package:jara_vendor/screens/job_details/job_details.dart';
import 'package:jara_vendor/screens/job_progress/bindings/job_progress_bindings.dart';
import 'package:jara_vendor/screens/job_progress/job_progress.dart';
import 'package:jara_vendor/screens/login/bindings/login_bindings.dart';
import 'package:jara_vendor/screens/login/login.dart';
import 'package:jara_vendor/screens/market_list/bindings/market_list_bindings.dart';
import 'package:jara_vendor/screens/market_list/market_list.dart';
import 'package:jara_vendor/screens/onboarding_screen/bindings/onboarding_bindings.dart';
import 'package:jara_vendor/screens/onboarding_screen/onboarding_screen.dart';
import 'package:jara_vendor/screens/order_history/bindings/order_history_bindings.dart';
import 'package:jara_vendor/screens/order_history/order_history.dart';
import 'package:jara_vendor/screens/orders_screen/bindings/orders_bindings.dart';
import 'package:jara_vendor/screens/orders_screen/orders_screen.dart';
import 'package:jara_vendor/screens/payment_method/bindings/payment_method_bindings.dart';
import 'package:jara_vendor/screens/payment_method/payment_method.dart';
import 'package:jara_vendor/screens/privacy_policy/privacy_policy.dart';
import 'package:jara_vendor/screens/product_selection/bindings/product_selection_bindings.dart';
import 'package:jara_vendor/screens/product_selection/product_selection.dart';
import 'package:jara_vendor/screens/profile_screen/bindings/profile_bindings.dart';
import 'package:jara_vendor/screens/profile_screen/profile_screen.dart';
import 'package:jara_vendor/screens/referral_screen/bindings/referral_bindings.dart';
import 'package:jara_vendor/screens/referral_screen/referral_screen.dart';
import 'package:jara_vendor/screens/shop_size/shop_size.dart';
import 'package:jara_vendor/screens/splash_screen/bindings/splash_bindings.dart';
import 'package:jara_vendor/screens/splash_screen/splash_screen.dart';
import 'package:jara_vendor/screens/summary_screen/summary_screen.dart';
import 'package:jara_vendor/screens/wallet_screen/bindings/wallet_bindings.dart';
import 'package:jara_vendor/screens/wallet_screen/wallet_screen.dart';
import 'package:jara_vendor/screens/withdraw_money/bindings/withdraw_money_bindings.dart';
import 'package:jara_vendor/screens/withdraw_money/withdraw_money.dart';

class AppRoutes {
  static const checkoutAddressChange = '/checkout-address-change';
  static const String onboarding = '/onboarding';
  static const String createAccount = '/create-account';
  static const String emailVerification = '/email-verification';
  static const String profileSetup = '/profile-setup';
  static const String businessName = '/business-name';
  static const String productSelection = '/product-selection';
  static const String shopSize = '/shop-size';
  static const faqScreen = '/faq_screen';
  static const String address = '/address';
  static const String paymentMethod = '/payment-method';
  static const String summary = '/summary';
  static const String dashboard = '/dashboard';
  static const String jobDetails = '/job-details';
  static const String jobProgress = '/job-progress';
  static const String jobCompleted = '/job-completed';
  static const String marketList = '/market-list';
  static const String withdrawMoney = '/withdraw-money';
  static const String bankSelection = '/bank-selection';
  static const String profile = '/profile';
  static const String earnings = '/earnings';
  static const String orders = '/orders';
  static const String orderHistory = '/order-history';
  static const String wallet = '/wallet';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String referralS = '/referral_screen';
  static const String addScreen = '/add-money';
  static const String privacyPolicyScreen = '/privacy_policy_screen';

  static List<GetPage> pages = [
    GetPage(
      name: addScreen,
      page: () => const AddMoneyScreen(),
      bindings: [AddMoneyBindings()],
    ),
    GetPage(
      name: checkoutAddressChange,
      page: () => CheckoutAddressChangeScreen(),
      bindings: [CheckoutAddressChangeBinding()],
    ),
    GetPage(
      name: referralS,
      page: () => const ReferralScreen(),
      bindings: [ReferralBindings()],
    ),
    GetPage(name: privacyPolicyScreen, page: () => const PrivacyPolicyScreen()),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      bindings: [
        // Add any necessary bindings here
        OnboardingBindings(),
      ],
    ),
    GetPage(
      name: faqScreen,
      page: () => const FaqScreen(),
      bindings: [FaqBindings()],
    ),
    GetPage(
      name: createAccount,
      page: () => const CreateAccountScreen(),
      bindings: [
        // Add any necessary bindings here
        CreateAccountBindings(),
      ],
    ),
    GetPage(
      name: emailVerification,
      page: () => const EmailVerificationScreen(),
      binding: EmailVerificationBindings(),
    ),
    GetPage(
      name: profileSetup,
      page: () => ProfileScreen(),
      bindings: [ProfileBindings()],
    ),
    GetPage(
      name: businessName,
      page: () => const BusinessNameScreen(),
      bindings: [
        // Add any necessary bindings here
        BusinessBindings(),
      ],
    ),
    GetPage(
      name: productSelection,
      page: () => const ProductSelectionScreen(),
      bindings: [ProductSelectionBindings()],
    ),
    GetPage(name: shopSize, page: () => const ShopSizeScreen()),
    GetPage(
      name: address,
      page: () => const AddressScreen(),
      bindings: [
        // Add any necessary bindings here
        AddressBindings(),
      ],
    ),
    GetPage(
      name: paymentMethod,
      page: () => const PaymentMethodScreen(),
      bindings: [
        // Add any necessary bindings here
        PaymentMethodBindings(),
      ],
    ),
    GetPage(
      name: summary,
      page: () => const SummaryScreen(),
      bindings: List.empty(),
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardScreen(),
      bindings: [
        // Add any necessary bindings here
        DashboardBindings(),
      ],
    ),
    GetPage(
      name: jobDetails,
      page: () => const JobDetailsScreen(),
      bindings: [JobDetailsBindings()],
    ),
    GetPage(
      name: jobProgress,
      page: () => const JobProgressScreen(),
      bindings: [
        // Add any necessary bindings here
        JobProgressBindings(),
      ],
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      bindings: [
        // Add any necessary bindings here
        LoginBindings(),
      ],
    ),
    GetPage(
      name: jobCompleted,
      page: () => const JobCompletedScreen(),
      bindings: [JobCompletedBindings()],
    ),
    GetPage(
      name: marketList,
      page: () => const MarketListScreen(),
      bindings: [
        // Add any necessary bindings here
        MarketListBindings(),
      ],
    ),
    GetPage(
      name: withdrawMoney,
      page: () => const WithdrawMoneyScreen(),
      bindings: [
        // Add any necessary bindings here
        WithdrawMoneyBindings(),
      ],
    ),
    GetPage(
      name: bankSelection,
      page: () => const BankSelectionScreen(),
      bindings: [
        // Add any necessary bindings here
        BankSelectionBindings(),
      ],
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      bindings: [
        // Add any necessary bindings here
        ProfileBindings(),
      ],
    ),
    GetPage(
      name: earnings,
      page: () => const EarningsScreen(),
      bindings: [
        // Add any necessary bindings here
        EarningsBindings(),
      ],
    ),
    GetPage(
      name: orders,
      page: () => const OrdersScreen(),
      bindings: [
        // Add any necessary bindings here
        OrdersBindings(),
      ],
    ),
    GetPage(
      name: orderHistory,
      page: () => const OrderHistoryScreen(),
      bindings: [OrderHistoryBindings()],
    ),
    GetPage(
      name: wallet,
      page: () => const WalletScreen(),
      bindings: [WalletBindings()],
    ),
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      bindings: [
        // Add any necessary bindings here
        SplashBindings(),
      ],
    ),
  ];
}

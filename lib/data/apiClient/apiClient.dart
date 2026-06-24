import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:jara_vendor/utils/snackbar_utils.dart';
import 'package:jara_vendor/utils/storage.dart';
import 'dart:developer' as myLog;

import 'package:overlay_kit/overlay_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

const API_TIMEOUT_INT_SECONDS = 60 * 5;
const API_TIMEOUT_DURATION = const Duration(seconds: API_TIMEOUT_INT_SECONDS);

class ApiClient extends GetConnect {
  Duration timeout = API_TIMEOUT_DURATION;

  ApiClient(this.timeout) : super(timeout: timeout);
  var basePath = 'https://jaramarket-backend.onrender.com/api/jaram';
  var baseUrl = 'https://jaramarket-backend.onrender.com/api/jaram';
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  Future<String?> fn_getCurrentBearerToken() async {
    return await 'dataBase.getToken()';
  }

  fn_generateCacheBuster([int length = 30]) {
    // Define the set of characters to use for the string
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    // Create an instance of Random
    final Random randomizer = Random();

    // Generate the string by randomly selecting characters
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(randomizer.nextInt(chars.length)),
      ),
    );
  }

  // Auth

  Future<bool> onboarding_login(String email, String password) async {
    // OverlayLoadingProgress.start();

    try {
      print("onboarding_login > $basePath/login");

      var response = await post(
        '$basePath/login?cache-buster=${fn_generateCacheBuster()}',
        {'email': email, 'password': password},
      );

      print("response.bodyString ${response.bodyString}");

      var body = jsonDecode(response.bodyString ?? '{}');

      print("body ${body}");

      if (response.statusCode == 200) {
        //  unawaited(loginOneSignalUser(id, email, token, basePath));

        SnackbarUtils.showSnackbarMessage(message: 'Login successful');

        return true;
      }
    } catch (error) {
      // OverlayLoadingProgress.stop();

      SnackbarUtils.showSnackbarError(
        "Oops",
        "Login failed! ${error.toString()}",
      );

      myLog.log("Login failed! ${error.toString()}");

      return false;
    }
    return false;
  }

  // Helper function for logging
  void _logRequest(String method, Uri url, {dynamic body}) {
    if (kDebugMode) {
      print('--- API Request ---');
      print('Method: $method');
      print('URL: $url');
      if (body != null) {
        print('Body: ${jsonEncode(body)}');
      }
      print('-------------------');
    }
  }

  void _logResponse(http.Response response) {
    if (kDebugMode) {
      print('--- API Response ---');
      print('Status Code: ${response.statusCode}');
      print('URL: ${response.request?.url}');
      try {
        // Attempt to decode and print if JSON, otherwise print raw body
        final decodedBody = jsonDecode(response.body);
        print('Body: ${jsonEncode(decodedBody)}'); // Pretty print JSON
      } catch (e) {
        print('Body: ${response.body}'); // Print as is if not JSON
      }
      print('--------------------');
    }
  }

  Future<http.Response> _retryRequest(
    Future<http.Response> Function() request,
  ) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        final response = await request();
        return response;
      } catch (e) {
        attempts++;
        if (attempts == maxRetries) {
          rethrow;
        }
        if (kDebugMode) {
          print(
            'Request failed, retrying in ${retryDelay.inSeconds} seconds... (Attempt $attempts of $maxRetries)',
          );
        }
        await Future.delayed(retryDelay);
      }
    }
    throw Exception('Failed after $maxRetries attempts');
  }

  Future<http.Response> verifyPin(String pin, {bool remember = false}) async {
    return http
        .post(
          _uri('/pin/verify'),
          headers: await _authHeaders(),
          body: jsonEncode({'pin': pin, 'remember': remember}),
        )
        .timeout(timeout);
  }

  Future<http.Response> verifyPIN(Map<String, dynamic> pinData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/pin/verify');
    _logRequest('POST', url, body: pinData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode(pinData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> clearPIN() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/pin/clear');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> createSupportTicket({
    required String subject,
    required String message,
    String? name,
    String? email,
    String? phone,
    File? attachment,
  }) async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/support');

    _logRequest(
      'POST',
      url,
      body: {
        'subject': subject,
        'message': message,
        if (name != null && name.isNotEmpty) 'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (attachment != null) 'attachment': attachment.path,
      },
    );

    if (attachment != null) {
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['subject'] = subject;
      request.fields['message'] = message;
      if (name != null && name.isNotEmpty) request.fields['name'] = name;
      if (email != null && email.isNotEmpty) request.fields['email'] = email;
      if (phone != null && phone.isNotEmpty) request.fields['phone'] = phone;

      request.files.add(
        await http.MultipartFile.fromPath('attachment', attachment.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logResponse(response);
      return response;
    } else {
      final body = {
        'subject': subject,
        'message': message,
        if (name != null && name.isNotEmpty) 'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      };

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      _logResponse(response);
      return response;
    }
  }

  Future<http.Response> fetchSupportTickets() async {
    final token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/support');
    _logRequest('GET', url);

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchSupportTicket(int id) async {
    final token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/support/$id');
    _logRequest('GET', url);

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    _logResponse(response);
    return response;
  }

  Future<http.Response> validatePIN() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final pinToken = prefs.getString('pin_token') ?? '';

    final url = Uri.parse('$baseUrl/pin/validate');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'X-PIN-TOKEN': pinToken,
        'Accept': 'application/json',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<bool> onboarding_signup(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String password,
  ) async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    myLog.log("password $firstName");
    myLog.log("password $lastName");
    myLog.log("password $phoneNumber");
    myLog.log("email $email");
    myLog.log("password $password");

    try {
      print("onboarding_login > $basePath/register");

      final Map<String, String> header = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };

      var response = await http.post(
        headers: header,
        Uri.parse(
          '$baseUrl/register?cache-buster=${fn_generateCacheBuster()}',
        ),
        body: jsonEncode({
          'firstname': firstName,
          'lastname': lastName,
          'email': email,
          "phone_number": phoneNumber,
          'password': password,
          'country_id': 4,
          "role": "vendor",
        }),
      );

      // print("response.bodyString ${response.bodyString}");

      // var body = jsonDecode(response.bodyString ?? '{}');

      //  print("body ${body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        await dataBase.saveFirstName(
          firstName,
        ); //  unawaited(loginOneSignalUser(id, email, token, basePath));
        await dataBase.saveLastName(lastName);
        await dataBase.savePhoneNumber(phoneNumber);
        //await dataBase.saveRecommendedBy(recommended_by)
        // final prefs = await SharedPreferences.getInstance();
        //     final token = prefs.setString('token') ?? '';
        await dataBase.saveEmail(email);

        Get.toNamed(
          '/email-verification',
          arguments: {
            'email': email,
            // 'password': password,
          },
        );
        // await resendOtp({'email': email});
        SnackbarUtils.showSnackbarMessage(
          message: 'An OTP has been sent to your email',
        );

        return true;
      } else {
        // OverlayLoadingProgress.stop();
        // if(jsonDecode(response.bodyString!)['errors'] != {}){
        //   if(jsonDecode(response.bodyString!)['errors']['email'][0] != '' && jsonDecode(response.bodyString!)['errors']['phone_number'][0] == ''){
        //   SnackbarUtils.showSnackbarError(
        //   "Oops", "${jsonDecode(response.bodyString!)['message']}\n ${jsonDecode(response.bodyString!)['errors']['email'][0]}");
        // }else if(jsonDecode(response.bodyString!)['errors']['phone_number'][0] != '' && jsonDecode(response.bodyString!)['errors']['email'][0] == ''){
        //   SnackbarUtils.showSnackbarError(
        //   "Oops", "${jsonDecode(response.bodyString!)['message']}\n ${jsonDecode(response.bodyString!)['errors']['phone_number'][0]}");
        // }
        // SnackbarUtils.showSnackbarError(
        //   "Oops", "${jsonDecode(response.bodyString!)['message']}\n ${jsonDecode(response.bodyString!)['errors']['email'][0]} \n ${jsonDecode(response.bodyString!)['errors']['phone_number'][0]}");

        // }

        SnackbarUtils.showSnackbarError(
          "Oops",
          "${jsonDecode(response.body)['message']}\n ${jsonDecode(response.body)}",
        );
      }

      OverlayLoadingProgress.stop();
    } catch (error) {
      OverlayLoadingProgress.stop();

      SnackbarUtils.showSnackbarError(
        "Oops",
        "Sign up failed! ${error.toString()}",
      );

      myLog.log("Sign up failed! ${error.toString()}");

      return false;
    }
    return false;
  }

  /// send fcm token to backend
  Future<http.Response> sendFcmToken(Map<String, dynamic> replyData) async {
    final token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/api/notifications/token');
    _logRequest('POST', url, body: replyData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(replyData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> googleSignIn({
    required String idToken,
    required String role,
    // String? displayName,
    // String? photoUrl,
  }) async {
    final url = Uri.parse('$baseUrl/google-signin');
    _logRequest('POST', url, body: {
      'id_token': idToken,
      'role': role,
      // if (displayName != null) 'display_name': displayName,
      // if (photoUrl != null) 'photo_url': photoUrl,
    });
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'id_token': idToken,
        'role': role,
        // if (displayName != null) 'display_name': displayName,
        // if (photoUrl != null) 'photo_url': photoUrl,
      }),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> setPin(String pin, String confirmPin) async {
    return http
        .post(
          _uri('/pin/set'),
          headers: await _authHeaders(),
          body: jsonEncode({'pin': pin, 'confirm_pin': confirmPin}),
        )
        .timeout(timeout);
  }

  Future<http.Response> resendOtp(Map<String, dynamic> customerData) async {
    final url = Uri.parse('$basePath/resend-otp');
    _logRequest('POST', url, body: customerData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(customerData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> forgotPassword(
    Map<String, dynamic> customerData,
  ) async {
    final url = Uri.parse('$baseUrl/forgot-password');
    _logRequest('POST', url, body: customerData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(customerData),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> requestPinReset() async {
    return http
        .post(_uri('/pin/request-reset'), headers: await _authHeaders())
        .timeout(timeout);
  }

  Future<http.Response> resetPin(
    String token,
    String pin,
    String confirmPin,
  ) async {
    return http
        .post(
          _uri('/pin/reset'),
          headers: await _authHeaders(),
          body: jsonEncode({
            'token': token,
            'pin': int.tryParse(pin) ?? pin,
            'confirm_pin': int.tryParse(confirmPin) ?? confirmPin,
          }),
        )
        .timeout(timeout);
  }

  Future<http.Response> fetchBanks({String? search}) async {
    return http
        .get(
          _uri('/banks', search != null ? {'search': search} : null),
          headers: await _authHeaders(),
        )
        .timeout(timeout);
  }

  Future<http.Response> resetPassword(Map<String, dynamic> customerData) async {
    final url = Uri.parse('$baseUrl/reset-password');
    _logRequest('POST', url, body: customerData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(customerData),
    );
    _logResponse(response);
    return response;
  }

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: query);

  Future<Map<String, String>> _authHeaders({String? pinToken}) async {
    final db = Get.find<DataBase>();
    final token = await db.getToken();
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (pinToken != null) headers['X-PIN-TOKEN'] = pinToken;
    return headers;
  }

  Future<http.Response> transferToBank(Map<String, dynamic> data) async {
    return http
        .post(
          _uri('/wallet/transfer-to-bank'),
          headers: await _authHeaders(),
          body: jsonEncode(data),
        )
        .timeout(timeout);
  }

  Future<http.Response> fetchCountry() async {
    // var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/country');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchVendorCategories() async {
    var email = await dataBase.getEmail();
    final url = Uri.parse('$baseUrl/vendors/categories');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> saveVendorCategories(List<dynamic> category_ids) async {
    myLog.log('from api client class $category_ids');
    var email = await dataBase.getEmail();

    final url = Uri.parse('$baseUrl/update-vendor-categories/$email');
    _logRequest('POST', url);
    Map<String, dynamic> body = {"category_ids": category_ids};
    final response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchTransactions() async {
    // var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/payments');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchReferal() async {
    var token = await dataBase.getToken();
    final url = Uri.parse('$baseUrl/my-referrals');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchTransaction(int id) async {
    // var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/payments/$id');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchWallet() async {
    // var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/fetch-wallet');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchState() async {
    //var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/states');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> fetchLgas(String name) async {
    // var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/lgas?state=$name');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> updateCheckoutAddress(
    Map<String, dynamic> addressData,
  ) async {
    // var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/addresses/1');
    _logRequest('PUT', url, body: addressData);
    final response = await http.put(
      url,
      body: jsonEncode(addressData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> addCheckoutAddress(
    Map<String, dynamic> addressData,
  ) async {
    //var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/addresses');
    _logRequest('POST', url, body: addressData);
    final response = await http.post(
      url,
      body: jsonEncode(addressData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  Future<http.Response> getCheckoutAddress() async {
    //var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/addresses');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Validate user signup OTP
  Future<http.Response> validateUserSignupOtp(
    Map<String, dynamic> otpData,
  ) async {
    final url = Uri.parse('$baseUrl/validate-otp');
    _logRequest('POST', url, body: otpData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(otpData),
    );
    _logResponse(response);
    return response;
  }

  // Validate user signup Email
  Future<http.Response> validateUserSignupEmail(
    Map<String, dynamic> otpData,
  ) async {
    final url = Uri.parse(
      'https://jaramarket.kenjeffy.com/api/jaram/validate-email',
    );
    _logRequest('POST', url, body: otpData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(otpData),
    );
    _logResponse(response);
    return response;
  }

  // Login user
  Future<http.Response> login(Map<String, dynamic> loginData) async {
    final url = Uri.parse('$baseUrl/login');
    _logRequest('POST', url, body: loginData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(loginData),
    );
    _logResponse(response);
    return response;
  }

  // Validate user login OTP
  Future<http.Response> validateUserLoginOtp(
    Map<String, dynamic> otpData,
  ) async {
    final url = Uri.parse('$baseUrl/validate-otp');
    _logRequest('POST', url, body: otpData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(otpData),
    );
    _logResponse(response);
    return response;
  }

  // Fetch food categories
  Future<http.Response> fetchFoodCategory() async {
    if (Get.isSnackbarOpen) {
      return Future.error('Snackbar is open');
    }
    //final url = Uri.parse('$baseUrl/fetch-ProductCategory');
    //final url = Uri.parse('$baseUrl/fetch/categories-limit-products');
    final url = Uri.parse('$baseUrl/fetch/categories-all-products');

    _logRequest('GET', url);
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    // var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return _retryRequest(() async {
      final response = await http
          .get(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json;',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );
      _logResponse(response);
      return response;
    });
  }

  // Fetch food products
  Future<http.Response> fetchFood() async {
    final url = Uri.parse('$baseUrl/fetch/categories-limit-products');
    _logRequest('GET', url);
    return _retryRequest(() async {
      final response = await http
          .get(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );
      _logResponse(response);
      return response;
    });
  }

  // Fetch available orders
  Future<http.Response> fetchorders() async {
    final url = Uri.parse('$baseUrl/vendor/orders');
    var token = await dataBase.getToken();
    myLog.log('fetching orders with token: $token');
    _logRequest('GET', url);
    return _retryRequest(() async {
      final response = await http
          .get(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );
      _logResponse(response);
      return response;
    });
  }

  Future<http.Response> fetchAcceptedOrders() async {
    final url = Uri.parse('$baseUrl/vendor/orders/accepted');
    var token = await dataBase.getToken();
    _logRequest('GET', url);
    return _retryRequest(() async {
      final response = await http
          .get(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );
      _logResponse(response);
      return response;
    });
  }

  //accept order
  Future<http.Response> acceptedOrders(String itemId, int vendorId) async {
    print(vendorId);
    final url = Uri.parse('$baseUrl/vendor/orders/item/$itemId/decision');
    var token = await dataBase.getToken();
    _logRequest('POST', url);
    return _retryRequest(() async {
      final response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              "status": "accepted", //rejected
              "vendor_id": vendorId, //1 if is admin that is accepted
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );
      _logResponse(response);
      return response;
    });
  }

  //reject order
  Future<http.Response> rejectedOrders(String itemId, int vendorId) async {
    print(vendorId);
    final url = Uri.parse('$baseUrl/vendor/orders/item/$itemId/decision');
    var token = await dataBase.getToken();
    _logRequest('POST', url);
    return _retryRequest(() async {
      final response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              "status": "rejected", //rejected
              "vendor_id": vendorId, //1 if is admin that is accepted
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );
      _logResponse(response);
      return response;
    });
  }

  // Fetch ingredients
  Future<http.Response> fetchIngredients() async {
    final url = Uri.parse('$baseUrl/fetch/ingredients');
    // var token = await dataBase.getToken();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    _logRequest('GET', url);
    return _retryRequest(() async {
      final response = await http
          .get(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );
      _logResponse(response);
      return response;
    });
  }

  // Create order (used in checkout_screen.dart)
  Future<http.Response> createOrder(Map<String, dynamic> orderData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/orders');
    _logRequest('POST', url, body: orderData);
    final response = await http.post(
      url,
      // body: jsonEncode(orderData),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(orderData),
    );
    _logResponse(response);
    return response;
  }

  // Fetch user profile
  Future<http.Response> fetchUserProfile(String email) async {
    final url = Uri.parse('$baseUrl/fetchUserProfile/$email');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Edit user profile
  Future<http.Response> editUserProfile(
    String email,
    Map<String, dynamic> profileData,
  ) async {
    final url = Uri.parse('$baseUrl/edit-user-profile/$email');
    _logRequest('POST', url, body: profileData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(profileData),
    );
    _logResponse(response);
    return response;
  }

  // Get current user
  Future<http.Response> getUser() async {
    final url = Uri.parse('$baseUrl/fetch-user');
    _logRequest('GET', url);
    //final prefs = await SharedPreferences.getInstance();
    //  final token = await dataBase.getToken();  //prefs.getString('token');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new order
  Future<http.Response> postOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/orders');
    _logRequest('POST', url, body: orderData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderData),
    );
    _logResponse(response);
    return response;
  }

  // Get all orders
  Future<http.Response> getOrders() async {
    final url = Uri.parse('$baseUrl/orders');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Cancel an order
  Future<http.Response> cancelOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/cancel');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get cart by ID
  Future<http.Response> getCart(String cartId) async {
    final url = Uri.parse('$baseUrl/carts/$cartId');
    _logRequest('GET', url);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get order by ID
  Future<http.Response> getOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Update order by ID
  Future<http.Response> updateOrder(
    String orderId,
    Map<String, dynamic> orderData,
  ) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    _logRequest('PUT', url, body: orderData);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderData),
    );
    _logResponse(response);
    return response;
  }

  // Delete order by ID
  Future<http.Response> deleteOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get order receipt
  Future<http.Response> getOrderReceipt(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/receipt');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Track order
  Future<http.Response> trackOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/track');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get orders for a specific user
  Future<http.Response> getUserOrders(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/orders');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new payment
  Future<http.Response> createPayment(Map<String, dynamic> paymentData) async {
    final url = Uri.parse('$baseUrl/payments');
    _logRequest('POST', url, body: paymentData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(paymentData),
    );
    _logResponse(response);
    return response;
  }

  // Get all payments
  Future<http.Response> getPayments() async {
    final url = Uri.parse('$baseUrl/payments');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Handle payment callback
  Future<http.Response> handlePaymentCallback(
    Map<String, dynamic> callbackData,
  ) async {
    final url = Uri.parse('$baseUrl/payments/callback');
    _logRequest('GET', url); // Assuming GET, adjust if needed
    final response = await http.get(
      url, // Assuming query parameters are handled elsewhere or not needed for logging body
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Fund wallet
  Future<http.Response> fundWallet(Map<String, dynamic> fundData) async {
    final url = Uri.parse('$baseUrl/wallets/fund');
    _logRequest('POST', url, body: fundData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(fundData),
    );
    _logResponse(response);
    return response;
  }

  // Get all franchises
  Future<http.Response> getFranchises() async {
    final url = Uri.parse('$baseUrl/franchises');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get all users
  Future<http.Response> getUsers() async {
    final url = Uri.parse('$baseUrl/users');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Update a user
  Future<http.Response> updateUser(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    _logRequest('PUT', url, body: userData);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );
    _logResponse(response);
    return response;
  }

  // Delete a user
  Future<http.Response> deleteUser(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Toggle user status
  Future<http.Response> toggleUserStatus(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/toggle-status');
    _logRequest('PATCH', url); // Assuming PATCH, adjust if needed
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Add body here if the PATCH request sends data
    );
    _logResponse(response);
    return response;
  }

  // Get all settings
  Future<http.Response> getSettings() async {
    final url = Uri.parse('$baseUrl/settings');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create or update settings
  Future<http.Response> updateSettings(
    Map<String, dynamic> settingsData,
  ) async {
    final url = Uri.parse('$baseUrl/settings');
    _logRequest(
      'POST',
      url,
      body: settingsData,
    ); // Assuming POST for create/update
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(settingsData),
    );
    _logResponse(response);
    return response;
  }

  // Get all categories
  Future<http.Response> getCategories() async {
    final url = Uri.parse('$baseUrl/categories');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new category
  Future<http.Response> createCategory(
    Map<String, dynamic> categoryData,
  ) async {
    final url = Uri.parse('$baseUrl/categories');
    _logRequest('POST', url, body: categoryData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(categoryData),
    );
    _logResponse(response);
    return response;
  }

  // Update a category
  Future<http.Response> updateCategory(
    String categoryId,
    Map<String, dynamic> categoryData,
  ) async {
    final url = Uri.parse('$baseUrl/categories/$categoryId');
    _logRequest('PUT', url, body: categoryData);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(categoryData),
    );
    _logResponse(response);
    return response;
  }

  // Delete a category
  Future<http.Response> deleteCategory(String categoryId) async {
    final url = Uri.parse('$baseUrl/categories/$categoryId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new food item
  Future<http.Response> createFood(Map<String, dynamic> foodData) async {
    final url = Uri.parse('$baseUrl/foods');
    _logRequest('POST', url, body: foodData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(foodData),
    );
    _logResponse(response);
    return response;
  }

  // Get order reports
  Future<http.Response> getOrderReports() async {
    final url = Uri.parse('$baseUrl/reports/orders');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get payment reports
  Future<http.Response> getPaymentReports() async {
    final url = Uri.parse('$baseUrl/reports/payments');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get user's favorites
  Future<http.Response> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/favorites');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Add to favorites
  Future<http.Response> addToFavorites(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/favorites');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'product_id': productId}),
    );
    _logResponse(response);
    return response;
  }

  // Remove from favorites
  Future<http.Response> removeFromFavorites(int favoriteId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/favorites/$favoriteId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  addFavorite() {}

  logOut() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/logout');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  getCheckoutData(Map<String, dynamic> checkoutData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/payments/initialize-transaction');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      body: jsonEncode(checkoutData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // createOrder(Map<String, dynamic> checkoutData) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token') ?? '';

  //   final url = Uri.parse('$baseUrl/payments/initialize-transaction');
  //   _logRequest('POST', url);
  //   final response = await http.post(
  //     url,
  //     body: jsonEncode(checkoutData),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   _logResponse(response);
  //   return response;
  // }
}

ApiClient apiClient = ApiClient(API_TIMEOUT_DURATION);

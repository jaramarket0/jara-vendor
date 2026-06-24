import 'package:jara_vendor/utils/storage.dart';
import 'package:mime/mime.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:developer' as myLog;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/data/apiClient/apiClient.dart';

class BusinessController extends GetxController {
  ApiClient apiClient = ApiClient(Duration(milliseconds: 60 * 5));
  TextEditingController businessNameController = TextEditingController();

  Future<void> updateVendorProfileBusinessName() async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    //myLog.log(email);
    var email = await dataBase.getEmail();
    try {
      String url =
          '${apiClient.baseUrl}/profile-update/$email'; // Replace with your API endpoint
      Map<String, String> headers = {
        'Accept': 'application/json',

        //'Content-Type': 'multipart/form-data', // Important for multipart
      };

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields['business_name'] = businessNameController.text;

      // if (file1.value != null) {
      //   myLog.log('profile photo adding');
      //   XFile? imageFile = file1.value;
      //   String mimeType = lookupMimeType(imageFile!.path) ?? 'image/jpeg';
      //   String fileName = basename(imageFile.path);

      //   // Convert image to MultipartFile and add it to the request
      //   var multipartFile1 = await http.MultipartFile.fromPath(
      //     'profile_picture', // The name of the field in your API
      //     imageFile.path,
      //     filename: fileName,
      //     contentType:
      //         MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
      //   );
      //   request.files.add(multipartFile1);
      // }

      // Send the request
      var response = await request.send();
      print(response.headers);
      print(response.stream);
      print(response.request);
      myLog.log('Response status: ${response.statusCode}');
      myLog.log('Response headers: ${response.headers}');
      myLog.log('Response request: ${response.request}');
      // var responseBody = await response.stream.bytesToString();
      //   myLog.log('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        // var responseBody = await response.stream.bytesToString();
        // myLog.log('Response Body: $responseBody');
        //   // Refresh profile data
        //   fetchUserProfile();
        //   ScaffoldMessenger.of(Get.context!).showSnackBar(
        //     const SnackBar(content: Text('Profile updated successfully')),
        //   );
        // } else {
        //   ScaffoldMessenger.of(Get.context!).showSnackBar(
        //     SnackBar(content: Text('Failed to update profile: ${response.body}')),
        //   );
        Get.snackbar("Success", "Profile updated successfully");
        myLog.log('Profile updated successfully');

        businessNameController.clear();
        Navigator.pushNamed(Get.context!, '/product-selection');
      } else {
        OverlayLoadingProgress.stop();
        var responseBody = await response.stream.bytesToString();
        print('Error: ${response.statusCode}, Response: $responseBody');
        Get.snackbar("Error:", " ${response.statusCode} - $responseBody");
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      Get.snackbar("Error occurred:", e.toString());
      myLog.log(e.toString());
    } finally {
      OverlayLoadingProgress.stop();
    }
  }
}

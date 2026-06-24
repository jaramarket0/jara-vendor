// import 'package:flutter/material.dart';
// import 'package:get/get_instance/get_instance.dart';
// import 'package:get/route_manager.dart';
// import 'package:jara_vendor/screens/profile_screen/controller/profile_controller.dart';
// import '../../widgets/status_bar.dart';

// ProfileController controller = Get.put(ProfileController());
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const StatusBar(),
//             // Profile header with curved background
//             Container(
//               height: 180,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//             ),
//             // Profile picture (positioned to overlap the curved background)
//             Transform.translate(
//               offset: const Offset(0, -80),
//               child: Center(
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: 160,
//                       height: 160,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.person,
//                           size: 80,
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withAlpha(26), // Changed from withOpacity(0.1)
//                               blurRadius: 8,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: const Icon(
//                           Icons.edit,
//                           size: 24,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Name
//             Transform.translate(
//               offset: const Offset(0, -60),
//               child: const Center(
//                 child: Text(
//                   'Jacob Peter',
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             // Contact Information
//             Transform.translate(
//               offset: const Offset(0, -40),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Contact Information',
//                           style: TextStyle(fontSize: 16, color: Colors.black54),
//                         ),
//                         TextButton(
//                           onPressed: () {},
//                           child: Row(
//                             children: [
//                               const Text(
//                                 'Edit',
//                                 style: TextStyle(
//                                   color: Color(0xFFFF9800),
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                               Icon(
//                                 Icons.arrow_forward_ios,
//                                 size: 14,
//                                 color: Colors.orange.shade700,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: Column(
//                         children: [
//                           _buildInfoRow(
//                             'Phone Number',
//                             '+49 151 23456789',
//                             Icons.phone,
//                             const Color(0xFFFF9800),
//                           ),
//                           const Divider(height: 24),
//                           _buildInfoRow(
//                             'Email Address',
//                             'hello@mystiquelounge.com',
//                             Icons.email,
//                             const Color(0xFFFF9800),
//                           ),
//                           const Divider(height: 24),
//                           _buildInfoRow(
//                             'Address',
//                             '4905 Verla Rapid, South Nicklaus 50971',
//                             Icons.location_on,
//                             const Color(0xFFFF9800),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: Column(
//                         children: [
//                           _buildSettingRow(
//                             'Notifications',
//                             Icons.notifications_none,
//                             true,
//                           ),
//                           const Divider(height: 24),
//                           _buildSettingRow(
//                             'Wallet',
//                             Icons.account_balance_wallet_outlined,
//                             false,
//                             onTap: () {
//                               Navigator.pushNamed(context, '/wallet');
//                             },
//                           ),
//                           const Divider(height: 24),
//                           _buildSettingRow(
//                             'Referral',
//                             Icons.people_outline,
//                             false,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: Column(
//                         children: [
//                           _buildSettingRow(
//                             'Security',
//                             Icons.security_outlined,
//                             false,
//                           ),
//                           const Divider(height: 24),
//                           _buildSettingRow(
//                             'Help & Support',
//                             Icons.help_outline,
//                             false,
//                           ),
//                           const Divider(height: 24),
//                           _buildSettingRow(
//                             'Contact Us',
//                             Icons.message_outlined,
//                             false,
//                           ),
//                           const Divider(height: 24),
//                           _buildSettingRow(
//                             'Privacy Policy',
//                             Icons.lock_outline,
//                             false,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(
//     String title,
//     String value,
//     IconData icon,
//     Color iconColor,
//   ) {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Icon(icon, color: iconColor, size: 24),
//       ],
//     );
//   }

//   Widget _buildSettingRow(
//     String title,
//     IconData icon,
//     bool hasSwitch, {
//     VoidCallback? onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Row(
//         children: [
//           Icon(icon, size: 24, color: Colors.black87),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//           ),
//           if (hasSwitch)
//             const Text(
//               'On',
//               style: TextStyle(
//                 color: Color(0xFFFF9800),
//                 fontWeight: FontWeight.w600,
//               ),
//             )
//           else if (onTap != null)
//             const Icon(
//               Icons.arrow_forward_ios,
//               size: 16,
//               color: Colors.black54,
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_vendor/routes/app_routes.dart';
import 'package:jara_vendor/screens/forget_password_screen/forget_password_screen.dart';
import 'package:jara_vendor/screens/help_and_support/help_and_support.dart';
import 'package:jara_vendor/screens/profile_screen/controller/profile_controller.dart';
import 'package:jara_vendor/screens/success_screen/success_screen.dart';
import 'package:jara_vendor/widgets/avatar_with_edtt.dart';
import 'package:jara_vendor/widgets/custom_button.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

ProfileController controller = Get.put(ProfileController());

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _userProfile = {};

  void _onRefresh() {
    controller.fetchUserProfile();
  }

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    controller.fetchUserProfileByCondition();
  }

  @override
  Widget build(BuildContext context) {
    //    final imageUrl = this.imageUrl;
    //   ImageProvider imageProvider;
    //    if (imageUrl != null && imageUrl.startsWith('/')) {
    //   // Local file image
    //   imageProvider = FileImage(File(imageUrl));
    // } else if (imageUrl != null && imageUrl.startsWith('http')) {
    //   // Network image
    //   imageProvider = NetworkImage(imageUrl);
    // } else {
    //   // Fallback (asset or placeholder)
    //   imageProvider = AssetImage('assets/images/avatar_placeholder.png');
    // }

    return SmartRefresher(
      onRefresh: _onRefresh,
      controller: _refreshController,
      child: Scaffold(
        body: SafeArea(
          child: Obx(() {
            return controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  )
                : !controller.profileModel.status
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.network_check_sharp,
                          size: 74,
                          color: Colors.grey,
                        ),
                        Text(
                          controller.errorMessage!.value,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Text(
                          'Check your internet connection, then drag\n down to refresh page',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 114, 68, 68),
                          ),
                        ),
                        // ElevatedButton(onPressed: (){
                        //   Get.toNamed(AppRoutes.referralScreen);
                        // }, child: Text('referral'))
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -850,
                          left: MediaQuery.of(context).size.width / 2 - 500,
                          right: MediaQuery.of(context).size.width / 2 - 500,
                          child: const CircleAvatar(
                            radius: 500,
                            backgroundColor: Color(0xffEBF0F0),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 80),
                            Obx(
                              () => AvatarWithEdit(
                                avatarRadius: 60,
                                editIconSize: 24,
                                imageUrl:
                                    (controller.file1.value != null &&
                                        controller.file1.value!.path.isNotEmpty)
                                    ? controller.file1.value!.path
                                    : controller.data.profilePicture ??
                                          _userProfile['profile_image'],
                                onEditPressed: () {
                                  // Show dialog to update profile image
                                  _showEditProfileImageDialog();
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              controller.data.name! ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Contact Information',
                                    style: TextStyle(
                                      fontSize: 13,
                                      //(MediaQuery.of(context).size.width / 100 ) * 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showEditContactInfoDialog();
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontFamily: 'Mont',
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_outlined,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ContactInfoCard(
                            //   email: _userProfile['email'] ?? '',
                            //   phone: _userProfile['phone'] ?? '',
                            //   onEditPressed: () {
                            //     // Show dialog to edit contact info
                            //     _showEditContactInfoDialog();
                            //   },
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: const Color.fromARGB(14, 45, 45, 1),
                                  border: Border.all(
                                    width: 1,
                                    color: const Color.fromARGB(
                                      88,
                                      128,
                                      128,
                                      128,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Phone Number',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              controller.data.phoneNumber! ??
                                                  'N/A',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SvgPicture.asset(
                                        //   'assets/images/Vector(5).svg',
                                        //   semanticsLabel: 'Dart Logo',
                                        //   height: 20,
                                        //   width: 20,
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Email Address',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              controller.data.email! ?? 'N/A',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SvgPicture.asset(
                                        //   'assets/images/Group 35689.svg',
                                        //   semanticsLabel: 'Dart Logo',
                                        //   height: 20,
                                        //   width: 20,
                                        // ),
                                        //Icon(Icons.email,color: Colors.amber,size: 20,),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Address',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (controller
                                                        .data
                                                        .contactAddress !=
                                                    null &&
                                                controller
                                                    .data
                                                    .contactAddress!
                                                    .isNotEmpty)
                                              Text(
                                                controller
                                                        .data
                                                        .contactAddress![0]
                                                        .contactAddress! ??
                                                    'N/A',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Mont',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            else
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    AppRoutes
                                                        .checkoutAddressChange,
                                                    arguments: {
                                                      'isFromProfile': true,
                                                    },
                                                  );
                                                },
                                                child: const Text(
                                                  'Click here to set your address',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'Mont',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        // SvgPicture.asset(
                                        //   'assets/images/location.svg',
                                        //   semanticsLabel: 'Dart Logo',
                                        //   height: 20,
                                        //   width: 20,
                                        // ),
                                        // Icon(Icons.location_on,color: Colors.amber,size: 20,),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // const SettingsCard(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: const Color.fromARGB(14, 45, 45, 1),
                                  border: Border.all(
                                    width: 1,
                                    color: const Color.fromARGB(
                                      88,
                                      128,
                                      128,
                                      128,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/alarm.svg',
                                              semanticsLabel: 'Dart Logo',
                                              height: 20,
                                              width: 20,
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              'Notifications',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // SvgPicture.asset('assets/images/Vector(5).svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),
                                        TextButton(
                                          onPressed: () {
                                            Get.snackbar(
                                              'Notification',
                                              'You\'ll start receiving notifications from jara market (Coming Soon)',
                                            );
                                          },
                                          child: const Text(
                                            'on',
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.wallet);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/wallet.svg',
                                                semanticsLabel: 'Dart Logo',
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                'wallet',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.referralS,
                                          arguments:
                                              controller.data.referralCode,
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/referral.svg',
                                                semanticsLabel: 'Dart Logo',
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                'Refer and Earn',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          //
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            //   const AdditionalOptionsCard(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: const Color.fromARGB(14, 45, 45, 1),
                                  border: Border.all(
                                    width: 1,
                                    color: const Color.fromARGB(
                                      88,
                                      128,
                                      128,
                                      128,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.faqScreen);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/security.svg',
                                                semanticsLabel: 'Dart Logo',
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              // Text('Security',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600),),
                                              const Text(
                                                'FAQs',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // SvgPicture.asset('assets/images/Vector(5).svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),
                                          //   TextButton(onPressed: (){}, child: Text('on',style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 18),))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(const HelpAndSupport());
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/help_and_support.svg',
                                                semanticsLabel: 'Dart Logo',
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                'Help and Support',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/contact_us.svg',
                                              semanticsLabel: 'Dart Logo',
                                              height: 20,
                                              width: 20,
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              'Contact Us',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        //
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.privacyPolicyScreen,
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/privacy_policy.svg',
                                                semanticsLabel: 'Dart Logo',
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                'Privacy Policy',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          //
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: const Color.fromARGB(14, 45, 45, 1),
                                  border: Border.all(
                                    width: 1,
                                    color: const Color.fromARGB(
                                      88,
                                      128,
                                      128,
                                      128,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.faqScreen);
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [],
                                      ),
                                    ),
                                    //  const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(const ForgetPasswordScreen());
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/help_and_support.svg',
                                                semanticsLabel: 'Dart Logo',
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                'Reset Password',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        _showSetPINDialog();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/help_and_support.svg',
                                                semanticsLabel: 'Dart Logo',
                                                height: 20,
                                                width: 20,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'Transaction PIN',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        controller.logOut();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/privacy_policy.svg',
                                                semanticsLabel: 'Dart Logo',
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                'Log Out',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          //
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }

  void _showEditProfileImageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Update Profile Picture',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: 'Choose from Gallery',
              onPressed: () {
                Navigator.pop(context);
                controller.obtainImageFromGallery();
              },
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Take a Photo',
              onPressed: () {
                Navigator.pop(context);
                controller.obtainImageFromCamera();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showEditContactInfoDialog() {
    final TextEditingController phoneController = TextEditingController(
      text: _userProfile['phone'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Contact Information',
          style: TextStyle(fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.firstNameController,
              decoration: InputDecoration(
                prefix: const Icon(Icons.person, color: Colors.amber),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(width: 1, color: Colors.amber),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color(0xff9E9E9E),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color(0xff9E9E9E),
                  ),
                ),
                labelText: controller.data.firstname,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.lastNameController,
              decoration: InputDecoration(
                prefix: const Icon(Icons.person, color: Colors.amber),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(width: 1, color: Colors.amber),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color(0xff9E9E9E),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color(0xff9E9E9E),
                  ),
                ),
                labelText: controller.data.lastname,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.phoneController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone, color: Colors.amber),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(width: 1, color: Colors.amber),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color(0xff9E9E9E),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color(0xff9E9E9E),
                  ),
                ),
                labelText: controller.data.phoneNumber,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.firstNameController.text.isEmpty ||
                  controller.lastNameController.text.isEmpty ||
                  controller.phoneController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'All fields must be provided',
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
                return;
              }
              Navigator.pop(context);
              controller.updateUserProfile();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSetPINDialog() {
    controller.pinController.clear();
    controller.confirmPinController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Set Transaction PIN',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set a 4-digit PIN for secure transactions',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                prefix: Icon(Icons.lock, color: Colors.amber),
                hintText: 'Enter 4-digit PIN',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1, color: Colors.amber),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1, color: Color(0xff9E9E9E)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1, color: Color(0xff9E9E9E)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                prefix: Icon(Icons.lock, color: Colors.amber),
                hintText: 'Confirm PIN',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1, color: Colors.amber),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1, color: Color(0xff9E9E9E)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1, color: Color(0xff9E9E9E)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          Obx(
            () => TextButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                      if (controller.pinController.text.isEmpty ||
                          controller.confirmPinController.text.isEmpty) {
                        Get.snackbar('Error', 'Both fields are required');
                        return;
                      }
                      Navigator.pop(context);
                      controller.setPIN(
                        controller.pinController.text,
                        controller.confirmPinController.text,
                      );
                    },
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    )
                  : const Text('Set PIN'),
            ),
          ),
        ],
      ),
    );
  }
}

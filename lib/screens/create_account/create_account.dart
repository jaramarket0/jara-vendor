import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';
import 'package:jara_vendor/data/apiClient/auth_service.dart';
import 'package:jara_vendor/screens/create_account/controller/create_account_controller.dart';
import 'package:jara_vendor/screens/login/login.dart';
import '../../widgets/status_bar.dart';

CreateAccountController controller = Get.put(CreateAccountController());

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  bool _agreeToTerms = false;
  bool _isPasswordVisible = false;
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  // final TextEditingController _firstNameController = TextEditingController();
  // final TextEditingController _lastNameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _referralCodeController = TextEditingController(); // Add referral code controller
  // final ApiService _apiService = ApiService();
  String? _errorFirstName;
  String? _errorLastName;
  String? _errorEmail;
  String? _errorPassword;
  String? _errorPhoneNumber;

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorEmail = 'Email is required';
      } else if (!value.contains('@')) {
        _errorEmail = 'Enter a valid email';
      } else {
        _errorEmail = null;
      }
    });
  }

  void _validatePhoneNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorPhoneNumber = 'Phone number is required';
      } else if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
        _errorPhoneNumber = 'Enter a valid phone number';
      } else {
        _errorPhoneNumber = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorPassword = 'Password is required';
      } else if (value.length < 8) {
        _errorPassword = 'Password must be at least 8 characters';
      } else {
        _errorPassword = null;
      }
    });
  }

  void _validateFirstName(String value) {
    setState(() {
      if (value.trim().isEmpty || value == null) {
        _errorFirstName = 'First name is required';
      } else if (value.length < 2) {
        _errorFirstName = 'First name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
        _errorFirstName = 'First name can only contain letters';
      } else if (value.contains(RegExp(r'\d'))) {
        _errorFirstName = 'First name cannot contain numbers';
      } else if (value.contains(RegExp(r'[@!#\$%^&*(),.?":{}|<>]'))) {
        _errorFirstName = 'First name cannot contain special characters';
      } else {
        _errorFirstName = null;
      }
    });
  }

  void _validateLastName(String value) {
    setState(() {
      if (value.trim().isEmpty || value == null) {
        _errorLastName = 'Last name is required';
      } else if (value.length < 2) {
        _errorLastName = 'Last name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
        _errorLastName = 'Last name can only contain letters';
      } else if (value.contains(RegExp(r'\d'))) {
        _errorLastName = 'Last name cannot contain numbers';
      } else if (value.contains(RegExp(r'[@!#\$%^&*(),.?":{}|<>]'))) {
        _errorLastName = 'Last name cannot contain special characters';
      } else {
        _errorLastName = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.firstNameController.addListener(_validateForm);
    controller.lastNameController.addListener(_validateForm);
    controller.emailController.addListener(_validateForm);
    controller.passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final firstName = controller.firstNameController.text;
    final lastName = controller.lastNameController.text;
    final email = controller.emailController.text;
    final password = controller.passwordController.text;
    final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    final passwordValid = password.length >= 8;

    setState(() {
      _isButtonEnabled =
          firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          emailValid &&
          passwordValid &&
          _agreeToTerms;
    });
  }

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusBar(),
                const SizedBox(height: 24),
                const Text(
                  'Create an account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome! please enter your details.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextField(
                  onChanged: (value) {
                    _validateFirstName(value);
                  },
                  controller: controller.firstNameController,
                  decoration: InputDecoration(
                    errorText: _errorFirstName,
                    labelText: 'Enter your First Name',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    _validateLastName(value);
                  },
                  controller: controller.lastNameController,
                  decoration: InputDecoration(
                    errorText: _errorLastName,
                    labelText: 'Enter your Last Name',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    _validateEmail(value);
                  },
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    errorText: _errorEmail,
                    labelText: 'Enter your Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    _validatePhoneNumber(value);
                  },
                  controller: controller.phoneNumberController,
                  decoration: InputDecoration(
                    errorText: _errorPhoneNumber,
                    labelText: 'Enter your Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    _validatePassword(value);
                  },
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: !_isPasswordVisible
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: _isPasswordVisible,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                          _validateForm();
                        });
                      },
                      activeColor: const Color(0xFFFF9800),
                    ),
                    const Expanded(
                      child: Text(
                        'Agree To Terms Of Services & Privacy Policy',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => (_isButtonEnabled && !_isLoading)
                      ? controller.processSignUp()
                      : null, // () { ()
                  // Navigator.pushNamed(context, '/email-verification');
                  //  controller.processSignUp();
                  //},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'or sign up with',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSocialButton(
                  'Continue with Google',
                  'assets/google_logo.png',
                  () {
                    authController.loginWithGoogle();
                  },
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  'Continue with Apple',
                  'assets/apple_logo.png',
                  () {},
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  'Continue with facebook',
                  'assets/facebook_logo.png',
                  () {},
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(
                              color: Color(0xFFFF9800),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Are you a client looking to book an appointment',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Go to Qwik Reserve for client',
                    style: TextStyle(
                      color: Color(0xFFFF9800),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    String text,
    String iconPath,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, height: 24, width: 24),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}

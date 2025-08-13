// import 'package:flutter/material.dart';
// import 'package:myapp/login_page.dart';
// import 'package:myapp/therapist_screen.dart';
// import 'services/api_service.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _formKey = GlobalKey<FormState>();
//   final passwordController = TextEditingController();
//   final passwordConfirmController = TextEditingController();
//   final usernameController = TextEditingController();
//   final emailController = TextEditingController();

//   String userType = "User";
//   bool isPasswordVisible = false;
//   bool isConfirmPasswordVisible = false;

//   @override
//   void dispose() {
//     passwordController.dispose();
//     passwordConfirmController.dispose();
//     usernameController.dispose();
//     emailController.dispose();
//     super.dispose();
//   }

//   void validateAndSignup() async {
//     if (!_formKey.currentState!.validate()) return;

//     final username = usernameController.text.trim();
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     final result = await ApiService.signup(username, email, password, userType);

//     if (result['success']) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Signup successful!')),
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } else {
//       showAlert("Signup Error", result['message']);
//     }
//   }

//   void showAlert(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Gradient
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color.fromRGBO(255, 226, 159, 1), // Light yellow
//                   Color(0xFFFFC0CB), // Light pink
//                 ],
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const SizedBox(height: 80), // Space for better alignment
//                   _header(),
//                   const SizedBox(height: 20),
//                   _inputFields(),
//                   const SizedBox(height: 20),
//                   _signupButton(),
//                   const SizedBox(height: 20),
//                   _alreadyHaveAccount(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _header() {
//     return Column(
//       children: const [
//         Text(
//           "Create Your Account",
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: 8),
//         Text(
//           "Sign up to join our community",
//           style: TextStyle(fontSize: 16, color: Colors.black54),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   // Widget _inputFields() {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.stretch,
//   //     children: [
//   //       DropdownButtonFormField<String>(
//   //         value: userType,
//   //         decoration: InputDecoration(
//   //           filled: true,
//   //           fillColor: Colors.grey[200],
//   //           border: OutlineInputBorder(
//   //             borderRadius: BorderRadius.circular(30),
//   //             borderSide: BorderSide.none,
//   //           ),
//   //         ),
//   //         items: ["User", "Therapist"]
//   //             .map((type) => DropdownMenuItem(value: type, child: Text(type)))
//   //             .toList(),
//   //         onChanged: (value) {
//   //           setState(() {
//   //             userType = value!;
//   //           });
//   //         },
//   //       ),
//   //       const SizedBox(height: 20),
//   //       TextFormField(
//   //         controller: usernameController,
//   //         decoration: const InputDecoration(
//   //           hintText: "Username",
//   //           prefixIcon: Icon(Icons.person, color: Colors.purple),
//   //         ),
//   //         validator: (value) =>
//   //             value == null || value.length < 3 ? "Username must be at least 3 characters" : null,
//   //       ),
//   //       const SizedBox(height: 20),
//   //       TextFormField(
//   //         controller: emailController,
//   //         decoration: const InputDecoration(
//   //           hintText: "Email",
//   //           prefixIcon: Icon(Icons.email, color: Colors.purple),
//   //         ),
//   //         validator: (value) {
//   //           final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//   //           return value == null || !emailRegex.hasMatch(value) ? "Enter a valid email address" : null;
//   //         },
//   //       ),
//   //       const SizedBox(height: 20),
//   //       TextFormField(
//   //         controller: passwordController,
//   //         obscureText: !isPasswordVisible,
//   //         decoration: InputDecoration(
//   //           hintText: "Password",
//   //           prefixIcon: const Icon(Icons.lock, color: Colors.purple),
//   //           suffixIcon: IconButton(
//   //             icon: Icon(
//   //               isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//   //               color: Colors.purple,
//   //             ),
//   //             onPressed: () {
//   //               setState(() {
//   //                 isPasswordVisible = !isPasswordVisible;
//   //               });
//   //             },
//   //           ),
//   //         ),
//   //         validator: (value) =>
//   //             value == null || value.length < 6 ? "Password must be at least 6 characters long" : null,
//   //       ),
//   //       const SizedBox(height: 20),
//   //       TextFormField(
//   //         controller: passwordConfirmController,
//   //         obscureText: !isConfirmPasswordVisible,
//   //         decoration: InputDecoration(
//   //           hintText: "Confirm Password",
//   //           prefixIcon: const Icon(Icons.lock, color: Colors.purple),
//   //           suffixIcon: IconButton(
//   //             icon: Icon(
//   //               isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
//   //               color: Colors.purple,
//   //             ),
//   //             onPressed: () {
//   //               setState(() {
//   //                 isConfirmPasswordVisible = !isConfirmPasswordVisible;
//   //               });
//   //             },
//   //           ),
//   //         ),
//   //         validator: (value) =>
//   //             value != passwordController.text ? "Passwords do not match" : null,
//   //       ),
//   //     ],
//   //   );
//   // }
//   Widget _inputFields() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.stretch,
//     children: [
//       DropdownButtonFormField<String>(
//         value: userType,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.grey[200],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         items: ["User", "Therapist"]
//             .map((type) => DropdownMenuItem(value: type, child: Text(type)))
//             .toList(),
//         onChanged: (value) {
//           setState(() {
//             userType = value!;
//           });

//           // Redirect to a new screen when "Therapist" is selected
//           if (value == "Therapist") {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => CreateTherapistPage()), // Replace TherapistScreen with your actual screen widget
//             );
//           }
//         },
//       ),
//       const SizedBox(height: 20),
//       TextFormField(
//         controller: usernameController,
//         decoration: const InputDecoration(
//           hintText: "Username",
//           prefixIcon: Icon(Icons.person, color: Colors.purple),
//         ),
//         validator: (value) =>
//             value == null || value.length < 3 ? "Username must be at least 3 characters" : null,
//       ),
//       const SizedBox(height: 20),
//       TextFormField(
//         controller: emailController,
//         decoration: const InputDecoration(
//           hintText: "Email",
//           prefixIcon: Icon(Icons.email, color: Colors.purple),
//         ),
//         validator: (value) {
//           final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//           return value == null || !emailRegex.hasMatch(value) ? "Enter a valid email address" : null;
//         },
//       ),
//       const SizedBox(height: 20),
//       TextFormField(
//         controller: passwordController,
//         obscureText: !isPasswordVisible,
//         decoration: InputDecoration(
//           hintText: "Password",
//           prefixIcon: const Icon(Icons.lock, color: Colors.purple),
//           suffixIcon: IconButton(
//             icon: Icon(
//               isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//               color: Colors.purple,
//             ),
//             onPressed: () {
//               setState(() {
//                 isPasswordVisible = !isPasswordVisible;
//               });
//             },
//           ),
//         ),
//         validator: (value) =>
//             value == null || value.length < 6 ? "Password must be at least 6 characters long" : null,
//       ),
//       const SizedBox(height: 20),
//       TextFormField(
//         controller: passwordConfirmController,
//         obscureText: !isConfirmPasswordVisible,
//         decoration: InputDecoration(
//           hintText: "Confirm Password",
//           prefixIcon: const Icon(Icons.lock, color: Colors.purple),
//           suffixIcon: IconButton(
//             icon: Icon(
//               isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
//               color: Colors.purple,
//             ),
//             onPressed: () {
//               setState(() {
//                 isConfirmPasswordVisible = !isConfirmPasswordVisible;
//               });
//             },
//           ),
//         ),
//         validator: (value) =>
//             value != passwordController.text ? "Passwords do not match" : null,
//       ),
//     ],
//   );
// }

//   Widget _signupButton() {
//     return ElevatedButton(
//       onPressed: validateAndSignup,
//       style: ElevatedButton.styleFrom(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         backgroundColor: Colors.deepPurple,
//         elevation: 5,
//       ),
//       child: const Text(
//         "Sign Up",
//         style: TextStyle(fontSize: 20,color: Colors.black, fontWeight: FontWeight.bold),

//       ),
//     );
//   }

//   Widget _alreadyHaveAccount() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text(
//           "Already have an account? ",
//           style: TextStyle(color: Colors.black54),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const LoginPage()),
//             );
//           },
//           child: const Text(
//             "Login",
//             style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/therapist_screen.dart';
import 'services/api_service.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/components/modern_input.dart';
import 'package:myapp/components/modern_button.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/ThemeProvider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  String therapistType = "Therapist";
  String userType = "User";

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {
    passwordController.dispose();
    passwordConfirmController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void validateAndSignup() async {
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed");
      return;
    }

    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print(
        "Attempting to sign up with: username=$username, email=$email, password=$password");

    try {
      final result =
          await ApiService.signup(username, email, password, userType);
      print("API Response: $result");

      if (result['success']) {
        print("Signup successful, navigating to LoginPage");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Display the error message from the API response
        showAlert("Signup Error",
            result['message'] ?? "Signup failed. Please try again.");
      }
    } catch (e) {
      print("Error during signup: $e");
      showAlert("Signup Error", "An error occurred. Please try again.");
    }
  }

  void showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showTherapistInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Therapist Registration'),
        content: const Text(
          'You have selected Therapist account type. After completing this signup, you can apply to become a therapist through the app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTherapistPage(),
                ),
              );
            },
            child: const Text("Apply Now"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: themeProvider.getBackgroundGradient(),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppTheme.spacingXL),
                      _header(),
                      const SizedBox(height: AppTheme.spacingXL),
                      _inputFields(),
                      const SizedBox(height: AppTheme.spacingL),
                      _signupButton(),
                      const SizedBox(height: AppTheme.spacingXL),
                      _alreadyHaveAccount(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingXL),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.spa_outlined,
            size: 64,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppTheme.spacingXL),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.primaryGradient.createShader(bounds),
          child: const Text(
            "Join MindEase",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Text(
          "Start your wellness journey today",
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _inputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: AppTheme.softShadow,
          ),
          child: DropdownButtonFormField<String>(
            value: userType,
            decoration: const InputDecoration(
              labelText: "Account Type",
              prefixIcon: Icon(Icons.account_circle_outlined,
                  color: AppTheme.secondaryColor),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingM,
              ),
            ),
            items: ["User", "Therapist"]
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type == "User" ? "Patient" : "Therapist",
                        style: AppTheme.bodyLarge,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                userType = value!;
              });

              // Show info dialog when "Therapist" is selected
              if (value == "Therapist") {
                _showTherapistInfoDialog();
              }
            },
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        ModernInput(
          label: "Username",
          hint: "Enter your username",
          controller: usernameController,
          prefixIcon: Icons.person_outline,
          validator: (value) => value == null || value.length < 3
              ? "Username must be at least 3 characters"
              : null,
        ),
        const SizedBox(height: AppTheme.spacingM),
        ModernInput(
          label: "Email Address",
          hint: "Enter your email",
          controller: emailController,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            return value == null || !emailRegex.hasMatch(value)
                ? "Enter a valid email address"
                : null;
          },
        ),
        const SizedBox(height: AppTheme.spacingM),
        ModernInput(
          label: "Password",
          hint: "Enter your password",
          controller: passwordController,
          prefixIcon: Icons.lock_outline,
          suffixIcon:
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          onSuffixIconPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          obscureText: !isPasswordVisible,
          validator: (value) => value == null || value.length < 6
              ? "Password must be at least 6 characters long"
              : null,
        ),
        const SizedBox(height: AppTheme.spacingM),
        ModernInput(
          label: "Confirm Password",
          hint: "Re-enter your password",
          controller: passwordConfirmController,
          prefixIcon: Icons.lock_outline,
          suffixIcon: isConfirmPasswordVisible
              ? Icons.visibility
              : Icons.visibility_off,
          onSuffixIconPressed: () {
            setState(() {
              isConfirmPasswordVisible = !isConfirmPasswordVisible;
            });
          },
          obscureText: !isConfirmPasswordVisible,
          validator: (value) => value != passwordController.text
              ? "Passwords do not match"
              : null,
        ),
      ],
    );
  }

  Widget _signupButton() {
    return PrimaryButton(
      text: "Create Account",
      onPressed: validateAndSignup,
      icon: Icons.person_add,
    );
  }

  Widget _alreadyHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: AppTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

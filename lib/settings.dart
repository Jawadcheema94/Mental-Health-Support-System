// import 'package:flutter/material.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//         backgroundColor: Colors.purple, // Set the app bar color to purple
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // This will navigate back to the previous screen
//           },
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color.fromRGBO(255, 226, 159, 1), // Light yellow
//               Color(0xFFFFC0CB), // Light pink
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: ListView(
//             padding: const EdgeInsets.all(16.0),
//             children: [
//               const Text(
//                 '',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.purple,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               ListTile(
//                 leading: const Icon(Icons.person, color: Colors.purple),
//                 title: const Text('Profile'),
//                 subtitle: const Text('Update your personal details'),
//                 onTap: () {
//                   // Navigate to profile update screen
//                 },
//               ),
//               const Divider(),

//               ListTile(
//                 leading: const Icon(Icons.notifications, color: Colors.purple),
//                 title: const Text('Notifications'),
//                 subtitle: const Text('Manage app notifications and reminders'),
//                 onTap: () {
//                   // Navigate to notifications settings
//                 },
//               ),
//               const Divider(),

//               ListTile(
//                 leading: const Icon(Icons.color_lens, color: Colors.purple),
//                 title: const Text('Theme'),
//                 subtitle: const Text('Choose light or dark mode'),
//                 onTap: () {
//                   // Navigate to theme settings
//                 },
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.language, color: Colors.purple),
//                 title: const Text('Language'),
//                 subtitle: const Text('Select your preferred language'),
//                 onTap: () {
//                   // Navigate to language settings
//                 },
//               ),
//               const Divider(),

//               ListTile(
//                 leading: const Icon(Icons.lock, color: Colors.purple),
//                 title: const Text('Security'),
//                 subtitle: const Text('Manage PIN and biometric settings'),
//                 onTap: () {
//                   // Navigate to security settings
//                 },
//               ),
//               const Divider(),

//               ListTile(
//                 leading: const Icon(Icons.info, color: Colors.purple),
//                 title: const Text('About'),
//                 subtitle: const Text('Learn more about the app'),
//                 onTap: () {
//                   // Navigate to about screen
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.help, color: Colors.purple),
//                 title: const Text('Support'),
//                 subtitle: const Text('Contact support or view FAQs'),
//                 onTap: () {
//                   // Navigate to support screen
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String username = '';
//   String email = '';
//   String role = '';
//   String password = '';
//   String confirmPassword = '';
//   File? _profileImage;
//   bool _isLoading = false;
//   String? _errorMessage;
//   String? _successMessage;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch initial user data (mocked for now, replace with actual API call)
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     // Replace with actual API call to fetch user data
//     setState(() {
//       username = 'current_user'; // Mocked data
//       email = 'user@example.com';
//       role = 'user';
//     });
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> updateUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//       _successMessage = null;
//     });

//     try {
//       final response = await http.put(
//         Uri.parse('YOUR_API_BASE_URL/users/${username}'), // Replace with actual API URL
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': username,
//           'email': email,
//           'role': role,
//         }),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _successMessage = 'Profile updated successfully';
//         });
//       } else {
//         setState(() {
//           _errorMessage = jsonDecode(response.body)['message'] ?? 'Failed to update profile';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'An error occurred: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> deleteUser() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//       _successMessage = null;
//     });

//     try {
//       final response = await http.delete(
//         Uri.parse('YOUR_API_BASE_URL/users/${username}'), // Replace with actual API URL
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _successMessage = 'Account deleted successfully';
//           // Optionally navigate away or reset form
//         });
//       } else {
//         setState(() {
//           _errorMessage = jsonDecode(response.body)['message'] ?? 'Failed to delete account';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'An error occurred: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile Settings'),
//         backgroundColor: Colors.purple,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color.fromRGBO(255, 226, 159, 1),
//               Color(0xFFFFC0CB),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: ListView(
//                 children: [
//                   // Profile Picture
//                   Center(
//                     child: GestureDetector(
//                       onTap: _pickImage,
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
//                         child: _profileImage == null
//                             ? const Icon(Icons.person, size: 50, color: Colors.purple)
//                             : null,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Center(
//                     child: TextButton(
//                       onPressed: _pickImage,
//                       child: const Text(
//                         'Change Profile Picture',
//                         style: TextStyle(color: Colors.purple),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Username
//                   TextFormField(
//                     initialValue: username,
//                     decoration: const InputDecoration(
//                       labelText: 'Username',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.person, color: Colors.purple),
//                     ),
//                     onChanged: (value) => setState(() => username = value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a username';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // Email
//                   TextFormField(
//                     initialValue: email,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.email, color: Colors.purple),
//                     ),
//                     onChanged: (value) => setState(() => email = value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter an email';
//                       }
//                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // Role
//                   DropdownButtonFormField<String>(
//                     value: role.isNotEmpty ? role : null,
//                     decoration: const InputDecoration(
//                       labelText: 'Role',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.work, color: Colors.purple),
//                     ),
//                     items: ['user', 'therapist'].map((String role) {
//                       return DropdownMenuItem<String>(
//                         value: role,
//                         child: Text(role),
//                       );
//                     }).toList(),
//                     onChanged: (value) => setState(() => role = value!),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please select a role';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // Password
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'New Password',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.lock, color: Colors.purple),
//                     ),
//                     obscureText: true,
//                     onChanged: (value) => setState(() => password = value),
//                     validator: (value) {
//                       if (value != null && value.isNotEmpty && value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // Confirm Password
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: 'Confirm Password',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.lock, color: Colors.purple),
//                     ),
//                     obscureText: true,
//                     onChanged: (value) => setState(() => confirmPassword = value),
//                     validator: (value) {
//                       if (value != null && value.isNotEmpty && value != password) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Error/Success Messages
//                   if (_errorMessage != null)
//                     Text(
//                       _errorMessage!,
//                       style: const TextStyle(color: Colors.red),
//                       textAlign: TextAlign.center,
//                     ),
//                   if (_successMessage != null)
//                     Text(
//                       _successMessage!,
//                       style: const TextStyle(color: Colors.green),
//                       textAlign: TextAlign.center,
//                     ),
//                   const SizedBox(height: 20),

//                   // Update Button
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : updateUser,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.purple,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             'Update Profile',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Delete Account Button
//                   OutlinedButton(
//                     onPressed: _isLoading
//                         ? null
//                         : () {
//                             showDialog(
//                               context: context,
//                               builder: (context) => AlertDialog(
//                                 title: const Text('Delete Account'),
//                                 content: const Text(
//                                     'Are you sure you want to delete your account? This action cannot be undone.'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: const Text('Cancel'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                       deleteUser();
//                                     },
//                                     child: const Text(
//                                       'Delete',
//                                       style: TextStyle(color: Colors.red),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Colors.red),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: const Text(
//                       'Delete Account',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 226, 159, 1),
              Color(0xFFFFC0CB),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.purple),
                title: const Text('Update Profile'),
                subtitle: const Text('Update your personal details'),
                onTap: () {
                  // Replace 'user_id' with the actual user ID (a valid MongoDB ObjectId, e.g., '507f1f77bcf86cd799439011')
                  // This ID should come from your authentication flow (e.g., user._id from login response)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const UpdateUserScreen(userId: 'user_id'),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.purple),
                title: const Text('Change Password'),
                subtitle: const Text('Update your password'),
                onTap: () {
                  // Replace 'user_id' with the actual user ID (a valid MongoDB ObjectId, e.g., '507f1f77bcf86cd799439011')
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ChangePasswordScreen(userId: 'user_id'),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.purple),
                title: const Text('Notifications'),
                subtitle: const Text('Manage app notifications and reminders'),
                onTap: () {
                  // Navigate to notifications settings
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.color_lens, color: Colors.purple),
                title: const Text('Theme'),
                subtitle: const Text('Choose light or dark mode'),
                onTap: () {
                  // Navigate to theme settings
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.purple),
                title: const Text('Language'),
                subtitle: const Text('Select your preferred language'),
                onTap: () {
                  // Navigate to language settings
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.purple),
                title: const Text('Security'),
                subtitle: const Text('Manage PIN and biometric settings'),
                onTap: () {
                  // Navigate to security settings
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.purple),
                title: const Text('About'),
                subtitle: const Text('Learn more about the app'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.purple),
                title: const Text('Support'),
                subtitle: const Text('Contact support or view FAQs'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SupportScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateUserScreen extends StatefulWidget {
  final String userId;
  const UpdateUserScreen({super.key, required this.userId});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String role = '';
  File? _profileImage;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/users/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          username = userData['username'] ?? '';
          email = userData['email'] ?? '';
          role = userData['role'] ?? 'user';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = jsonDecode(response.body)['message'] ??
              'Failed to fetch user data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching user data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/users/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _successMessage = 'Profile updated successfully';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = jsonDecode(response.body)['message'] ??
              'Failed to update profile';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating profile: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> deleteUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/users/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _successMessage = 'Account deleted successfully';
          _isLoading = false;
          Navigator.pop(context);
        });
      } else {
        setState(() {
          _errorMessage = jsonDecode(response.body)['message'] ??
              'Failed to delete account';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error deleting account: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final double paddingValue = isLargeScreen ? 24.0 : 16.0;
    final double fontSize = isLargeScreen ? 18.0 : 16.0;
    final double iconSize = isLargeScreen ? 60.0 : 50.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 226, 159, 1),
              Color(0xFFFFC0CB),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.purple))
                : Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: iconSize,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? Icon(Icons.person,
                                      size: iconSize, color: Colors.purple)
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: paddingValue / 2),
                        Center(
                          child: TextButton(
                            onPressed: _pickImage,
                            child: Text(
                              'Change Profile Picture',
                              style: TextStyle(
                                  color: Colors.purple, fontSize: fontSize),
                            ),
                          ),
                        ),
                        SizedBox(height: paddingValue),
                        TextFormField(
                          initialValue: username,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.person, color: Colors.purple),
                          ),
                          style: TextStyle(fontSize: fontSize),
                          onChanged: (value) =>
                              setState(() => username = value),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: paddingValue),
                        TextFormField(
                          initialValue: email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email, color: Colors.purple),
                          ),
                          style: TextStyle(fontSize: fontSize),
                          onChanged: (value) => setState(() => email = value),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: paddingValue),
                        DropdownButtonFormField<String>(
                          value: role.isNotEmpty ? role : null,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.work, color: Colors.purple),
                          ),
                          style: TextStyle(fontSize: fontSize),
                          items: ['user', 'admin'].map((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role,
                                  style: TextStyle(fontSize: fontSize)),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => role = value!),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a role';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: paddingValue),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                                color: Colors.red, fontSize: fontSize),
                            textAlign: TextAlign.center,
                          ),
                        if (_successMessage != null)
                          Text(
                            _successMessage!,
                            style: TextStyle(
                                color: Colors.green, fontSize: fontSize),
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: paddingValue),
                        ElevatedButton(
                          onPressed: _isLoading ? null : updateUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding:
                                EdgeInsets.symmetric(vertical: paddingValue),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  'Update Profile',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: fontSize),
                                ),
                        ),
                        SizedBox(height: paddingValue),
                        OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Account'),
                                      content: const Text(
                                          'Are you sure you want to delete your account? This action cannot be undone.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            deleteUser();
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding:
                                EdgeInsets.symmetric(vertical: paddingValue),
                          ),
                          child: Text(
                            'Delete Account',
                            style: TextStyle(
                                color: Colors.red, fontSize: fontSize),
                          ),
                        ),
                        SizedBox(height: paddingValue),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  final String userId;
  const ChangePasswordScreen({super.key, required this.userId});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String id = '';
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please provide both old and new passwords';
      });
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('userId') ?? '0';
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/users/change-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _successMessage = 'Password updated successfully';
          oldPassword = '';
          newPassword = '';
          confirmPassword = '';
          _isLoading = false;
        });
      } else {
        final errorMsg =
            jsonDecode(response.body)['message'] ?? 'Failed to update password';
        setState(() {
          _errorMessage = errorMsg;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating password: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final double paddingValue = isLargeScreen ? 24.0 : 16.0;
    final double fontSize = isLargeScreen ? 18.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 226, 159, 1),
              Color(0xFFFFC0CB),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.purple))
                : Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Old Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock, color: Colors.purple),
                          ),
                          style: TextStyle(fontSize: fontSize),
                          obscureText: true,
                          onChanged: (value) =>
                              setState(() => oldPassword = value),
                        ),
                        SizedBox(height: paddingValue),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock, color: Colors.purple),
                          ),
                          style: TextStyle(fontSize: fontSize),
                          obscureText: true,
                          onChanged: (value) =>
                              setState(() => newPassword = value),
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: paddingValue),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Confirm New Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock, color: Colors.purple),
                          ),
                          style: TextStyle(fontSize: fontSize),
                          obscureText: true,
                          onChanged: (value) =>
                              setState(() => confirmPassword = value),
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value != newPassword) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: paddingValue),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                                color: Colors.red, fontSize: fontSize),
                            textAlign: TextAlign.center,
                          ),
                        if (_successMessage != null)
                          Text(
                            _successMessage!,
                            style: TextStyle(
                                color: Colors.green, fontSize: fontSize),
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: paddingValue),
                        ElevatedButton(
                          onPressed: _isLoading ? null : changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding:
                                EdgeInsets.symmetric(vertical: paddingValue),
                          ),
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                                color: Colors.white, fontSize: fontSize),
                          ),
                        ),
                        SizedBox(height: paddingValue),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final double titleFontSize = isLargeScreen ? 28 : 24;
    final double bodyFontSize = isLargeScreen ? 18 : 16;
    final double iconSize = isLargeScreen ? 32 : 24;
    final double paddingValue = isLargeScreen ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 226, 159, 1),
              Color(0xFFFFC0CB),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(paddingValue),
            children: [
              Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: paddingValue),
              Text(
                'For any issues or inquiries, please reach out to our support team via email:',
                style: TextStyle(fontSize: bodyFontSize, color: Colors.black87),
              ),
              SizedBox(height: paddingValue),
              ListTile(
                leading:
                    Icon(Icons.email, color: Colors.purple, size: iconSize),
                title: Text(
                  'bscs2112134@szabist.pk',
                  style: TextStyle(fontSize: bodyFontSize),
                ),
                onTap: () {
                  // Optionally add email client launch functionality
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.email, color: Colors.purple, size: iconSize),
                title: Text(
                  'bscs2112117@szabist.pk',
                  style: TextStyle(fontSize: bodyFontSize),
                ),
                onTap: () {
                  // Optionally add email client launch functionality
                },
              ),
              SizedBox(height: paddingValue * 2),
              Text(
                'We are here to help you with any questions or concerns. Our team typically responds within 24-48 hours.',
                style: TextStyle(fontSize: bodyFontSize, color: Colors.black87),
              ),
              SizedBox(height: paddingValue * 2),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final double titleFontSize = isLargeScreen ? 28 : 24;
    final double bodyFontSize = isLargeScreen ? 18 : 16;
    final double paddingValue = isLargeScreen ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About MindEase'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 226, 159, 1),
              Color(0xFFFFC0CB),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(paddingValue),
            children: [
              Text(
                'About MindEase',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: paddingValue),
              Text(
                'MindEase is a mental health platform designed to make professional support accessible and convenient. Our mission is to empower individuals to prioritize their mental well-being by connecting them with licensed therapists and providing tools to manage their mental health journey.',
                style: TextStyle(fontSize: bodyFontSize, color: Colors.black87),
              ),
              SizedBox(height: paddingValue),
              Text(
                'Key Features:',
                style: TextStyle(
                  fontSize: bodyFontSize + 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: paddingValue / 2),
              Text(
                '• Therapist Directory: Browse and search for licensed therapists by name, with detailed profiles to help you find the right match.\n'
                '• User Profiles: Personalize your experience by managing your profile, including username, email, and profile picture.\n'
                '• Responsive Design: Enjoy a seamless experience across devices, with intuitive navigation to access therapist details and settings.\n'
                '• Support Access: Reach out to our dedicated support team for assistance whenever needed.',
                style: TextStyle(fontSize: bodyFontSize, color: Colors.black87),
              ),
              SizedBox(height: paddingValue),
              Text(
                'At MindEase, we believe mental health matters. Join us in creating a world where everyone has the support they need to thrive.',
                style: TextStyle(fontSize: bodyFontSize, color: Colors.black87),
              ),
              SizedBox(height: paddingValue),
            ],
          ),
        ),
      ),
    );
  }
}

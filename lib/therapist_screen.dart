import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/login_page.dart'; // Ensure this import is correct

class CreateTherapistPage extends StatefulWidget {
  const CreateTherapistPage({super.key});

  @override
  _CreateTherapistPageState createState() => _CreateTherapistPageState();
}

class _CreateTherapistPageState extends State<CreateTherapistPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool _isLoading = false; // Added loading state

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createTherapist() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://localhost:3000/api/therapists'), // Replace with your actual API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': _nameController.text.trim(),
          'specialty': _specialtyController.text.trim(),
          'location': _locationController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Therapist created successfully!')),
        );
        // Clear the form
        _nameController.clear();
        _specialtyController.clear();
        _locationController.clear();
        _emailController.clear();
        _passwordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create therapist.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(255, 226, 159, 1), // Light yellow
                  Color(0xFFFFC0CB), // Light pink
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80), // Space for better alignment
                  _header(),
                  const SizedBox(height: 20),
                  _inputFields(),
                  const SizedBox(height: 20),
                  _createTherapistButton(),
                  const SizedBox(height: 20),
                  _alreadyHaveAccount(), // Added this widget
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(), // Loading indicator
            ),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      children: const [
        Text(
          "Create Therapist",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          "Add a new therapist to the system",
          style: TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _inputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: "Name",
            prefixIcon: Icon(Icons.person, color: Colors.purple),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Please enter a name" : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _specialtyController,
          decoration: const InputDecoration(
            hintText: "Specialty",
            prefixIcon: Icon(Icons.medical_services, color: Colors.purple),
          ),
          validator: (value) => value == null || value.isEmpty
              ? "Please enter a specialty"
              : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _locationController,
          decoration: const InputDecoration(
            hintText: "Location",
            prefixIcon: Icon(Icons.location_on, color: Colors.purple),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Please enter a location" : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: "Email",
            prefixIcon: Icon(Icons.email, color: Colors.purple),
          ),
          validator: (value) {
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            return value == null || !emailRegex.hasMatch(value)
                ? "Enter a valid email address"
                : null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: const Icon(Icons.lock, color: Colors.purple),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.purple,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
          ),
          validator: (value) => value == null || value.length < 6
              ? "Password must be at least 6 characters long"
              : null,
        ),
      ],
    );
  }

  Widget _createTherapistButton() {
    return ElevatedButton(
      onPressed:
          _isLoading ? null : _createTherapist, // Disable button when loading
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              color: Colors.black) // Show loading indicator
          : const Text(
              "Create Therapist",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _alreadyHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.black),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            "Login",
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

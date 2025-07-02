import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripeService {
  static const String _baseUrl = 'http://localhost:3000/api/stripe';

  // COMMENTED OUT: Initialize Stripe with publishable key
  static Future<void> init() async {
    // Stripe.publishableKey =
    //     'pk_test_51RCF7D2XdGiu93ZvZQcJgRtZDWfK1mxn2HyNUAMvaOBnbBfwu8opr4OIjcI1yssA92P88ZhXNsCkAODg2YemU3aR008klErbkH';
    // await Stripe.instance.applySettings();
  }

  // COMMENTED OUT: Create a Stripe customer
  static Future<Map<String, dynamic>?> createCustomer({
    required String email,
    required String name,
  }) async {
    // try {
    //   final response = await http.post(
    //     Uri.parse('$_baseUrl/createcustomer'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({
    //       'email': email,
    //       'name': name,
    //     }),
    //   );

    //   if (response.statusCode == 200) {
    //     final data = jsonDecode(response.body);
    //     return data['customer'];
    //   } else {
    //     print('Failed to create customer: ${response.body}');
    //     return null;
    //   }
    // } catch (e) {
    //   print('Error creating customer: $e');
    //   return null;
    // }
    return null; // Stripe functionality disabled
  }

  // COMMENTED OUT: Create payment intent
  static Future<Map<String, dynamic>?> createPaymentIntent({
    required double amount,
    required String currency,
    String? customerId,
  }) async {
    // try {
    //   final response = await http.post(
    //     Uri.parse('$_baseUrl/create-payment-intent'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({
    //       'amount': (amount * 100).round(), // Convert to cents
    //       'currency': currency,
    //       'customerId': customerId,
    //     }),
    //   );

    //   if (response.statusCode == 200) {
    //     return jsonDecode(response.body);
    //   } else {
    //     print('Failed to create payment intent: ${response.body}');
    //     return null;
    //   }
    // } catch (e) {
    //   print('Error creating payment intent: $e');
    //   return null;
    // }
    return null; // Stripe functionality disabled
  }

  // COMMENTED OUT: Process payment
  static Future<bool> processPayment({
    required String clientSecret,
    required String email,
  }) async {
    // try {
    //   // Initialize payment sheet
    //   await Stripe.instance.initPaymentSheet(
    //     paymentSheetParameters: SetupPaymentSheetParameters(
    //       paymentIntentClientSecret: clientSecret,
    //       merchantDisplayName: 'MindEase',
    //       customerEphemeralKeySecret: null,
    //       customerId: null,
    //       style: ThemeMode.system,
    //     ),
    //   );

    //   // Present payment sheet
    //   await Stripe.instance.presentPaymentSheet();

    //   return true;
    // } catch (e) {
    //   print('Payment failed: $e');
    //   return false;
    // }
    return false; // Stripe functionality disabled
  }
}

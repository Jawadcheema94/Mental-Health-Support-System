// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:stripe_payment/stripe_payment.dart';

// void main() {
//   // Initialize Stripe with your publishable key and merchant ID
//   StripePayment.setOptions(StripeOptions(
//     publishableKey: 'pk_test_51RHhyTQnCvEPlVgD3fYwSACZL05lvbpsyzWTPlHS8x3AxxPubD7CZfYTsLkGpHaYmWMCF8EwRDslbAxQsPTrg11k00ZNRQuvk1', // Replace with your Stripe publishable key
//     merchantId: 'acct_1RHhy9HvF8Cq7QRE', // Replace with your merchant ID
//     androidPayMode: 'test', // Use 'production' for live mode
//   ));
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Stripe Payment Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PaymentScreen(),
//     );
//   }
// }

// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   Future<void> createPaymentIntent() async {
//     try {
//       // Make HTTP request to your backend to create a payment intent
//       final response = await http.post(
//         Uri.parse('https://localhost:3000/api/payments/stripe'), // Replace with your backend URL
//         body: jsonEncode({
//           'amount': 1000, // Amount in cents (e.g., $10.00)
//           'currency': 'usd',
//           'userId': 'user-id', // Replace with actual user ID
//           'therapistId': 'therapist-id', // Replace with actual therapist ID
//         }),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final clientSecret = data['clientSecret'];

//         // Create payment method
//         final paymentMethod = await StripePayment.createPaymentMethod(
//           PaymentMethodRequest(
//             card: CardRequest(),
//           ),
//         );

//         // Confirm payment intent
//         final paymentIntentResult = await StripePayment.confirmPaymentIntent(
//           PaymentIntentParams(
//             clientSecret: clientSecret,
//             paymentMethodId: paymentMethod.id,
//           ),
//         );

//         if (paymentIntentResult.status == 'succeeded') {
//           // Payment succeeded, notify backend
//           await http.post(
//             Uri.parse('https://localhost:3000/api/payments/createPaymentIntent'), // Replace with your backend URL
//             body: jsonEncode({'paymentIntentId': paymentIntentResult.id}),
//             headers: {'Content-Type': 'application/json'},
//           );
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Payment succeeded')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Payment failed')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create payment intent: ${response.statusCode} - ${response.body}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stripe Payment'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: createPaymentIntent,
//           child: Text('Pay $10.00'),
//         ),
//       ),
//     );
//   }
// }

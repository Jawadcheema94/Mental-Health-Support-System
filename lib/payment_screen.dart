import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/services/stripe_service.dart';
import 'package:myapp/components/modern_button.dart';
import 'package:myapp/components/modern_card.dart';

class PaymentScreen extends StatefulWidget {
  final String userId;
  final double amount;
  final String description;
  final String? therapistId;
  final String? appointmentId;

  const PaymentScreen({
    super.key,
    required this.userId,
    required this.amount,
    required this.description,
    this.therapistId,
    this.appointmentId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Payment',
          style: AppTheme.headingMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Payment Summary Card
                ModernCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.payment,
                              color: AppTheme.primaryColor,
                              size: 28,
                            ),
                            const SizedBox(width: AppTheme.spacingM),
                            Text(
                              'Payment Summary',
                              style: AppTheme.headingMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingL),
                        _buildSummaryRow('Service', widget.description),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildSummaryRow('Amount', '\$${widget.amount.toStringAsFixed(2)}'),
                        const SizedBox(height: AppTheme.spacingM),
                        _buildSummaryRow('Payment Method', 'Credit/Debit Card'),
                        const Divider(height: AppTheme.spacingL * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: AppTheme.headingMedium.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            Text(
                              '\$${widget.amount.toStringAsFixed(2)}',
                              style: AppTheme.headingLarge.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingL),
                
                // Security Info Card
                ModernCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: AppTheme.successColor,
                          size: 24,
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Secure Payment',
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your payment is secured by Stripe with 256-bit SSL encryption',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: AppTheme.spacingL),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: AppTheme.errorColor),
                        const SizedBox(width: AppTheme.spacingS),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const Spacer(),

                // Payment Buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      text: _isProcessing ? 'Processing...' : 'Pay with Stripe',
                      onPressed: _isProcessing ? null : _processStripePayment,
                      icon: Icons.credit_card,
                      isLoading: _isProcessing,
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    OutlinedButton.icon(
                      onPressed: _isProcessing ? null : _processSimulatedPayment,
                      icon: const Icon(Icons.account_balance_wallet),
                      label: const Text('Simulate Payment (Test)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _processStripePayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Create payment intent
      final paymentIntentData = await StripeService.createPaymentIntent(
        amount: widget.amount,
        currency: 'usd',
      );

      if (paymentIntentData != null) {
        // Process payment
        final success = await StripeService.processPayment(
          clientSecret: paymentIntentData['clientSecret'],
          email: 'user@example.com', // You should get this from user data
        );

        if (success) {
          _showSuccessDialog();
        } else {
          setState(() {
            _errorMessage = 'Payment was cancelled or failed. Please try again.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to initialize payment. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Payment error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processSimulatedPayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final success = await StripeService.processSimplePayment(
        amount: widget.amount,
        currency: 'usd',
      );

      if (success) {
        _showSuccessDialog();
      } else {
        setState(() {
          _errorMessage = 'Simulated payment failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Payment error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successColor, size: 28),
            const SizedBox(width: AppTheme.spacingS),
            const Text('Payment Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your payment of \$${widget.amount.toStringAsFixed(2)} has been processed successfully.',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Service: ${widget.description}',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          PrimaryButton(
            text: 'Continue',
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(true); // Return to previous screen with success
            },
          ),
        ],
      ),
    );
  }
}

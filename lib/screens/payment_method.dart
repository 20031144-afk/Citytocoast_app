import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Payment Method"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lock, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Add a card securely with Stripe. Your card details never "
                      "touch our servers.",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "We'll open Stripe's secure card form to save a payment method "
              "for future bookings.",
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isSubmitting ? null : _handleAddPaymentMethod,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        "Add Payment Method",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAddPaymentMethod() async {
    setState(() => _isSubmitting = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('You must be logged in to add a payment method.');
      }

      final data = await _createSetupIntent();
      final clientSecret = data['clientSecret']?.toString();
      final customerId = data['customerId']?.toString();
      final ephemeralKey = data['ephemeralKey']?.toString();

      if (clientSecret == null ||
          clientSecret.isEmpty ||
          customerId == null ||
          customerId.isEmpty ||
          ephemeralKey == null ||
          ephemeralKey.isEmpty) {
        throw Exception('Unable to start the Stripe setup flow.');
      }

      await _initPaymentSheet(
        clientSecret: clientSecret,
        customerId: customerId,
        ephemeralKey: ephemeralKey,
      );
      await Stripe.instance.presentPaymentSheet();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment method saved.")),
      );
      Navigator.pop(context, true);
    } on StripeException catch (e) {
      if (!mounted) return;
      final message =
          e.error.localizedMessage ??
          'Payment method setup was cancelled. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_friendlyError(e))),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<Map<String, dynamic>> _createSetupIntent() async {
    final callable = FirebaseFunctions.instance.httpsCallable(
      'createSetupIntent',
    );
    final result = await callable.call(<String, dynamic>{});
    final data = result.data;
    if (data is Map) {
      return Map<String, dynamic>.from(data as Map);
    }
    throw Exception('Unexpected response from payment service.');
  }

  Future<void> _initPaymentSheet({
    required String clientSecret,
    required String customerId,
    required String ephemeralKey,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        setupIntentClientSecret: clientSecret,
        customerId: customerId,
        customerEphemeralKeySecret: ephemeralKey,
        merchantDisplayName: 'City to Coast',
        style: ThemeMode.system,
      ),
    );
  }

  String _friendlyError(Object e) {
    if (e is FirebaseFunctionsException) {
      return e.message ?? 'Unable to add payment method.';
    }
    return 'Unable to add payment method: $e';
  }
}

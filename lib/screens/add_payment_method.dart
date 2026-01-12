import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:citytocoast_app/services/payment_methods_service.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final PaymentMethodsService _paymentMethodsService = PaymentMethodsService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  CardEditController _cardController = CardEditController();
  bool _isCardValid = false;
  bool _isSubmitting = false;
  bool _saveCard = true;

  // For card preview
  String _cardNumber = "•••• •••• •••• ••••";
  String _cardHolderName = "YOUR NAME";
  String _expiryDate = "MM/YY";
  String _brand = "Card";

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateCardPreview);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateCardPreview);
    _nameController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _updateCardPreview() {
    setState(() {
      _cardHolderName = _nameController.text.isEmpty
          ? "YOUR NAME"
          : _nameController.text.toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Payment Method"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Blue Card Visual
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF9333EA),
                    ], // Blue to Purple
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative Circles
                    Positioned(
                      right: -20,
                      top: -20,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Brand Label
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 50,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFD4AF37,
                                  ), // Gold chip color
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEBC860),
                                      Color(0xFFC59D1D),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                              Text(
                                _brand.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          // Dots (Card Number)
                          Text(
                            _cardNumber,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              letterSpacing: 2,
                              fontFamily: 'Courier',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // Name and Expiry
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "CARDHOLDER NAME",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _cardHolderName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "EXPIRES",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _expiryDate,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 🔹 Input Fields
              const Text(
                "Card Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              // 🛡️ Secure Stripe CardField
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  color: Colors.grey[50],
                ),
                child: CardField(
                  controller: _cardController,
                  onCardChanged: (card) {
                    setState(() {
                      _isCardValid = card?.complete ?? false;
                      _brand = card?.brand ?? "Card";

                      // Update visual preview
                      if (card != null && card.last4 != null) {
                        _cardNumber = "•••• •••• •••• ${card.last4}";
                      } else {
                        _cardNumber = "•••• •••• •••• ••••";
                      }

                      if (card != null &&
                          card.expiryMonth != null &&
                          card.expiryYear != null) {
                        final month = card.expiryMonth.toString().padLeft(
                          2,
                          '0',
                        );
                        final year = card.expiryYear.toString().substring(
                          card.expiryYear.toString().length - 2,
                        );
                        _expiryDate = "$month/$year";
                      } else {
                        _expiryDate = "MM/YY";
                      }
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "0000 0000 0000 0000",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Name
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.characters,
                decoration: _inputDecoration(
                  "Cardholder Name",
                  "SANDIP PANDEY",
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Name required" : null,
              ),
              const SizedBox(height: 24),

              // 🔹 Save Card Toggle
              Row(
                children: [
                  Switch.adaptive(
                    value: _saveCard,
                    activeColor: const Color(0xFF2563EB),
                    onChanged: (val) {
                      setState(() {
                        _saveCard = val;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Save card for future bookings",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 🔹 Secure Badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDBEAFE)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, color: Color(0xFF2563EB)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Secure & Encrypted",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E40AF),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Your card information is protected with bank-level encryption and is handled securely by Stripe.",
                            style: TextStyle(
                              color: Color(0xFF3B82F6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 🔹 Add Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: (_isSubmitting || !_isCardValid)
                      ? null
                      : _handleAddPaymentMethod,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          _isCardValid
                              ? "Add Payment Method"
                              : "Enter Card Details",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Future<void> _handleAddPaymentMethod() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isCardValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete card details.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('You must be logged in.');
      }

      // 1. Create a Setup Intent via backend
      // This function returns customerId, ephemeralKey, and clientSecret
      final setupIntentResult = await _paymentMethodsService
          .createSetupIntent();

      // 2. Confirm the Setup Intent securely using Stripe SDK
      // The CardField automatically handles the card details
      await Stripe.instance.confirmSetupIntent(
        paymentIntentClientSecret: setupIntentResult.setupIntentClientSecret,
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: _nameController.text,
              email: user.email,
            ),
          ),
        ),
      );

      // 3. Sync payment methods to Firestore (fetched from Stripe)
      await _paymentMethodsService.syncPaymentMethods(
        customerId: setupIntentResult.customerId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Card added successfully!')));

      Navigator.pop(context, true);
    } on StripeException catch (e) {
      if (!mounted) return;
      debugPrint('Stripe Error: ${e.error.localizedMessage}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.error.localizedMessage ?? "Error adding card"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint('Setup Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

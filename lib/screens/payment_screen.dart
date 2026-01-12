import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:citytocoast_app/models/booking_model.dart';
import 'package:citytocoast_app/services/firestore_service.dart';
import 'sitter.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Sitter sitter;
  final DateTime date;
  final String time;
  final int duration;
  final double totalCost;
  final String specialRequests;
  final bool isEmergency;

  const PaymentScreen({
    Key? key,
    required this.sitter,
    required this.date,
    required this.time,
    required this.duration,
    required this.totalCost,
    required this.specialRequests,
    this.isEmergency = false,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Fees are now dynamic
  double get serviceFee => widget.totalCost * 0.10;
  final double processingFee = 0.0;

  bool _isProcessing = false;
  int _processingStep = 0; // 0: Verifying, 1: Processing, 2: Confirming

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final double grandTotal = widget.totalCost + serviceFee + processingFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Secure Checkout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.isEmergency
                  ? Colors.red.shade50
                  : const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isEmergency
                    ? Colors.red.shade100
                    : const Color(0xFFD1E9FF),
              ),
            ),
            child: Text(
              widget.isEmergency ? "Emergency" : "Regular",
              style: TextStyle(
                color: widget.isEmergency
                    ? Colors.red.shade700
                    : const Color(0xFF0070E0),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Booking Summary
                _sectionTitle("Booking Summary"),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.sitter.profileImageUrl,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Booking with ${widget.sitter.name}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Verified Sitter",
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _summaryRow(
                        "Date & Time:",
                        "${widget.date.day}/${widget.date.month}/${widget.date.year} • ${widget.time}",
                        Icons.calendar_today,
                      ),
                      const SizedBox(height: 8),
                      _summaryRow(
                        "Duration:",
                        "${widget.duration} hours",
                        Icons.schedule,
                      ),
                    ],
                  ),
                ),

                // 🔹 Caring Message Card
                _buildCaringMessage(),

                const SizedBox(height: 24),

                const SizedBox(height: 24),

                // 🔹 Cost Breakdown
                _sectionTitle("Cost Breakdown"),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _costRow(
                        "Service (${widget.duration} hours)",
                        "\$${widget.totalCost.toStringAsFixed(2)}",
                      ),
                      _costRow(
                        "Service Fee",
                        "\$${serviceFee.toStringAsFixed(2)}",
                      ),
                      _costRow(
                        "Processing Fee",
                        "\$${processingFee.toStringAsFixed(2)}",
                      ),
                      const Divider(height: 24),
                      _costRow(
                        "Total",
                        "\$${grandTotal.toStringAsFixed(2)}",
                        isBold: true,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Secure Payment Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF2563EB),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Your payment is secure and encrypted.",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 🔹 Pay Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isProcessing
                        ? null
                        : () => _handlePay(grandTotal),
                    child: Text(
                      "Proceed to Pay \$${grandTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          if (_isProcessing) _buildProcessingOverlay(),
        ],
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Lock Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF9333EA),
                    ], // Blue to Purple
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.lock, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 24),
              const Text(
                "Processing Payment",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please wait while we securely process your payment...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 24),

              // Checklist Steps
              _buildChecklistStep("Verifying payment details", 0),
              const SizedBox(height: 12),
              _buildChecklistStep("Processing transaction", 1),
              const SizedBox(height: 12),
              _buildChecklistStep("Confirming booking", 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaringMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFF2563EB),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Your Peace of Mind is Our Priority",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "We handle all payments securely via Stripe. You'll be able to choose between Credit Card, Apple Pay, or Google Pay in the next step. Your payment details are never stored on our servers.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistStep(String title, int stepIndex) {
    bool isCompleted = _processingStep > stepIndex;
    bool isCurrent = _processingStep == stepIndex;

    return Row(
      children: [
        if (isCompleted)
          const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 24)
        else if (isCurrent)
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF2563EB),
            ),
          )
        else
          Icon(Icons.circle_outlined, color: Colors.grey[300], size: 24),

        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: isCompleted || isCurrent ? Colors.black : Colors.grey[400],
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // 🔹 Helpers
  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    ),
  );

  Widget _summaryRow(String label, String value, IconData icon) => Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 8),
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
      ),
      const Spacer(),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );

  Widget _costRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.grey[900],
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePay(double grandTotal) async {
    setState(() {
      _isProcessing = true;
      _processingStep = 0; // Verifying defaults
    });

    String? paymentIntentId;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('You must be logged in to book.');
      }

      // Simulate verification delay
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() => _processingStep = 1); // Processing Transaction

      final intentData = await _createPaymentIntent(grandTotal);
      final clientSecret = intentData['clientSecret']?.toString();
      final customerId = intentData['customerId']?.toString();
      final ephemeralKey = intentData['ephemeralKey']?.toString();
      paymentIntentId = intentData['paymentIntentId']?.toString();

      if (clientSecret == null || clientSecret.isEmpty) {
        throw Exception('Unable to start the payment flow. Please try again.');
      }
      if (customerId == null || customerId.isEmpty) {
        throw Exception('Payment customer could not be loaded.');
      }
      if (ephemeralKey == null || ephemeralKey.isEmpty) {
        throw Exception('Payment ephemeral key could not be loaded.');
      }
      if (paymentIntentId == null || paymentIntentId.isEmpty) {
        throw Exception('Payment Intent was created without an id.');
      }

      await _initPaymentSheet(
        clientSecret: clientSecret,
        customerId: customerId,
        ephemeralKey: ephemeralKey,
      );

      // Still in processing transaction step
      await Stripe.instance.presentPaymentSheet();

      setState(() => _processingStep = 2); // Confirming Booking

      final booking = BookingModel(
        bookingId: '',
        clientId: user.uid,
        sitterId: widget.sitter.id,
        sitterName: widget.sitter.name,
        sitterProfileImageUrl: widget.sitter.img,
        dateStr: _formatDate(widget.date),
        timeStr: _normalizeTime(widget.time),
        durationHours: widget.duration,
        specialRequests: widget.specialRequests,
        isEmergency: widget.isEmergency,
        ratePerHour: widget.sitter.ratePerHour,
        baseCost: widget.totalCost,
        serviceFee: serviceFee,
        processingFee: processingFee,
        grandTotal: grandTotal,
        status: 'pending',
        paymentMethod: 'stripe_sheet',
        paymentStatus: 'pending',
        paymentProvider: 'stripe',
        paymentRef: paymentIntentId,
      );

      final bookingId = await _firestoreService.createBooking(booking);

      await _firestoreService.markBookingPaid(
        bookingId: bookingId,
        clientId: user.uid,
        sitterId: widget.sitter.id,
        paymentRef: paymentIntentId,
        paymentMethod: 'stripe_sheet',
      );

      await _firestoreService.createPaymentRecord(
        bookingId: bookingId,
        paymentIntentId: paymentIntentId,
        clientId: user.uid,
        sitterId: widget.sitter.id,
        amount: grandTotal,
        currency: 'AUD',
        paymentMethod: 'stripe_sheet',
      );

      // Small delay for the user to see "Confirming" checked
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(
            sitter: widget.sitter,
            bookingId: bookingId,
            date: widget.date,
            time: widget.time,
            paymentMethod: 'Secure Checkout',
            isEmergency: widget.isEmergency,
          ),
        ),
      );
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('StripeException: ${e.error.localizedMessage}');
        print('Stripe code: ${e.error.code}');
      }
      if (!mounted) return;
      setState(() => _isProcessing = false); // Hide overlay
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.error.localizedMessage ?? 'Payment cancelled or failed.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e, stack) {
      if (kDebugMode) {
        print('General Error: $e');
        print(stack);
      }
      if (!mounted) return;
      setState(() => _isProcessing = false); // Hide overlay
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_friendlyError(e))));
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(double grandTotal) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'createPaymentIntent',
      );
      if (kDebugMode) {
        print('Calling createPaymentIntent with amount: ${grandTotal * 100}');
      }

      final result = await callable.call(<String, dynamic>{
        'amount': (grandTotal * 100).round(),
        'currency': 'aud',
        'sitterId': widget.sitter.id,
        'date': _formatDate(widget.date),
        'time': _normalizeTime(widget.time),
      });

      if (kDebugMode) {
        print('Payment Service Response: ${result.data}');
      }

      final data = result.data;
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      throw Exception('Format Error: Unexpected response format from server.');
    } catch (e) {
      if (kDebugMode) {
        print('Function Call Error: $e');
      }
      rethrow;
    }
  }

  Future<void> _initPaymentSheet({
    required String clientSecret,
    required String customerId,
    required String ephemeralKey,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        customerId: customerId,
        customerEphemeralKeySecret: ephemeralKey,
        merchantDisplayName: 'City to Coast',
        style: ThemeMode.system,
        applePay: const PaymentSheetApplePay(merchantCountryCode: 'AU'),
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'AU',
          testEnv: true,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _normalizeTime(String timeLabel) {
    final lower = timeLabel.trim().toLowerCase();
    final parts = RegExp(
      r'^(\d{1,2}):(\d{2})(?:\s*(am|pm))?$',
    ).firstMatch(lower);
    if (parts != null) {
      var hour = int.parse(parts.group(1)!);
      final minute = parts.group(2)!;
      final meridiem = parts.group(3);

      if (meridiem == 'pm' && hour != 12) {
        hour += 12;
      } else if (meridiem == 'am' && hour == 12) {
        hour = 0;
      }
      final hourStr = hour.toString().padLeft(2, '0');
      return '$hourStr:$minute';
    }
    return timeLabel;
  }

  String _friendlyError(Object e) {
    if (e is FirebaseFunctionsException) {
      return e.message ?? 'Payment failed. Please try again.';
    }
    final message = e.toString();
    if (message.contains('already booked')) {
      return 'Sorry, this time has just been booked. Please pick another slot.';
    }
    return 'Payment failed: $message';
  }
}

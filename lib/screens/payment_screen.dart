import 'package:flutter/material.dart';
import 'sitter.dart';
import 'confirmation_screen.dart';
import 'add_payment_method.dart';

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
  String? selectedPaymentMethod = "Credit Card"; // default

  final double serviceFee = 11.0;
  final double processingFee = 2.99;

  @override
  Widget build(BuildContext context) {
    final double grandTotal = widget.totalCost + serviceFee + processingFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: widget.isEmergency
                  ? Colors.red.shade50
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.isEmergency ? "Emergency Booking" : "Regular Booking",
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Booking Summary
            _sectionTitle("Booking Summary"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _summaryRow("Sitter:", widget.sitter.name),
                  _summaryRow(
                    "Date & Time:",
                    "${widget.date.day}/${widget.date.month}/${widget.date.year} at ${widget.time}",
                  ),
                  _summaryRow("Duration:", "${widget.duration} hours"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Payment Method
            _sectionTitle("Payment Method"),
            _paymentOption("Credit Card", "**** **** **** 4242"),
            const SizedBox(height: 8),
            _paymentOption("PayPal", "alex.rodriguez@email.com"),
            const SizedBox(height: 8),
            _addPaymentOption(),

            const SizedBox(height: 20),

            // 🔹 Quick Pay Options
            _sectionTitle("Quick Pay Options"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _quickPayButton("Apple Pay", Icons.apple),
                _quickPayButton("Google Pay", Icons.g_mobiledata),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Cost Breakdown
            _sectionTitle("Cost Breakdown"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _costRow(
                    "Service (${widget.duration} hours)",
                    "\$${widget.totalCost.toStringAsFixed(2)}",
                  ),
                  _costRow("Service Fee", "\$${serviceFee.toStringAsFixed(2)}"),
                  _costRow(
                    "Processing Fee",
                    "\$${processingFee.toStringAsFixed(2)}",
                  ),
                  const Divider(),
                  _costRow(
                    "Total",
                    "\$${grandTotal.toStringAsFixed(2)}",
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Secure Payment Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lock, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Secure Payment\nYour payment information is encrypted and protected by industry-standard security measures.",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Terms & Pay Button
            Text(
              "By completing this payment, you agree to our Terms of Service and Cancellation Policy.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedPaymentMethod != null
                      ? Colors.black
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedPaymentMethod == null
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConfirmationScreen(
                              sitter: widget.sitter,
                              bookingRef: "#SC2024001",
                              date: widget.date,
                              time: widget.time,
                              paymentMethod: selectedPaymentMethod!,
                              isEmergency: widget.isEmergency,
                            ),
                          ),
                        );
                      },
                child: Text(
                  "Pay \$${grandTotal.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: Text(
                "Need help? Contact Support or call (555) 123-CARE",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helpers
  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );

  Widget _summaryRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );

  Widget _paymentOption(String method, String details) {
    final isSelected = selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: method,
              groupValue: selectedPaymentMethod,
              onChanged: (val) {
                setState(() {
                  selectedPaymentMethod = val;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    details,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _addPaymentOption() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPaymentMethodScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add new payment method tapped")),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: const [
            Icon(Icons.add_card_outlined),
            SizedBox(width: 8),
            Text("Add New Payment Method"),
          ],
        ),
      ),
    );
  }

  Widget _quickPayButton(String label, IconData icon) {
    final isSelected = selectedPaymentMethod == label;
    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          selectedPaymentMethod = label;
        });
      },
      icon: Icon(
        icon,
        size: 20,
        color: isSelected ? Colors.white : Colors.black,
      ),
      label: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.black : Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.black : Colors.grey.shade300,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _costRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

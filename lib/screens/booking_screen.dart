import 'package:flutter/material.dart';
import 'sitter.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Sitter sitter;

  const BookingScreen({Key? key, required this.sitter}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDate;
  String? selectedTime;
  int duration = 2;
  String specialRequests = "";

  final double serviceFee = 10.0;

  final List<String> timeSlots = [
    "9:00 AM",
    "12:00 PM",
    "3:00 PM",
    "6:00 PM",
    "7:00 PM",
    "8:00 PM",
  ];

  double get totalCost => (widget.sitter.ratePerHour * duration) + serviceFee;

  bool get isFormComplete =>
      selectedDate != null && selectedTime != null && duration > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book ${widget.sitter.name}"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Date Picker
            _sectionTitle("Select Date"),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                          : "dd/mm/yyyy",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Time Slots
            _sectionTitle("Select Time"),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: timeSlots.map((time) {
                final isSelected = selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => selectedTime = time);
                  },
                  selectedColor: Colors.black,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  backgroundColor: Colors.grey.shade100,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // 🔹 Duration
            _sectionTitle("Duration (hours)"),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (duration > 1) {
                      setState(() => duration--);
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text("$duration", style: const TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () {
                    setState(() => duration++);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Special Requests
            _sectionTitle("Special Requests"),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Any special instructions or requirements...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) => setState(() => specialRequests = val),
            ),

            const SizedBox(height: 20),

            // 🔹 Cost Summary
            _sectionTitle("Cost Summary"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _costRow(
                    "Service ($duration hours)",
                    "\$${(widget.sitter.ratePerHour * duration).toStringAsFixed(0)}",
                  ),
                  _costRow("Service Fee", "\$${serviceFee.toStringAsFixed(0)}"),
                  const Divider(),
                  _costRow(
                    "Total",
                    "\$${totalCost.toStringAsFixed(0)}",
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Continue to Payment
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
                onPressed: isFormComplete
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(
                              sitter: widget.sitter,
                              date: selectedDate!,
                              time: selectedTime!,
                              duration: duration,
                              totalCost: totalCost,
                              specialRequests: specialRequests,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  "Continue to Payment",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helpers
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

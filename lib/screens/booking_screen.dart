import 'package:flutter/material.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final String sitterName;
  final int sitterRate;
  final String sitterImg;

  const BookingScreen({
    super.key,
    required this.sitterName,
    required this.sitterRate,
    required this.sitterImg,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTimeRange? selectedRange;
  TimeOfDay? selectedTime;

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now().add(const Duration(days: 1)),
        end: DateTime.now().add(const Duration(days: 1)),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => selectedRange = picked);
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Sitter")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Sitter Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.sitterImg),
                  radius: 30,
                ),
                title: Text(
                  widget.sitterName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("\$${widget.sitterRate}/hr • Rating: 4.8"),
              ),
            ),
            const SizedBox(height: 20),

            // Date range picker
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.teal),
              title: Text(
                selectedRange == null
                    ? "Select Date(s)"
                    : "${selectedRange!.start.day}/${selectedRange!.start.month} - "
                          "${selectedRange!.end.day}/${selectedRange!.end.month}",
              ),
              onTap: _pickDateRange,
            ),

            // Time picker
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.teal),
              title: Text(
                selectedTime == null
                    ? "Choose Time"
                    : selectedTime!.format(context),
              ),
              onTap: _pickTime,
            ),

            const Spacer(),

            // Confirm button
            ElevatedButton(
              onPressed: (selectedRange != null && selectedTime != null)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(
                            sitterName: widget.sitterName,
                            sitterRate: widget.sitterRate,
                            sitterImg: widget.sitterImg,
                            range: selectedRange!,
                            time: selectedTime!,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Proceed to Payment"),
            ),
          ],
        ),
      ),
    );
  }
}

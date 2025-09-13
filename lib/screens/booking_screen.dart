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
  int hoursPerDay = 2;

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
    if (picked != null) setState(() => selectedRange = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Booking Your Date")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Sitter card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.sitterImg),
                  radius: 28,
                ),
                title: Text(
                  widget.sitterName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("\$${widget.sitterRate}/hr • ⭐ 4.8"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Date range
            _buildOptionTile(
              icon: Icons.calendar_today,
              label: selectedRange == null
                  ? "Select Date(s)"
                  : "${selectedRange!.start.day}/${selectedRange!.start.month} - ${selectedRange!.end.day}/${selectedRange!.end.month}",
              onTap: _pickDateRange,
            ),

            // Time
            _buildOptionTile(
              icon: Icons.access_time,
              label: selectedTime == null
                  ? "Choose Time"
                  : selectedTime!.format(context),
              onTap: _pickTime,
            ),

            // Hours slider
            ListTile(
              leading: const Icon(Icons.timer, color: Colors.teal),
              title: Text("Hours per day: $hoursPerDay"),
              subtitle: Slider(
                value: hoursPerDay.toDouble(),
                min: 1,
                max: 12,
                divisions: 11,
                label: "$hoursPerDay",
                onChanged: (val) {
                  setState(() => hoursPerDay = val.toInt());
                },
              ),
            ),

            const Spacer(),

            // Continue button
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
                            hoursPerDay: hoursPerDay,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

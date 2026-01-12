import 'package:citytocoast_app/models/booking_model.dart';
import 'package:citytocoast_app/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'sitter.dart';

class ConfirmationScreen extends StatefulWidget {
  final Sitter? sitter;
  final String bookingId;
  final DateTime? date;
  final String? time;
  final String? paymentMethod;
  final bool isEmergency;

  const ConfirmationScreen({
    Key? key,
    this.sitter,
    required this.bookingId,
    this.date,
    this.time,
    this.paymentMethod,
    this.isEmergency = false,
  }) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<BookingModel?> _bookingFuture;
  Future<Sitter?>? _sitterFuture;

  @override
  void initState() {
    super.initState();
    _bookingFuture = _firestoreService.getBookingById(widget.bookingId);

    if (widget.sitter != null) {
      _sitterFuture = Future.value(widget.sitter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookingModel?>(
      future: _bookingFuture,
      builder: (context, bookingSnapshot) {
        if (bookingSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final booking = bookingSnapshot.data;
        if (booking == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Booking Details")),
            body: const Center(child: Text("Booking not found.")),
          );
        }

        // Now that we have the booking, ensure we have a sitter future
        if (_sitterFuture == null) {
          _sitterFuture = _firestoreService.getSitterById(booking.sitterId);
        }

        return FutureBuilder<Sitter?>(
          future: _sitterFuture,
          builder: (context, sitterSnapshot) {
            final sitter = sitterSnapshot.data;
            final sitterLoading =
                sitterSnapshot.connectionState == ConnectionState.waiting;

            final sitterName = sitter?.name ?? booking.sitterName;
            final sitterFirst = sitterName.split(' ').first;
            final bookingRef = booking.bookingId;
            final isEmergency = booking.isEmergency;
            final durationHours = booking.durationHours;
            final baseCost = booking.baseCost;
            final serviceFee = booking.serviceFee;
            final processingFee = booking.processingFee;
            final grandTotal = booking.grandTotal;

            // Handle date and time from booking
            DateTime displayDate;
            try {
              displayDate = DateTime.parse(booking.dateStr);
            } catch (_) {
              displayDate = widget.date ?? DateTime.now();
            }
            final displayTime = booking.timeStr;

            return Scaffold(
              backgroundColor: const Color(0xFFF5F7FB),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // 🔹 Check Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF16A34A).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🔹 Title
                      const Text(
                        "Booking Confirmed!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Your pet sitting session has been successfully booked",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Booking ID: $bookingRef",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 🔹 Booking Details Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Booking Details",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Sitter Info
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        sitter?.profileImageUrl ??
                                            booking.sitterProfileImageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sitterName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          ...List.generate(
                                            5,
                                            (index) => Icon(
                                              index <
                                                      (sitter?.ratingAvg ?? 5.0)
                                                          .round()
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              size: 14,
                                              color: Colors.amber,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            (sitter?.ratingAvg ?? 5.0)
                                                .toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Verified Sitter",
                                    style: TextStyle(
                                      color: Color(0xFF16A34A),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 32),

                            // Time
                            _detailRow(
                              icon: Icons.calendar_today,
                              bgColor: const Color(0xFFEFF6FF),
                              iconColor: const Color(0xFF2563EB),
                              title: "Date & Time",
                              value: _formatDateTimeLabel(
                                displayDate,
                                displayTime,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Duration
                            _detailRow(
                              icon: Icons.schedule,
                              bgColor: const Color(0xFFFAF5FF),
                              iconColor: const Color(0xFF9333EA),
                              title: "Duration",
                              value: "$durationHours hours session",
                            ),
                            const SizedBox(height: 16),

                            // Location (Mock)
                            _detailRow(
                              icon: Icons.location_on_outlined,
                              bgColor: const Color(0xFFFFF7ED),
                              iconColor: const Color(0xFFEA580C),
                              title: "Location",
                              value: "Your home address",
                              subtitle: "123 Main Street, Apt 4B",
                            ),

                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  _moneyRow(
                                    "Service ($durationHours hours)",
                                    _formatCurrency(baseCost),
                                  ),
                                  const SizedBox(height: 8),
                                  _moneyRow(
                                    "Service Fee",
                                    _formatCurrency(serviceFee),
                                  ),
                                  const SizedBox(height: 8),
                                  _moneyRow(
                                    "Processing Fee",
                                    _formatCurrency(processingFee),
                                  ),
                                  const Divider(height: 24),
                                  _moneyRow(
                                    "Total Paid",
                                    _formatCurrency(grandTotal),
                                    isBold: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 🔹 Message Sitter Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: sitterLoading
                              ? null
                              : () async {
                                  final roomId = await _firestoreService
                                      .getOrCreateChatRoom(
                                        booking.clientId,
                                        booking.sitterId,
                                      );
                                  if (!mounted) return;
                                  Navigator.pushNamed(
                                    context,
                                    '/chat',
                                    arguments: {
                                      'roomId': roomId,
                                      'recipientName': sitterName,
                                      'recipientPhoto':
                                          sitter?.profileImageUrl ??
                                          booking.sitterProfileImageUrl,
                                    },
                                  );
                                },
                          icon: sitterLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.message_outlined, size: 20),
                          label: Text(
                            "Message $sitterFirst",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🔹 Return Home Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () =>
                              Navigator.popUntil(context, (r) => r.isFirst),
                          child: const Text(
                            "Return to Home",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Container(
                        height: 5,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
          ],
        ),
      ],
    );
  }

  Widget _moneyRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? Colors.black : Colors.grey[600],
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isBold ? Colors.black : Colors.grey[800],
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  String _formatDateTimeLabel(DateTime date, String time) {
    // E.g. September 1, 2026 at 7:00 PM
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    final m = months[date.month - 1];
    return "$m ${date.day}, ${date.year} at $time";
  }
}

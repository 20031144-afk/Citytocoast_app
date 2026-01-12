import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageAvailability extends StatefulWidget {
  const ManageAvailability({super.key});

  @override
  State<ManageAvailability> createState() => _ManageAvailabilityState();
}

class _ManageAvailabilityState extends State<ManageAvailability> {
  // Store availability for each day of the week
  // simple structure: day name, isAvailable, startTime, endTime
  List<Map<String, dynamic>> weekSchedule = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateWeekDates();
  }

  void _generateWeekDates() {
    // Start from tomorrow
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    weekSchedule.clear();

    // Generate for the next 7 days starting from tomorrow
    for (int i = 0; i < 7; i++) {
      final date = tomorrow.add(Duration(days: i));
      final dayName = DateFormat(
        'EEEE',
      ).format(date); // Full day name (e.g. Monday)
      final dateString = DateFormat('MMM d').format(date); // e.g. Jan 12

      // Default logic: weekends might be off or defaults
      // For simplicity, let's say all are available 9-5 primarily,
      // creating a fresh schedule object:
      weekSchedule.add({
        "day": dayName,
        "date": dateString,
        "isAvailable": true, // Default to available
        "start": const TimeOfDay(hour: 9, minute: 0),
        "end": const TimeOfDay(hour: 17, minute: 0),
        "hasUnavailableHours": false, // New field
        "unavailableStart": const TimeOfDay(
          hour: 12,
          minute: 0,
        ), // Default break
        "unavailableEnd": const TimeOfDay(hour: 13, minute: 0),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          "Manage Availability",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: weekSchedule.length,
              itemBuilder: (context, index) {
                return _buildDayCard(index);
              },
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildDayCard(int index) {
    final dayData = weekSchedule[index];
    final String dayName = dayData['day'];
    final bool isAvailable = dayData['isAvailable'];
    final TimeOfDay start = dayData['start'];
    final TimeOfDay end = dayData['end'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Header: Day Name + Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    dayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dayData['date'] ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Switch(
                value: isAvailable,
                activeColor: const Color(0xFF6A5AE0),
                onChanged: (val) {
                  setState(() {
                    weekSchedule[index]['isAvailable'] = val;
                  });
                },
              ),
            ],
          ),

          // If available, show time pickers
          if (isAvailable) ...[
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _timeSelector(
                    "From",
                    start,
                    () => _pickTime(index, 'start', start),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _timeSelector(
                    "To",
                    end,
                    () => _pickTime(index, 'end', end),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Unavailable Hours Checkbox
            Row(
              children: [
                Checkbox(
                  value: dayData['hasUnavailableHours'] ?? false,
                  activeColor: const Color(0xFF6A5AE0),
                  onChanged: (val) {
                    setState(() {
                      weekSchedule[index]['hasUnavailableHours'] = val;
                    });
                  },
                ),
                const Text("Unavailable hours (Break)"),
              ],
            ),

            // Unavailable Hours Time Pickers
            if (dayData['hasUnavailableHours'] == true) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _timeSelector(
                      "From",
                      dayData['unavailableStart'] ??
                          const TimeOfDay(hour: 12, minute: 0),
                      () => _pickTime(
                        index,
                        'unavailableStart',
                        dayData['unavailableStart'] ??
                            const TimeOfDay(hour: 12, minute: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _timeSelector(
                      "To",
                      dayData['unavailableEnd'] ??
                          const TimeOfDay(hour: 13, minute: 0),
                      () => _pickTime(
                        index,
                        'unavailableEnd',
                        dayData['unavailableEnd'] ??
                            const TimeOfDay(hour: 13, minute: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _timeSelector(String label, TimeOfDay time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(int index, String key, TimeOfDay initial) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF6A5AE0)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        weekSchedule[index][key] = picked;
      });
    }
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _saveAvailability,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A5AE0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveAvailability() async {
    setState(() => _isLoading = true);

    // Simulate backend delay or Firebase call
    await Future.delayed(const Duration(seconds: 2));

    // Here you would upload 'weekSchedule' to Firestore
    // e.g., await FirebaseFirestore.instance.collection('sitters').doc(uid).update({...});

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Availability updated successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    // Optional: Go back after saving
    // Navigator.pop(context);
  }
}

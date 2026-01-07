import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String bookingId;
  final String clientId;
  final String sitterId;
  final String sitterName;
  final String sitterProfileImageUrl;
  final String date; // YYYY-MM-DD
  final String time; // HH:mm
  final int durationHours;
  final String specialRequests;
  final bool isEmergency;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final double ratePerHour;
  final double baseCost;
  final double serviceFee;
  final double processingFee;
  final double grandTotal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Booking({
    required this.bookingId,
    required this.clientId,
    required this.sitterId,
    required this.sitterName,
    required this.sitterProfileImageUrl,
    required this.date,
    required this.time,
    required this.durationHours,
    required this.specialRequests,
    required this.isEmergency,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.ratePerHour,
    required this.baseCost,
    required this.serviceFee,
    required this.processingFee,
    required this.grandTotal,
    this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromMap(Map<String, dynamic> data, {String? documentId}) {
    DateTime? parseTimestamp(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    return Booking(
      bookingId: (documentId ?? data['bookingId'] ?? '').toString(),
      clientId: data['clientId']?.toString() ?? '',
      sitterId: data['sitterId']?.toString() ?? '',
      sitterName: data['sitterName']?.toString() ?? '',
      sitterProfileImageUrl: data['sitterProfileImageUrl']?.toString() ?? '',
      date: data['date']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      durationHours: _toInt(data['durationHours']),
      specialRequests: data['specialRequests']?.toString() ?? '',
      isEmergency: data['isEmergency'] is bool ? data['isEmergency'] as bool : false,
      status: data['status']?.toString() ?? '',
      paymentMethod: data['paymentMethod']?.toString() ?? '',
      paymentStatus: data['paymentStatus']?.toString() ?? '',
      ratePerHour: _toDouble(data['ratePerHour']),
      baseCost: _toDouble(data['baseCost']),
      serviceFee: _toDouble(data['serviceFee']),
      processingFee: _toDouble(data['processingFee']),
      grandTotal: _toDouble(data['grandTotal']),
      createdAt: parseTimestamp(data['createdAt']),
      updatedAt: parseTimestamp(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    Timestamp? toTimestamp(DateTime? value) {
      if (value == null) return null;
      return Timestamp.fromDate(value);
    }

    return {
      'bookingId': bookingId,
      'clientId': clientId,
      'sitterId': sitterId,
      'sitterName': sitterName,
      'sitterProfileImageUrl': sitterProfileImageUrl,
      'date': date,
      'time': time,
      'durationHours': durationHours,
      'specialRequests': specialRequests,
      'isEmergency': isEmergency,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'ratePerHour': ratePerHour,
      'baseCost': baseCost,
      'serviceFee': serviceFee,
      'processingFee': processingFee,
      'grandTotal': grandTotal,
      'createdAt': toTimestamp(createdAt),
      'updatedAt': toTimestamp(updatedAt),
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

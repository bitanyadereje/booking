class AppointmentRequest {
  final String childName;
  final DateTime requestedTime;
  String? message; // Add a message field
  String status; // Add a status field

  AppointmentRequest({
    required this.childName,
    required this.requestedTime,
    this.message, // Allow message to be optional
    required this.status, // Status is required
  });
}

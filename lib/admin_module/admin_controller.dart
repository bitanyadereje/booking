import 'package:get/get.dart';

class AdminController extends GetxController {
  // List to store meetings
  RxList<String> meetings = <String>[].obs;

  // Add a meeting
  void scheduleMeeting(String meetingDetails) {
    meetings.add(meetingDetails);
  }

  // Notify clients (simple print statement for now)
  void notifyClients(String message) {
    print("Notification Sent: $message");
  }
}

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:booking/manage_child_page/manage_child_page.dart';

class AppointmentRequest {
  String childName;
  DateTime requestedTime;
  String status;
  String? message; // Optional message from the Father

  AppointmentRequest({
    required this.childName,
    required this.requestedTime,
    this.status = 'pending',
    this.message,
  });
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Dummy data for appointments (Gregorian Dates)
  final Map<DateTime, List<AppointmentRequest>> _appointments = {
    DateTime(2025, 3, 15): [
      AppointmentRequest(
        childName: "Bitanya Dereje",
        requestedTime: DateTime(2025, 3, 15, 10, 0),
      ),
      AppointmentRequest(
        childName: "Abel Kinde",
        requestedTime: DateTime(2025, 3, 15, 11, 30),
      ),
    ],
    DateTime(2025, 3, 16): [
      AppointmentRequest(
        childName: "Alice Brown",
        requestedTime: DateTime(2025, 3, 16, 14, 0),
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF7F2EE),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05), // Responsive height
              _buildHeader(),
              SizedBox(height: screenHeight * 0.02),
              _buildCalendarSection(),
              SizedBox(height: screenHeight * 0.02),
              _buildAppointmentsList(),
              SizedBox(height: screenHeight * 0.02),
              _buildManageChildrenButton(), // Button to navigate to Manage Child page
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, Father!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "Here’s your schedule for today.",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return FractionallySizedBox(
      alignment: Alignment.topCenter,
      widthFactor: 0.9,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.orange.shade200,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    DateTime selectedDate = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );
    List<AppointmentRequest> appointments = _appointments[selectedDate] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Appointments on ${_selectedDay.toLocal()}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        appointments.isNotEmpty
            ? Column(
              children:
                  appointments.map((appt) => _appointmentCard(appt)).toList(),
            )
            : Text(
              "No appointments",
              style: TextStyle(color: Colors.grey.shade600),
            ),
      ],
    );
  }

  Widget _appointmentCard(AppointmentRequest appointment) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.childName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Time: ${appointment.requestedTime.hour}:${appointment.requestedTime.minute}',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'Status: ${appointment.status}',
                style: TextStyle(
                  color:
                      appointment.status == 'approved'
                          ? Colors.green
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (appointment.message != null)
                Text(
                  'Message: ${appointment.message}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.check_circle, color: Colors.green),
                onPressed: () => _showStatusDialog(appointment, 'approved'),
              ),
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.red),
                onPressed: () => _showStatusDialog(appointment, 'declined'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(AppointmentRequest appointment, String status) {
    TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Add a message (Optional)"),
            content: TextField(
              controller: messageController,
              decoration: InputDecoration(hintText: "Write a message..."),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  _updateAppointmentStatus(
                    appointment,
                    status,
                    messageController.text,
                  );
                  Navigator.pop(context);
                },
                child: Text("Confirm"),
              ),
            ],
          ),
    );
  }

  void _updateAppointmentStatus(
    AppointmentRequest appointment,
    String status,
    String message,
  ) {
    setState(() {
      appointment.status = status;
      appointment.message = message;
    });
  }

  // Button to navigate to 'Manage Children' page
  Widget _buildManageChildrenButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManageChildPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.brown, // Button color
      ),
      child: Text("Manage Children"),
    );
  }
}

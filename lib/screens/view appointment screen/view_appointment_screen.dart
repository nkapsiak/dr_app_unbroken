import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../controllers/user provider/user_provider.dart';

class ViewAppointmentsScreen extends StatefulWidget {
  @override
  _ViewAppointmentsScreenState createState() => _ViewAppointmentsScreenState();
}

class _ViewAppointmentsScreenState extends State<ViewAppointmentsScreen> {
  List<dynamic> appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  // Fetch appointments for the logged-in user
  Future<void> _fetchAppointments() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2/doctor_appointment_api/get_appointments.php?user_id=$userId'),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // This will help you see the actual response

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            appointments = List<Map<String, dynamic>>.from(data['appointments']);
            _isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Failed to fetch appointments')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error parsing response: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Your Appointments'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? Center(child: Text('No appointments found'))
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          final appointmentDate = DateTime.parse(appointment['appointment_datetime']);
          final formattedDate = "${appointmentDate.month}/${appointmentDate.day}/${appointmentDate.year} at ${appointmentDate.hour}:${appointmentDate.minute.toString().padLeft(2, '0')}";

          return ListTile(
            title: Text(appointment['description']),
            subtitle: Text(formattedDate),
            trailing: Icon(Icons.calendar_today),
          );
        },
      ),
    );
  }
}

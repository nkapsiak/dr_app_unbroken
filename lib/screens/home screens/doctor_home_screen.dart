// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class DoctorHomeScreen extends StatefulWidget {
//   final int doctorId;
//
//   DoctorHomeScreen({required this.doctorId});
//
//   @override
//   _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
// }
//
// class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
//   List<Map<String, dynamic>> appointments = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAppointments();
//   }
//
//   // Fetch appointments for the doctor
//   Future<void> fetchAppointments() async {
//     final response = await http.get(
//       Uri.parse('http://10.0.2.2/doctor_appointment_api/get_appointments_by_doctor.php?doctor_id=${widget.doctorId}'),
//     );
//
//
//     // Check if the response body contains HTML (e.g., <br>)
//     if (response.body.startsWith('<br>')) {
//       setState(() {
//         isLoading = false;
//       });
//       _showErrorDialog('Unexpected error from server. Please try again later.');
//       return;
//     }
//
//     // Proceed to decode the JSON if no HTML content is detected
//     if (response.statusCode == 200) {
//       try {
//         final data = json.decode(response.body);
//
//         if (data['status'] == 'success') {
//           setState(() {
//             appointments = List<Map<String, dynamic>>.from(data['appointments']);
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//           _showErrorDialog('Failed to fetch appointments');
//         }
//       } catch (e) {
//         setState(() {
//           isLoading = false;
//         });
//         _showErrorDialog('Error parsing response. Please try again later.');
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       _showErrorDialog('Error: ${response.statusCode}');
//     }
//   }
//
//   // Show an error dialog
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doctor\'s Appointments'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : appointments.isEmpty
//           ? Center(child: Text('No appointments found'))
//           : ListView.builder(
//         itemCount: appointments.length,
//         itemBuilder: (context, index) {
//           final appointment = appointments[index];
//           return Card(
//             margin: EdgeInsets.all(10),
//             child: ListTile(
//               title: Text('Patient: ${appointment['user_name']}'),
//               subtitle: Text(
//                 'Time: ${appointment['appointment_datetime']}\nDescription: ${appointment['description']}',
//               ),
//               trailing: Icon(Icons.access_time),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorHomeScreen extends StatefulWidget {
  final int doctorId;

  DoctorHomeScreen({required this.doctorId});

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  // Fetch appointments for the doctor
  Future<void> fetchAppointments() async {
    final url = 'http://10.0.2.2/doctor_appointment_api/get_appointments_by_doctor.php?doctor_id=${widget.doctorId}';
    print('Fetching appointments from: $url');  // <-- Debugging: print URL

    final response = await http.get(Uri.parse(url));

    // Debugging: print status code and response body
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');  // <-- Debugging: print raw response body

    // Check if the response body contains HTML (e.g., <br>)
    if (response.body.startsWith('<br>')) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Unexpected error from server. Please try again later.');
      return;
    }

    // Proceed to decode the JSON if no HTML content is detected
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        print('Decoded Data: $data');  // <-- Debugging: print the decoded data

        if (data['status'] == 'success') {
          setState(() {
            appointments = List<Map<String, dynamic>>.from(data['appointments']);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          _showErrorDialog('Failed to fetch appointments');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Error parsing response. Please try again later.');
        print('Error parsing response: $e');  // <-- Debugging: print parsing error
      }
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Error: ${response.statusCode}');
      print('Error response: ${response.statusCode}');  // <-- Debugging: print error response
    }
  }

  // Show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor\'s Appointments'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? Center(child: Text('No appointments found'))
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          // Debugging: print the appointment details
          print('Appointment $index: $appointment');  // <-- Debugging: print each appointment
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('Patient: ${appointment['user_name']}'),
              subtitle: Text(
                'Time: ${appointment['appointment_datetime']}\nDescription: ${appointment['description']}',
              ),
              trailing: Icon(Icons.access_time),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../book appointment screens/book_appointment_screen.dart';
import 'widgets/clinic_visit_button.dart';
import 'widgets/doctor_grid.dart';
import 'widgets/symptom_row.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreen createState() => _DoctorListScreen();
}

class _DoctorListScreen extends State<DoctorListScreen> {
  List<Map<String, dynamic>> doctors = [];
  bool isLoading = true;

  List<String> symptoms = [
    "Temperature",
    "Sniffle",
    "Fever",
    "Cough",
    "Cold",
  ];

  List<String> imgs = [
    "doctor 1.jpg",
    "doctor 2.jpg",
    "doctor 3.jpg",
    "doctor 4.jpg",
    "doctor 5.jpg",
  ];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    final response = await http.get(Uri.parse('http://192.168.1.121/doctor_appointment_api/get_doctors.php'));

    if (response.statusCode == 200) {
      setState(() {
        doctors = List<Map<String, dynamic>>.from(json.decode(response.body));
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load doctors. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Appointment App'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Doctors",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
            ),
            DoctorGrid(doctors: doctors, imgs: imgs),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPatientInfoScreen extends StatefulWidget {
  @override
  _AddPatientInfoScreenState createState() => _AddPatientInfoScreenState();
}

class _AddPatientInfoScreenState extends State<AddPatientInfoScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> _addPatientInfo() async {
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;
    final String phoneNumber = _phoneNumberController.text;

    if (firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty) {
      setState(() {
        _message = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.1.121/doctor_appointment_api/add_patient_info.php'),  // Replace with your server URL
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
      },
    );

    setState(() {
      _isLoading = false;
    });

    final data = json.decode(response.body);

    if (data['status'] == 'success') {
      setState(() {
        _message = 'Patient information added successfully!';
      });
    } else {
      setState(() {
        _message = data['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Patient Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _firstNameController, decoration: InputDecoration(labelText: 'First Name')),
            TextField(controller: _lastNameController, decoration: InputDecoration(labelText: 'Last Name')),
            TextField(controller: _phoneNumberController, decoration: InputDecoration(labelText: 'Phone Number')),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: _addPatientInfo, child: Text('Add Patient Info')),
            SizedBox(height: 20),
            Text(_message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

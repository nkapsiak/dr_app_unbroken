import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterDoctorScreen extends StatefulWidget {
  @override
  _RegisterDoctorScreenState createState() => _RegisterDoctorScreenState();
}

class _RegisterDoctorScreenState extends State<RegisterDoctorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // New controller for confirm password
  final TextEditingController _descriptionController = TextEditingController(); // Controller for description
  bool _isLoading = false;

  // Method to handle doctor registration
  Future<void> _registerDoctor() async {
    final String name = _nameController.text;
    final String specialty = _specialtyController.text;
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text; // Get the confirm password
    final String description = _descriptionController.text; // Get the description

    // Validate if all fields are filled and password matches confirm password
    if (name.isEmpty || specialty.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Send the data to the backend PHP file
    final response = await http.post(
      Uri.parse('http://192.168.1.121/doctor_appointment_api/register_doctor.php'), // Localhost address for emulator
      body: {
        'name': name,
        'specialty': specialty,
        'username': username,
        'password': password,
        'description': description, // Send the description
      },
    );
    print("Response body: ${response.body}");

    setState(() {
      _isLoading = false;
    });

    // Handle the response from the PHP script
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Doctor registered successfully!'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context); // Go back after successful registration
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to register doctor. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Doctor Name'),
            ),
            TextField(
              controller: _specialtyController,
              decoration: InputDecoration(labelText: 'Specialty'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _confirmPasswordController, // Confirm password field
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _registerDoctor,
              child: Text('Register Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}

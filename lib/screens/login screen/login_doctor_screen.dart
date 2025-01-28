// **Login Screen for Doctors**
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';

class LoginDoctorScreen extends StatefulWidget {
  @override
  _LoginDoctorScreenState createState() => _LoginDoctorScreenState();
}

class _LoginDoctorScreenState extends State<LoginDoctorScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginDoctor() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both username and password'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2/doctor_appointment_api/login_doctor.php'),
      body: {
        'username': username,
        'password': password,
      },
    );

    setState(() {
      _isLoading = false;
    });

    print('Response Status: ${response.statusCode}');
    print('Raw Response Body: ${response.body}');  // Print raw response for debugging

    if (response.statusCode == 200) {
      // Check if the response is JSON
      try {
        final data = json.decode(response.body);  // Try parsing the response
        print("Response data: $data"); // For debugging
        if (data['status'] == 'success') {
          final doctorId = int.tryParse(data['doctor_id'].toString()); // Parse doctor_id safely
          if (doctorId != null) {
            Navigator.pushReplacementNamed(
              context,
              '/doctorHome',
              arguments: doctorId,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Invalid Doctor ID in the response'),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message']),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print('Error parsing response: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: Invalid response format or server issue'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      // Handle non-200 status codes, like 404 or 500
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Failed to login. Please try again later or check the server.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _loginDoctor,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/doctorRegister');
              },
              child: Text('Don\'t have an account? Register as Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
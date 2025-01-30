import 'dart:convert';
import 'package:dr_app_unbroken/screens/forgot%20password/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendResetCode() async {
    final phone = _phoneController.text;

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number is required')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.1.121/doctor_appointment_api/forgot_password_sms.php'),
      body: {
        'phone': phone,
      },
    );

    // Print the response body to the console for debugging
    print('Response body: ${response.body}');

    setState(() {
      _isLoading = false;
    });

    // Check for a successful response and parse JSON
    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body); // This might throw an exception
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reset code sent to your phone')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>ResetPasswordScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } catch (e) {
        // Handle any errors when parsing JSON
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error parsing response: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Enter your phone number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _sendResetCode,
              child: Text('Send Reset Code'),
            ),
          ],
        ),
      ),
    );
  }
}

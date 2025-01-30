import 'dart:convert';
import 'package:dr_app_unbroken/screens/login%20screen/login_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _resetCodeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> _sendResetCode() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your phone number')),
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

    setState(() {
      _isLoading = false;
    });

    final data = json.decode(response.body);

    if (data['status'] == 'success') {
      setState(() {
        _message = 'Reset code sent to your phone.';
      });
    } else {
      setState(() {
        _message = 'Failed to send reset code.';
      });
    }
  }

  Future<void> _verifyResetCode() async {
    final resetCode = _resetCodeController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (resetCode.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the reset code and new password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });


    final response = await http.post(
      Uri.parse('http://192.168.1.121/doctor_appointment_api/verify_reset_code.php'),
      body: {
        'reset_code': resetCode,
        'new_password': newPassword,
      },
    );

    setState(() {
      _isLoading = false;
    });

    final data = json.decode(response.body);

    if (data['status'] == 'success') {
      setState(() {
        _message = 'Password reset successful!';
      });
    } else {
      setState(() {
        _message = 'Invalid reset code or error resetting password.';
      });
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginUserScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField(
            //   controller: _phoneController,
            //   decoration: InputDecoration(labelText: 'Phone Number'),
            //   keyboardType: TextInputType.phone,
            // ),
            // SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: _sendResetCode,
            //   child: _isLoading
            //       ? CircularProgressIndicator()
            //       : Text('Send Reset Code'),
            // ),
            // SizedBox(height: 20),
            TextField(
              controller: _resetCodeController,
              decoration: InputDecoration(labelText: 'Enter Reset Code'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'Enter New Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _verifyResetCode,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Verify Reset Code and Reset Password'),
            ),
            SizedBox(height: 20),
            Text(_message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

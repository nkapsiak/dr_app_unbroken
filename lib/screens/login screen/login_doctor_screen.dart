// **Login Screen for Doctors**
import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
      Uri.parse('http://192.168.1.121/doctor_appointment_api/login_doctor.php'),
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
  bool passToggle = true;
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Doctor Login"),),
      body: Material(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox( height: 10,),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Image.asset("images/doctors.jpg"),
                  ),
                  SizedBox(height: 10,),
                  Padding(padding: EdgeInsets.all(12),
                    child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Enter Username"),
                            prefixIcon: Icon(Icons.person)
                        )
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(12),
                    child: TextField(
                        controller: _passwordController,
                        obscureText: passToggle ? true : false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Enter Password"),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: InkWell(
                              onTap: (){
                                if(passToggle == true){
                                  passToggle = false;
                                }
                                else{
                                  passToggle = true;
                                }
                                setState(() {

                                });
                              },
                              child: passToggle
                                  ? Icon(CupertinoIcons.eye_slash_fill)
                                  : Icon(CupertinoIcons.eye_slash),
                            )
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: Color(0xFF700031),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: _loginDoctor,
                          child: Padding(padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 40 ),
                            child: Center(
                              child: Text("Log In",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),),
                            ),),

                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/doctorRegister');
                          },
                          child: Text("Create Account",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF700031)
                            ),))
                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:dr_app_unbroken/screens/forgot%20password/reset_password_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../controllers/user provider/user_provider.dart';
import '../forgot password/forgot_password_screen.dart';
import '../home screens/user_home_screen.dart';

class LoginUserScreen extends StatefulWidget {
  @override
  _LoginUserScreenState createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both username and password'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    print('Request Body: username = $username, password = $password');

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://192.168.1.121/doctor_appointment_api/login_user.php'),
      body: {
        'username': username,
        'password': password,
      },
    );

    setState(() {
      _isLoading = false;
    });
    print("Response: ${response.body}"); // Debugging: Check response from server

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Response JSON: $data"); // Debugging: Log the response body
      if (data != null && data['status'] == 'success' && data.containsKey('username')) {
        String userName = data['username'] ?? ''; // Safe fallback to empty string
        final userId = data['user_id'].toString();
        print('Login Successful, navigating to UserHomeScreen with username: $userName');
        Provider.of<UserProvider>(context, listen: false).setUser(userId, userName);

        // Navigate to UserHomeScreen with the username
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserHomeScreen(userName: userName), // Pass the username here
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Failed to login. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: _loginUser,
//               child: Text('Login'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/userRegister');
//               },
//               child: Text('Don\'t have an account? Register as User'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
bool passToggle = true;
Widget build(BuildContext context) {

  return Scaffold(
    appBar: AppBar(title: Text("User Login"),),
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
                        onTap: _loginUser,
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
                Column(
                  children: [
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
                              Navigator.pushNamed(context, '/userRegister');
                            },
                            child: Text("Create Account",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF700031)
                              ),)),

                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: Text('Forgot Password?'),
                    )

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
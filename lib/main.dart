import 'dart:convert';
import 'package:dr_app_unbroken/screens/view%20appointment%20screen/view_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'screens/home screens/doctor_home_screen.dart';
import 'screens/home screens/doctor_list_screen.dart';
import 'screens/home screens/user_home_screen.dart';
import 'screens/login screen/login_screen.dart';
import 'screens/registration screens/register_doctor_screen.dart';
import 'screens/registration screens/register_user_screen.dart';
import 'controllers/user provider/user_provider.dart';

// Main function to run the app
void main() {
  runApp(
      ChangeNotifierProvider(
          create: (context) => UserProvider(),
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Doctor Appointment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/doctorRegister': (context) => RegisterDoctorScreen(),
        '/userRegister': (context) => RegisterUserScreen(),
        '/doctorList': (context) => DoctorListScreen(),
        '/userHome': (context) {
             final userName = ModalRoute.of(context)?.settings.arguments as String? ?? '';
             print('UserHomeScreen received username: $userName');
              return UserHomeScreen(userName: userName,);
              },
        '/viewAppointments': (context) => ViewAppointmentsScreen(),
        '/doctorHome': (context) {
            final doctorId = ModalRoute.of(context)!.settings.arguments as int;
            return DoctorHomeScreen(doctorId: doctorId);},},

      debugShowCheckedModeBanner: false,
    );
  }
}

// **Login Screen (Choose between Doctor or User Login)**
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => LoginDoctorScreen()));
//               },
//               child: Text('Login as Doctor'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => LoginUserScreen()));
//               },
//               child: Text('Login as User'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// **Login Screen for Doctors**
// class LoginDoctorScreen extends StatefulWidget {
//   @override
//   _LoginDoctorScreenState createState() => _LoginDoctorScreenState();
// }
//
// class _LoginDoctorScreenState extends State<LoginDoctorScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//
//   Future<void> _loginDoctor() async {
//     final String username = _usernameController.text;
//     final String password = _passwordController.text;
//
//     if (username.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Please enter both username and password'),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final response = await http.post(
//       Uri.parse('http://192.168.1.121/doctor_appointment_api/login_doctor.php'),
//       body: {
//         'username': username,
//         'password': password,
//       },
//     );
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == 'success') {
//         Navigator.pushReplacementNamed(context, '/doctorList');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(data['message']),
//           backgroundColor: Colors.red,
//         ));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: Failed to login. Please try again later.'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doctor Login'),
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
//               onPressed: _loginDoctor,
//               child: Text('Login'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/doctorRegister');
//               },
//               child: Text('Don\'t have an account? Register as Doctor'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// **Login Screen for Users (Patients)**
// class LoginUserScreen extends StatefulWidget {
//   @override
//   _LoginUserScreenState createState() => _LoginUserScreenState();
// }
//
// class _LoginUserScreenState extends State<LoginUserScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//
//   Future<void> _loginUser() async {
//     final String username = _usernameController.text;
//     final String password = _passwordController.text;
//
//     if (username.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Please enter both username and password'),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final response = await http.post(
//       Uri.parse('http://192.168.1.121/doctor_appointment_api/login_user.php'),
//       body: {
//         'username': username,
//         'password': password,
//       },
//     );
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == 'success') {
//         Navigator.pushReplacementNamed(context, '/userHome');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(data['message']),
//           backgroundColor: Colors.red,
//         ));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: Failed to login. Please try again later.'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }
//
//   @override
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

// **Doctor Registration Screen**

// class RegisterDoctorScreen extends StatefulWidget {
//   @override
//   _RegisterDoctorScreenState createState() => _RegisterDoctorScreenState();
// }
//
// class _RegisterDoctorScreenState extends State<RegisterDoctorScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _specialtyController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//
//   // Method to handle doctor registration
//   Future<void> _registerDoctor() async {
//     final String name = _nameController.text;
//     final String specialty = _specialtyController.text;
//     final String username = _usernameController.text;
//     final String password = _passwordController.text;
//
//     if (name.isEmpty || specialty.isEmpty || username.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Please fill in all fields'),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     // Send the data to the backend PHP file
//     final response = await http.post(
//       Uri.parse('http://192.168.1.121/doctor_appointment_api/register_doctor.php'), // Localhost address for emulator
//       body: {
//         'name': name,
//         'specialty': specialty,
//         'username': username,
//         'password': password,
//       },
//     );
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     // Handle the response from the PHP script
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == 'success') {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Doctor registered successfully!'),
//           backgroundColor: Colors.green,
//         ));
//         Navigator.pop(context); // Go back after successful registration
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(data['message']),
//           backgroundColor: Colors.red,
//         ));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to register doctor. Please try again later.'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register Doctor'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Doctor Name'),
//             ),
//             TextField(
//               controller: _specialtyController,
//               decoration: InputDecoration(labelText: 'Specialty'),
//             ),
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Password'),
//             ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: _registerDoctor,
//               child: Text('Register Doctor'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// **User Registration Screen**
// class RegisterUserScreen extends StatefulWidget {
//   @override
//   _RegisterUserScreenState createState() => _RegisterUserScreenState();
// }
//
// class _RegisterUserScreenState extends State<RegisterUserScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//
//   Future<void> _registerUser() async {
//     final String name = _nameController.text;
//     final String username = _usernameController.text;
//     final String password = _passwordController.text;
//
//     if (name.isEmpty || username.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('All fields are required'),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final response = await http.post(
//       Uri.parse('http://192.168.1.121/doctor_appointment_api/register_user.php'),
//       body: {
//         'name': name,
//         'username': username,
//         'password': password,
//       },
//     );
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == 'success') {
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(data['message']),
//           backgroundColor: Colors.red,
//         ));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: Failed to register. Please try again later.'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register User'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
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
//               onPressed: _registerUser,
//               child: Text('Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// **Doctor List Screen (After Doctor Login)**
// class DoctorListScreen extends StatefulWidget {
//   @override
//   _DoctorListScreenState createState() => _DoctorListScreenState();
// }
//
// class _DoctorListScreenState extends State<DoctorListScreen> {
//   List doctors = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDoctors();
//   }
//
//   Future<void> fetchDoctors() async {
//     final response = await http.get(Uri.parse('http://192.168.1.121/doctor_appointment_api/get_doctors.php'));
//
//     if (response.statusCode == 200) {
//       setState(() {
//         doctors = json.decode(response.body);
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load doctors');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doctors List'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: doctors.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(doctors[index]['name']),
//             subtitle: Text(doctors[index]['specialty']),
//           );
//         },
//       ),
//     );
//   }
// }

// UserHomeScreen (After User Login)
// class UserHomeScreen extends StatefulWidget {
//   @override
//   _UserHomeScreenState createState() => _UserHomeScreenState();
// }
//
// class _UserHomeScreenState extends State<UserHomeScreen> {
//   List doctors = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDoctors();
//   }
//
//   Future<void> fetchDoctors() async {
//     final response = await http.get(Uri.parse('http://192.168.1.121/doctor_appointment_api/get_doctors.php'));
//
//     if (response.statusCode == 200) {
//       setState(() {
//         doctors = json.decode(response.body);
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load doctors');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doctor Appointment App'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: doctors.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(doctors[index]['name']),
//             subtitle: Text(doctors[index]['specialty']),
//             onTap: () {
//               // Ensure 'id' is treated as an int
//               int doctorId = int.tryParse(doctors[index]['id'].toString()) ?? 0;
//
//               // Navigate to appointment booking screen, pass doctor id
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => BookAppointmentScreen(
//                     doctorId: doctorId,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



// Appointment Booking Screen
// class BookAppointmentScreen extends StatefulWidget {
//   final int doctorId;
//
//   BookAppointmentScreen({required this.doctorId});
//
//   @override
//   _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
// }
//
// class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
//   final TextEditingController _descriptionController = TextEditingController();
//   DateTime? _selectedDate;
//   List<String> availableTimes = [
//     '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM',
//     '12:00 PM', '12:30 PM', '01:00 PM', '01:30 PM', '02:00 PM', '02:30 PM',
//     '03:00 PM', '03:30 PM', '04:00 PM', '04:30 PM', '05:00 PM',
//   ];
//   Set<String> bookedTimes = {}; // Set of already booked time slots
//   String? _selectedTime;
//   bool _isBooking = false;
//
//   // Function to pick a date
//   Future<void> _pickDate() async {
//     DateTime today = DateTime.now();
//     DateTime initialDate = _selectedDate ?? today;
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: today,
//       lastDate: DateTime(today.year + 1),
//     );
//
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _selectedTime = null; // Reset selected time
//         _fetchBookedTimes(); // Fetch booked times when date is selected
//       });
//     }
//   }
//
//   // Function to fetch booked time slots for the selected date
//   Future<void> _fetchBookedTimes() async {
//     if (_selectedDate == null) return;
//
//     final formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
//
//     final response = await http.get(
//       Uri.parse('http://192.168.1.121/doctor_appointment_api/get_booked_times.php?date=$formattedDate&doctor_id=${widget.doctorId}'),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//
//       if (data['status'] == 'success') {
//         setState(() {
//           bookedTimes = Set<String>.from(data['booked_times']);
//         });
//       } else {
//         _showErrorDialog('Failed to fetch booked times.');
//       }
//     } else {
//       _showErrorDialog('Failed to load booked times.');
//     }
//   }
//
//   // Function to handle appointment booking
//   Future<void> _bookAppointment() async {
//     if (_selectedDate == null || _selectedTime == null || _descriptionController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please complete all fields')),
//       );
//       return;
//     }
//
//     setState(() {
//       _isBooking = true;
//     });
//
//     final appointmentDateTime = DateTime(
//       _selectedDate!.year,
//       _selectedDate!.month,
//       _selectedDate!.day,
//       int.parse(_selectedTime!.split(":")[0]),
//       int.parse(_selectedTime!.split(":")[1].split(" ")[0]),
//     );
//
//     final response = await http.post(
//       Uri.parse('http://192.168.1.121/doctor_appointment_api/book_appointment.php'),
//       body: {
//         'doctor_id': widget.doctorId.toString(),
//         'description': _descriptionController.text,
//         'appointment_datetime': appointmentDateTime.toIso8601String(),
//         'user_id': '1', // Assuming the user_id is 1, change accordingly
//       },
//     );
//
//     setState(() {
//       _isBooking = false;
//     });
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == 'success') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Appointment booked successfully!')),
//         );
//         Navigator.pop(context); // Go back to previous screen
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'Failed to book appointment')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${response.statusCode}')),
//       );
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
//         title: Text('Book Appointment'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _descriptionController,
//               decoration: InputDecoration(
//                 labelText: 'Appointment Description',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextButton(
//                     onPressed: _pickDate,
//                     child: Text(
//                       _selectedDate == null
//                           ? 'Select Date'
//                           : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             _selectedDate == null
//                 ? Container()
//                 : Column(
//               children: [
//                 Text('Select a Time:'),
//                 GridView.builder(
//                   shrinkWrap: true,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     childAspectRatio: 2,
//                   ),
//                   itemCount: availableTimes.length,
//                   itemBuilder: (context, index) {
//                     final time = availableTimes[index];
//                     final isBooked = bookedTimes.contains(time);
//                     return GestureDetector(
//                       onTap: isBooked
//                           ? null
//                           : () {
//                         setState(() {
//                           _selectedTime = time;
//                         });
//                       },
//                       child: Container(
//                         margin: EdgeInsets.all(4.0),
//                         decoration: BoxDecoration(
//                           color: isBooked
//                               ? Colors.grey
//                               : (_selectedTime == time ? Colors.blue : Colors.white),
//                           borderRadius: BorderRadius.circular(8.0),
//                           border: Border.all(color: Colors.blue),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           time,
//                           style: TextStyle(
//                             color: isBooked ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 32),
//             _isBooking
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: _bookAppointment,
//               child: Text('Book Appointment'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
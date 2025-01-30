import 'dart:convert';
import 'package:dr_app_unbroken/screens/settings%20screen/settings_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/user provider/user_provider.dart';
import '../book appointment screens/book_appointment_screen.dart';
import 'doctor_list_screen.dart';
import 'widgets/clinic_visit_button.dart';
import 'widgets/doctor_grid.dart';
import 'widgets/symptom_row.dart';
//
// // class UserHomeScreen extends StatefulWidget {
// //   @override
// //   _UserHomeScreenState createState() => _UserHomeScreenState();
// // }
// //
// // class _UserHomeScreenState extends State<UserHomeScreen> {
// //   List doctors = [];
// //   bool isLoading = true;
// //
// //   List symptoms = [
// //     "Temperature",
// //     "Sniffle",
// //     "Fever",
// //     "Cough",
// //     "Cold"
// //
// //   ];
// //
// //   List imgs = [
// //     "doctor 1.jpg",
// //     "doctor 2.jpg",
// //     "doctor 3.jpg",
// //     "doctor 4.jpg",
// //     "doctor 5.jpg",
// //
// //   ];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchDoctors();
// //   }
// //
// //   Future<void> fetchDoctors() async {
// //     final response = await http.get(Uri.parse('http://192.168.1.121/doctor_appointment_api/get_doctors.php'));
// //
// //     if (response.statusCode == 200) {
// //       setState(() {
// //         doctors = json.decode(response.body);
// //         isLoading = false;
// //       });
// //     } else {
// //       // Show an error message using AlertDialog if the request fails
// //       showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             title: Text('Error'),
// //             content: Text('Failed to load doctors. Please try again later.'),
// //             actions: <Widget>[
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.of(context).pop();
// //                 },
// //                 child: Text('OK'),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Doctor Appointment App'),
// //       ),
// //       // body: isLoading
// //       //     ? Center(child: CircularProgressIndicator())
// //       //     : ListView.builder(
// //       //   itemCount: doctors.length,
// //       //   itemBuilder: (context, index) {
// //       //     return ListTile(
// //       //       title: Text(doctors[index]['name']),
// //       //       subtitle: Text(doctors[index]['specialty']),
// //       //       onTap: () {
// //       //         // Ensure 'id' is treated as an int
// //       //         int doctorId = int.tryParse(doctors[index]['id'].toString()) ?? 0;
// //       //
// //       //         // Navigate to appointment booking screen, pass doctor id
// //       //         Navigator.push(
// //       //           context,
// //       //           MaterialPageRoute(
// //       //             builder: (context) => BookAppointmentScreen(
// //       //               doctorId: doctorId,
// //       //             ),
// //       //           ),
// //       //         );
// //       //       },
// //       //     );
// //       //   },
// //       // ),
// //       body: Material(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.only(top: 40),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [const Padding(padding: EdgeInsets.symmetric(horizontal: 15),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text("Hello Alex",
// //                       style: TextStyle(
// //                           fontSize: 35,
// //                           fontWeight: FontWeight.w500
// //                       ),
// //                     ),
// //                     CircleAvatar(
// //                         radius: 25,
// //                         backgroundImage: AssetImage("images/doctor 1.jpg")
// //                     )
// //                   ],
// //                 )
// //             ),
// //               const SizedBox(height: 30,),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   InkWell(
// //                     onTap: (){
// //                       Navigator.push(context, MaterialPageRoute(
// //                           builder: (context) => DoctorListScreen()));
// //                     },
// //                     child: Container(
// //                       width: MediaQuery.of(context).size.width * 0.4,
// //                       padding: const EdgeInsets.all(20),
// //                       decoration: BoxDecoration(
// //                           color: const Color(0xFF700031),
// //                           borderRadius: BorderRadius.circular(10),
// //                           boxShadow: const [
// //                             BoxShadow(
// //                                 color: Colors.black12,
// //                                 blurRadius: 6,
// //                                 spreadRadius: 4
// //                             )
// //                           ]
// //                       ),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Container(
// //                             padding: const EdgeInsets.all(8),
// //                             decoration: const BoxDecoration(
// //                               color: Colors.white,
// //                               shape: BoxShape.circle,
// //                             ),
// //                             child: const Icon(
// //                               Icons.add,
// //                               color: Color(0xFF700031),
// //                               size: 35,),
// //                           ),
// //                           const SizedBox(height: 30,),
// //                           const Text("Clinic Visits",
// //                             style: TextStyle(
// //                                 fontSize: 18,
// //                                 color: Colors.white,
// //                                 fontWeight: FontWeight.w500
// //                             ),),
// //                           const SizedBox(height: 5,),
// //                           const Text("Make an apppointment",
// //                             style: TextStyle(
// //                                 color: Colors.white54
// //                             ),)
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                   InkWell(
// //                     onTap: (){},
// //                     child: Container(
// //                       width: MediaQuery.of(context).size.width * 0.4,
// //                       padding: const EdgeInsets.all(20),
// //                       decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(10),
// //                           boxShadow: const [
// //                             BoxShadow(
// //                                 color: Colors.black12,
// //                                 blurRadius: 6,
// //                                 spreadRadius: 4
// //                             )
// //                           ]
// //                       ),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Container(
// //                             padding: const EdgeInsets.all(8),
// //                             decoration: const BoxDecoration(
// //                               color: Color(0xFFF8D4E4),
// //                               shape: BoxShape.circle,
// //                             ),
// //                             child: const Icon(
// //                               Icons.home_filled,
// //                               color: Color(0xFF700031),
// //                               size: 35,),
// //                           ),
// //                           const SizedBox(height: 30,),
// //                           const Text("Home Visits",
// //                             style: TextStyle(
// //                                 fontSize: 18,
// //                                 // color: Colors.black,
// //                                 fontWeight: FontWeight.w500
// //                             ),),
// //                           const SizedBox(height: 5,),
// //                           const Text("Call the doctor home",
// //                             style: TextStyle(
// //                                 color: Colors.black54
// //                             ),)
// //                         ],
// //                       ),
// //                     ),
// //                   )
// //                 ],
// //               ),
// //               const SizedBox(height: 25,),
// //               const Padding(
// //                 padding: EdgeInsets.only(left: 15),
// //                 child: Text("What are your symptoms?",
// //                   style: TextStyle(
// //                       fontSize: 23,
// //                       fontWeight: FontWeight.w500,
// //                       color: Colors.black54
// //                   ),),
// //               ),
// //               SizedBox(height: 70,
// //                   child: ListView.builder(
// //                     shrinkWrap: true,
// //                     scrollDirection: Axis.horizontal,
// //                     itemCount: symptoms.length,
// //                     itemBuilder: (context, index){
// //                       return Container(
// //                         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
// //                         padding: const EdgeInsets.symmetric(horizontal: 25),
// //                         decoration: BoxDecoration(
// //                             color: const Color(0xFFF4F6FA),
// //                             borderRadius: BorderRadius.circular(10),
// //                             boxShadow: const [
// //                               BoxShadow(
// //                                   color: Colors.black12,
// //                                   blurRadius: 4,
// //                                   spreadRadius: 2
// //                               )
// //                             ]
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             symptoms[index],
// //                             style: const TextStyle(
// //                                 fontWeight: FontWeight.w500,
// //                                 fontSize: 16,
// //                                 color: Colors.black54
// //                             ),
// //                           ),
// //                         ),
// //
// //                       );
// //                     },)
// //               ),
// //               const SizedBox(height: 10),
// //               const Padding(padding: EdgeInsets.only(left: 15),
// //                 child: Text("Popular Doctors",
// //                   style: TextStyle(
// //                       fontSize: 23,
// //                       fontWeight: FontWeight.w500,
// //                       color: Colors.black54
// //                   ),
// //                 ),
// //               ),
// //               // GridView.builder(
// //               //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //               //         crossAxisCount: 2),
// //               //     itemCount: doctors.length,
// //               //     shrinkWrap: true,
// //               //     physics: const NeverScrollableScrollPhysics(),
// //               //     itemBuilder: (context, index){
// //               //       return InkWell(
// //               //         onTap: (){
// //               //           int doctorId = int.tryParse(doctors[index]['id'].toString()) ?? 0;
// //               //
// //               //           // Navigate to appointment booking screen, pass doctor id
// //               //           Navigator.push(
// //               //               context,
// //               //               MaterialPageRoute(
// //               //                   builder: (context) => BookAppointmentScreen(
// //               //                     doctorId: doctorId,)));
// //               //         },
// //               //         child: Container(
// //               //           margin: const EdgeInsets.all(10),
// //               //           padding: const EdgeInsets.symmetric(vertical: 15),
// //               //           decoration: BoxDecoration(
// //               //               color: Colors.white,
// //               //               borderRadius: BorderRadius.circular(10),
// //               //               boxShadow: const [
// //               //                 BoxShadow(
// //               //                     color: Colors.black12,
// //               //                     blurRadius: 4,
// //               //                     spreadRadius: 2
// //               //                 )
// //               //               ]
// //               //           ),
// //               //           child: Column(
// //               //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               //             children: [
// //               //               CircleAvatar(
// //               //                 radius: 30,
// //               //                 backgroundImage: AssetImage("images/${imgs[index]}"),
// //               //               ),
// //               //               Text(doctors[index]['name']),
// //               //               Text(doctors[index]['specialty']),
// //               //               const Row(
// //               //                 mainAxisSize: MainAxisSize.min,
// //               //                 mainAxisAlignment: MainAxisAlignment.center,
// //               //                 children: [
// //               //                   Icon(
// //               //                     Icons.star,
// //               //                     color: Colors.amber,
// //               //                   ),
// //               //                   Text("4.9",
// //               //                     style: TextStyle(
// //               //                         color: Colors.black45
// //               //                     ),)
// //               //                 ],
// //               //               )
// //               //
// //               //             ],
// //               //           ),
// //               //         ),
// //               //
// //               //       );
// //               //     })
// //               GridView.builder(
// //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                   crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3, // 2 columns for small screens, 3 columns for larger screens
// //                   crossAxisSpacing: 10,
// //                   mainAxisSpacing: 10,
// //                 ),
// //                 itemCount: doctors.length,
// //                 shrinkWrap: true,
// //                 physics: NeverScrollableScrollPhysics(),
// //                 itemBuilder: (context, index) {
// //                   return InkWell(
// //                     onTap: () {
// //                       int doctorId = int.tryParse(doctors[index]['id'].toString()) ?? 0;
// //                       if(doctorId > 0){
// //                         Navigator.push(context,
// //                         MaterialPageRoute(
// //                           builder: (context) => BookAppointmentScreen(doctorId: doctorId),
// //                         ),
// //                       );
// //                       }else {
// //                         // Show an error message using an AlertDialog if the doctorId is invalid
// //                         showDialog(context: context, builder: (
// //                             BuildContext context) {
// //                           return AlertDialog(title: Text('Error'),
// //                             content: Text(
// //                                 'Invalid doctor ID. Please try again later.'),
// //                             actions: <Widget>[
// //                               TextButton(
// //                                 onPressed: () {
// //                                   Navigator.of(context).pop();
// //                                 },
// //                                 child: Text('OK'),
// //                               ),
// //                             ],
// //                           );
// //                         },
// //                         );
// //                       }
// //                     },
// //                     child: Container(
// //                       margin: EdgeInsets.all(10),
// //                       padding: EdgeInsets.symmetric(vertical: 15),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(10),
// //                         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2)],
// //                       ),
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                         children: [
// //                           CircleAvatar(
// //                             radius: 30,
// //                             backgroundImage: AssetImage("images/${imgs[index]}"),
// //                           ),
// //                           Text(doctors[index]['name']),
// //                           Text(doctors[index]['specialty']),
// //                           Row(
// //                             mainAxisSize: MainAxisSize.min,
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               Icon(
// //                                 Icons.star,
// //                                 color: Colors.amber,
// //                               ),
// //                               Text(
// //                                 "4.9",
// //                                 style: TextStyle(color: Colors.black45),
// //                               )
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               )
// //
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// class UserHomeScreen extends StatefulWidget {
//   @override
//   _UserHomeScreenState createState() => _UserHomeScreenState();
// }
//
// class _UserHomeScreenState extends State<UserHomeScreen> {
//   List<Map<String, dynamic>> doctors = [];
//   bool isLoading = true;
//
//   List<String> symptoms = [
//     "Temperature",
//     "Sniffle",
//     "Fever",
//     "Cough",
//     "Cold",
//   ];
//
//   List<String> imgs = [
//     "doctor 1.jpg",
//     "doctor 2.jpg",
//     "doctor 3.jpg",
//     "doctor 4.jpg",
//     "doctor 5.jpg",
//   ];
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
//         doctors = List<Map<String, dynamic>>.from(json.decode(response.body));
//         isLoading = false;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to load doctors. Please try again later.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       setState(() {
//         isLoading = false;
//       });
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
//           : SingleChildScrollView(
//         padding: const EdgeInsets.only(top: 40),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Hello Alex",
//                     style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
//                   ),
//                   CircleAvatar(
//                     radius: 25,
//                     backgroundImage: AssetImage("images/doctor 1.jpg"),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ClinicVisitButton(
//                   title: "Clinic Visits",
//                   subtitle: "Make an appointment",
//                   icon: Icons.add,
//                   color: const Color(0xFF700031),
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorListScreen()));
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),
//             const Padding(
//               padding: EdgeInsets.only(left: 15),
//               child: Text(
//                 "What are your symptoms?",
//                 style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black54),
//               ),
//             ),
//             SymptomRow(symptoms: symptoms),
//             const SizedBox(height: 10),
//             const Padding(
//               padding: EdgeInsets.only(left: 15),
//               child: Text(
//                 "Popular Doctors",
//                 style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black54),
//               ),
//             ),
//             DoctorGrid(doctors: doctors, imgs: imgs),
//           ],
//         ),
//       ),
//     );
//   }
// }
class UserHomeScreen extends StatefulWidget {
  final String userName;// Declare a field for the user's name
  // Pass the user's name when navigating to this screen
  UserHomeScreen({required this.userName});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<Map<String, dynamic>> doctors = [];
  String _userFullName = '';
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
    _fetchUserDetails();
  }
  // Fetch user details (first and last name)
  Future<void> _fetchUserDetails() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.121/doctor_appointment_api/get_user_details.php?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _userFullName = '${data['first_name']} ${data['last_name']}';
            isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Failed to fetch user details')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error parsing response: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  void _onMenuItemSelected(String value) {
    switch (value) {
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorListScreen()),
        );
        break;
      case 'settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
        break;
      case 'logout':
      // Perform logout action here
        break;
    }
  }


  Future<void> fetchDoctors() async {
    final response = await http.get(Uri.parse('http://192.168.1.121/doctor_appointment_api/get_doctors.php'));
    print('Doctor data: ${response.body}');
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
        actions:
      <Widget>[
      // Overflow menu (three dots menu)
      PopupMenuButton<String>(
        onSelected: _onMenuItemSelected,  // Callback when an option is selected
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: 'profile',
              child: Row(
                children: <Widget>[
                  Icon(Icons.account_circle),
                  SizedBox(width: 8),
                  Text('Profile')
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'settings',
              child: Row(
                children: <Widget>[
                  Icon(Icons.settings),
                  SizedBox(width: 8),
                  Text('Settings')
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: <Widget>[
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Logout')
                ],
              ),
            ),
          ];
        },
      ),
      ],
    ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(
                      'Welcome, $_userFullName!',
                      style: TextStyle(fontSize: 24),
                    ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("images/doctor 1.jpg"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClinicVisitButton(
                  title: "Clinic Visits",
                  subtitle: "Make an appointment",
                  icon: Icons.add,
                  color: const Color(0xFF700031),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorListScreen()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 25),
            ElevatedButton(
                onPressed: () {
                    Navigator.pushNamed(context, '/viewAppointments');
                  },
                child: Text('View Your Appointments'),),
            // const Padding(
            //   padding: EdgeInsets.only(left: 15),
            //   child: Text(
            //     "What are your symptoms?",
            //     style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black54),
            //   ),
            // ),
            // SymptomRow(symptoms: symptoms),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Popular Doctors",
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

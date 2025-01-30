
// // **Login Screen (Choose between Doctor or User Login)**
// import 'package:flutter/material.dart';
//
// import 'login_doctor_screen.dart';
// import 'login_user_screen.dart';
//
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
import 'package:dr_app_unbroken/screens/registration%20screens/add_patient_info_screen.dart';
import 'package:flutter/material.dart';

import 'login_doctor_screen.dart';
import 'login_user_screen.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 15,),
              // Align(alignment: Alignment.centerRight,
              //   child: TextButton(
              //       onPressed: (){
              //         // Navigator.push(context,
              //         //     MaterialPageRoute(builder: (context) => const NavbarRoots()));
              //       },
              //       child: const Text("SKIP",
              //         style: TextStyle(
              //           color: Color(0xFF700031),
              //           fontSize: 20,
              //         ),)
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset("images/doctors.jpg"),
              ),
              const SizedBox(height: 50,),
              const Text("Doctors Appointment",
                style: TextStyle(
                    color: Color(0xFF700031),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    wordSpacing: 2
                ),),
              const SizedBox(height: 10,),
              // const Text("Appoint your doctor",
              //   style: TextStyle(
              //       color: Colors.black54,
              //       fontSize: 18,
              //       fontWeight: FontWeight.w500,
              //   ),
              // ),
              // const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    color: const Color(0xFF700031),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => LoginDoctorScreen() ));
                      },
                      child: const Padding(padding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 40 ),
                        child: Text("Doctor Login",
                          style: TextStyle(color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),),),

                    ),
                  ),
                  Material(
                    color: const Color(0xFF700031),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => LoginUserScreen()));
                      },
                      child: const Padding(padding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 40 ),
                        child: Text("User Login",
                          style: TextStyle(color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),),),

                    ),
                  ),
                ],
              ),
              SizedBox( height: 10),
              Material(
                  color: const Color(0xFF700031),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                  onTap: (){
                    Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => AddPatientInfoScreen()));
                    },
                  child: const Padding(padding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 40 ),
                      child: Text("Register Patients",
                        style: TextStyle(color: Colors.white,
                        fontSize: 15,
                          fontWeight: FontWeight.bold),),),
                  ))],
            // ),
          ),
        ));
  }
}
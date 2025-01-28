import 'package:flutter/material.dart';

import '../../book appointment screens/book_appointment_screen.dart';

class DoctorGrid extends StatelessWidget {
  final List<Map<String, dynamic>> doctors;
  final List<String> imgs;

  const DoctorGrid({Key? key, required this.doctors, required this.imgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: doctors.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            int doctorId = int.tryParse(doctors[index]['doctor_id'].toString()) ?? 0;
            print('Doctor ID: $doctorId');
            if (doctorId > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookAppointmentScreen(doctorId: doctorId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invalid doctor ID. Please try again later.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("images/${imgs[index]}"),
                ),
                Text(doctors[index]['name']),
                Text(doctors[index]['specialty']),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Text(
                      "4.9",
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

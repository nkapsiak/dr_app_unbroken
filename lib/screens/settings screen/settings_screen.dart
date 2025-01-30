import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                leading: CircleAvatar(radius: 30,
                  backgroundImage: AssetImage("images/doctor 1.jpg"),
                ),
                title: Text("Dr. Doctor Name",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),),
                subtitle: Text("Profile"),
              ),
              const Divider(height: 50,),
              ListTile(
                onTap: (){},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle
                  ),
                  child: const Icon(CupertinoIcons.person, size: 35,),
                ),
                title: const Text("Profile",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(height: 20,),
              ListTile(
                onTap: (){},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      shape: BoxShape.circle
                  ),
                  child: const Icon(Icons.notifications_active_outlined,
                    size: 35,
                    color: Colors.deepPurple,),
                ),
                title: const Text("Notifications",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(height: 20,),
              ListTile(
                onTap: (){},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      shape: BoxShape.circle
                  ),
                  child: const Icon(Icons.privacy_tip_outlined,
                    size: 35,
                    color: Colors.indigo,),
                ),
                title: const Text("Privacy",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(height: 20,),
              ListTile(
                onTap: (){},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle
                  ),
                  child: const Icon(
                    Icons.settings_suggest_outlined,
                    size: 35,
                    color: Colors.green,),
                ),
                title: const Text("General",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(height: 20,),
              ListTile(
                onTap: (){},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    size: 35,
                    color: Colors.orange,),
                ),
                title: const Text("About us",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const Divider(height: 40,),
              ListTile(
                onTap: (){},
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.redAccent.shade100,
                      shape: BoxShape.circle
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    size: 35,
                    color: Colors.redAccent,),
                ),
                title: const Text("Log Out",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

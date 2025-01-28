import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  MessagesScreen({super.key});
  List imgs = [
    "doctor 1.jpg",
    "doctor 2.jpg",
    "doctor 3.jpg",
    "doctor 4.jpg",
    "doctor 5.jpg",
    "doctor 1.jpg"
  ];


  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40,),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Messages",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),),),
          const SizedBox(height: 30,),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2
                  )]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none
                        ),
                      ),),
                  ),
                  const Icon(Icons.search, color: Color(0xFF700031),)
                ],
              ),
            ),),
          const SizedBox(height: 20,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text("Active Now",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
          ),
          SizedBox(height: 90,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: 65,
                    height: 65,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 2,
                              blurRadius: 10
                          )
                        ]
                    ),
                    child: Stack(
                      textDirection: TextDirection.rtl,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 65,
                            width: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset("images/${imgs[index]}",
                                fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(3),
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Text("Recent Chats",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChatScreen() ));
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("images/${imgs[index]}"),
                    ),
                    title: const Text("Dr. Doctor Name",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),),
                    subtitle: const Text("Hello, Doctor are you there?",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54
                      ),),
                    trailing: const Text("12:30",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54
                      ),),
                  ),
                );
              })
        ],
      ),
    );
  }
}

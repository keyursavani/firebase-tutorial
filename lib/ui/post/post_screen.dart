import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/Utils/utils.dart';
import 'package:firebase_tutorial/ui/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget{
  const PostScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PostScreenState();
  }
}

class PostScreenState extends State<PostScreen>{
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Post Screen"),
        actions: [
          IconButton(
              onPressed: (){
                auth.signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return const LoginScreen();
                    }),
                  );
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
          },
              icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 10,),
        ],
      ),
    );
  }
}
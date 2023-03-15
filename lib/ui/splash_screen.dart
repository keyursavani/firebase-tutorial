import 'package:firebase_tutorial/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>{

  SplashServices splashScreen = SplashServices();

  @override
  void initState(){
    super.initState();
    splashScreen.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return const Scaffold(
     body: Center(
       child: Text("Firebase Tutorial",style: TextStyle(
         fontSize: 30,
       ),),
     ),
   );
  }
}
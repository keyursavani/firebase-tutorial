import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget{
  const ForgotPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ForgotPasswordScreenState();
  }
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen>{
  final emailController  = TextEditingController();
  final _formKey = GlobalKey<FormState>();
final auth = FirebaseAuth.instance;
  final enabledBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(9),
    ),
    borderSide: BorderSide(color: Colors.black),
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 30,right: 30) ,
            child: TextFormField(
              controller: emailController,
              cursorColor: Colors.black12,
              keyboardType: TextInputType.text,
              style: const TextStyle(fontSize: 16, color: Color(0xFF19232d)),
              validator: (value){
                if(value!.isEmpty){
                  return "Enter Email";
                }
                return null;
              },
              obscureText: false,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: const TextStyle(fontSize:17, color: Colors.black54),
                prefixIcon:const Icon(Icons.lock_outline ,color: Colors.black45,),
                enabledBorder: enabledBorder,
                border: enabledBorder,
                focusedBorder: enabledBorder,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ),
          const SizedBox(height: 30,),
          InkWell(
            onTap: (){
              auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                Utils().toastMessage("Password Send Successfully");
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            child: Container(
              height: 50,
              width: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.deepPurple,
              ),
              child:  Align(
                alignment: Alignment.center,
                child:
                // loading ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,)
                //     :
                const Text("Forgot",style: TextStyle(
                    color: Colors.white,
                    fontSize: 22
                ),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
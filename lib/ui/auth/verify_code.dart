import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/ui/post/post_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/utils.dart';

class VerifyPhoneNumber extends StatefulWidget{
  final String verificationId;
  const VerifyPhoneNumber({Key? key, required this.verificationId}): super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VerifyPhoneNumberState();
  }
}

class VerifyPhoneNumberState extends State<VerifyPhoneNumber>{
  final verificationCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final enabledBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(9),
    ),
    borderSide: BorderSide(color: Colors.black),
  );

  @override
  void dispose() {
    super.dispose();
    verificationCodeController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 40),
                        child: TextFormField(
                          controller: verificationCodeController,
                          cursorColor: Colors.black12,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFF19232d)),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Verification code";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "6 digit code",
                            hintStyle: const TextStyle(
                                fontSize: 17, color: Colors.black54),
                            enabledBorder: enabledBorder,
                            border: enabledBorder,
                            focusedBorder: enabledBorder,
                            floatingLabelBehavior:
                            FloatingLabelBehavior.never,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          final credential = PhoneAuthProvider.credential(
                              verificationId:widget.verificationId,
                              smsCode: verificationCodeController.text.toString(),
                          );
                          try{
                            await _auth.signInWithCredential(credential);

                            Navigator.push(
                              context,
                            MaterialPageRoute(builder: (context){
                              return PostScreen();
                            })
                            );
                          }catch(e){
                            setState(() {
                              loading = false;
                            });
                            Utils().toastMessage(e.toString());
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(15)),
                            color: Colors.deepPurple,
                          ),
                          child:  Align(
                            alignment: Alignment.center,
                            child: loading ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,)
                                : const Text(
                              "Verify",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      )
    );
  }
}
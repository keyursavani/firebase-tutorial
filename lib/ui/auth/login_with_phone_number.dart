import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/Utils/utils.dart';
import 'package:firebase_tutorial/ui/auth/verify_code.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginWithPhoneNumberState();
  }
}

class LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController = TextEditingController();
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
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("Phone Number"),
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
                            controller: phoneNumberController,
                            cursorColor: Colors.black12,
                            style: const TextStyle(
                                fontSize: 16, color: Color(0xFF19232d)),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter phone number";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: " +919499556633",
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
                          onTap: () {
                            setState(() {
                              loading = true;
                            });
                            _auth.verifyPhoneNumber(
                                phoneNumber: phoneNumberController.text,
                                verificationCompleted: (_) {
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                verificationFailed: (e) {
                                  setState(() {
                                    loading = false;
                                  });
                                  Utils().toastMessage(e.toString());
                                },
                                codeSent: (String verificationId, int? token) {
                                  Navigator.push(
                                    context,
                                      MaterialPageRoute(builder: (context) {
                                    return VerifyPhoneNumber(verificationId: verificationId);
                                  }),
                                  );
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                codeAutoRetrievalTimeout: (e) {
                                  Utils().toastMessage(e.toString());
                                  setState(() {
                                    loading = false;
                                  });
                                });
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
                              child: loading ?
                                  const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,)
                                      :
                                  const Text(
                                "Login",
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
        ));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/Utils/utils.dart';
import 'package:firebase_tutorial/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen>{
  final emailController  = TextEditingController();
  final passwordController  = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final enabledBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(9),
    ),
    borderSide: BorderSide(color: Colors.black),
  );

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Sign Up"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 30,right: 30) ,
                    child: TextFormField(
                      controller: emailController,
                      cursorColor: Colors.black12,
                      style: const TextStyle(fontSize: 16, color: Color(0xFF19232d)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Email id",
                        hintStyle: const TextStyle(fontSize:17, color: Colors.black54),
                        prefixIcon:const Icon(Icons.person ,color: Colors.black45,),
                        enabledBorder: enabledBorder,
                        border: enabledBorder,
                        focusedBorder: enabledBorder,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.only(left: 30,right: 30) ,
                    child: TextFormField(
                      controller: passwordController,
                      cursorColor: Colors.black12,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 16, color: Color(0xFF19232d)),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter Password";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(fontSize:17, color: Colors.black54),
                        prefixIcon:const Icon(Icons.lock_outline ,color: Colors.black45,),
                        enabledBorder: enabledBorder,
                        border: enabledBorder,
                        focusedBorder: enabledBorder,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40,),
                  InkWell(
                    onTap: (){
                      if(_formKey.currentState!.validate()){
                       signUp();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context){
                        //     return const LoginScreen();
                        //   })
                        // );
                      }
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
                        child: loading ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,)
                            : const Text("Signup",style: TextStyle(
                            color: Colors.white,
                            fontSize: 22
                        ),
                      ),
                      ),
                    ),
                  )
                ],
              )
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              const Text("Already have an account?  " ,style: TextStyle(
                color: Colors.black,
                fontSize:17,
              ),),
              InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return const LoginScreen();
                      })
                  );
                },
                child: const Text("Login",style: TextStyle(
                  color:Colors.deepPurple,
                  fontSize: 20,
                ),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
  void signUp(){
    setState(() {
      loading = true;
    });
    _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value){
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
}
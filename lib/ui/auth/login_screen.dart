import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/Utils/utils.dart';
import 'package:firebase_tutorial/ui/auth/login_with_phone_number.dart';
import 'package:firebase_tutorial/ui/auth/signup_screen.dart';
import 'package:firebase_tutorial/ui/post/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenState();
  }
}
class LoginScreenState extends State<LoginScreen>{
  bool loading = false;
  final emailController  = TextEditingController();
  final passwordController  = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final enabledBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(9),
    ),
    borderSide: BorderSide(color: Colors.black),
  );
  FirebaseAuth _auth = FirebaseAuth.instance;

   void login(){
     setState(() {
       loading = true;
     });
     _auth.signInWithEmailAndPassword(
         email: emailController.text,
         password: passwordController.text).then((value) {
               Utils().toastMessage(value.user!.email.toString());
               setState(() {
                 loading = false;
               });
               Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context){
                     return const PostScreen();
                   })
               );
     }).onError((error, stackTrace) {
       debugPrint(error.toString());
       Utils().toastMessage(error.toString());
       setState(() {
         loading = false;
       });
     });
   }
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Login"),
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
                            return "Enter email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "email id",
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
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF19232d)),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Password";
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
                          login();
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
                          :  const Text("Login",style: TextStyle(
                            color: Colors.white,
                            fontSize: 22
                          ),),
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
                const Text("Don't have an account?  " ,style: TextStyle(
                  color: Colors.black,
                  fontSize:17,
                ),),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return const SignUpScreen();
                      })
                    );
                  },
                  child: const Text("Signup",style: TextStyle(
                      color:Colors.deepPurple,
                    fontSize: 20,
                  ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40,),
            InkWell(
              onTap:  (){
                Navigator.push(
                  context,
                MaterialPageRoute(builder: (context){
                  return const LoginWithPhoneNumber();
                }),
                );
              },
              child: Padding(
                padding:  const EdgeInsets.only(left: 30,right: 30),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Center(
                    child: Text("Login With Phone"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
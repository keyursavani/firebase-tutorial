import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorial/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFireStoreDataScreen extends StatefulWidget{
  const AddFireStoreDataScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddFireStoreDataScreenState();
  }
}
class AddFireStoreDataScreenState extends State<AddFireStoreDataScreen>{
  bool loading = false;
  final postController = TextEditingController();

  final fireStore = FirebaseFirestore.instance.collection('users');

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
        title: const Text("Add FireStore Data"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40,left:20,right: 20,bottom: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 0,right: 0) ,
              child: TextFormField(
                controller: postController,
                cursorColor: Colors.black12,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 16, color: Color(0xFF19232d)),
                // validator: (value){
                //   if(value!.isEmpty){
                //     return "Enter Password";
                //   }
                //   return null;
                // },
                obscureText: false,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "What is in your mind?",
                  hintStyle: const TextStyle(fontSize:17, color: Colors.black54),
                  // prefixIcon:const Icon(Icons.lock_outline ,color: Colors.black45,),
                  enabledBorder: enabledBorder,
                  border: enabledBorder,
                  focusedBorder: enabledBorder,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            const SizedBox(height: 50,),
            InkWell(
              onTap: (){
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  'title':postController.text.toString(),
                  'id':id,
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                  Utils().toastMessage("Post Added");
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
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
                  child: loading ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,)
                      :  const Text("Add",style: TextStyle(
                      color: Colors.white,
                      fontSize: 22
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
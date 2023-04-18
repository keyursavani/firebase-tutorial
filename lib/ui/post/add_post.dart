import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorial/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget{
  const AddPost({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return AddPostState();
  }
}
class AddPostState extends State<AddPost>{
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  final postController = TextEditingController();
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
        title: const Text("Add Post"),
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
                databaseRef.child(id).set({
                  'id' : id,
                  'title': postController.text.toString(),
                  }).then((value) {
                    Utils().toastMessage('Post Added');
                    setState(() {
                      loading = false;
                    });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorial/Utils/utils.dart';
import 'package:firebase_tutorial/ui/auth/login_screen.dart';
import 'package:firebase_tutorial/ui/post/add_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_firestore_data.dart';


class FireStoreScreen extends StatefulWidget{
  const FireStoreScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FireStoreScreenState();
  }
}

class FireStoreScreenState extends State<FireStoreScreen>{
final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("FireStore Screen"),
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
      body: Column(
        children:  [
          const SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if(snapshot.hasError) {
                  return const Text("Some Error");
                }
                return Expanded(
                    child:ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context , index){
                          return  ListTile(
                            onTap: (){
                              ref.doc(snapshot.data!.docs[index]['id'].toString()).update({
                              'title':'Savani KeyurBhai',
                              }).then((value) {
                                Utils().toastMessage("Updated");
                              }).onError((error, stackTrace) {
                                Utils().toastMessage(error.toString());
                              });
                              // ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                            },
                            title: Text(snapshot.data!.docs[index]['title'].toString()),
                            subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                          );
                        })
                );
          }),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context){
                return const AddFireStoreDataScreen();
              })
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> showMyDialog(String title , String id) async{
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Update"),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: const InputDecoration(
                    hintText: 'Edit'
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: (){
                  },
                  child: const Text("Update")),
            ],
          );
        }
    );
  }
}
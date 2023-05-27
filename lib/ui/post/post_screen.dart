import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_tutorial/Utils/utils.dart';
import 'package:firebase_tutorial/ui/auth/login_screen.dart';
import 'package:firebase_tutorial/ui/post/add_post.dart';
import 'package:firebase_tutorial/ui/post/uplode_image.dart';
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
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
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
      body: Column(
        children:  [
          // Expanded(
          //     child: StreamBuilder(
          //       stream: ref.onValue,
          //       builder: (context ,AsyncSnapshot<DatabaseEvent> snapshot){
          //         if(!snapshot.hasData){
          //           return const CircularProgressIndicator();
          //         }
          //         else{
          //           Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //           List<dynamic> list = [];
          //           list.clear();
          //           list = map.values.toList();
          //           return ListView.builder(
          //               itemCount: snapshot.data!.snapshot.children.length,
          //               itemBuilder: (context , index){
          //                 return ListTile(
          //                   title: Text(list[index]['title'].toString()),
          //                   subtitle: Text(list[index]['id'].toString()),
          //                 );
          //               });
          //         }
          //       },
          //     )),
          const SizedBox(height: 20,),
          Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10),
           child: TextFormField(
             controller: searchFilter,
             decoration: const InputDecoration(
               hintText: 'Search',
               border: OutlineInputBorder(),
             ),
             onChanged: (String value){
               setState(() {

               });
             },
           ),
         ),
         const SizedBox(height: 20,),
         Expanded(
             child: FirebaseAnimatedList(
               query: ref,
               defaultChild: const Text("Loading"),
               itemBuilder: (context , snapshot ,index ,animation){
                 final title =  snapshot.child('title').value.toString();
                 final id = snapshot.child('id').value.toString();
                 if(searchFilter.text.isEmpty){
                   return ListTile(
                     title:  Text(snapshot.child('title').value.toString()),
                     subtitle: Text(snapshot.child('id').value.toString()),
                     trailing: PopupMenuButton(
                       icon: const Icon(Icons.more_vert),
                       itemBuilder: (context) =>[
                          PopupMenuItem(
                           value: 1,
                           child: ListTile(
                             onTap: (){
                               Navigator.pop(context);
                               showMyDialog(title , id);
                             },
                             leading: const Icon(Icons.edit),
                             title: const Text("Edit"),
                           ),
                         ),
                          PopupMenuItem(
                           value: 2,
                           child: ListTile(
                             onTap: (){
                               ref.child(snapshot.child('id').value.toString()).remove();
                               Navigator.pop(context);
                             },
                             leading: const Icon(Icons.delete_outlined),
                             title: const Text("Delete"),
                           ),
                         ),
                       ],
                     ),
                   );
                 }
                 else if(title.toString().toLowerCase().contains(searchFilter.text.toLowerCase().toString())){
                   return ListTile(
                     title:  Text(snapshot.child('title').value.toString()),
                     subtitle: Text(snapshot.child('id').value.toString()),
                   );
                 }
                 else{
                   return Container();
                 }
               },
             )
         ),
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                MaterialPageRoute(builder: (context){
                  return const UploadImageScreen();
                })
              );
            },
            child: Container(
              height: 50,
              width: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.deepPurple,
              ),
              child:  const Align(
                alignment: Alignment.center,
                 child:
                Text("Upload Image",style: TextStyle(
                    color: Colors.white,
                    fontSize: 22
                ),),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context){
              return const AddPost();
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
                    Navigator.pop(context);
                    ref.child(id).update({
                      'title': editController.text.toString(),
                    }).then((value){
                      Utils().toastMessage("Post Update");
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text("Update")),
            ],
          );
        }
    );
  }
}
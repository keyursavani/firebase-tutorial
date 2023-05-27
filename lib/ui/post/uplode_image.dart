import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_tutorial/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget{
  const UploadImageScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UploadImageScreenState();
  }
}

class UploadImageScreenState extends State<UploadImageScreen>{
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery ,imageQuality: 80);
    if(pickedFile != null){
      _image = File(pickedFile.path);
    }
    else{
      print("No Image Picked");
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     body: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 20),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Center(
             child: InkWell(
               onTap: (){
                 getGalleryImage();
               },
               child: Container(
                 height:200,
                 width:200,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   border: Border.all(
                     color: Colors.black,
                   )
                 ),
                 child: _image != null ? Image.file(_image!.absolute) :
                 const Center(child: Icon(Icons.image)),
               ),
             ),
           ),
           const SizedBox(height: 40,),
           InkWell(
             onTap: () async{
               setState(() {
                 loading = true;
               });
               firebase_storage.Reference ref =
               firebase_storage.FirebaseStorage.instance.ref('/Image Folder/${DateTime.now().microsecondsSinceEpoch}');
               firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
               String id = DateTime.now().microsecondsSinceEpoch.toString();
                Future.value(uploadTask).then((value) async {
                 var newUrl = await ref.getDownloadURL();
                 databaseRef.child(id).set({
                   'id': id,
                   'title':newUrl.toString(),
                 }).then((value) {
                   setState(() {
                     loading = false;
                   });
                   Utils().toastMessage("Image Uploaded");
                 }).onError((error, stackTrace) {
                   setState(() {
                     loading = false;
                   });
                   Utils().toastMessage(error.toString());
                 });
               }).onError((error, stackTrace) {
                 setState(() {
                   loading = false;
                 });
                 Utils().toastMessage(error.toString());
               });

             },
             child: Container(
               height: 50,
               width: 300,
               decoration: const BoxDecoration(
                 borderRadius: BorderRadius.all(Radius.circular(15)),
                 color: Colors.deepPurple,
               ),
               child:  Align(
                 alignment: Alignment.center,
                 child: loading ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,)
                     :
                 const Text("Upload",style: TextStyle(
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
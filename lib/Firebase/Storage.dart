import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'Authentication.dart';
import 'dart:io' as i;
class Storage
{
  FirebaseStorage _storage = FirebaseStorage.instance;
  late Reference addreference;
  Authenticate authclass = Authenticate();
  late Reference cartreference;
  String? uid;

  Storage({required this.uid})
  {
    addreference = _storage.ref().child("image").child('add');
    cartreference = _storage.ref().child("image").child("cart").child("$uid");
  }

  Future<String> downloadUrl(String name)
  async {
    return await addreference.child(name).getDownloadURL();
  }

  Future<void> uploadImg(String name , i.File image)
  async {
    await addreference.child(name).putFile(image);
  }
  Future<void> deleteImg(String name) async{
    await addreference.child(name).delete();
  }

  //Check for same names
}
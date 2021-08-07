import 'dart:io' as i;
import 'dart:async';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  XFile? _image;
  double price =10.0;
  ImagePicker _picker = ImagePicker();
  String? name;
  String? description;
  int? id;
  Item? perform;
  double opacity =0;
  @override
  Widget build(BuildContext context)
  {
    var _user = Provider.of<User?>(context,listen:false);
    perform = Item.setfirebase(uid: _user?.uid);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Container(
            constraints: BoxConstraints(
              maxHeight: 700,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 32,
                  ),
                  Center(
                    child: InkWell(
                      child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Color(0xffFDCF09),
                              child: (_image != null)
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                  i.File(_image!.path),
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                                  : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                  Center(
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                              onChanged: (value) {
                                name = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Add name",
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 20.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.pink,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          TextFormField(
                            onChanged: (value) {
                              try {
                                price = decimal(value);
                              }
                              catch(e)
                              {
                                //TODO error
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Add price",
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 20.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              description = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Add description",
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 20.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      )
                    ),
                   Opacity(
                     opacity: opacity,
                     child: ElevatedButton(
                        onPressed:(){
                          compute(context);
                          },
                        child: Text("Submit"),
                      ),
                   ),
                  ElevatedButton(
                    onPressed: (){

                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  _imgFromCamera() async {
    XFile? ximage = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    // i.File? image = i.File();
    setState((){
      _image = ximage;
      opacity = 1;
    });
  }
  double decimal(String num)
  {
    var myDouble = double.parse(num);
    assert(myDouble is double);
    return myDouble;
  }
  _imgFromGallery() async {
    XFile? image = (await  _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    ));

    setState(() {
      _image = image;
      opacity = 1;
    }
      );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void compute(BuildContext context) async{
    if((name!= null)&&(price>0.0))
    {
      i.File file = i.File(_image!.path);
      await perform?.storage?.uploadImg(name!, file);
      Map? p = await perform?.products();
      id =p?.length;
      String? temp = await perform?.storage?.downloadUrl(name!);

      await perform?.database?.additem({
        "id" : (id! + 1),
        "title":name,
        "image" : temp,
        "description" : description,
        "category" : "added",
        "price" : price
      });

      Navigator.popUntil(context, ModalRoute.withName('home'));
    }
    else
      {
        //TODO-> AlertDialog?
      }
  }

  void reset()
  {
    name = null;
    price = 0.0;
    _image  = null;
    setState(() {

    });
  }


}



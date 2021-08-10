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

class _AddState extends State<Add> with SingleTickerProviderStateMixin {
  XFile? _image;
  double price =0.0;
  ImagePicker _picker = ImagePicker();
  String name ="";
  String description="";
  int? id;
  Item? perform;
  double opacity =0;
  late AnimationController _controller;
  late Animation _sizeAnimate;
  late Animation _sizeAnimate2;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration:Duration(milliseconds: 700),
        vsync: this);
    _sizeAnimate = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(tween:Tween<double>(begin: 100,end: 0),weight:100),
        ]
    ).animate(_controller);
    _sizeAnimate2 = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(tween:Tween<double>(begin: 0,end: 100),weight:100),
        ]
    ).animate(_controller);
    _controller.addListener(() {
      setState((){});
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Form(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.drive_file_rename_outline),
                              title: TextFormField(
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
                            ),
                            ListTile(
                              leading: Icon(Icons.monetization_on),
                              title: TextFormField(
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
                            ),
                            ListTile(
                              leading: Icon(Icons.note_add),
                              title: TextFormField(
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
                            ),
                          ],
                        ),
                        )
                      ),
                  ),
                   Container(
                     child: Stack(
                       children : [
                         Opacity(
                           opacity: opacity,
                           child: Opacity(
                             opacity: _sizeAnimate.value/100,
                             child: ElevatedButton(
                                onPressed:((name!="")||(price!=0.0)||(description != ""))?(){
                                  _controller.forward();
                                  compute(context);
                                  }:(){
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All three fields must be filled'),));
                                },
                                child: Text("Submit",style: TextStyle(fontSize: _sizeAnimate.value/5),),
                              ),
                           ),
                          ),
                         Opacity(
                           opacity: _sizeAnimate2.value/100,
                           child: Container(
                             height: _sizeAnimate2.value/2,
                             width: _sizeAnimate2.value/2,
                             child: CircularProgressIndicator(
                               strokeWidth: _sizeAnimate2.value/15,
                               color: Colors.blue[900],
                             ),
                           ),
                         ),
                      ]
                     ),
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

      i.File file = i.File(_image!.path);
      await perform?.storage?.uploadImg(name, file);
      Map? p = await perform?.products();
      id =p?.length;
      String? temp = await perform?.storage?.downloadUrl(name);

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
}



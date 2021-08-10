import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/Itemholder/Items.dart';
import 'package:firebase_flutter/Pages/Error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with SingleTickerProviderStateMixin{

  ImagePicker _picker = ImagePicker();
  String? uid;
  Item? perform;
  XFile? _image;
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
  Widget build(BuildContext context) {
    String? uid = Provider.of<User?>(context,listen:false)!.uid;
    Item perform = Item.setfirebase(uid: uid);

    Future<void> store(BuildContext context)
    async{
      File file = File(_image!.path);
      await perform.storage!.uploadImg(uid,file);
      String? temp = await perform.storage?.downloadUrl(uid);
      await perform.database?.name.doc(uid).set(<String,dynamic>{
        "name":Provider.of<Item>(context,listen:false).name,
        'profile': temp,
      });
      QuerySnapshot? querysnap = await perform.database?.review.get();
      int i=0;
      if(querysnap != null) {
        Map<String,dynamic>? revchange = Map();
        for (i = 0; i < (querysnap.size); i++) {
          DocumentSnapshot? docsnap = querysnap.docs[i];
          revchange = docsnap.data() as Map<String,dynamic>?;
          print(revchange);
          revchange?.forEach((key, value) {
            if (value["name"] == Provider
                .of<Item>(context, listen: false)
                .name) {
              value["profile"] = temp;
            }
          });
          await perform.database?.review.doc(docsnap.id).set(revchange);
        }
        print(revchange);
      }
    }

    return SafeArea(
      child:Scaffold(
        appBar:AppBar(
          title: Text("Edit details"),
          centerTitle: true,
        ),
        body: SizedBox(
          height:600,
          child: ListView(
            children: [
              Container(
                child: FutureBuilder<String>(
                  future: perform.getProfile(),
                  builder: (context,snapshot){
                    Widget child;
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasError)
                        {
                          child = ErrorPopup();
                        }
                      else
                        {
                          String? url = snapshot.data;
                          child =Container(
                            height: 300,
                            child: ListView(
                              children: <Widget>[
                                SizedBox(height:27),
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
                                                File(_image!.path),
                                                fit: BoxFit.fitHeight,
                                              ),
                                            )
                                            : ClipRect(
                                              //borderRadius: BorderRadius.circular(50),
                                                child: (url== "")
                                                    ? Image.asset(
                                                        "assets/profile.jpg",
                                                        fit: BoxFit.fitHeight,
                                                      )
                                                    :Image.network(
                                                     url!,
                                                    fit: BoxFit.fitHeight,
                                                    ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    }
                    else{
                      child = CircularProgressIndicator();
                    }
                    return AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: child,
                    );
                  },
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: Stack(
                  children: [
                    Opacity(
                      opacity: _sizeAnimate.value/100,
                      child: ElevatedButton(
                          onPressed:()async{
                        if(_image!= null)
                          {
                            _controller.forward();
                            await store(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Done'),));
                            _controller.reverse();
                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Choose image to save'),));
                          }
                        },
                          child: Text("Save")
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
                  ],
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                if(Provider.of<Item>(context,listen: false).googleName != "") {
                  Navigator.popAndPushNamed(context, 'passwordchange');
                }
                else
                  {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google Users cannot do this'),));
                  }
                }, child: Text("Change Password"))
            ],
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
    });
  }
  _imgFromGallery() async {
    XFile? image = (await  _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    ));

    setState(() {
      _image = image;
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
  //TODO-> Button CircularProgressIndicator here and in Add_items
}

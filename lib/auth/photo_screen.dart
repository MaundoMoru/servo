import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:servo/auth/login_screen.dart';
import 'dart:io';

import 'package:servo/screens/home_screen2.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({Key? key}) : super(key: key);

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text('HireHub'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Upload profile image',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Select the profile image',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              isLoading == false
                  ? Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.zero,
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 2,
                                blurRadius: 5,
                              )
                            ],
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            image: const DecorationImage(
                              image: AssetImage(
                                'images/profile_picture.png',
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).accentColor,
                              border: Border.all(
                                width: 2,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              color: Colors.white,
                              onPressed: () {
                                uploadImage();
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(
                      padding: EdgeInsets.zero,
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.blue,
                            spreadRadius: 2,
                            blurRadius: 5,
                          )
                        ],
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        image: const DecorationImage(
                          image: AssetImage(
                            'images/profile_picture.png',
                          ),
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              isLoading == false
                  ? MaterialButton(
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'NEXT',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).accentColor,
                    )
                  : const Text('')
            ],
          ),
        ),
      ),
    );
  }

  void uploadImage() async {
    XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    if (img == null) {
      return;
    } else {
      setState(() {
        image = img;
      });
    }

    setState(() {
      isLoading = true;
    });

    firebase_storage.Reference _reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(_auth.currentUser!.uid);

    firebase_storage.UploadTask _task = _reference.putFile(File(image!.path));

    String downloadUrl = await (await _task).ref.getDownloadURL();

    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({'imageUrl': downloadUrl}, SetOptions(merge: true));

    setState(() {
      isLoading = false;
    });
  }
}

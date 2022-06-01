import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _name = TextEditingController(text: 'Joe');
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _about = TextEditingController();

  XFile? image;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Edit profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            _name.text = '${data['name']}';
            _bio.text = '${data['bio']}';
            _about.text = '${data['about']}';

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    buildProfileImg(context, data),
                    const SizedBox(height: 20),
                    buildEditName(context, data),
                    const SizedBox(height: 20),
                    buildEditBio(context, data),
                    const SizedBox(height: 20),
                    buildEditAbout(context),
                    const SizedBox(height: 20),
                    buildSaveButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget buildProfileImg(context, data) => isLoading == true
      ? Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        )
      : Stack(
          children: [
            '${data['imageUrl']}' == ''
                ? Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${data['name']}'[0],
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: '${data['imageUrl']}',
                    imageBuilder: (context, imageProvider) => Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        image: const DecorationImage(
                          image: AssetImage(
                            'images/profile_picture.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    uploadImage();
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        );

  buildEditName(context, data) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Full Name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '${data['name']}',
              ),
            ),
          ],
        ),
      );

  buildEditBio(context, data) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Bio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _bio,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '${data['bio']}',
              ),
            ),
          ],
        ),
      );

  buildEditAbout(context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Me',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              controller: _about,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Describe yourself here',
              ),
            ),
          ],
        ),
      );

  Widget buildSaveButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: MaterialButton(
          color: Theme.of(context).accentColor,
          minWidth: double.infinity,
          height: 40,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () async {
            FirebaseFirestore.instance
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .set({
              'name': _name.text,
              'bio': _bio.text,
              'about': _about.text,
            }, SetOptions(merge: true));

            SharedPreferences _prefs = await SharedPreferences.getInstance();
            _prefs.setString('name', _name.text);
            _prefs.setString('bio', _bio.text);
            _prefs.setString('about', _about.text);

            Fluttertoast.showToast(
              msg: 'Saved Successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          },
          child: const Text(
            'SAVE',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  void uploadImage() async {
    XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    if (img == null) {
      return;
    } else {
      setState(() {
        image = img;
      });
    }

    isLoading = true;

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

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    // _prefs.clear();
    _prefs.setString('imageUrl', downloadUrl);
    // setState(() {
    //   imageUrl = downloadUrl;
    // });

    setState(() {
      isLoading = false;
    });
  }
}

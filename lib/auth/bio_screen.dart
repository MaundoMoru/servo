import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servo/auth/about_screen.dart';
import 'package:servo/auth/photo_screen.dart';

class BioScreen extends StatelessWidget {
  BioScreen({Key? key}) : super(key: key);

  final TextEditingController _bio = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _refs =
      FirebaseFirestore.instance.collection('users');

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
                'Create your bio',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Briefly describe yourself here',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _bio,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bio',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Describe yourself',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () async {
                  await _refs
                      .doc(_auth.currentUser!.uid)
                      .set({'bio': _bio.text}, SetOptions(merge: true));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutScreen(),
                    ),
                  );
                },
                child: const Text(
                  'NEXT',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

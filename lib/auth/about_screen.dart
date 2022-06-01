import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servo/auth/photo_screen.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key? key}) : super(key: key);

  final TextEditingController _about = TextEditingController();
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
                'Describe about yourself',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Describe yourself here',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                maxLines: 4,
                controller: _about,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'About Me',
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
                      .set({'about': _about.text}, SetOptions(merge: true));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhotoScreen(),
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

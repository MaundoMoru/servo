import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servo/auth/bio_screen.dart';

class NameScreen extends StatelessWidget {
  NameScreen({Key? key}) : super(key: key);

  final TextEditingController _name = TextEditingController();
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
                'What is your name',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Please enter your name that will be visible to other members',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Enter your name',
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
                      .set({'name': _name.text}, SetOptions(merge: true));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BioScreen(),
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

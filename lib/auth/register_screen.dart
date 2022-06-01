import 'package:flutter/material.dart';
import 'package:servo/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servo/auth/name_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _refs =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Sign up',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'eg. chatapp@gmail.com',
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '******',
                  prefixIcon: Icon(
                    Icons.lock,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password is too short';
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _confirmpassword,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'confirm password ',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '******',
                  prefixIcon: Icon(
                    Icons.lock,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter confirmation password';
                  }
                  if (value != _password.text) {
                    return 'Password not matching';
                  }
                  if (value.length < 6) {
                    return 'Password is too short';
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                minWidth: double.infinity,
                height: 40.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () async {
                  if (_form.currentState!.validate()) {
                    try {
                      await _auth
                          .createUserWithEmailAndPassword(
                              email: _email.text, password: _password.text)
                          .then((value) async {
                        _refs.doc(_auth.currentUser!.uid).set({
                          "uid": value.user!.uid,
                          "email": value.user!.email,
                          "imageUrl": "",
                          "avgRating": 0.0,
                          "numRatings": 0.0,
                          "created_at": FieldValue.serverTimestamp()
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NameScreen(),
                          ),
                        );
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-email') {
                        // Fluttertoast.showToast(msg: 'invalid email');
                      } else if (e.code == 'email-already-in-use') {
                        // Fluttertoast.showToast(msg: 'Email already in use');
                      }
                    }
                  }
                },
                child: const Text(
                  'NEXT',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text('Do you have account?'),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

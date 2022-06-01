import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servo/auth/register_screen.dart';
import 'package:servo/screens/employer/employer_menu_screen.dart';
import 'package:servo/screens/menu_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Sign in',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
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
                      return 'Please enter username';
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
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
              MaterialButton(
                minWidth: double.infinity,
                height: 40,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () async {
                  if (_form.currentState!.validate()) {
                    try {
                      // UserCredential userCredential =
                      await _auth
                          .signInWithEmailAndPassword(
                              email: _email.text, password: _password.text)
                          .then((value) async {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(_auth.currentUser!.uid)
                            .get()
                            .then((value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("name", value['name']);
                          prefs.setString("bio", value['bio']);
                          prefs.setString("email", value['email']);
                          prefs.setString("imageUrl", value['imageUrl']);
                          prefs.setString("uid", value['uid']);
                          prefs.setString("role", value['role']);

                          var role = prefs.getString('role');

                          role == 'employer'
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmployerMenuScreen(),
                                  ),
                                )
                              : Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MenuScreen(),
                                  ),
                                );
                        });
                      });
                    } on FirebaseAuthException catch (e) {
                      // if (e.code == 'invalid-email') {
                      //   Fluttertoast.showToast(msg: 'invalid email');
                      // } else if (e.code == 'user-not-found') {
                      //   Fluttertoast.showToast(
                      //       msg: 'User not found for that email');
                      // }
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
                    Text('Do not have account?'),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
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

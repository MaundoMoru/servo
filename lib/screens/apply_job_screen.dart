import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:servo/screens/success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplyJobScreen extends StatefulWidget {
  const ApplyJobScreen({Key? key, @required this.docId}) : super(key: key);
  final String? docId;

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  String? myName;
  String? myUid;
  String? myImageUrl;
  String? myBio;

  // function to fetch current user from shared prefs
  void fetchCurrentUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      myName = _prefs.getString('name') ?? '';
      myUid = _prefs.getString('uid') ?? '';
      myImageUrl = _prefs.getString('imageUrl') ?? '';
      myBio = _prefs.getString('bio') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _deadline = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Set Your Bid'),
        actions: const [
          Icon(Icons.bookmark_outline),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                buildBudget(),
                buildDeadline(),
                buildNote(),
                buildSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBudget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Budget',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 50,
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.2),
                ),
                child: const Center(
                  child: Text('USD'),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade300
                          : Colors.grey.shade300.withOpacity(0.2),
                    ),
                  ),
                  child: TextFormField(
                    controller: _budget,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter budget';
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '240',
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );

  Widget buildDeadline() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Days',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 50,
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.2),
                ),
                child: const Center(
                  child: Text('Days'),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade300
                          : Colors.grey.shade300.withOpacity(0.2),
                    ),
                  ),
                  child: TextFormField(
                    controller: _deadline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter days';
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '10',
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );

  Widget buildNote() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Notes',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 150,
            padding: const EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade300
                    : Colors.grey.shade300.withOpacity(0.2),
              ),
            ),
            child: TextFormField(
              maxLines: 6,
              controller: _notes,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter notes';
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Convince the client that you can handle this task..',
              ),
            ),
          )
        ],
      );

  Widget buildSubmit() => Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width * 0.9,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () async {
              if (_form.currentState!.validate()) {
                DocumentReference _documentReference = FirebaseFirestore
                    .instance
                    .collection('jobs')
                    .doc('${widget.docId}');

                _documentReference.set({
                  'applicants': FieldValue.arrayUnion([_auth.currentUser!.uid])
                }, SetOptions(merge: true));

                _documentReference.collection('applications').add({
                  'applicant_image': '$myImageUrl',
                  'applicant_name': '$myName',
                  'applicant_uid': '$myUid',
                  'budget': _budget.text,
                  'deadline': _deadline.text,
                  'notes': _notes.text,
                  'createdOn': FieldValue.serverTimestamp(),
                });
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessScreen(),
                ),
              );
            },
            child: const Text(
              'Apply Now',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
}

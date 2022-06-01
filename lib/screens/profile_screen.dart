import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:servo/screens/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List _elements = [
    {
      'role': 'Android App Developer',
      'start_date': '08-May-2019',
      'end_date': '09-May-2021',
      'description':
          'I have been working as a developer in High Tech Company fo the last one year. I have gained a vast experience of coding throughout the working',
      'type': 'Experience'
    },
    {
      'role': 'Android App Developer',
      'start_date': '08-May-2019',
      'end_date': '09-May-2021',
      'description':
          'I have been working as a developer in High Tech Company fo the last one year. I have gained a vast experience of coding throughout the working',
      'type': 'Experience'
    },
    {
      'role': 'Android App Developer',
      'start_date': '08-May-2019',
      'end_date': '09-May-2021',
      'description':
          'I have been working as a developer in High Tech Company fo the last one year. I have gained a vast experience of coding throughout the working',
      'type': 'Education'
    },
    {
      'role': 'Android App Developer',
      'start_date': '08-May-2019',
      'end_date': '09-May-2021',
      'description':
          'I have been working as a developer in High Tech Company fo the last one year. I have gained a vast experience of coding throughout the working',
      'type': 'Education'
    },
    {
      'role': 'Android App Developer',
      'start_date': '08-May-2019',
      'end_date': '09-May-2021',
      'description':
          'I have been working as a developer in High Tech Company fo the last one year. I have gained a vast experience of coding throughout the working',
      'type': 'Education'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('My profile'),
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
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Center(
                child: Column(
                  children: [
                    buildProfileImg(context, data),
                    const SizedBox(height: 10),
                    buildName(context, data),
                    const SizedBox(height: 10),
                    buildEditButton(),
                    const SizedBox(height: 30),
                    buildAbout(context, data),
                    const SizedBox(height: 10.0),
                    const Divider(),
                    const SizedBox(height: 10.0),
                    // BuildContent(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget buildProfileImg(context, data) => Stack(
        children: [
          // profile image
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
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
  Widget buildName(context, data) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0),
        child: Column(
          children: [
            Text(
              '${data['name']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              '${data['bio']}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  Widget buildEditButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {},
        child: const Text('Edit Profile'),
      );

  Widget buildAbout(context, data) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${data['about']}',
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      );

  Widget BuildContent() => GroupedListView<dynamic, String>(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        elements: _elements,
        groupBy: (element) => element['type'],
        groupHeaderBuilder: (element) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                element['type'],
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add),
              )
            ],
          ),
        ),
        itemBuilder: (BuildContext context, element) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  element['role'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Text(
                      element['start_date'],
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text(
                      element['end_date'],
                      style: TextStyle(color: Colors.grey.shade700),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(element['description']),
              ],
            ),
          );
        },
      );
}

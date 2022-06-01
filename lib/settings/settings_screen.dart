import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servo/auth/login_screen.dart';
import 'package:servo/screens/job_applicants_screen.dart';
import 'package:servo/screens/profile_screen.dart';
import 'package:servo/settings/themeprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsSecreen extends StatefulWidget {
  const SettingsSecreen({Key? key}) : super(key: key);

  @override
  State<SettingsSecreen> createState() => _SettingsSecreenState();
}

class _SettingsSecreenState extends State<SettingsSecreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        centerTitle: true,
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: StreamBuilder(
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
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Column(
                children: [
                  buildTop(context, data),
                  buildContent(context),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildTop(context, data) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  '${data['imageUrl']}' == ""
                      ? Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${data['name'][0]}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: '${data['imageUrl']}',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data['name']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '+254 708655407',
                        style: TextStyle(),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              leading: const Icon(
                Icons.brightness_6,
              ),
              title: const Text(
                'Appearance',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
            const Divider()
          ],
        ),
      );

  Widget buildContent(context) => Column(
        children: [
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.settings_outlined,
            ),
            title: const Text(
              'Accout Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Privacy, Security, Language'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobApplicantsScreen(),
                ),
              );
            },
            leading: const Icon(
              Icons.settings_outlined,
            ),
            title: const Text(
              'About Jobs',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Posted Jobs'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.notification_important_outlined),
            title: const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Newsletter, App Updates'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.delete_outline_outlined,
            ),
            title: const Text(
              'Delete Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () async {
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              _prefs.remove('email');
              _prefs.remove('name');
              _prefs.remove('uid');
              _prefs.remove('imageUrl');
              _prefs.remove('role');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            leading: const Icon(
              Icons.logout_outlined,
            ),
            title: const Text(
              'Log out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
}

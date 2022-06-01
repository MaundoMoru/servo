import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servo/screens/apply_job_screen.dart';
import 'package:servo/screens/job_details_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key, @required this.category}) : super(key: key);

  // final String? category;
  final String? category;

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Icon(
            Icons.notifications_outlined,
            color: Colors.grey.shade600,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '${widget.category}' == 'All'
                    ? 'All Jobs'
                    : '${widget.category}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '44 Job Opportunity',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Can you make Passive income in 2022?',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 150,
                        width: 30,
                        decoration: const BoxDecoration(
                          // shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/worker.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            StreamBuilder(
              stream: '${widget.category}' == 'All'
                  ? FirebaseFirestore.instance.collection('jobs').snapshots()
                  : FirebaseFirestore.instance
                      .collection('jobs')
                      .where('category', isEqualTo: '${widget.category}')
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    separatorBuilder: (BuildContext context, index) {
                      return const Divider();
                    },
                    itemBuilder: (BuildContext context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return ListTile(
                        leading: ds['user_image'] == ''
                            ? Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.shade300,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey
                                  //         .withOpacity(0.4),
                                  //     spreadRadius: 3,
                                  //     blurRadius: 6,
                                  //   ),
                                  // ],
                                ),
                                child: Center(
                                  child: Text(
                                    ds['user_name'][0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: ds['user_image'],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey
                                    //         .withOpacity(0.4),
                                    //     spreadRadius: 3,
                                    //     blurRadius: 6,
                                    //   ),
                                    // ],
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue.shade300,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 3,
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
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
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ds['title'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.bookmark_outline_rounded,
                              color: Colors.grey.shade400,
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ds['location'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                ds['applicants']
                                        .contains(_auth.currentUser!.uid)
                                    ? Text(
                                        'Applied',
                                        style: TextStyle(
                                          color: Colors.blue.shade200,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text('')
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.blue.shade50
                                        : Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '\$' +
                                        ds['salary_min'] +
                                        ' - ' +
                                        '\$' +
                                        ds['salary_max'] +
                                        'Yearly',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Text('3 days ago')
                              ],
                            )
                          ],
                        ),
                        onTap: () async {
                          // showJobModal(context, ds);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailsScreen(
                                userImage: ds['user_image'],
                                userName: ds['user_name'],
                                salaryMin: ds['salary_min'],
                                salaryMax: ds['salary_max'],
                                title: ds['title'],
                                description: ds['description'],
                                availability: ds['availability'],
                                applicants: ds['applicants'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showJobModal(context, ds) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      context: context,
      builder: (context) {
        return Stack(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.3,
                maxChildSize: 0.9,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : const Color(0xFF212121),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: ds['user_image'],
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            spreadRadius: 3,
                                            blurRadius: 6,
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue.shade300,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            spreadRadius: 3,
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
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
                                    width: 10,
                                  ),
                                  Text(
                                    ds['user_name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.bookmark_outline),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.more_vert_outlined),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            ds['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'images/location.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    ds['location'],
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'images/clock.jfif',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    ds['availability'],
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(ds['description'])
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            buildApplyBox(context, ds)
          ],
        );
      },
    );
  }

  Widget buildApplyBox(context, ds) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.shade100
                : Colors.grey.shade800,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey
                        : Colors.grey.shade800,
                  ),
                  child: const Icon(Icons.bookmark_outline),
                ),
                ds['applicants'].contains(_auth.currentUser!.uid)
                    ? MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Colors.blue.shade200,
                        onPressed: () {},
                        child: const Text(
                          'ALREADY APPLIED',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplyJobScreen(
                                docId: ds.id,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'APPLY NOW',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
              ],
            ),
          ),
        ),
      );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servo/screens/job_categories_screen.dart';
import 'package:servo/screens/jobs_screen.dart';
import 'package:servo/screens/post_screen.dart';
import 'package:servo/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List _jobs = [
    {
      'title': 'Senior Flutter Developer',
      'description':
          'The online recruitment sites have witnessed exponential growth since the 2000s. With the internet becoming a prominent part of everyone’s life, there has been an increase in the use of recruitment sites by both job seekers and employers.',
      'category': 'Art',
      'type': 'Job Type 3',
      'availability': 'Full Time',
      'experience': 'Expert',
      'budget': 'Hourly Price',
      'salary_min': '120',
      'salary_max': '300',
      'location': 'Los Angeles',
      'user_image': 'images/google.jfif',
      'user_name': 'Google',
      'time': '3 days ago'
    },
    {
      'title': 'Senior Product Designer',
      'description':
          'The online recruitment sites have witnessed exponential growth since the 2000s. With the internet becoming a prominent part of everyone’s life, there has been an increase in the use of recruitment sites by both job seekers and employers.',
      'category': 'Art',
      'type': 'Job Type 1',
      'availability': 'Part Time',
      'experience': 'Beginner',
      'budget': 'Hourly Price',
      'salary_min': '120',
      'salary_max': '300',
      'location': 'Los Angeles',
      'user_image': 'images/airbnb.png',
      'user_name': 'Airbnb',
      'time': '3days ago'
    },
    {
      'title': 'Sales & Marketing Rep',
      'description':
          'The online recruitment sites have witnessed exponential growth since the 2000s. With the internet becoming a prominent part of everyone’s life, there has been an increase in the use of recruitment sites by both job seekers and employers.',
      'category': 'Business',
      'type': 'Job Type 1',
      'availability': 'Part Time',
      'experience': 'Intermediate',
      'budget': 'Full Time',
      'salary_min': '50',
      'salary_max': '100',
      'location': 'Carlifornia',
      'user_image': 'images/sale.jfif',
      'user_name': 'Platinum Credit Ltd',
      'time': '40 min ago'
    },
    {
      'title': 'Computer Science Lecturer',
      'description':
          'The online recruitment sites have witnessed exponential growth since the 2000s. With the internet becoming a prominent part of everyone’s life, there has been an increase in the use of recruitment sites by both job seekers and employers.',
      'category': 'Education',
      'type': 'Job Type 3',
      'availability': 'Full Time',
      'experience': 'Expert',
      'budget': 'Full Time',
      'salary_min': '8000',
      'salary_max': '1000',
      'location': 'Nottingham',
      'user_image': 'images/school.jfif',
      'user_name': 'Nottingham School of IT',
      'time': '1 min ago'
    },
    {
      'title': 'Kenya Defence Force',
      'description':
          'The online recruitment sites have witnessed exponential growth since the 2000s. With the internet becoming a prominent part of everyone’s life, there has been an increase in the use of recruitment sites by both job seekers and employers.',
      'category': 'Law enforcement',
      'type': 'Job Type 1',
      'availability': 'Full Time',
      'experience': 'Beginner',
      'budget': 'Hourly Price',
      'salary_min': '700',
      'salary_max': '800',
      'location': 'Texas',
      'user_image': 'images/law.png',
      'user_name': ' KDF',
      'time': ' 2 sec ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsSecreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.menu_outlined,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Loop',
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade200
                  : Colors.grey.shade300.withOpacity(0.05),
            ),
            // child: Icon(Icons.work_outline),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.shade300
                        : Colors.grey.shade300.withOpacity(0.05),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: 50,
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search_outlined,
                      ),
                      hintText: 'Enter Name or Job category ..'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Search',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const JobsScreen(category: 'All'),
                        ),
                      );
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('jobs').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (BuildContext context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.grey.shade300
                                          : Colors.grey.shade300
                                              .withOpacity(0.05),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 150,
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.blue.shade50
                                                  : Colors.blue.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(ds['availability']),
                                            ),
                                          ),
                                          Icon(
                                            Icons.bookmark_outline_rounded,
                                            color: Colors.grey.shade600,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        ds['title'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          ds['user_image'] == ''
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: ds['user_image'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
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
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          Colors.blue.shade300,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.4),
                                                          spreadRadius: 3,
                                                          blurRadius: 6,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
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
                                                      image:
                                                          const DecorationImage(
                                                        image: AssetImage(
                                                          'images/profile_picture.png',
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Expanded(
                                            child: Text(
                                              ds['user_name'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            '3 days ago',
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JobCategoriesScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade100
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 100,
                    width: 80,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("images/arts.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Text('Arts')
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade100
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 100,
                    width: 80,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("images/business.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Text('Business')
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade100
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 100,
                    width: 80,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("images/education.jfif"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Text('Education')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            )
          ],
        ),
      ),
    );
  }
}

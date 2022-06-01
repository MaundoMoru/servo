import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servo/screens/apply_job_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({
    Key? key,
    @required this.userImage,
    @required this.userName,
    @required this.salaryMin,
    @required this.salaryMax,
    @required this.title,
    @required this.description,
    @required this.availability,
    @required this.applicants,
  }) : super(key: key);

  final String? userImage;
  final String? userName;
  final String? title;
  final String? salaryMin;
  final String? salaryMax;
  final String? description;
  final String? availability;
  final List? applicants;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _selectedTabbar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DefaultTabController(
            length: 3,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  toolbarHeight: 80,
                  // title: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text('${widget.userName}'),
                  //       IconButton(
                  //         padding: EdgeInsets.zero,
                  //         onPressed: () {},
                  //         icon: const Icon(
                  //           Icons.more_vert_outlined,
                  //         ),
                  //       ),
                  //     ]),
                  pinned: true,
                  expandedHeight: 250,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(color: Colors.blue.shade100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: '${widget.userImage}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 50,
                                    height: 50,
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
                                    height: 50,
                                    width: 50,
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
                                    width: 50.0,
                                    height: 50.0,
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
                                  '${widget.userName}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20),
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 8),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black54,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: TabBar(
                          onTap: (index) {
                            print(index);
                            setState(() {
                              _selectedTabbar = index;
                            });
                          },
                          tabs: const [
                            Tab(text: "Description"),
                            Tab(text: "Company"),
                            Tab(text: "Reviews"),
                          ]),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Builder(builder: (_) {
                      if (_selectedTabbar == 0) {
                        return Column(
                          children: [
                            jobDetails(),
                            const SizedBox(height: 30),
                          ],
                        ); //1st custom tabBarView
                      } else if (_selectedTabbar == 1) {
                        return Container(); //2nd tabView
                      } else {
                        return Container(); //3rd tabView
                      }
                    }),
                  ),
                )
              ],
            ),
          ),
          buildApplyBox(),
        ],
      ),
    );
  }

  Widget jobDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            '${widget.title}',
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
                        color: Theme.of(context).scaffoldBackgroundColor,
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
                    'Los Angeles',
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
                        color: Theme.of(context).scaffoldBackgroundColor,
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
                    '${widget.availability}',
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
              Text('${widget.description}')
            ],
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      );

  Widget buildApplyBox() => Align(
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                '${widget.applicants}'.contains(_auth.currentUser!.uid)
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
                        onPressed: () {},
                        child: const Text(
                          'APPLY NOW',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      );
}

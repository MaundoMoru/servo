import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:servo/screens/image_screen.dart';
import 'package:servo/screens/tasks_screen.dart';
import 'package:servo/screens/users_screen.dart';
import 'package:servo/settings/settings_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        title: const Text('HireHub'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            buildTopProfiles(),
            const SizedBox(height: 5.0),
            buildUserInvitations(),
          ],
        ),
      ),
    );
  }

  Widget buildTopProfiles() => Container(
        height: 130,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey.shade100
            : Colors.grey.shade300.withOpacity(0.05),
        child: Column(
          children: [
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top profiles',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UsersScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'View more',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .limit(7)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        return InkWell(
                          onTap: () {
                            modal(context, ds);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 20, right: 8.0),
                            child: ds['imageUrl'] == ""
                                ? Column(
                                    children: [
                                      Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue.shade300,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              spreadRadius: 3,
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            ds['name'][0],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: Center(
                                          child: Text(
                                            ds['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: ds['imageUrl'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 55.0,
                                          height: 55.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
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
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 55,
                                          width: 55,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue.shade300,
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
                                        height: 3,
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: Center(
                                          child: Text(
                                            ds['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3.0,
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );

  modal(context, ds) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.64,
              minChildSize: 0.2,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : const Color(0xFF212121),
                  child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          // build user image
                          InkWell(
                            onTap: () {},
                            child: ds['imageUrl'] == ''
                                ? Container(
                                    height: 90,
                                    width: 90,
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
                                    child: Center(
                                      child: Text(
                                        ds['name'][0],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageScreen(
                                            image: ds['imageUrl'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: ds['imageUrl'],
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 90.0,
                                        height: 90.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
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
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              spreadRadius: 3,
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        width: 55,
                                        height: 55,
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
                                  ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            ds['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          Text(
                            ds['bio'],
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          InkWell(
                            child: RatingBar.builder(
                              initialRating:
                                  double.parse(ds['avgRating'].toString()),
                              // rating != 0 ? rating : ds['avgRating'],
                              ignoreGestures: true,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              updateOnDrag: true,
                              itemSize: 18,
                              onRatingUpdate: (rating) {},
                              allowHalfRating: true,
                            ),
                            onTap: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => AlertDialog(
                              //     title: const Text('Rate Me'),
                              //     content: Column(
                              //       mainAxisSize: MainAxisSize.min,
                              //       children: [
                              //         RatingBar.builder(
                              //           minRating: 1,
                              //           itemBuilder: (context, _) =>
                              //               const Icon(
                              //             Icons.star,
                              //             color: Colors.amber,
                              //           ),
                              //           updateOnDrag: true,
                              //           itemSize: 35,
                              //           onRatingUpdate: (rating) {
                              //             setState(() {
                              //               this.rating = rating;
                              //             });
                              //           },
                              //           allowHalfRating: true,
                              //         ),
                              //         const SizedBox(height: 10.0),
                              //         //
                              //         Container(
                              //           height: 150,
                              //           // child:
                              //         )
                              //       ],
                              //     ),
                              //     actions: [
                              //       TextButton(
                              //         onPressed: () async {
                              //           Navigator.pop(context);
                              //           rateUser(context, ds);
                              //         },
                              //         child: const Text('Ok'),
                              //       ),
                              //     ],
                              //   ),
                              // );
                            },
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade300
                                                .withOpacity(0.05),
                                      ),
                                      child: const Icon(Icons.message_outlined),
                                    ),
                                    const Text('Message')
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.grey.shade200
                                            : Colors.grey.shade300
                                                .withOpacity(0.05),
                                      ),
                                      // child: Icon(Icons.work_outline),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.work_outline),
                                      ),
                                    ),
                                    const Text('Invite me')
                                  ],
                                ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }

  Widget buildUserInvitations() => StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('invitations')
            .where('employee_uid', isEqualTo: _auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            separatorBuilder: (BuildContext context, index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, index) {
              DocumentSnapshot invitation = snapshot.data!.docs[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TasksScreen(
                          imageUrl: invitation['employer_imageUrl'],
                          name: invitation['employer_name'],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      invitation['employer_imageUrl'] == ''
                          ? Container(
                              height: 55,
                              width: 55,
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
                              child: Center(
                                child: Text(
                                  invitation['employer_name'][0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: invitation['employer_imageUrl'],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 55,
                                height: 55,
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
                                height: 55,
                                width: 55,
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
                                width: 55.0,
                                height: 55.0,
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
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              invitation['employer_name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Congratulations! You have new invitation',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: const [
                                Text(
                                  'In Ngara',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'In Contract',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert_outlined),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
}

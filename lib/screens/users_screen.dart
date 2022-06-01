import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:servo/screens/image_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String? _search = '';
  String? name;
  String? uid;
  String? imageUrl;
  String? bio;

  // function to fetch current user from shared prefs
  void fetchCurrentUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      name = _prefs.getString('name');
      uid = _prefs.getString('uid');
      imageUrl = _prefs.getString('imageUrl');
      bio = _prefs.getString('bio');
    });
  }

  double rating = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

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
        title: const Text('Users'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 5.0,
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
                    setState(() {
                      _search = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            StreamBuilder(
              stream: (_search == '' && _search!.isEmpty)
                  ? FirebaseFirestore.instance.collection('users').snapshots()
                  : FirebaseFirestore.instance
                      .collection('users')
                      .orderBy('name')
                      .startAt([_search]).endAt(
                          [_search! + '\uf8ff']).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(''),
                  );
                } else {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (BuildContext context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return buildUsers(context, ds);
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildUsers(context, ds) => Padding(
        padding: const EdgeInsets.all(5),
        child: InkWell(
          onTap: () {
            modal(context, ds);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ds['imageUrl'] == ''
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
                          ds['name'][0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: ds['imageUrl'],
                      imageBuilder: (context, imageProvider) => Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).scaffoldBackgroundColor,
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
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ds['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      ds['bio'],
                      style: const TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating:
                              double.parse(ds['avgRating'].toString()),
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
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('(90)')
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('In Ngara'),
                        const SizedBox(
                          width: 8,
                        ),
                        ds['isInContract'] == true
                            ? const Text('In Contract')
                            : const Icon(
                                Icons.closed_caption,
                                color: Colors.grey,
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
                              {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Rate Me'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RatingBar.builder(
                                          minRating: 1,
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          updateOnDrag: true,
                                          itemSize: 35,
                                          onRatingUpdate: (rating) {
                                            setState(() {
                                              this.rating = rating;
                                            });
                                          },
                                          allowHalfRating: true,
                                        ),
                                        const SizedBox(height: 10.0),
                                        //
                                        Container(
                                          height: 150,
                                          // child:
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          rateUser(context, ds);
                                        },
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  ),
                                );
                              }
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
                                    const Text('Hire me')
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

// function to rate the user
  void rateUser(context, ds) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(ds['uid']);

    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      // Compute new number of ratings
      var newNumRatings = snapshot['numRatings'] + 1;

      // Compute new average rating
      var oldRatingTotal = snapshot['avgRating'] * snapshot['numRatings'];
      var newAvgRating = (oldRatingTotal + rating) / newNumRatings;

      // Commit to Firestore
      transaction.update(documentReference,
          {'numRatings': newNumRatings, 'avgRating': newAvgRating});

      // create ratings subcollection
      documentReference.collection('ratings').add({
        'rated_id': ds['uid'],
        'rater_id': _auth.currentUser!.uid,
        'rating': rating,
        'my_name': '$name',
        'my_image': '$imageUrl'
      });

      setState(() {
        rating = 0.0;
      });
    });
  }
}

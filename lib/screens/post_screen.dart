import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:servo/screens/users_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PageController _controller = PageController(initialPage: 0);

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  final TextEditingController _period = TextEditingController();

  String? _selectedJobType = 'short term';
  String? name;
  String? uid;
  String? imageUrl;
  String? bio;

  // function to fetch current user from shared prefs
  void fetchCurrentUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      name = _prefs.getString('name') ?? '';
      uid = _prefs.getString('uid') ?? '';
      imageUrl = _prefs.getString('imageUrl') ?? '';
      bio = _prefs.getString('bio') ?? '';
    });
  }

  String? dropdownvalue = 'Post to everyone';
  List<String> items = [
    'Post to everyone',
    'Select individual',
  ];

  String? _jobCategory;
  final List<String> _category = [
    'Art',
    'Business',
    'Education',
    'Law enforcement',
    'Media',
    'Medical',
    'Service industry',
    'Technology',
    'Other options'
  ];

  String? _jobType;
  final List<String> _type = ['Job Type 1', 'Job Type 2', 'Job Type 3'];

  String? _jobAvailability;
  final List<String> _availability = ['Full Time', 'Part Time'];

  String? _jobExperienceLevel;
  final List<String> _experience = ['Beginner', 'Intermediate', 'Expert'];

  String? _jobBudget;
  final List<String> _budget = ['Fixed price', 'Hourly price'];

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _jobTitle = TextEditingController();
  final TextEditingController _jobDescription = TextEditingController();
  final TextEditingController _salaryMin = TextEditingController();
  final TextEditingController _salaryMax = TextEditingController();
  final TextEditingController _location = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // centerTitle: true,
          // title: const Text('Post'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Add News',
              ),
              Tab(
                text: 'Post Job',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('data'),
            ),
            SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    buildJobTitle(),
                    const SizedBox(height: 20.0),
                    buildJobDescription(),
                    const SizedBox(height: 20.0),
                    buildJobCategory(),
                    const SizedBox(height: 20.0),
                    buildJobType(),
                    const SizedBox(height: 20.0),
                    buildJobAvailability(),
                    const SizedBox(height: 20.0),
                    buildJobExperience(),
                    const SizedBox(height: 20.0),
                    buildJobBudget(),
                    const SizedBox(height: 20.0),
                    buildJobSalary(),
                    const SizedBox(height: 20.0),
                    buildJobLocation(),
                    const SizedBox(height: 20.0),
                    buildPostButton(),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJobTitle() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Title',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.05),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                controller: _jobTitle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter job title';
                  }
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type job title ..',
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildJobDescription() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              // height: 50,
              padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.05),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),

              child: TextFormField(
                controller: _jobDescription,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type job description ..',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter job description';
                  }
                },
              ),
            ),
          ],
        ),
      );

  Widget buildJobCategory() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              // height: 50,
              // padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.05),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: DropdownButtonFormField(
                  hint: const Text('Select job category'),
                  // underline: Container(),

                  value: _jobCategory,
                  isExpanded: true,

                  // alignment: AlignmentDirectional.bottomEnd,
                  items: _category
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _jobCategory = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildJobType() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Type',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.05),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: DropdownButtonFormField(
                  hint: const Text('Select job type'),
                  // underline: Container(),

                  value: _jobType,
                  isExpanded: true,

                  alignment: AlignmentDirectional.bottomEnd,
                  items: _type
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _jobType = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildJobAvailability() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Availability',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              // height: 50,
              // padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.05),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: DropdownButtonFormField(
                  hint: const Text('Select job availability'),
                  // underline: Container(),

                  value: _jobAvailability,
                  isExpanded: true,

                  alignment: AlignmentDirectional.bottomEnd,
                  items: _availability
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _jobAvailability = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildJobExperience() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Experience',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              // height: 50,
              // padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.05),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: DropdownButtonFormField(
                  hint: const Text('Select experience level'),
                  // underline: Container(),

                  value: _jobExperienceLevel,
                  isExpanded: true,

                  alignment: AlignmentDirectional.bottomEnd,
                  items: _experience
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    _jobExperienceLevel = value;
                  },
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildJobBudget() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Budget',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              // height: 50,
              // padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.05),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: DropdownButtonFormField(
                  hint: const Text('Select job budget'),
                  // underline: Container(),

                  value: _jobBudget,
                  isExpanded: true,

                  alignment: AlignmentDirectional.bottomEnd,
                  items: _budget
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _jobBudget = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildJobSalary() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Salary min:'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade300
                            : Colors.grey.shade300.withOpacity(0.05),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _salaryMin,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Min',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Min salary';
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Salary max:'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade300
                            : Colors.grey.shade300.withOpacity(0.05),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _salaryMax,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Max',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Max salary';
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildJobLocation() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.05),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                controller: _location,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter job location';
                  }
                },
              ),
            ),
          ],
        ),
      );

  Widget buildPostButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: MaterialButton(
          color: Theme.of(context).accentColor,
          minWidth: double.infinity,
          height: 40,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () {
            if (_form.currentState!.validate()) {
              FirebaseFirestore.instance.collection('jobs').add({
                'title': _jobTitle.text,
                'description': _jobDescription.text,
                'category': _jobCategory.toString(),
                'type': _jobType.toString(),
                'availability': _jobAvailability.toString(),
                'experience': _jobExperienceLevel.toString(),
                'budget': _jobBudget.toString(),
                'salary_min': _salaryMin.text,
                'salary_max': _salaryMax.text,
                'location': _location.text,
                'applicants': [],
                'user_image': '$imageUrl',
                'user_name': '$name',
                'time': FieldValue.serverTimestamp(),
              });
            }
          },
          child: const Text(
            'SUBMIT',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
}

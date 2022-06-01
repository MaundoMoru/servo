import 'package:flutter/material.dart';
import 'package:servo/screens/jobs_screen.dart';

class JobCategoriesScreen extends StatefulWidget {
  const JobCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<JobCategoriesScreen> createState() => _JobCategoriesScreenState();
}

class _JobCategoriesScreenState extends State<JobCategoriesScreen> {
  final List _category = [
    {
      'category': 'Art',
      'image': 'images/arts.png',
    },
    {
      'category': 'Business',
      'image': 'images/business.png',
    },
    {
      'category': 'Education',
      'image': 'images/education.jfif',
    },
    {
      'category': 'Law enforcement',
      'image': 'images/law.png',
    },
    {
      'category': 'Media',
      'image': 'images/media.png',
    },
    {
      'category': 'Medical',
      'image': 'images/medical.png',
    },
    {
      'category': 'Service industry',
      'image': 'images/industry.png',
    },
    {
      'category': 'Technology',
      'image': 'images/technology.png',
    },
    {
      'category': 'Other options',
      'image': 'images/others.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Job Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.separated(
          itemCount: _category.length,
          separatorBuilder: (BuildContext context, index) {
            return const Divider();
          },
          itemBuilder: (BuildContext context, index) {
            return ListTile(
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(_category[index]['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(_category[index]['category']),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobsScreen(
                      category: _category[index]['category'],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:servo/screens/post_screen.dart';
import '../../settings/settings_screen.dart';

class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({Key? key}) : super(key: key);

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servo/auth/login_screen.dart';
import 'package:servo/screens/menu_screen.dart';
import 'package:servo/settings/themeprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String> loadUserData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String email = _prefs.getString('email') ?? '';
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme.currentTheme,
          home: FutureBuilder<String>(
            future: loadUserData(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return const MenuScreen();
                } else {
                  return LoginScreen();
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),
        );
      },
    );
  }
}

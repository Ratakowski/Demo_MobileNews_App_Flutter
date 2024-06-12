import 'package:flutter/material.dart';
import 'package:busidemo31/news_database.dart'; 
import 'package:busidemo31/news_list_page.dart';
import 'package:busidemo31/user.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await myFunction();

  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NewsListPage(),
    );
  }
}

//Database untuk Login
Future<void> myFunction() async {
  final newsDatabase = NewsDatabase.instance;

  final newUser = User(
    username: 'satya',
    password: '123210140',
  );

  await newsDatabase.insertUser(newUser);

  final user = await newsDatabase.authenticate('satya', '123210140');

  if (user != null) {
    print('User authenticated: ${user.username}');
  } else {
    print('User not found or incorrect password');
  }
}




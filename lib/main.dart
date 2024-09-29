import 'package:flutter/material.dart';
import 'package:pos_flutter/views/home_view.dart';
import 'package:pos_flutter/views/login_view.dart';
import 'package:pos_flutter/views/product_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
      routes: {
        '/home': (context)=> ProductListView()
      },
    );
  }
}




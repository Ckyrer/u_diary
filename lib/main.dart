import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u_diary/providers/my_data_provider.dart';
import 'package:u_diary/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyDataProvider()..getData(DateTime.now()),
      child: MaterialApp(
        title: 'UDiary',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 233, 157, 17),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lazyload_todo_list/ui/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sq_test/layout/home_layout.dart';
import 'package:sq_test/shared/bloc_observer.dart';

import 'modules/first/NewTaskScreen.dart';

void main() {
  runApp(const MyApp());
  Bloc.observer = MyBlocObserver();

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home_layout(),
    );

    // TODO: implement build
  }

  // This widget is the root of your application.

  }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metronome/Pages/Metronome/MetronomeController.dart';

import 'Pages/Metronome/MetronomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<MetronomeController>(() => MetronomeController());
      }),
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => MetronomeScreen(),)
      ],
    );
  }
}


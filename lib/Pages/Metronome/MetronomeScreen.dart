

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metronome/Pages/Metronome/MetronomeController.dart';
import 'package:metronome/Pages/Metronome/Widgets/BottomSectionWidget.dart';
import 'package:metronome/Pages/Metronome/Widgets/TopSectionWidget.dart';

class MetronomeScreen extends GetView<MetronomeController> {
   const MetronomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder(
        init: controller,
        builder: (_) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TopSectionWidget(controller: controller),
            BottomSectionWidget(controller: controller)
          ],
        ),
      ),
    );
  }
}

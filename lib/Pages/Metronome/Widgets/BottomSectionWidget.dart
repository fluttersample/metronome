

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:metronome/Pages/Metronome/MetronomeController.dart';

class BottomSectionWidget extends StatelessWidget {
  const BottomSectionWidget({super.key , required this.controller});
    final MetronomeController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: Column(
          children: [
            const Divider(),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 12,
                ),
                Obx(
                  () =>  Text(
                    '${controller.bpm.value} ',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                 Text('BPM '),
                // Obx(() =>  Text('BPM (${(controller.sec.value / controller.bpm.value).toStringAsFixed(1)})')),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.decrementBpm(1);
                  },
                  onLongPress: () {
                    controller.holdDecrementBpm();
                  },
                  onLongPressEnd: (details) {
                    controller.isStartIncrementBpm = false;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.remove),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () =>  Slider(
                      min: 10,
                      max: 320,
                      value: controller.bpm.value.toDouble(),
                      onChanged: (value) {
                        controller.bpm.value = value.toInt();
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.incrementBpm(1);
                  },
                  onLongPress: () {
                    controller.holdIncrementBpm();
                  },
                  onLongPressEnd: (details) {
                    controller.isStartIncrementBpm = false;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize:
                    Size(MediaQuery.of(context).size.width * 0.8, 45)),
                onPressed: () {
                controller.startOrStopMetronome();
                },
                child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: controller.controllerAnimIconPlay))
          ],
        ),
      ),
    );
  }
}

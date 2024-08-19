

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/state_manager.dart';
import 'package:metronome/Pages/Metronome/MetronomeController.dart';

class TopSectionWidget extends StatelessWidget {
  const TopSectionWidget({super.key , required this.controller});
    final MetronomeController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () =>  SwitchListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: controller.isActiveLight.value,
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'چراغ چشمک زن',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              onChanged: (value) {
                controller.isActiveLight.value = !controller.isActiveLight.value;
              }),
        ),
        const Divider(
          endIndent: 50,
          indent: 50,
        ),
        Obx(
          () =>  SwitchListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: controller.isChangePattern.value,
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'تغییر الگو',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              onChanged: (value) {
                controller.isChangePattern.value = !controller.isChangePattern.value;
                controller.update();
              }),
        ),
        const SizedBox(
          height: 30,
        ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.isChangePattern.value
              ? Row(
            key: const ValueKey<int>(2),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(
                () =>  AnimatedContainer(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: controller.isTurnOnLightRight.value ? Colors.white : Colors.blue ,
                      boxShadow: const [
                        BoxShadow(color: Colors.white, blurRadius: 5)
                      ]),
                  duration: controller.durationLight,
                  child: Image.asset(
                    'assets/note-2.png',
                  ),
                ),
              ),
              Obx(
                () =>  AnimatedContainer(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: controller.isTurnOnLightLeft.value ? Colors.white : Colors.blue,
                      boxShadow: const [
                        BoxShadow(color: Colors.white, blurRadius: 5)
                      ]),
                  duration: controller.durationLight,
                  child: Image.asset(
                    'assets/note-2.png',
                  ),
                ),
              ),
            ],
          )
              : Obx(
                () =>  AnimatedContainer(
                            key: const ValueKey<int>(1),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: controller.isTurnOnLightRight.value ? Colors.white : Colors.blue,
                  boxShadow: const [
                    BoxShadow(color: Colors.white, blurRadius: 5)
                  ]),
                            // duration: durationLight,
                            duration: controller.durationLight,
                            child:  Image.asset('assets/note-1.png',
                            ),
                          ),
              ),
        ),

        // Container(
        //   height: 200,
        //   width: 200,
        //   color: Colors.red,
        // ),
      ],
    );
  }
}

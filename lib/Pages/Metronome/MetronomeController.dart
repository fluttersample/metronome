

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';

class MetronomeController extends GetxController with GetSingleTickerProviderStateMixin{

  /// variables
  Soundpool pool = Soundpool.fromOptions();
  int tickID = 0;
  int minValueSlider = 10;
  int maxValueSlider = 320;
  Timer? timerMetronome;
  bool isStartIncrementBpm = false;
  late AnimationController controllerAnimIconPlay;
  final durationLight = const Duration(milliseconds: 150);

  // obs
  final bpm = 60.obs , sec = 60.obs;
  final isPlay = false.obs,
      isChangePattern = false.obs ,
      isActiveLight = false.obs ,
      isTurnOnLightRight = false.obs ,
      isTurnOnLightLeft =  false.obs;



  @override
  void onInit() {
    setBeat();
    controllerAnimIconPlay = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.onInit();
  }
  @override
  void onClose() {
    stopMetronome();
    super.onClose();
  }

  /// methods
  void incrementBpm(int value) {
    if (bpm.value == maxValueSlider) return;
    bpm.value += value;
  }

  void decrementBpm(int value) {
    if (bpm.value == minValueSlider) return;
    bpm.value -= value;
  }

  void holdIncrementBpm() async {
    isStartIncrementBpm = true;
    while (isStartIncrementBpm) {
      incrementBpm(1);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void holdDecrementBpm() async {
    isStartIncrementBpm = true;
    while (isStartIncrementBpm) {
      decrementBpm(1);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void setBeat() async {
    tickID =
    await rootBundle.load("assets/beat.m4a").then((ByteData soundData) {
      return pool.load(soundData);
    });
  }

  void startMetronome() {
    final result = (sec.value / bpm.value);
    final duration = (result * 1000).toInt();
    timerMetronome = Timer.periodic(Duration(milliseconds: duration), (timer) {
      print("Tick Timer ${timer.tick}");
      pool.play(tickID);
      turnOnLight();
      playWithNewPattern(duration);
    });
    isPlay.value = true;
  }

  void playWithNewPattern(int duration){
    if (isChangePattern.value) {
      Future.delayed(
        Duration(milliseconds: duration ~/ 2),
            () {
          pool.play(tickID);
          turnOnLight(isRightLight: false );

        },
      );
    }
  }

  void stopMetronome() {
    timerMetronome?.cancel();
    timerMetronome = null;
    isPlay.value = false;
  }

  void turnOnLight({bool isRightLight = true }) {
    if (!isActiveLight.value) return;
    if(isRightLight){
      isTurnOnLightRight.value = true;

    }else {
      isTurnOnLightLeft.value = true;
    }

    Future.delayed(
      durationLight,
          () {
        if(isRightLight){
          isTurnOnLightRight.value = false;
        }else {
          isTurnOnLightLeft.value = false;
        }
      },
    );
  }

  void startOrStopMetronome(){
    if (isPlay.value) {
      controllerAnimIconPlay.reverse();
      stopMetronome();
      return;
    }
    controllerAnimIconPlay.forward();
    startMetronome();
  }

}
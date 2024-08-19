import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class MetronomeScreen extends StatefulWidget {
  const MetronomeScreen({super.key});

  @override
  State<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen>
    with SingleTickerProviderStateMixin {
  Soundpool pool = Soundpool.fromOptions();
  int bpm = 60;
  int sec = 60;
  double resultTimer = 0;
  Timer? timerMetronome;
  int tickID = 0;
  bool isStartIncrementBpm = false;
  bool isPlay = false;
  bool isChangePattern = false;
  bool isTurnOnLight = false;
  late AnimationController controllerAnimIconPlay;
  Color colorLightRight = Colors.blue;
  Color colorLightLeft = Colors.blue;
  final durationLight = const Duration(milliseconds: 150);
  @override
  void initState() {
    super.initState();
    setBeat();
    controllerAnimIconPlay = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    stopMetronome();
    super.dispose();
  }

  void setBeat() async {
    tickID =
        await rootBundle.load("assets/beat.m4a").then((ByteData soundData) {
      return pool.load(soundData);
    });
  }

  void startMetronome() {
    final result = sec / bpm;
    final duration = (result * 1000).toInt();
    timerMetronome = Timer.periodic(Duration(milliseconds: duration), (timer) {
      print("Tick Timer ${timer.tick}");

      pool.play(tickID);
      turnOnLight();

      playWithNewPattern(duration);
    });
    isPlay = true;
  }
  void playWithNewPattern(int duration){
    if (isChangePattern) {
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
    isPlay = false;
  }

  void turnOnLight({bool isRightLight = true }) {
    if (!isTurnOnLight) return;
    if(isRightLight){
      colorLightRight = Colors.white;
    }else {
      colorLightLeft = Colors.white;
    }

    setState(() {});
    Future.delayed(
     durationLight,
      () {
        if(isRightLight){
          colorLightRight = Colors.blue;
        }else {
          colorLightLeft = Colors.blue;
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _topSection,
          _bottomSection,
        ],
      ),
    );
  }

  Widget get _topSection {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SwitchListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: isTurnOnLight,
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'چراغ چشمک زن',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            onChanged: (value) {
              isTurnOnLight = !isTurnOnLight;
              setState(() {});
            }),
        const Divider(
          endIndent: 50,
          indent: 50,
        ),
        SwitchListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: isChangePattern,
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'تغییر الگو',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            onChanged: (value) {
              isChangePattern = !isChangePattern;
              setState(() {});
            }),
        const SizedBox(
          height: 30,
        ),
        // Row(
        //   children: [
        //     AnimatedContainer(
        //       height: 100,
        //       width: 100,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(15),
        //           color: colorLightRight,
        //           boxShadow: const [
        //             BoxShadow(color: Colors.white, blurRadius: 5)
        //           ]),
        //       duration: durationLight,
        //       child: AnimatedSwitcher(
        //         duration: Duration(milliseconds: 300),
        //         child: Image.asset(
        //           'assets/note-2.png',
        //         ),
        //       ),
        //     ),
        //     AnimatedContainer(
        //       height: 100,
        //       width: 100,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(15),
        //           color: colorLightLeft,
        //           boxShadow: const [
        //             BoxShadow(color: Colors.white, blurRadius: 5)
        //           ]),
        //       duration: durationLight,
        //       child: Image.asset(
        //         'assets/note-2.png',
        //       ),
        //     ),
        //   ],
        // ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: isChangePattern
              ? Row(
            key: ValueKey<int>(2),
            mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedContainer(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: colorLightRight,
                        boxShadow: const [
                          BoxShadow(color: Colors.white, blurRadius: 5)
                        ]),
                    duration: durationLight,
                    child: Image.asset(
                      'assets/note-2.png',
                    ),
                  ),
                  AnimatedContainer(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: colorLightLeft,
                          boxShadow: const [
                            BoxShadow(color: Colors.white, blurRadius: 5)
                          ]),
                      duration: durationLight,
                      child: Image.asset(
                        'assets/note-2.png',
                      ),
                    ),
                ],
              )
              : AnimatedContainer(
                 key: const ValueKey<int>(1),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: colorLightRight,
                      boxShadow: const [
                        BoxShadow(color: Colors.white, blurRadius: 5)
                      ]),
                  // duration: durationLight,
                  duration: durationLight,
                  child:  Image.asset('assets/note-1.png',
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

  Widget get _bottomSection {
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
                Text(
                  '${bpm} ',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text('BPM (${(sec / bpm).toStringAsFixed(1)})'),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _decrementBpm(1);
                  },
                  onLongPress: () {
                    _holdDecrementBpm();
                  },
                  onLongPressEnd: (details) {
                    isStartIncrementBpm = false;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle),
                    padding: const EdgeInsets.all(8),
                    child: Ink(child: const Icon(Icons.remove)),
                  ),
                ),
                Expanded(
                  child: Slider(
                    min: 10,
                    max: 320,
                    value: bpm.toDouble(),
                    onChanged: (value) {
                      bpm = value.toInt();
                      print(bpm);
                      setState(() {});
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _incrementBpm(1);
                  },
                  onLongPress: () {
                    _holdIncrementBpm();
                  },
                  onLongPressEnd: (details) {
                    isStartIncrementBpm = false;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle),
                    padding: const EdgeInsets.all(8),
                    child: Ink(child: const Icon(Icons.add)),
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
                  if (isPlay) {
                    controllerAnimIconPlay.reverse();
                    stopMetronome();
                    return;
                  }
                  controllerAnimIconPlay.forward();
                  startMetronome();
                },
                child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: controllerAnimIconPlay))
          ],
        ),
      ),
    );
  }

  void _incrementBpm(int value) {
    if (bpm == 320) return;

    bpm += value;
    setState(() {});
  }

  void _decrementBpm(int value) {
    if (bpm == 1) return;
    bpm -= value;
    setState(() {});
  }

  void _holdIncrementBpm() async {
    isStartIncrementBpm = true;
    while (isStartIncrementBpm) {
      _incrementBpm(1);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void _holdDecrementBpm() async {
    isStartIncrementBpm = true;
    while (isStartIncrementBpm) {
      _decrementBpm(1);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:weather/api.dart';
import 'package:weather/frames_lister.dart';
import 'package:weather/map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? currentUrl;
  List<Frame>? _data;

  @override
  void initState() {
    Future.delayed(Duration.zero, fetch);
    super.initState();
  }

  Future fetch() async {
    _data = await fetchData();
    setState(() {
      currentUrl = (_data != null && _data!.isNotEmpty) ? _data![0].url : null;
    });
  }

  void setUrl(String target) {
    setState(() {
      currentUrl = target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            MapWidget(currentUrl),
            FramesLister(
                list: _data, setActive: setUrl, currentUrl: currentUrl),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              fetch();
            });
          },
          child: const Icon(Icons.replay_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}

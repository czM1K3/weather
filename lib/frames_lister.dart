import 'package:flutter/material.dart';
import 'package:weather/api.dart';

class FramesLister extends StatelessWidget {
  const FramesLister({
    super.key,
    required this.list,
    required this.setActive,
    required this.currentUrl,
  });

  final List<Frame>? list;
  final void Function(String) setActive;
  final String? currentUrl;

  @override
  Widget build(BuildContext context) {
    if (list == null) {
      return const Column();
    }
    return Wrap(
      direction: Axis.vertical,
      children: list!
          .map((e) => GestureDetector(
                onTap: () {
                  setActive(e.url);
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:
                          currentUrl == e.url ? Colors.red : Colors.lightBlue),
                  child: Text(e.label,
                      style: const TextStyle(color: Colors.white)),
                ),
              ))
          .toList(),
    );
  }
}

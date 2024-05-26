import 'package:flutter/material.dart';
import 'package:weather/api.dart';

class FramesLister extends StatefulWidget {
  const FramesLister({
    super.key,
    required this.list,
    required this.setActive,
    required this.currentUrl,
    required this.size
  });

  final List<Frame>? list;
  final void Function(String) setActive;
  final String? currentUrl;
  final int size;

  @override
  State<FramesLister> createState() => _FramesListerState();
}

class _FramesListerState extends State<FramesLister> {
  late double _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.size.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list == null) {
      return const Column();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 80),
          child: Slider(
            value: _selectedIndex,
            min: 0,
            max: ((widget.list?.length ?? 1) - 1).toDouble(),
            divisions: (widget.list?.length ?? 1) - 1,
            label: widget.list![_selectedIndex.toInt()].label,
            onChanged: (newValue) {
              setState(() {
                _selectedIndex = newValue;
                widget.setActive(widget.list![newValue.toInt()].url);
              });
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CircularCheckbox extends StatefulWidget {
  const CircularCheckbox({
    super.key,
    this.isChecked = false,
    this.size,
  });

  final bool isChecked;
  final double? size;

  @override
  CircularCheckboxState createState() => CircularCheckboxState();
}

class CircularCheckboxState extends State<CircularCheckbox> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: _isChecked
          ? Icon(
        Icons.check_circle,
        size: widget.size ?? 25.0,
        color: Colors.orange,
      )
          : Icon(
        Icons.circle_outlined,
        size: widget.size ?? 25.0,
        color: const Color(0xffE5E7EB),
      ),
    );
  }
}
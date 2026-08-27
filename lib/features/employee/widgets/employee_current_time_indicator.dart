import 'package:flutter/material.dart';

class EmployeeCurrentTimeIndicator extends StatelessWidget {
  const EmployeeCurrentTimeIndicator({
    super.key,
    required this.hourHeight,
  });

  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final top =
        ((now.hour * 60) + now.minute) *
            hourHeight /
            60;

    return Positioned(
      top: top,
      left: 58,
      right: 0,
      child: IgnorePointer(
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Container(
                height: 2,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
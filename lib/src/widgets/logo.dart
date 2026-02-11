import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.timeline,
              weight: 10,
              fontWeight: FontWeight.w900,
              size: 12,
            ),
          ),
          Icon(Icons.directions_run, size: 40),
        ],
      ),
    );
  }
}

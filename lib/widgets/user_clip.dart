import 'package:flutter/material.dart';

class UserIconClip extends StatelessWidget {
  final String iconpath;
  const UserIconClip({super.key, required this.iconpath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(180),
      child: Image.asset(
        iconpath,
      ),
    );
  }
}

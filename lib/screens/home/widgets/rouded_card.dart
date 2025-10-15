import 'package:flutter/material.dart';

class RoundedAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final VoidCallback? onTap;

  const RoundedAvatar({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: size / 2,
      backgroundImage: NetworkImage(imageUrl),
      backgroundColor: Colors.grey.shade200,
    );
    return GestureDetector(
      onTap: onTap,
      child: avatar,
    );
  }
}
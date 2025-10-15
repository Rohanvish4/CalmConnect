import 'package:calm_connect/model/tip.dart';
import 'package:flutter/material.dart';

class TipCard extends StatelessWidget {
  final Tip tip;
  final Color? background;
  const TipCard({super.key, required this.tip, this.background});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background ?? scheme.primaryContainer.withOpacity(.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.wb_sunny_outlined,
              color: scheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip.message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

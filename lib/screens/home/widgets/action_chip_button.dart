import 'package:flutter/material.dart';

class ActionChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  const ActionChipButton({
    super.key,
    required this.icon,
    required this.label,
    this.filled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = filled ? scheme.primaryContainer.withOpacity(.5) : scheme.surface;
    final border = BorderSide(color: scheme.primary.withOpacity(.15));
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
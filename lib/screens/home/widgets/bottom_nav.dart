import 'package:flutter/material.dart';

class CalmBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CalmBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        height: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: currentIndex == 0 ? scheme.primary : scheme.onSurface.withOpacity(0.6),
            ),
            selectedIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.home, color: scheme.primary),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.psychology_outlined, // Brain/psychology icon
              color: currentIndex == 1 ? scheme.primary : scheme.onSurface.withOpacity(0.6),
            ),
            selectedIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.psychology, color: scheme.primary),
            ),
            label: 'Resources',
          ),
          NavigationDestination(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: currentIndex == 2 ? scheme.primary : scheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.support_agent_outlined,
                color: currentIndex == 2 ? Colors.white : scheme.primary,
              ),
            ),
            selectedIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.support_agent, color: Colors.white),
            ),
            label: 'Support',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.people_outline,
              color: currentIndex == 3 ? scheme.primary : scheme.onSurface.withOpacity(0.6),
            ),
            selectedIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.people, color: scheme.primary),
            ),
            label: 'Peers',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.self_improvement_outlined, // Better icon for self-care
              color: currentIndex == 4 ? scheme.primary : scheme.onSurface.withOpacity(0.6),
            ),
            selectedIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.self_improvement, color: scheme.primary),
            ),
            label: 'Self-care',
          ),
        ],
      ),
    );
  }
}
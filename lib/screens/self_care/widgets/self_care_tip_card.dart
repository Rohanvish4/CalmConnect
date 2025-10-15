import 'package:calm_connect/model/tip.dart';
import 'package:calm_connect/screens/self_care/controller/self_care_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelfCareTipCard extends StatelessWidget {
  final Tip tip;
  final VoidCallback? onTap;

  const SelfCareTipCard({
    super.key,
    required this.tip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<SelfCareController>();
    final isLiked = controller.isLikedByCurrentUser(tip);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: scheme.outline.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with type and author info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(scheme).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tip.typeIcon,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tip.type.toString().split('.').last.capitalize!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getTypeColor(scheme),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTimeAgo(tip.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  // Add delete button for counselor's own tips
                  if (controller.canDeleteTip(tip)) ...[
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        size: 18,
                        color: scheme.onSurface.withOpacity(0.6),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteDialog(context, controller);
                        }
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                tip.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),

              // Content
              Text(
                tip.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Tags
              if (tip.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: tip.tags.map<Widget>((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#$tag',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Footer with author and like button
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: scheme.primaryContainer,
                    child: Text(
                      tip.authorName.isNotEmpty ? tip.authorName[0].toUpperCase() : 'A',
                      style: TextStyle(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.authorName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                        Text(
                          'Professional Counselor',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Like button
                  GetBuilder<SelfCareController>(
                    builder: (controller) => InkWell(
                      onTap: () => controller.likeTip(tip.id),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: isLiked ? Colors.red : scheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tip.likes.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: scheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(ColorScheme scheme) {
    switch (tip.type) {
      case TipType.tip:
        return scheme.primary;
      case TipType.resource:
        return Colors.blue;
      case TipType.quote:
        return Colors.purple;
      case TipType.awareness:
        return Colors.teal;
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showDeleteDialog(BuildContext context, SelfCareController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tip'),
        content: Text(
          'Are you sure you want to delete "${tip.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.deleteTip(tip.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../model/professional_resource.dart';

class ResourceCard extends StatelessWidget {
  final ProfessionalResource resource;
  final VoidCallback? onTap;

  const ResourceCard({super.key, required this.resource, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        width: 190,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: scheme.outlineVariant.withOpacity(.4)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(resource.imageUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    resource.role,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: scheme.primary),
                      const SizedBox(width: 2),
                      Text(
                        resource.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' (${resource.reviews})',
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurface.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

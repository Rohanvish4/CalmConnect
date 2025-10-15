import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/enhanced_professional_resource.dart';

class EnhancedResourceCard extends StatelessWidget {
  final EnhancedProfessionalResource resource;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;

  const EnhancedResourceCard({
    super.key,
    required this.resource,
    this.onTap,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

  Future<void> _makePhoneCall(String phoneNumber, BuildContext context) async {
    try {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber.replaceAll(RegExp(r'[^\d+]'), ''),
      );
      
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showErrorSnackBar('Cannot make phone call. Please check if phone app is available.', context);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to make phone call: ${e.toString()}', context);
    }
  }

  Future<void> _launchUrl(String url, BuildContext context) async {
    try {
      // Ensure the URL has a proper scheme
      Uri uri;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        uri = Uri.parse('https://$url');
      } else {
        uri = Uri.parse(url);
      }
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri, 
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showErrorSnackBar('Cannot open website. Please check your internet connection.', context);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to open website: ${e.toString()}', context);
    }
  }
  
  void _showErrorSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with image, basic info, and favorite
              Row(
                children: [
                  // Profile image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      resource.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.person,
                            color: scheme.primary,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Name and basic info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              resource.type.emoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                resource.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${resource.title} • ${resource.type.displayName}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber.shade600,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${resource.rating}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              ' (${resource.reviews})',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (resource.isAvailable) ...[
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Available',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Busy',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Colors.orange.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Favorite button
                  IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Bio/Description
              Text(
                resource.bio,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Specializations chips
              if (resource.specializations.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: resource.specializations.take(3).map((spec) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        spec,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
              
              // Service details row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Service mode
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(resource.serviceMode.emoji, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          resource.serviceMode.displayName,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Price
                    if (resource.priceRange != null) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 14,
                            color: scheme.onSurfaceVariant,
                          ),
                          Text(
                            resource.priceRange == 0 
                                ? 'Free' 
                                : '\$${resource.priceRange!.toInt()}',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                    ],
                    
                    // Experience
                    Text(
                      '${resource.yearsExperience} years exp.',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Action buttons
              Row(
                children: [
                  // Call button
                  if (resource.phone != null) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _makePhoneCall(resource.phone!, context),
                        icon: const Icon(Icons.phone, size: 18),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  
                  // Book/Website button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (resource.bookingUrl != null) {
                          _launchUrl(resource.bookingUrl!, context);
                        } else if (resource.website != null) {
                          _launchUrl(resource.website!, context);
                        }
                      },
                      icon: Icon(
                        resource.bookingUrl != null ? Icons.calendar_today : Icons.language,
                        size: 18,
                      ),
                      label: Text(resource.bookingUrl != null ? 'Book' : 'Website'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Next availability
              if (resource.nextAvailability != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Next: ${resource.nextAvailability}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
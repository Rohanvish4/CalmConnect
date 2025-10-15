import 'package:flutter/material.dart';
import '../../../model/user_model.dart';

class FeaturedCounsellorCard extends StatelessWidget {
  final UserModel counsellor;
  final VoidCallback? onTap;
  final VoidCallback? onBookConsultation;

  const FeaturedCounsellorCard({
    super.key,
    required this.counsellor,
    this.onTap,
    this.onBookConsultation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with avatar and rating
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        counsellor.name.isNotEmpty ? counsellor.name[0].toUpperCase() : 'C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (counsellor.rating > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 12, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              counsellor.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Name
                Text(
                  counsellor.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                
                // Specialization and experience in single line
                Row(
                  children: [
                    if (counsellor.specialization.isNotEmpty) ...[
                      Expanded(
                        child: Text(
                          counsellor.specialization,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    if (counsellor.specialization.isNotEmpty && counsellor.experienceYears > 0) 
                      Text(
                        ' • ${counsellor.experienceYears}y',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (counsellor.specialization.isEmpty && counsellor.experienceYears > 0)
                      Text(
                        '${counsellor.experienceYears}+ years exp',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
                
                // Online status
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: counsellor.isOnline ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      counsellor.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 10,
                        color: counsellor.isOnline ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
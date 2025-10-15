import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../model/user_model.dart';
import '../../routes/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: GetBuilder<AuthController>(
        builder: (authController) {
          final user = authController.currentUserModel;
          final firebaseUser = authController.currentUser;
          
          if (user == null || firebaseUser == null) {
            return const Center(
              child: Text('User not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // User Info Cards
                _buildInfoCard(
                  context,
                  icon: Icons.person,
                  title: 'Name',
                  value: user.name,
                ),
                const SizedBox(height: 12),
                
                _buildInfoCard(
                  context,
                  icon: Icons.email,
                  title: 'Email',
                  value: user.email,
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  context,
                  icon: user.userType == UserType.peer 
                      ? Icons.people 
                      : Icons.psychology,
                  title: 'Account Type',
                  value: user.userType == UserType.peer ? 'Peer' : 'Counsellor',
                ),
                const SizedBox(height: 12),

                _buildInfoCard(
                  context,
                  icon: Icons.circle,
                  title: 'Status',
                  value: user.isOnline ? 'Online' : 'Offline',
                  valueColor: user.isOnline ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 12),

                if (user.bio.isNotEmpty)
                  _buildInfoCard(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    value: user.bio,
                  ),
                
                if (user.occupation.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    icon: Icons.work_outline,
                    title: 'Occupation',
                    value: user.occupation,
                  ),
                ],

                if (user.userType == UserType.counsellor) ...[
                  if (user.specialization.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      context,
                      icon: Icons.psychology_outlined,
                      title: 'Specialization',
                      value: user.specialization,
                    ),
                  ],
                  if (user.experienceYears > 0) ...[
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      context,
                      icon: Icons.schedule,
                      title: 'Experience',
                      value: '${user.experienceYears} years',
                    ),
                  ],
                  if (user.qualifications.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      context,
                      icon: Icons.school_outlined,
                      title: 'Qualifications',
                      value: user.qualifications,
                    ),
                  ],
                  if (user.rating > 0) ...[
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      context,
                      icon: Icons.star_outline,
                      title: 'Rating',
                      value: '${user.rating.toStringAsFixed(1)}/5.0 (${user.consultationCount} consultations)',
                      valueColor: Colors.amber[700],
                    ),
                  ],
                ],
                const SizedBox(height: 32),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(Routes.usersListView),
                    icon: const Icon(Icons.chat),
                    label: const Text('Start Chatting'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final authController = Get.find<AuthController>();
              await authController.signOut();
              Get.offAllNamed(Routes.authView);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
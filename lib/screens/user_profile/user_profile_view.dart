import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../routes/routes.dart';
import '../../service/firebase_service.dart';

class UserProfileView extends StatelessWidget {
  final String userUID;

  const UserProfileView({super.key, required this.userUID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: FutureBuilder<UserModel?>(
        future: FirebaseService.getUserById(userUID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('User not found'),
            );
          }

          final user = snapshot.data!;
          return _buildUserProfile(context, user);
        },
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, UserModel user) {
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
                style: const TextStyle(
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
            icon: user.userType == UserType.counsellor ? Icons.psychology : Icons.people,
            title: 'Type',
            value: user.userType == UserType.counsellor ? 'Counsellor' : 'Peer',
            valueColor: user.userType == UserType.counsellor ? Colors.blue[700] : null,
          ),
          const SizedBox(height: 12),

          if (user.occupation.isNotEmpty)
            Column(
              children: [
                _buildInfoCard(
                  context,
                  icon: Icons.work,
                  title: 'Occupation',
                  value: user.occupation,
                ),
                const SizedBox(height: 12),
              ],
            ),

          if (user.userType == UserType.counsellor) ...[
            if (user.specialization.isNotEmpty)
              Column(
                children: [
                  _buildInfoCard(
                    context,
                    icon: Icons.medical_services,
                    title: 'Specialization',
                    value: user.specialization,
                    valueColor: Colors.blue[700],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            _buildInfoCard(
              context,
              icon: Icons.school,
              title: 'Experience',
              value: '${user.experienceYears} years',
              valueColor: Colors.green[700],
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              icon: Icons.star,
              title: 'Rating',
              value: '${user.rating.toStringAsFixed(1)}/5.0 (${user.consultationCount} consultations)',
              valueColor: Colors.amber[700],
            ),
          ],

          // Online Status
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                size: 16,
                color: user.isOnline ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                user.isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  color: user.isOnline ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.chatView,
                  arguments: {'otherUserUID': user.userUID},
                );
              },
              icon: const Icon(Icons.chat),
              label: const Text('Start Chatting'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
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
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: valueColor,
                          fontWeight: FontWeight.w500,
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
}
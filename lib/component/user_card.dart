import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../routes/routes.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final VoidCallback? onChatTap;
  final bool isHorizontal;
  final bool showChatButton;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.onChatTap,
    this.isHorizontal = false,
    this.showChatButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontalCard(context);
    } else {
      return _buildVerticalCard(context);
    }
  }

  Widget _buildHorizontalCard(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap ?? () => _navigateToProfile(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 8),
                _buildName(context),
                const SizedBox(height: 3),
                _buildSpecializationAndExperience(context),
                const SizedBox(height: 4),
                _buildOnlineStatus(context),
                if (showChatButton) ...[
                  const SizedBox(height: 8),
                  _buildChatButton(context, isCompact: true),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildAvatar(context),
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(user.userType == UserType.peer ? 'Peer' : 'Counsellor'),
                if (user.userType == UserType.counsellor && user.rating > 0) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(' ${user.rating.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 12)),
                ],
              ],
            ),
            if (user.occupation.isNotEmpty)
              Text(user.occupation, 
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            if (user.userType == UserType.counsellor && user.specialization.isNotEmpty)
              Text('${user.specialization} • ${user.experienceYears}y exp',
                  style: TextStyle(fontSize: 12, color: Colors.blue[700])),
            _buildOnlineStatus(context),
          ],
        ),
        trailing: showChatButton ? _buildChatButton(context) : null,
        onTap: onTap ?? () => _navigateToProfile(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(context, radius: 18),
        const Spacer(),
        if (user.userType == UserType.counsellor && user.rating > 0)
          _buildRatingBadge(context),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, {double radius = 20}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }

  Widget _buildRatingBadge(BuildContext context) {
    return Container(
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
            user.rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return Text(
      user.name,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSpecializationAndExperience(BuildContext context) {
    return Row(
      children: [
        if (user.specialization.isNotEmpty) ...[
          Expanded(
            child: Text(
              user.specialization,
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
        if (user.specialization.isNotEmpty && user.experienceYears > 0) 
          Text(
            ' • ${user.experienceYears}y',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        if (user.specialization.isEmpty && user.experienceYears > 0)
          Text(
            '${user.experienceYears}+ years exp',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }

  Widget _buildOnlineStatus(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 8,
          color: user.isOnline ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          user.isOnline ? 'Online' : 'Offline',
          style: TextStyle(
            fontSize: 10,
            color: user.isOnline ? Colors.green : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildChatButton(BuildContext context, {bool isCompact = false}) {
    if (isCompact) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onChatTap ?? () => _navigateToChat(context),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 30),
            textStyle: const TextStyle(fontSize: 11),
            padding: const EdgeInsets.symmetric(vertical: 6),
          ),
          child: const Text('Start Chat'),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onChatTap ?? () => _navigateToChat(context),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(60, 36),
        ),
        child: const Text('Chat'),
      );
    }
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.userProfileView,
      arguments: {'userUID': user.userUID},
    );
  }

  void _navigateToChat(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.chatView,
      arguments: {'otherUserUID': user.userUID},
    );
  }
}
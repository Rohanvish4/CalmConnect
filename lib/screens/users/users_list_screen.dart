import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/user_card.dart';
import '../../controller/auth_controller.dart';
import '../../model/user_model.dart';
import '../../routes/routes.dart';
import '../../service/firebase_service.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<UserModel> _users = [];
  bool _isLoading = true;
  UserType _filterType = UserType.peer;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final users = await FirebaseService.getUsersList();
    final authController = Get.find<AuthController>();
    
    setState(() {
      // Exclude current user from list
      _users = users.where((user) => 
          user.userUID != authController.currentUser?.uid).toList();
      _isLoading = false;
    });
  }

  List<UserModel> get filteredUsers {
    return _users.where((user) => user.userType == _filterType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // Ensure proper navigation back to the previous screen
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connect with Others'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, Routes.profileView),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _filterType = UserType.peer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _filterType == UserType.peer 
                          ? Theme.of(context).colorScheme.primary 
                          : Theme.of(context).colorScheme.surfaceVariant,
                      foregroundColor: _filterType == UserType.peer 
                          ? Colors.white 
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    child: const Text('Peers'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _filterType = UserType.counsellor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _filterType == UserType.counsellor 
                          ? Theme.of(context).colorScheme.primary 
                          : Theme.of(context).colorScheme.surfaceVariant,
                      foregroundColor: _filterType == UserType.counsellor 
                          ? Colors.white 
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    child: const Text('Counsellors'),
                  ),
                ),
              ],
            ),
          ),
          
          // Users List
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : filteredUsers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _filterType == UserType.peer 
                                  ? Icons.people_outline 
                                  : Icons.psychology_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No ${_filterType == UserType.peer ? 'peers' : 'counsellors'} available',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return UserCard(
                            user: user,
                            isHorizontal: false,
                            showChatButton: true,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "users_refresh_fab",
        onPressed: _loadUsers,
        child: const Icon(Icons.refresh),
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
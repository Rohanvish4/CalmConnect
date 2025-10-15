import 'package:calm_connect/component/calm_connect_logo.dart';
import 'package:calm_connect/controller/auth_controller.dart';
import 'package:calm_connect/model/user_model.dart';
import 'package:calm_connect/routes/routes.dart';
import 'package:calm_connect/screens/home/widgets/bottom_nav.dart';
import 'package:calm_connect/screens/home/widgets/category_card.dart';
import 'package:calm_connect/screens/home/widgets/rouded_card.dart';
import 'package:calm_connect/screens/home/widgets/section_header.dart';
import 'package:calm_connect/component/user_card.dart';
import 'package:calm_connect/shared/animated_navigation.dart';
import 'package:calm_connect/screens/self_care/controller/self_care_controller.dart';
import 'package:flutter/services.dart';
import 'package:calm_connect/screens/self_care/widgets/self_care_tip_card.dart';
import 'package:calm_connect/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onNavTap(int i) {
    if (_navIndex == i) return;
    
    HapticFeedback.lightImpact();
    setState(() => _navIndex = i);
    
    switch (i) {
      case 1:
        Navigator.pushNamed(context, Routes.resourcesView);
        break;
      case 2:
        Navigator.pushNamed(context, Routes.supportView);
        break;
      case 3:
        Navigator.pushNamed(context, Routes.usersListView);
        break;
      case 4:
        Navigator.pushNamed(context, Routes.selfCareView);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: const SizedBox(height: 8)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore Features',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose what you need support with',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCategoryGrid(context),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 32)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Featured Counsellors',
                  actionText: 'View All',
                  onAction: () {
                    Navigator.pushNamed(context, Routes.usersListView);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: FutureBuilder<List<UserModel>>(
                future: FirebaseService.getUsersList(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(
                      height: 135,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  final featuredCounsellors = snapshot.data!
                      .where((user) => user.isFeatured)
                      .take(5)
                      .toList();
                  
                  if (featuredCounsellors.isEmpty) {
                    return const SizedBox(
                      height: 135,
                      child: Center(
                        child: Text('No featured counsellors available'),
                      ),
                    );
                  }
                  
                  return Container(
                    height: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredCounsellors.length,
                      itemBuilder: (context, i) {
                        final counsellor = featuredCounsellors[i];
                        return Container(
                          margin: EdgeInsets.only(right: i < featuredCounsellors.length - 1 ? 16 : 0),
                          child: UserCard(
                            user: counsellor,
                            isHorizontal: true,
                            showChatButton: false,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 32)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: "Today's Tips",
                      actionText: 'See all',
                      onAction: () {
                        Navigator.pushNamed(context, Routes.selfCareView);
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Daily wisdom and mindfulness practices',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: GetBuilder<SelfCareController>(
                builder: (selfCareController) {
                  if (selfCareController.isLoading) {
                    return const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (selfCareController.tips.isEmpty) {
                    return SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          'No tips available yet',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    );
                  }
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: selfCareController.tips.take(2).map((tip) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: SelfCareTipCard(
                            tip: tip,
                            onTap: () => _showTipDetail(tip, selfCareController),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),


            SliverToBoxAdapter(child: const SizedBox(height: 32)),
          ],
        ),
      ),
      bottomNavigationBar: CalmBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      const CalmConnectLogo(
                        size: 32,
                        showBackground: false,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CalmConnect',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: RoundedAvatar(
                    imageUrl: 'https://icons.veryicon.com/png/o/miscellaneous/standard/avatar-15.png',
                    onTap: () => Navigator.pushNamed(context, Routes.profileView),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GetBuilder<AuthController>(
              builder: (authController) {
                final user = authController.currentUserModel;
                final timeOfDay = DateTime.now().hour;
                String greeting = 'Good morning';
                if (timeOfDay >= 12 && timeOfDay < 17) {
                  greeting = 'Good afternoon';
                } else if (timeOfDay >= 17) {
                  greeting = 'Good evening';
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, ${user?.name.split(' ').first ?? 'User'}! 👋',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'How are you feeling today?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildCategoryGrid(BuildContext context) {
    final items = [
      _CategoryData(
        Icons.favorite_outline,
        'Self-care',
        'Daily tools for mindfulness and wellbeing.',
        Routes.selfCareView,
      ),
      _CategoryData(
        Icons.support_agent_outlined,
        'Peer Support',
        'Connect with others via chats and forums.',
        Routes.usersListView,
      ),
      _CategoryData(
        Icons.menu_book_outlined,
        'Resources',
        'Find professionals and organizations.',
        Routes.resourcesView,
      ),
      _CategoryData(
        Icons.lightbulb_outline,
        'Daily Tip',
        'Gentle reminders to take care of you.',
        Routes.selfCareView,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final crossAxisCount = isWide ? 4 : 2;
        final spacing = 16.0;
        final width = (constraints.maxWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;
        
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items
              .map<Widget>(
                (e) => SizedBox(
                  width: width,
                  child: AnimatedTapButton(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pushNamed(context, e.route!);
                    },
                    child: CategoryCard(
                      icon: e.icon,
                      title: e.title,
                      description: e.desc,
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        final user = authController.currentUserModel;
        
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? 'User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      user?.userType.name == 'peer' ? 'Peer' : 'Counsellor',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.psychology),
                title: const Text('Professional Resources'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.resourcesView);
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Support Chat'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.supportView);
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Connect with Others'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.usersListView);
                },
              ),
              ListTile(
                leading: const Icon(Icons.self_improvement),
                title: const Text('Self Care'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.selfCareView);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.profileView);
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        );
      },
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
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close drawer
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

  void _showTipDetail(tip, selfCareController) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      tip.typeIcon,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip.typeDisplayName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  tip.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  tip.message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
                if (tip.tags.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: tip.tags.map<Widget>((tag) {
                      return Chip(
                        label: Text('#$tag'),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      child: Text(tip.authorName[0].toUpperCase()),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip.authorName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Professional Counselor',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${tip.likes} likes',
                      style: Theme.of(context).textTheme.bodySmall,
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

class _CategoryData {
  final IconData icon;
  final String title;
  final String desc;
  final String? route;

  _CategoryData(this.icon, this.title, this.desc, [this.route]);
}

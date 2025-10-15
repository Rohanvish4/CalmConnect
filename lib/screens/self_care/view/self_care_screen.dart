import 'package:calm_connect/model/tip.dart';
import 'package:calm_connect/screens/self_care/controller/self_care_controller.dart';
import 'package:calm_connect/screens/self_care/widgets/post_tip_bottom_sheet.dart';
import 'package:calm_connect/screens/self_care/widgets/self_care_tip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelfCareScreen extends StatefulWidget {
  const SelfCareScreen({super.key});

  @override
  State<SelfCareScreen> createState() => _SelfCareScreenState();
}

class _SelfCareScreenState extends State<SelfCareScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showPostBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PostTipBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return GetBuilder<SelfCareController>(
      builder: (controller) => Scaffold(
        backgroundColor: scheme.surface,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 160,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: scheme.surface,
                foregroundColor: scheme.onSurface,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          scheme.primaryContainer.withOpacity(0.3),
                          scheme.secondaryContainer.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🌱 Self-Care Hub',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: scheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    controller.canPost
                                        ? 'Share your wisdom • Help others grow'
                                        : 'Professional insights • Evidence-based tips',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: scheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (controller.canPost) ...[
                              const SizedBox(width: 12),
                              FloatingActionButton.small(
                                heroTag: "self_care_add_fab",
                                onPressed: _showPostBottomSheet,
                                backgroundColor: scheme.primary,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: scheme.surface,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: scheme.primary,
                    unselectedLabelColor: scheme.onSurface.withOpacity(0.6),
                    indicatorColor: scheme.primary,
                    indicatorWeight: 2,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    onTap: (index) {
                      final filterTypes = [
                        null, // All
                        TipType.tip,
                        TipType.resource,
                        TipType.quote,
                        TipType.awareness,
                      ];
                      controller.setFilter(filterTypes[index]);
                    },
                    tabs: const [
                      Tab(text: '✨ All'),
                      Tab(text: '💡 Tips'),
                      Tab(text: '📚 Resources'),
                      Tab(text: '💭 Quotes'),
                      Tab(text: '🧠 Awareness'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: List.generate(5, (index) => _buildContentList(controller)),
            ),
          ),
        ),
        floatingActionButton: controller.canPost
            ? FloatingActionButton.extended(
                heroTag: "self_care_post_fab",
                onPressed: _showPostBottomSheet,
                backgroundColor: scheme.primary,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.edit),
                label: const Text(
                  'Share Wisdom',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildContentList(SelfCareController controller) {
    if (controller.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading inspiring content...'),
          ],
        ),
      );
    }

    if (controller.tips.isEmpty) {
      return _buildEmptyState(controller);
    }

    return RefreshIndicator(
      onRefresh: () async => controller.refreshTips(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: controller.tips.length,
        itemBuilder: (context, index) {
          final tip = controller.tips[index];
          return SelfCareTipCard(
            tip: tip,
            onTap: () => _showTipDetail(tip),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(SelfCareController controller) {
    final scheme = Theme.of(context).colorScheme;
    final filterText = _getFilterEmptyMessage(controller.selectedFilter);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getFilterIcon(controller.selectedFilter),
                size: 48,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              filterText['title']!,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              filterText['subtitle']!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: scheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (controller.canPost) ...[
              ElevatedButton.icon(
                onPressed: _showPostBottomSheet,
                icon: const Icon(Icons.add),
                label: const Text('Be the First to Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ] else ...[
              TextButton(
                onPressed: controller.refreshTips,
                child: const Text('Refresh'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, String> _getFilterEmptyMessage(TipType? filter) {
    switch (filter) {
      case TipType.tip:
        return {
          'title': 'No Tips Yet',
          'subtitle': 'Be the first to share mental health tips with the community',
        };
      case TipType.resource:
        return {
          'title': 'No Resources Yet',
          'subtitle': 'Share helpful mental health resources and tools',
        };
      case TipType.quote:
        return {
          'title': 'No Quotes Yet',
          'subtitle': 'Share inspirational quotes to motivate others',
        };
      case TipType.awareness:
        return {
          'title': 'No Awareness Content Yet',
          'subtitle': 'Share important mental health awareness information',
        };
      default:
        return {
          'title': 'No Content Yet',
          'subtitle': 'Professional counselors will share valuable insights here',
        };
    }
  }

  IconData _getFilterIcon(TipType? filter) {
    switch (filter) {
      case TipType.tip:
        return Icons.lightbulb_outline;
      case TipType.resource:
        return Icons.book_outlined;
      case TipType.quote:
        return Icons.format_quote;
      case TipType.awareness:
        return Icons.psychology_outlined;
      default:
        return Icons.favorite_outline;
    }
  }

  void _showTipDetail(Tip tip) {
    final controller = Get.find<SelfCareController>();
    
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
                    // Add delete button for counselor's own tips
                    if (controller.canDeleteTip(tip))
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showDeleteDialog(context, tip, controller);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete tip',
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
                    children: tip.tags.map((tag) {
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

  void _showDeleteDialog(BuildContext context, Tip tip, SelfCareController controller) {
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
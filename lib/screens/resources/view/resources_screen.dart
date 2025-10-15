import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/resources_controller.dart';
import '../widgets/enhanced_resource_card.dart';
import '../widgets/resource_filter_bottom_sheet.dart';
import '../../../model/enhanced_professional_resource.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    final controller = Get.find<ResourcesController>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: ResourceFilterBottomSheet(
          initialFilter: controller.activeFilter,
          onApplyFilter: controller.updateFilter,
        ),
      ),
    );
  }

  void _showSortOptions() {
    final controller = Get.find<ResourcesController>();
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              'Sort By',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...SortOption.values.map((option) {
              return ListTile(
                leading: Icon(_getSortIcon(option)),
                title: Text(_getSortLabel(option)),
                trailing: controller.sortOption == option 
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  controller.updateSort(option);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  IconData _getSortIcon(SortOption option) {
    switch (option) {
      case SortOption.rating:
        return Icons.star;
      case SortOption.distance:
        return Icons.location_on;
      case SortOption.price:
        return Icons.attach_money;
      case SortOption.availability:
        return Icons.schedule;
      case SortOption.experience:
        return Icons.school;
    }
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.rating:
        return 'Highest Rating';
      case SortOption.distance:
        return 'Nearest';
      case SortOption.price:
        return 'Lowest Price';
      case SortOption.availability:
        return 'Available First';
      case SortOption.experience:
        return 'Most Experience';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return GetBuilder<ResourcesController>(
      builder: (controller) => Scaffold(
        backgroundColor: scheme.surface,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
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
                          scheme.primaryContainer.withValues(alpha: 0.3),
                          scheme.secondaryContainer.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '🏥 Professional Resources',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Find licensed mental health professionals',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Search and Filter Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Search bar
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by name, specialty, or location...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty 
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    controller.updateSearchQuery('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        ),
                        onChanged: controller.updateSearchQuery,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Filter and Sort buttons
                      Row(
                        children: [
                          // Results count
                          Expanded(
                            child: Text(
                              '${controller.resources.length} professionals found',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          
                          // Filter button
                          OutlinedButton.icon(
                            onPressed: _showFilterBottomSheet,
                            icon: const Icon(Icons.filter_list),
                            label: const Text('Filter'),
                          ),
                          
                          const SizedBox(width: 8),
                          
                          // Sort button
                          OutlinedButton.icon(
                            onPressed: _showSortOptions,
                            icon: const Icon(Icons.sort),
                            label: const Text('Sort'),
                          ),
                        ],
                      ),
                      
                      // Active filters display
                      if (_hasActiveFilters(controller.activeFilter)) ...[
                        const SizedBox(height: 12),
                        _buildActiveFilters(controller),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Professional Type Quick Filters
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: ProfessionalType.values.length,
                    itemBuilder: (context, index) {
                      final type = ProfessionalType.values[index];
                      final isSelected = controller.activeFilter.type == type;
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text('${type.emoji} ${type.displayName}'),
                          selected: isSelected,
                          onSelected: (selected) {
                            controller.updateFilter(
                              controller.activeFilter.copyWith(
                                type: selected ? type : null,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              
              // Resources List
              if (controller.isLoading) ...[
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ] else if (controller.resources.isEmpty) ...[
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No professionals found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filters',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.clearFilters,
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                SliverList.builder(
                  itemCount: controller.resources.length,
                  itemBuilder: (context, index) {
                    final resource = controller.resources[index];
                    return EnhancedResourceCard(
                      resource: resource,
                      isFavorite: controller.isFavorite(resource.id),
                      onFavoriteToggle: () => controller.toggleFavorite(resource.id),
                      onTap: () => _showResourceDetail(resource),
                    );
                  },
                ),
              ],
              
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasActiveFilters(ResourceFilter filter) {
    return filter.type != null ||
        (filter.insurance != null && filter.insurance!.isNotEmpty) ||
        (filter.therapyTypes != null && filter.therapyTypes!.isNotEmpty) ||
        (filter.languages != null && filter.languages!.isNotEmpty) ||
        filter.serviceMode != null ||
        filter.maxPrice != null ||
        (filter.availableOnly == true);
  }

  Widget _buildActiveFilters(ResourcesController controller) {
    final filters = <Widget>[];

    if (controller.activeFilter.type != null) {
      filters.add(_buildFilterChip(
        '${controller.activeFilter.type!.emoji} ${controller.activeFilter.type!.displayName}',
        () => controller.updateFilter(controller.activeFilter.copyWith(type: null)),
      ));
    }

    if (controller.activeFilter.availableOnly == true) {
      filters.add(_buildFilterChip(
        'Available Now',
        () => controller.updateFilter(controller.activeFilter.copyWith(availableOnly: false)),
      ));
    }

    if (filters.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...filters,
        if (filters.length > 1)
          TextButton.icon(
            onPressed: controller.clearFilters,
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear All'),
          ),
      ],
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDelete) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDelete,
    );
  }

  void _showResourceDetail(EnhancedProfessionalResource resource) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ResourceDetailSheet(resource: resource),
    );
  }
}

class _ResourceDetailSheet extends StatelessWidget {
  final EnhancedProfessionalResource resource;

  const _ResourceDetailSheet({required this.resource});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: scheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with photo and basic info
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          resource.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              resource.name,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${resource.title} • ${resource.type.displayName}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, size: 20, color: Colors.amber.shade600),
                                const SizedBox(width: 4),
                                Text('${resource.rating} (${resource.reviews} reviews)'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bio
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    resource.bio,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Specializations
                  if (resource.specializations.isNotEmpty) ...[
                    Text(
                      'Specializations',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: resource.specializations.map((spec) {
                        return Chip(label: Text(spec));
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Credentials
                  Text(
                    'Credentials & Experience',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...resource.credentials.map((credential) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.verified, size: 16, color: scheme.primary),
                          const SizedBox(width: 8),
                          Text(credential),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Text('${resource.yearsExperience} years of experience'),
                  
                  const SizedBox(height: 24),
                  
                  // Contact & Location info
                  if (resource.location != null) ...[
                    Text(
                      'Location',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: scheme.primary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(resource.location!.fullAddress)),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
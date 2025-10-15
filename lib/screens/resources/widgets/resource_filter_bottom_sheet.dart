import 'package:flutter/material.dart';
import '../../../model/enhanced_professional_resource.dart';
import '../controller/resources_controller.dart';

class ResourceFilterBottomSheet extends StatefulWidget {
  final ResourceFilter initialFilter;
  final Function(ResourceFilter) onApplyFilter;

  const ResourceFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApplyFilter,
  });

  @override
  State<ResourceFilterBottomSheet> createState() => _ResourceFilterBottomSheetState();
}

class _ResourceFilterBottomSheetState extends State<ResourceFilterBottomSheet> {
  late ResourceFilter _currentFilter;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Filter Resources',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentFilter = const ResourceFilter();
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Professional Type
                  _buildFilterSection(
                    title: 'Professional Type',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ProfessionalType.values.map((type) {
                        final isSelected = _currentFilter.type == type;
                        return FilterChip(
                          label: Text('${type.emoji} ${type.displayName}'),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _currentFilter = _currentFilter.copyWith(
                                type: selected ? type : null,
                              );
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Service Mode
                  _buildFilterSection(
                    title: 'Service Mode',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ServiceMode.values.map((mode) {
                        final isSelected = _currentFilter.serviceMode == mode;
                        return FilterChip(
                          label: Text('${mode.emoji} ${mode.displayName}'),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _currentFilter = _currentFilter.copyWith(
                                serviceMode: selected ? mode : null,
                              );
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Insurance
                  _buildFilterSection(
                    title: 'Insurance Accepted',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: InsuranceType.values.map((insurance) {
                        final isSelected = _currentFilter.insurance?.contains(insurance) ?? false;
                        return FilterChip(
                          label: Text(insurance.displayName),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              final currentInsurance = List<InsuranceType>.from(_currentFilter.insurance ?? []);
                              if (selected) {
                                currentInsurance.add(insurance);
                              } else {
                                currentInsurance.remove(insurance);
                              }
                              _currentFilter = _currentFilter.copyWith(
                                insurance: currentInsurance.isEmpty ? null : currentInsurance,
                              );
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Languages
                  _buildFilterSection(
                    title: 'Languages',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Language.values.map((language) {
                        final isSelected = _currentFilter.languages?.contains(language) ?? false;
                        return FilterChip(
                          label: Text(language.displayName),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              final currentLanguages = List<Language>.from(_currentFilter.languages ?? []);
                              if (selected) {
                                currentLanguages.add(language);
                              } else {
                                currentLanguages.remove(language);
                              }
                              _currentFilter = _currentFilter.copyWith(
                                languages: currentLanguages.isEmpty ? null : currentLanguages,
                              );
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Therapy Types
                  _buildFilterSection(
                    title: 'Therapy Types',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TherapyType.values.map((therapy) {
                        final isSelected = _currentFilter.therapyTypes?.contains(therapy) ?? false;
                        return FilterChip(
                          label: Text(_getTherapyTypeName(therapy)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              final currentTherapy = List<TherapyType>.from(_currentFilter.therapyTypes ?? []);
                              if (selected) {
                                currentTherapy.add(therapy);
                              } else {
                                currentTherapy.remove(therapy);
                              }
                              _currentFilter = _currentFilter.copyWith(
                                therapyTypes: currentTherapy.isEmpty ? null : currentTherapy,
                              );
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Price Range
                  _buildFilterSection(
                    title: 'Maximum Price per Session',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slider(
                          value: _currentFilter.maxPrice ?? 300.0,
                          min: 0,
                          max: 300,
                          divisions: 12,
                          label: _currentFilter.maxPrice == null 
                              ? 'Any' 
                              : '\$${_currentFilter.maxPrice!.toInt()}',
                          onChanged: (value) {
                            setState(() {
                              _currentFilter = _currentFilter.copyWith(maxPrice: value);
                            });
                          },
                        ),
                        Text(
                          'Up to \$${(_currentFilter.maxPrice ?? 300).toInt()} per session',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Availability
                  _buildFilterSection(
                    title: 'Availability',
                    child: CheckboxListTile(
                      title: const Text('Available Now'),
                      subtitle: const Text('Only show professionals with current availability'),
                      value: _currentFilter.availableOnly ?? false,
                      onChanged: (value) {
                        setState(() {
                          _currentFilter = _currentFilter.copyWith(availableOnly: value);
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Apply button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: scheme.outline.withValues(alpha: 0.2))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApplyFilter(_currentFilter);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  String _getTherapyTypeName(TherapyType type) {
    switch (type) {
      case TherapyType.cbt:
        return 'CBT';
      case TherapyType.dbt:
        return 'DBT';
      case TherapyType.emdr:
        return 'EMDR';
      case TherapyType.familyTherapy:
        return 'Family Therapy';
      case TherapyType.groupTherapy:
        return 'Group Therapy';
      case TherapyType.artTherapy:
        return 'Art Therapy';
      case TherapyType.mindfulness:
        return 'Mindfulness';
      case TherapyType.psychodynamic:
        return 'Psychodynamic';
      case TherapyType.humanistic:
        return 'Humanistic';
    }
  }
}
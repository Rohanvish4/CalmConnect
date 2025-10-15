import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
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
                        Colors.blue.shade50,
                        Colors.green.shade50,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '🆘 Crisis & Support',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Immediate help available 24/7 • You are not alone',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: 'Search support resources...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: scheme.surfaceContainerHighest.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            // Emergency Crisis Support (Priority Section)
            SliverToBoxAdapter(
              child: _buildEmergencySection(scheme),
            ),

            // 24/7 Helplines
            SliverToBoxAdapter(
              child: _buildHelplinesSection(scheme),
            ),

            // Professional Resources
            SliverToBoxAdapter(
              child: _buildProfessionalResourcesSection(scheme),
            ),

            // Peer Support & Community
            SliverToBoxAdapter(
              child: _buildPeerSupportSection(scheme),
            ),

            // Mental Health Organizations
            SliverToBoxAdapter(
              child: _buildOrganizationsSection(scheme),
            ),

            // Specialized Support
            SliverToBoxAdapter(
              child: _buildSpecializedSupportSection(scheme),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencySection(ColorScheme scheme) {
    if (_searchQuery.isNotEmpty && 
        !_containsSearchQuery(['emergency', 'crisis', 'suicide', 'urgent', '988'])) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emergency, color: Colors.red.shade700, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'EMERGENCY CRISIS SUPPORT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'If you are in immediate danger, call 911',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Crisis hotlines
          _buildEmergencyButton(
            '988 - Suicide & Crisis Lifeline',
            'Available 24/7 in English and Spanish',
            '988',
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildEmergencyButton(
            'Crisis Text Line',
            'Text HOME to 741741 - Free, 24/7 support',
            'sms:741741?body=HOME',
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildEmergencyButton(
            'NAMI HelpLine',
            'National Alliance on Mental Illness',
            '1-800-950-6264',
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildEmergencyButton(
            'SAMHSA National Helpline',
            'Substance Abuse & Mental Health Services',
            '1-800-662-4357',
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildHelplinesSection(ColorScheme scheme) {
    if (_searchQuery.isNotEmpty && 
        !_containsSearchQuery(['helpline', 'hotline', 'support', 'call'])) {
      return const SizedBox.shrink();
    }

    return _buildSupportSection(
      '📞 24/7 Helplines & Chat Support',
      Colors.blue,
      [
        SupportItem(
          title: 'Mental Health America',
          subtitle: 'Information and support',
          action: '1-800-969-6642',
          actionType: ActionType.phone,
        ),
        SupportItem(
          title: 'The Trevor Project (LGBTQ)',
          subtitle: '24/7 suicide prevention for LGBTQ youth',
          action: '1-866-488-7386',
          actionType: ActionType.phone,
        ),
        SupportItem(
          title: 'National Domestic Violence Hotline',
          subtitle: 'Confidential support for survivors',
          action: '1-800-799-7233',
          actionType: ActionType.phone,
        ),
        SupportItem(
          title: 'Veterans Crisis Line',
          subtitle: 'Support for veterans and families',
          action: '1-800-273-8255',
          actionType: ActionType.phone,
        ),
        SupportItem(
          title: 'Live Crisis Chat',
          subtitle: 'Chat with trained crisis counselors',
          action: 'https://suicidepreventionlifeline.org/chat/',
          actionType: ActionType.web,
        ),
      ],
    );
  }

  Widget _buildProfessionalResourcesSection(ColorScheme scheme) {
    if (_searchQuery.isNotEmpty && 
        !_containsSearchQuery(['therapist', 'professional', 'therapy', 'psychologist'])) {
      return const SizedBox.shrink();
    }

    return _buildSupportSection(
      '👩‍⚕️ Professional Resources',
      Colors.green,
      [
        SupportItem(
          title: 'Psychology Today Therapist Finder',
          subtitle: 'Find licensed therapists near you',
          action: 'https://www.psychologytoday.com/us/therapists',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'BetterHelp Online Therapy',
          subtitle: 'Professional online counseling',
          action: 'https://www.betterhelp.com',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'Talkspace Therapy',
          subtitle: 'Text, video & voice therapy',
          action: 'https://www.talkspace.com',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'SAMHSA Treatment Locator',
          subtitle: 'Find treatment facilities and programs',
          action: 'https://findtreatment.samhsa.gov',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'Open Path Psychotherapy',
          subtitle: 'Affordable therapy sessions (\$30-\$60)',
          action: 'https://openpathcollective.org',
          actionType: ActionType.web,
        ),
      ],
    );
  }

  Widget _buildPeerSupportSection(ColorScheme scheme) {
    if (_searchQuery.isNotEmpty && 
        !_containsSearchQuery(['peer', 'support', 'community', 'group'])) {
      return const SizedBox.shrink();
    }

    return _buildSupportSection(
      '🤝 Peer Support & Community',
      Colors.purple,
      [
        SupportItem(
          title: 'NAMI Support Groups',
          subtitle: 'Find local peer support meetings',
          action: 'https://www.nami.org/Support-Education/Support-Groups',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'Mental Health America Communities',
          subtitle: 'Online support communities',
          action: 'https://www.mhanational.org/finding-help',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: '7 Cups',
          subtitle: 'Free anonymous emotional support chat',
          action: 'https://www.7cups.com',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'Reddit Mental Health Communities',
          subtitle: 'Peer support forums and discussions',
          action: 'https://www.reddit.com/r/mentalhealth',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'Crisis Text Line',
          subtitle: 'Text with trained crisis counselors',
          action: 'sms:741741?body=HELLO',
          actionType: ActionType.sms,
        ),
      ],
    );
  }

  Widget _buildOrganizationsSection(ColorScheme scheme) {
    if (_searchQuery.isNotEmpty && 
        !_containsSearchQuery(['organization', 'institute', 'association', 'foundation'])) {
      return const SizedBox.shrink();
    }

    return _buildSupportSection(
      '🏢 Mental Health Organizations',
      Colors.teal,
      [
        SupportItem(
          title: 'National Institute of Mental Health (NIMH)',
          subtitle: 'Leading federal agency for mental health research',
          action: 'https://www.nimh.nih.gov',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'Mental Health America',
          subtitle: 'Mental health advocacy and education',
          action: 'https://www.mhanational.org',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'American Psychological Association',
          subtitle: 'Professional psychology resources',
          action: 'https://www.apa.org',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'Anxiety and Depression Association',
          subtitle: 'ADAA resources and support',
          action: 'https://adaa.org',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'International OCD Foundation',
          subtitle: 'OCD and related disorders support',
          action: 'https://iocdf.org',
          actionType: ActionType.web,
        ),
      ],
    );
  }

  Widget _buildSpecializedSupportSection(ColorScheme scheme) {
    if (_searchQuery.isNotEmpty && 
        !_containsSearchQuery(['specialized', 'eating', 'substance', 'grief', 'teen', 'senior'])) {
      return const SizedBox.shrink();
    }

    return _buildSupportSection(
      '🎯 Specialized Support',
      Colors.orange,
      [
        SupportItem(
          title: 'National Eating Disorders Association',
          subtitle: 'Eating disorder support and resources',
          action: '1-800-931-2237',
          actionType: ActionType.phone,
        ),
        SupportItem(
          title: 'National Suicide Prevention Lifeline',
          subtitle: 'For substance abuse and mental health',
          action: '988',
          actionType: ActionType.phone,
        ),
        SupportItem(
          title: 'GriefShare',
          subtitle: 'Grief recovery support groups',
          action: 'https://www.griefshare.org',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'Teen Line',
          subtitle: 'Teen-to-teen helpline (6-10 PM PST)',
          action: '1-800-852-8336',
          actionType: ActionType.phone,
        ),
        SupportItem(
          title: 'National Council on Aging',
          subtitle: 'Senior mental health resources',
          action: 'https://www.ncoa.org/article/how-to-address-senior-mental-health-challenges',
          actionType: ActionType.web,
        ),
        SupportItem(
          title: 'Postpartum Support International',
          subtitle: 'Maternal mental health support',
          action: '1-800-944-4773',
          actionType: ActionType.phone,
        ),
      ],
    );
  }

  Widget _buildSupportSection(String title, Color color, List<SupportItem> items) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == items.length - 1;
                
                return Column(
                  children: [
                    _buildSupportItem(item, color),
                    if (!isLast) 
                      Divider(height: 1, color: Colors.grey.shade200),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportItem(SupportItem item, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(
          _getActionIcon(item.actionType),
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: () => _handleAction(item),
    );
  }

  Widget _buildEmergencyButton(String title, String subtitle, String action, Color color) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleEmergencyAction(action),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActionIcon(ActionType type) {
    switch (type) {
      case ActionType.phone:
        return Icons.phone;
      case ActionType.web:
        return Icons.web;
      case ActionType.sms:
        return Icons.message;
    }
  }

  Future<void> _handleAction(SupportItem item) async {
    switch (item.actionType) {
      case ActionType.phone:
        await _makePhoneCall(item.action);
        break;
      case ActionType.web:
        await _launchUrl(item.action);
        break;
      case ActionType.sms:
        final Uri uri = Uri.parse(item.action);
        await launchUrl(uri);
        break;
    }
  }

  Future<void> _handleEmergencyAction(String action) async {
    if (action.startsWith('sms:')) {
      final Uri uri = Uri.parse(action);
      await launchUrl(uri);
    } else {
      await _makePhoneCall(action);
    }
  }

  bool _containsSearchQuery(List<String> keywords) {
    return keywords.any((keyword) => keyword.toLowerCase().contains(_searchQuery));
  }
}

enum ActionType { phone, web, sms }

class SupportItem {
  final String title;
  final String subtitle;
  final String action;
  final ActionType actionType;

  SupportItem({
    required this.title,
    required this.subtitle,
    required this.action,
    required this.actionType,
  });
}
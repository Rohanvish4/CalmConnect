import 'package:calm_connect/model/professional_resource.dart';
import 'package:calm_connect/model/tip.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HomeProvider extends GetxController {
  List<Tip> _tips = [];
  List<ProfessionalResource> _resources = [];
  String _search = '';

  void initialize() {
    _tips = mockTips();
    _resources = mockResources();
    update();
  }

  @override
  void onReady() {
    super.onReady();
    initialize();
  }

  String get searchQuery => _search;

  List<Tip> get tips {
    if (_search.isEmpty) return _tips;
    final q = _search.toLowerCase();
    return _tips.where((t) => t.message.toLowerCase().contains(q)).toList();
  }

  List<ProfessionalResource> get resources {
    if (_search.isEmpty) return _resources;
    final q = _search.toLowerCase();
    return _resources
        .where(
          (r) =>
              r.name.toLowerCase().contains(q) ||
              r.role.toLowerCase().contains(q),
        )
        .toList();
  }

  void setSearch(String value) {
    _search = value;
    update();
  }

  void clearSearch() {
    _search = '';
    update();
  }

  void addTip(Tip tip) {
    _tips.insert(0, tip);
    update();
  }
}

List<Tip> mockTips() => [
  Tip(
    id: 't1',
    title: 'Breathing Exercise',
    message: 'Take a 5-minute breathing break. Inhale for 4, exhale for 6.',
    date: DateTime.now(),
    authorName: 'System',
    authorUID: 'system',
  ),
  Tip(
    id: 't2',
    title: 'Gratitude Practice',
    message: 'Write down three things you are grateful for today.',
    date: DateTime.now(),
    authorName: 'System',
    authorUID: 'system',
  ),
  Tip(
    id: 't3',
    title: 'Physical Wellness',
    message: 'Stretch your shoulders and neck for 30 seconds.',
    date: DateTime.now(),
    authorName: 'System',
    authorUID: 'system',
  ),
];

List<ProfessionalResource> mockResources() => [
  ProfessionalResource(
    id: 'r1',
    name: 'Dr. Maya Chen',
    role: 'Licensed Therapist',
    imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=80&h=80&fit=crop&crop=face',
    rating: 4.9,
    reviews: 120,
  ),
  ProfessionalResource(
    id: 'r2',
    name: 'Northside Wellness',
    role: 'Community Group',
    imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=80&h=80&fit=crop&crop=face',
    rating: 4.6,
    reviews: 54,
  ),
  ProfessionalResource(
    id: 'r3',
    name: 'Calm Minds Org',
    role: 'Non-profit',
    imageUrl: 'https://images.unsplash.com/photo-1607990281513-2c110a25bd8c?w=80&h=80&fit=crop&crop=face',
    rating: 4.8,
    reviews: 88,
  ),
];

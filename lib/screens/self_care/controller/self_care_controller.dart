import 'package:calm_connect/controller/auth_controller.dart';
import 'package:calm_connect/model/tip.dart';
import 'package:calm_connect/model/user_model.dart';
import 'package:calm_connect/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelfCareController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  
  List<Tip> _tips = [];
  bool _isLoading = false;
  TipType? _selectedFilter;
  bool _isPosting = false;

  // Getters
  List<Tip> get tips => _tips;
  bool get isLoading => _isLoading;
  TipType? get selectedFilter => _selectedFilter;
  bool get isPosting => _isPosting;
  UserModel? get currentUser => _authController.currentUserModel;
  bool get canPost => currentUser?.userType == UserType.counsellor;

  @override
  void onInit() {
    super.onInit();
    loadTips();
  }

  void setFilter(TipType? filter) {
    _selectedFilter = filter;
    loadTips();
    update();
  }

  Future<void> loadTips() async {
    _isLoading = true;
    update();

    try {
      _tips = await FirebaseService.getSelfCareTips(filterType: _selectedFilter);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load tips: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }

    _isLoading = false;
    update();
  }

  Future<bool> createTip({
    required String title,
    required String message,
    required TipType type,
    List<String> tags = const [],
  }) async {
    if (currentUser == null || !canPost) {
      Get.snackbar(
        'Permission Denied',
        'Only counselors can post tips',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade800,
      );
      return false;
    }

    _isPosting = true;
    update();

    try {
      final tip = Tip(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        message: message.trim(),
        date: DateTime.now(),
        type: type,
        authorName: currentUser!.name,
        authorUID: currentUser!.userUID,
        tags: tags,
      );

      final success = await FirebaseService.createSelfCareTip(tip);
      
      if (success) {
        // Add to local list for immediate UI update
        _tips.insert(0, tip);
        Get.snackbar(
          'Success',
          'Your ${type.toString().split('.').last} has been posted!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
        );
        update();
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to post tip. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to post tip: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return false;
    } finally {
      _isPosting = false;
      update();
    }
  }

  Future<void> likeTip(String tipId) async {
    if (currentUser == null) return;

    try {
      await FirebaseService.likeTip(tipId, currentUser!.userUID);
      
      // Update local tip
      final tipIndex = _tips.indexWhere((tip) => tip.id == tipId);
      if (tipIndex != -1) {
        final tip = _tips[tipIndex];
        final likedBy = List<String>.from(tip.likedBy);
        final isLiked = likedBy.contains(currentUser!.userUID);
        
        if (isLiked) {
          likedBy.remove(currentUser!.userUID);
        } else {
          likedBy.add(currentUser!.userUID);
        }
        
        final updatedTip = Tip(
          id: tip.id,
          title: tip.title,
          message: tip.message,
          date: tip.date,
          type: tip.type,
          authorName: tip.authorName,
          authorUID: tip.authorUID,
          imageUrl: tip.imageUrl,
          tags: tip.tags,
          likes: isLiked ? tip.likes - 1 : tip.likes + 1,
          likedBy: likedBy,
        );
        
        _tips[tipIndex] = updatedTip;
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update like: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  bool isLikedByCurrentUser(Tip tip) {
    return currentUser != null && tip.likedBy.contains(currentUser!.userUID);
  }

  bool canDeleteTip(Tip tip) {
    return currentUser != null && currentUser!.userUID == tip.authorUID;
  }

  Future<bool> deleteTip(String tipId) async {
    if (currentUser == null) {
      Get.snackbar(
        'Error',
        'You must be logged in to delete tips',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return false;
    }

    try {
      final success = await FirebaseService.deleteSelfCareTip(tipId);
      
      if (success) {
        // Remove from local list for immediate UI update
        _tips.removeWhere((tip) => tip.id == tipId);
        Get.snackbar(
          'Success',
          'Tip deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
        );
        update();
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete tip. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete tip: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
      return false;
    }
  }

  void refreshTips() {
    loadTips();
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';
import '../service/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  UserModel? _currentUserModel;

  User? get currentUser => _currentUser;
  UserModel? get currentUserModel => _currentUserModel;
  bool get isLoggedIn => _currentUser != null;

  @override
  void onInit() {
    super.onInit();
    _currentUser = _auth.currentUser;
    _loadCurrentUserModel();
  }

  // Simple email/password sign up
  Future<bool> signUp({
    required String email, 
    required String password, 
    required String name,
    required UserType userType,
    String bio = '',
    String occupation = '',
    String specialization = '',
    int experienceYears = 0,
    String qualifications = '',
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        _currentUser = credential.user;
        await FirebaseService.saveUserDetailToFirebase(
          userUID: credential.user!.uid,
          name: name,
          email: email,
          userType: userType,
          bio: bio,
          occupation: occupation,
          specialization: specialization,
          experienceYears: experienceYears,
          qualifications: qualifications,
        );
        await _loadCurrentUserModel();
        update();
        return true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Sign up failed: $e');
    }
    return false;
  }

  // Simple email/password sign in
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        _currentUser = credential.user;
        await _loadCurrentUserModel();
        update();
        return true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Sign in failed: $e');
    }
    return false;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    _currentUserModel = null;
    update();
  }

  Future<void> _loadCurrentUserModel() async {
    if (_currentUser != null) {
      _currentUserModel = await FirebaseService.getUserById(_currentUser!.uid);
    }
  }
}
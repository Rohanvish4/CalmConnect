import 'dart:developer';

import 'package:calm_connect/model/tip.dart';
import 'package:calm_connect/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static Future<bool> saveUserDetailToFirebase({
    required String userUID,
    required String name,
    required String email,
    UserType userType = UserType.peer,
    String bio = '',
    String occupation = '',
    String specialization = '',
    int experienceYears = 0,
    String qualifications = '',
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userUID);
      await docRef.set({
        'name': name,
        'email': email,
        'userUID': userUID,
        'userType': userType.name,
        'isOnline': true,
        'createdAt': DateTime.now(),
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
        'bio': bio,
        'occupation': occupation,
        'specialization': specialization,
        'experienceYears': userType == UserType.counsellor && experienceYears == 0 ? 5 : experienceYears,
        'qualifications': qualifications,
        'rating': userType == UserType.counsellor ? 4.5 : 0.0, // Default rating for counsellors
        'consultationCount': 0,
        'isAvailableForConsultation': userType == UserType.counsellor,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<UserModel?> getUserById(String userUID) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .get();
      
      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data()!);
      }
    } catch (e) {
      log("Error fetching user: $e");
    }
    return null;
  }

  static Future<List<UserModel>> getUsersList() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      final userList = querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
      return userList;
    } catch (e) {
      log("Error fetching users: $e");
      return [];
    }
  }

  // Self-Care Content Operations
  static Future<bool> createSelfCareTip(Tip tip) async {
    try {
      await FirebaseFirestore.instance
          .collection('selfCareTips')
          .doc(tip.id)
          .set(tip.toMap());
      return true;
    } catch (e) {
      log("Error creating tip: $e");
      return false;
    }
  }

  static Future<List<Tip>> getSelfCareTips({TipType? filterType}) async {
    try {
      Query query = FirebaseFirestore.instance
          .collection('selfCareTips')
          .orderBy('timestamp', descending: true);
      
      if (filterType != null) {
        query = query.where('type', isEqualTo: filterType.toString().split('.').last);
      }
      
      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => Tip.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      log("Error fetching tips: $e");
      return [];
    }
  }

  static Future<bool> likeTip(String tipId, String userUID) async {
    try {
      final tipRef = FirebaseFirestore.instance
          .collection('selfCareTips')
          .doc(tipId);
      
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final tipDoc = await transaction.get(tipRef);
        if (!tipDoc.exists) return;
        
        final data = tipDoc.data()!;
        final likedBy = List<String>.from(data['likedBy'] ?? []);
        final currentLikes = data['likes'] ?? 0;
        
        if (likedBy.contains(userUID)) {
          // Unlike
          likedBy.remove(userUID);
          transaction.update(tipRef, {
            'likedBy': likedBy,
            'likes': currentLikes - 1,
          });
        } else {
          // Like
          likedBy.add(userUID);
          transaction.update(tipRef, {
            'likedBy': likedBy,
            'likes': currentLikes + 1,
          });
        }
      });
      return true;
    } catch (e) {
      log("Error liking tip: $e");
      return false;
    }
  }

  static Future<bool> deleteSelfCareTip(String tipId) async {
    try {
      await FirebaseFirestore.instance
          .collection('selfCareTips')
          .doc(tipId)
          .delete();
      return true;
    } catch (e) {
      log("Error deleting tip: $e");
      return false;
    }
  }

  static Stream<List<Tip>> getSelfCareTipsStream({TipType? filterType}) {
    try {
      Query query = FirebaseFirestore.instance
          .collection('selfCareTips')
          .orderBy('timestamp', descending: true);
      
      if (filterType != null) {
        query = query.where('type', isEqualTo: filterType.toString().split('.').last);
      }
      
      return query.snapshots().map((snapshot) =>
          snapshot.docs
              .map((doc) => Tip.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList());
    } catch (e) {
      log("Error streaming tips: $e");
      return Stream.value([]);
    }
  }

  // static Future<List<UserModel>> getUsersList2() async {
  //   try {
  //     var beartoken = 'jasjabsjasasasbajsb';
  //     final result = await http.post(
  //       Uri.parse("dnsdns"),
  //       body: jsonEncode({'name': "dnsjds"}),
  //       headers: {'Authorization': "Bear $beartoken"},
  //     );
  //     if (result.statusCode == 200) {
  //       final data = jsonDecode(result.body) as List;
  //       return data.map((e) => UserModel.fromJson(e)).toList();
  //     }
  //   } catch (e) {
  //     log("Error fetching users: $e");
  //   }
  //   return [];
  // }
}

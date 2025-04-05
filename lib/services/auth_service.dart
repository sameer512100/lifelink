import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register Donor
  Future<String?> registerDonor(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  // Login Donor
  Future<String?> loginDonor(String email, String password) async {
    try {
      print("🔐 Firebase login with: $email");
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("✅ Logged in! UID: ${credential.user?.uid}");
      return null;
    } on FirebaseAuthException catch (e) {
      print("⚠️ FirebaseAuthException: ${e.code} - ${e.message}");
      return e.message;
    } catch (e, stackTrace) {
      print("🔥 Unexpected error: $e");
      print("🧵 StackTrace:\n$stackTrace");
      return "An unexpected error occurred: $e";
    }
  }

  // Register Hospital
  Future<String?> registerHospital(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  // Login Hospital
  Future<String?> loginHospital(String email, String password) async {
    try {
      print("🔐 Firebase login with: $email");
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("✅ Logged in! UID: ${credential.user?.uid}");
      return null;
    } on FirebaseAuthException catch (e) {
      print("⚠️ FirebaseAuthException: ${e.code} - ${e.message}");
      return e.message;
    } catch (e, stackTrace) {
      print("🔥 Unexpected error: $e");
      print("🧵 StackTrace:\n$stackTrace");
      return "An unexpected error occurred: $e";
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}

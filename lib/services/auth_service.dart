import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 // DONOR REGISTER
  Future<String?> registerDonor(String email, String password, String name, String bloodType) async {
  try {
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('donors').doc(userCredential.user!.uid).set({
      'name': name,
      'email': email,
      'bloodType': bloodType,
      'createdAt': Timestamp.now(),
    });

    return null;
  } catch (e) {
    return e.toString();
  }
}




  // ✅ ADD THIS:
  User? getCurrentUser() {
    return _auth.currentUser;
  }
  // Register Hospital
  Future<String?> registerHospital(String email, String password) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'email': email,
        'role': 'hospital',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  // Login Donor (You can make this a common login if needed)
  Future<String?> loginDonor(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}

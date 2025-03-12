import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_recipe/services/user_service.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign In Manually Way
  Future<String?> signInWithManual(String emailAddress, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      print(credential.user?.uid);
      return null; // No error
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        return "❌ อีเมลล์ไม่ถูกต้อง";
      } else if (e.code == "invalid-credential") {
        return "❌ เข้าสู่ระบบไม่สำเร็จ";
      } else {
        return "❌ เกิดข้อผิดพลาดในการเข้าสู่ระบบ";
      }
    }
  }

  // Register Manually Way
  Future<String?> registerWithManual(
    String username,
    String emailAddress,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      // Create a new user in Firestore
      final UserService _userService = UserService();
      await _userService.createUser(
        userId: credential.user!.uid,
        username: username,
        profileUrl: "", // TODO: Insert the default profile URL here
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "✉️ อีเมลล์นี้ถูกใช้งานแล้ว";
      } else if (e.code == "weak-password") {
        return "🔒 รหัสผ่านไม่แข็งแรงพอ";
      } else {
        return "❌ เกิดข้อผิดพลาดในการลงทะเบียน";
      }
    }
  }

  // Sign in with Google
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return "🔒 การเข้าสู่ระบบด้วย Google ไม่สำเร็จ";
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      print("Google Sign-In successful: ${userCredential.user?.uid}");

      final UserService _userService = UserService();
      final userSnapshot =
          await _userService.getUserById(userCredential.user!.uid).first;
      // Check if the user already exists in Firestore
      // User does not exist, create a new document otherwise do nothing
      if (userSnapshot == null) {
        await _userService.createUser(
          userId: userCredential.user!.uid,
          username:
              googleUser.displayName?.split(' ')[0] ??
              "User", // Use Google display name as username
          profileUrl:
              // TODO: Insert the default profile URL here
              googleUser.photoUrl ?? "", // Use Google photo URL as profile URL
        );
        print("New user created in Firestore.");
      } else {
        print("User already exists in Firestore.");
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return "❌ การเข้าสู่ระบบด้วย Google ไม่สำเร็จ: $e";
    } catch (e) {
      return "❌ เกิดข้อผิดพลาดที่ไม่คาดคิดในระบบ: $e";
    }
  }

  String? getSignInProvider() {
    final user = _auth.currentUser;
    if (user != null && user.providerData.isNotEmpty) {
      return user.providerData[0].providerId;
    }
    return null;
  }

  // Sign Out
  Future<String?> signOut() async {
    try {
      final providerId = getSignInProvider();
      if (providerId == "google.com") {
        await GoogleSignIn().signOut();
      }
      await _auth.signOut();
      return null;
    } catch (e) {
      return "❌ ออกจากระบบไม่สำเร็จ: $e";
    }
  }
}

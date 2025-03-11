import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    String emailAddress,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      print(credential.user?.uid);
      return null; // No error
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "🔒 อีเมลล์นี้ถูกใช้งานแล้ว";
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
      return null; // No error
    } on FirebaseAuthException catch (e) {
      return "❌ การเข้าสู่ระบบด้วย Google ไม่สำเร็จ: $e";
    } catch (e) {
      return "❌ เกิดข้อผิดพลาดที่ไม่คาดคิดในระบบ: $e";
    }
  }

  // Sign out Google
  Future<void> signOutGoogle() async {
    await GoogleSignIn().signOut();
    print("Google Sign-Out successful");
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign In Manually Way
  void signInWithManual(String emailAddress, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      print(credential.user?.uid);
    } on FirebaseAuthException catch (e) {
      // TODO: Login Failed Dialog Alert
      // print(e.code);
      if (e.code == "invalid-email") {
        print("อีเมลล์ไม่ถูกต้อง");
      } else if (e.code == "invalid-credential") {
        print("เข้าสู่ระบบไม่สำเร็จ");
      }
    }
  }

  // Register Manually Way
  void registerWithManual(String emailAddress, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      print(credential.user?.uid);
    } on FirebaseAuthException catch (e) {
      // TODO: Registration Failed Dialog Alert
      // print(e.code);
      if (e.code == "email-already-in-use") {
        print("อีเมลล์นี้ถูกใช้งานแล้ว");
      } else if (e.code == "weak-password") {
        print("รหัสผ่านไม่แข็งแรงพอ");
      }
    }
  }

  // Sign In With Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("Google Sign-In canceled by user.");
        return;
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
    } on FirebaseAuthException catch (e) {
      print("Google Sign-In failed: ${e.message}");
    } catch (e) {
      print("Unexpected error during Google Sign-In: $e");
    }
  }
}

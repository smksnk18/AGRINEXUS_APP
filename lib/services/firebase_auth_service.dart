import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) failed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      verificationCompleted: (PhoneAuthCredential credential) async {
        print("AUTO VERIFIED");
        await _auth.signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {
        print("FAILED");
        print(e.code);
        print(e.message);

        failed(e.message ?? "OTP Failed");
      },

      codeSent: (String verificationId, int? resendToken) {
        print("CODE SENT");
        print(verificationId);

        codeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        print("TIMEOUT");
      },
    );
  }

  Future<bool> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final PhoneAuthCredential credential =
      PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      return true;
    } on FirebaseAuthException catch (e) {
      print("VERIFY ERROR");
      print(e.code);
      print(e.message);
      return false;
    }
  }

  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
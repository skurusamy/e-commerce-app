import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Email & Password Sign Up
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print("AuthService: Verification email sent.");
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  //Check if user already exists
  Future<bool> isEmailExists(String email) async {
    List<String> signInMethods = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  }

  // Email & Password Login
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Sign In Error: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // Phone OTP Authentication
  Future<void> signInWithPhone(String phoneNumber, Function(String) codeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Phone Verification Failed: $e");
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Verify OTP
  Future<User?> verifyOTP(String verificationId, String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("OTP Verification Failed: $e");
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check User Login Status
  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  // Save Login State
  Future<void> saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

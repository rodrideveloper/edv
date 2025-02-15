import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida/models/auth_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<User?> get user {
    return CombineLatestStream.list([
      _auth.userChanges(),
      _auth.idTokenChanges(),
      _auth.authStateChanges(),
    ]).map((users) => users.first);
  }

  Future<AuthResult> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      return AuthResult.error('forgotPassword.popup.content.error');
    } on PlatformException catch (_) {
      return AuthResult.error('auth.platform.error');
    }
    return AuthResult.success();
  }

  Future<List<void>> signOut() async {
    return Future.wait(
      [
        FirebaseMessaging.instance.deleteToken(),
        FirebaseFirestore.instance.terminate(),
        FirebaseFirestore.instance.clearPersistence(),
        _auth.signOut(),
        googleSignIn.signOut(),
      ],
    );
  }

  Future<AuthResult> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException {
      return AuthResult.error('Error en plataforma');
    } on FirebaseAuthException catch (err) {
      AuthErrorCode authErrorCode = AuthErrorCode.values
          .firstWhere((value) => value.codeError == err.code);
      switch (authErrorCode) {
        case AuthErrorCode.invalidCredential:
        case AuthErrorCode.invalidEmail:
        case AuthErrorCode.wrongPassword:
        case AuthErrorCode.userNotFound:
          return AuthResult.error('Usuario no valido');
        case AuthErrorCode.userDisabled:
          return AuthResult.error('Usuario no deshabilitado');
        case AuthErrorCode.tooManyRequests:
          return AuthResult.error('Demasiadas peticiónes');
        case AuthErrorCode.networkRequestFailed:
          return AuthResult.error('Error de red');
      }
    }

    return AuthResult.success();
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          'photoURL': user.photoURL,
          'phone': user.phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return AuthResult.success();
      } else {
        return AuthResult.error("Error al autenticar el usuario");
      }
    } catch (e) {
      return AuthResult.error("Error al autenticar el usuario");
    }
  }

  Future<AuthResult> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: appleCredential.authorizationCode,
        idToken: appleCredential.identityToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          'photoURL': user.photoURL,
          'phone': user.phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return AuthResult.success();
      } else {
        return AuthResult.error("Error al autenticar el usuario");
      }
    } catch (e) {
      return AuthResult.error("Error al autenticar el usuario");
    }
  }
}

enum AuthErrorCode {
  invalidEmail('invalid-email'),
  wrongPassword('wrong-password'),
  userNotFound('user-not-found'),
  userDisabled('user-disabled'),
  tooManyRequests('too-many-requests'),
  invalidCredential('invalid-credential'),
  networkRequestFailed('network-request-failed');

  const AuthErrorCode(this._codeError);

  final String _codeError;

  get codeError => _codeError;
}

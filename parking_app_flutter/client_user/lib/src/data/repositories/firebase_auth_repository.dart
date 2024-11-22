import 'package:firebase_auth/firebase_auth.dart';

import '../../core/entities/user_entity.dart';
import '../../core/utils/utils.dart';
import '../../domain/interfaces/auth_repository.dart';

enum FirebaseAuthError {
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  invalidEmail,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  weakPassword,
  unknown;

  factory FirebaseAuthError.fromCode(String code) {
    switch (code) {
      case "user-not-found":
        return FirebaseAuthError.userNotFound;
      case "wrong-password":
        return FirebaseAuthError.wrongPassword;
      case "email-already-in-use":
        return FirebaseAuthError.emailAlreadyInUse;
      case "invalid-email":
        return FirebaseAuthError.invalidEmail;
      case "user-disabled":
        return FirebaseAuthError.userDisabled;
      case "operation-not-allowed":
        return FirebaseAuthError.operationNotAllowed;
      case "too-many-requests":
        return FirebaseAuthError.tooManyRequests;
      case "weak-password":
        return FirebaseAuthError.weakPassword;
      default:
        return FirebaseAuthError.unknown;
    }
  }

  String get message {
    switch (this) {
      case FirebaseAuthError.userNotFound:
        return "User not found!";
      case FirebaseAuthError.wrongPassword:
        return "Wrong password!";
      case FirebaseAuthError.emailAlreadyInUse:
        return "Email already in use!";
      case FirebaseAuthError.invalidEmail:
        return "Invalid email!";
      case FirebaseAuthError.userDisabled:
        return "User disabled!";
      case FirebaseAuthError.operationNotAllowed:
        return "Operation not allowed!";
      case FirebaseAuthError.tooManyRequests:
        return "Too many requests!";
      case FirebaseAuthError.weakPassword:
        return "Weak password!";
      default:
        return "Unknown error!";
    }
  }
}

extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  FirebaseAuthError get toFirebaseAuthError {
    switch (code) {
      case "user-not-found":
        return FirebaseAuthError.userNotFound;
      case "wrong-password":
        return FirebaseAuthError.wrongPassword;
      case "email-already-in-use":
        return FirebaseAuthError.emailAlreadyInUse;
      case "invalid-email":
        return FirebaseAuthError.invalidEmail;
      case "user-disabled":
        return FirebaseAuthError.userDisabled;
      case "operation-not-allowed":
        return FirebaseAuthError.operationNotAllowed;
      case "too-many-requests":
        return FirebaseAuthError.tooManyRequests;
      case "weak-password":
        return FirebaseAuthError.weakPassword;
      default:
        return FirebaseAuthError.unknown;
    }
  }
}

extension UserEntityExtension on UserEntity {
  static UserEntity fromFirebaseUser(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<Result<UserEntity, AppFailure>> currentUser() {
    try {
      final User? user = _firebaseAuth.currentUser;
      return Future.value(
        user != null
            ? Result.success(value: UserEntityExtension.fromFirebaseUser(user))
            : Result.failure(error: AppFailure("User not logged in!")),
      );
    } catch (e) {
      return Future.value(
        Result.failure(
          error: AppFailure(FirebaseAuthError.unknown.message),
        ),
      );
    }
  }

  @override
  Future<Result<UserEntity, AppFailure>> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.success(
        value: UserEntityExtension.fromFirebaseUser(userCredential.user!),
      );
    } on FirebaseAuthException catch (e) {
      return Result.failure(
        error: AppFailure(FirebaseAuthError.fromCode(e.code).message),
      );
    } catch (e) {
      return Result.failure(
        error: AppFailure(FirebaseAuthError.unknown.message),
      );
    }
  }

  @override
  Future<Result<UserEntity, AppFailure>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.success(
        value: UserEntityExtension.fromFirebaseUser(userCredential.user!),
      );
    } on FirebaseAuthException catch (e) {
      return Result.failure(
        error: AppFailure(FirebaseAuthError.fromCode(e.code).message),
      );
    } catch (e) {
      return Result.failure(
        error: AppFailure(FirebaseAuthError.unknown.message),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return Result.success(value: null);
    } on FirebaseAuthException catch (e) {
      return Result.failure(
        error: AppFailure(FirebaseAuthError.fromCode(e.code).message),
      );
    } catch (e) {
      return Result.failure(
        error: AppFailure(FirebaseAuthError.unknown.message),
      );
    }
  }
}

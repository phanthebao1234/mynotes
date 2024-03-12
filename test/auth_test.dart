import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('should not be initialized to begin with authentication', () {
      expect(provider.isInitialized, false);
    });

    test('cannot log out if not initial', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('should be able to be initial', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initial', () {
      expect(provider.currentUser, null);
    });

    test('should be able to initalize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('create user should delegate to login function ', () async {
      final badEmailUser = provider.createUser(
        email: 'phanthebao888@gmail.com',
        password: 'anypassword',
      );
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundException>()));

      final badPasswordUser = provider.createUser(
        email: 'any@email.com',
        password: 'hello123',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordException>()));

      final user = await provider.createUser(email: 'bad', password: '123');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, true);
    });

    test('logged in the user should be able to get verify', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to log in and log out again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });

    test('send password reset email', () async {
      await provider.sendPasswordReset(toEmail: 'phanthebao888@gmail.com');
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'phanthebao888@gmail.com') throw UserNotFoundException();
    if (password == 'foobar') throw WrongPasswordException();
    const user = AuthUser(
      id: 'my_id',
      isEmailVerified: true,
      email: 'phanthebao888@gmail.com',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundException();
    const newUser = AuthUser(
      id: 'my_id',
      isEmailVerified: true,
      email: 'phanthebao888@gmail.com',
    );
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    if (!isInitialized) throw NotInitializedException();
    if (toEmail == 'phanthebao888@gmail.com') throw UserNotFoundException();

    throw UnimplementedError();
  }
}

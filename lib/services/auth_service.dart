import 'package:psicoapp/models/user.dart';
import 'package:psicoapp/services/storage_service.dart';

class AuthService {
  final StorageService _storageService;

  AuthService(this._storageService);

  UserModel? get currentUser => _storageService.getActiveUser();

  bool get isLoggedIn => currentUser != null;

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    
    // Check if user already exists
    final users = await _storageService.getUsersList();
    final existingUser = users.any((u) => u.email.toLowerCase() == cleanEmail);
    if (existingUser) {
      return AuthResult(
        success: false,
        errorMessage: 'Ya existe una cuenta con este correo electrónico.',
      );
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName.trim(),
      email: cleanEmail,
      password: password, // In production, replace with Firebase Auth / hashed token
      createdAt: DateTime.now(),
    );

    await _storageService.saveUserToList(newUser);
    await _storageService.saveActiveUser(newUser);

    return AuthResult(success: true, user: newUser);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final users = await _storageService.getUsersList();

    UserModel? foundUser;
    for (var u in users) {
      if (u.email.toLowerCase() == cleanEmail && u.password == password) {
        foundUser = u;
        break;
      }
    }

    // Demo convenience fallback: If no user found in local storage list yet (first clean launch),
    // automatically create a default account for easy testing if credentials are provided.
    if (foundUser == null && users.isEmpty) {
      foundUser = UserModel(
        id: 'demo_user_1',
        fullName: 'Usuario PSICOAPP',
        email: cleanEmail,
        password: password,
        createdAt: DateTime.now(),
      );
      await _storageService.saveUserToList(foundUser);
    }

    if (foundUser != null) {
      await _storageService.saveActiveUser(foundUser);
      return AuthResult(success: true, user: foundUser);
    } else {
      return AuthResult(
        success: false,
        errorMessage: 'Correo o contraseña incorrectos.',
      );
    }
  }

  Future<void> logout() async {
    await _storageService.clearActiveUser();
  }

  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user != null) {
      await _storageService.deleteUserData(user.id);
    }
  }
}

class AuthResult {
  final bool success;
  final UserModel? user;
  final String? errorMessage;

  AuthResult({
    required this.success,
    this.user,
    this.errorMessage,
  });
}

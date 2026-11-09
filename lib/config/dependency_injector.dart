import 'package:flutter/widgets.dart';

import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

/// Dependency injection sederhana sekaligus InheritedWidget.
///
/// Menyimpan satu instance [ApiService] (singleton) beserta repository
/// yang memakainya, lalu menyebarkan dependency tersebut ke widget tree
/// melalui [DependencyInjector.of].
class DependencyInjector extends InheritedWidget {
  DependencyInjector({super.key, required super.child})
    : apiService = _apiService,
      userRepository = UserRepositoryImpl(apiService: _apiService),
      postRepository = PostRepositoryImpl(apiService: _apiService);

  /// Singleton pattern untuk ApiService.
  ///
  /// Satu instance dipakai bersama oleh semua repository, sehingga hanya
  /// ada satu HTTP client untuk seluruh aplikasi.
  static final ApiService _apiService = ApiService();

  final ApiService apiService;
  final UserRepository userRepository;
  final PostRepository postRepository;

  /// Mengambil dependency terdekat dari [context].
  ///
  /// Harus dipanggil dari widget yang berada di bawah [DependencyInjector]
  /// yang dipasang di `main.dart`.
  static DependencyInjector of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<DependencyInjector>();
    assert(
      scope != null,
      'DependencyInjector tidak ditemukan. Pasang di atas MaterialApp pada main.dart.',
    );
    return scope!;
  }

  @override
  bool updateShouldNotify(DependencyInjector oldWidget) => false;
}

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';

/// Class container Dependency Injection yang menyimpan instance service & repository.
class DependencyInjectorContainer {
  static final DependencyInjectorContainer _instance =
      DependencyInjectorContainer._internal();

  factory DependencyInjectorContainer() => _instance;

  DependencyInjectorContainer._internal();

  // Singleton instance ApiService
  late final ApiService apiService = ApiService();

  // Instance repository
  late final UserRepository userRepository =
      UserRepositoryImpl(apiService: apiService);
  late final PostRepository postRepository =
      PostRepositoryImpl(apiService: apiService);

  void dispose() {
    apiService.dispose();
  }
}

/// InheritedWidget untuk membagikan dependency ke seluruh widget tree.
class DependencyInjector extends InheritedWidget {
  final DependencyInjectorContainer container;

  DependencyInjector({
    super.key,
    required super.child,
    DependencyInjectorContainer? container,
  }) : container = container ?? DependencyInjectorContainer();

  /// Mengambil container dependency dari context terdekat.
  static DependencyInjectorContainer of(BuildContext context) {
    final injector =
        context.dependOnInheritedWidgetOfExactType<DependencyInjector>();
    assert(injector != null, 'DependencyInjector tidak ditemukan di context');
    return injector!.container;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
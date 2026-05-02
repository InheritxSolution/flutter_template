import 'package:flutter/material.dart';

import 'app_routes.dart';
import '../../features/task/presentation/pages/task_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.initialRoute:
        return MaterialPageRoute(
          builder: (_) => const TaskPage(),
        );

      case AppRoutes.todoRoute:
        return MaterialPageRoute(
          builder: (_) => const TaskPage(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('Page not found'),
          ),
        );
      },
    );
  }
}

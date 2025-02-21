import 'package:flutter/material.dart';

import '../../feature/todo/screens/todo_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.initialRoute:
        return MaterialPageRoute(
          builder: (_) =>
              const TodoScreen(todoId: 1),
        );

      case AppRoutes.todoRoute:
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => TodoScreen(todoId: args),
          );
        }
        return _errorRoute();

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

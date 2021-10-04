import 'package:flutter/material.dart';
import 'package:mapko_bloc/screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRouter(RouteSettings settings) {
    print('Nested Route: ${settings.name}');
    switch (settings.name) {
      case ChatScreen.routeName:
        return ChatScreen.route(args: settings.arguments! as ChatScreenArgs);
      case ChatInfoScreen.routeName:
        return ChatInfoScreen.route(
            args: settings.arguments! as ChatInfoScreenArgs);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: const Center(
            child: Text('Something went wrong!'),
          )),
    );
  }
}

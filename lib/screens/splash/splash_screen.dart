import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapko_bloc/blocs/auth/auth_bloc.dart';

import '../screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthorized) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.routeName,
              (route) => false,
            );
          } else if (state.status == AuthStatus.authorized) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              NavScreen.routeName,
              (route) => false,
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Container(),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mapko_bloc/blocs/auth/auth_bloc.dart';
import 'package:mapko_bloc/blocs/simple_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapko_bloc/repositories/token/token_provider.dart';

import 'config/custom_router.dart';
import 'repositories/repositories.dart';
import 'screens/screens.dart';

void main() async {
  Bloc.observer = SimpleBlocObsever();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => TokenProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()),
        ],
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<LocationRepository>(
              create: (_) => LocationRepository(authBloc: _.read<AuthBloc>()),
            ),
            RepositoryProvider(
              create: (_) => ChatRepository(authBloc: _.read<AuthBloc>()),
            ),
            RepositoryProvider(
              create: (_) => UserRepository(),
            ),
          ],
          child: MaterialApp(
            title: 'Mapko',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: CustomRouter.onGenerateRoute,
            initialRoute: SplashScreen.routeName,
          ),
        ),
      ),
    );
  }
}

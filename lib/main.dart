import 'package:flutter/material.dart';
import 'package:mapko_bloc/blocs/simple_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/blocs.dart';
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
        RepositoryProvider<TokenRepository>(create: (_) => TokenRepository()),
        RepositoryProvider<StorageRepository>(
          create: (_) => StorageRepository(),
        ),
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(
              tokenRepository: _.read<TokenRepository>(),
              storageRepository: _.read<StorageRepository>(),
              authRepository: _.read<AuthRepository>(),
            ),
          ),
        ],
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<LocationRepository>(
              create: (_) => LocationRepository(authBloc: _.read<AuthBloc>()),
            ),
            RepositoryProvider<ChatRepository>(
              create: (_) => ChatRepository(authBloc: _.read<AuthBloc>()),
            ),
            RepositoryProvider<UserRepository>(
              create: (_) => UserRepository(authBloc: _.read<AuthBloc>()),
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

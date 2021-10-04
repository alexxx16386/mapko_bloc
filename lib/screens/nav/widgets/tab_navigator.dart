import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapko_bloc/blocs/auth/auth_bloc.dart';
import 'package:mapko_bloc/blocs/blocs.dart';
import 'package:mapko_bloc/config/custom_router.dart';
import 'package:mapko_bloc/enums/enums.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:mapko_bloc/screens/chats_screen/bloc/chats_bloc.dart';
import 'package:mapko_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:mapko_bloc/screens/screens.dart';
import 'package:mapko_bloc/screens/home_screen/bloc/home_bloc.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatingRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({
    required this.navigatorKey,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatingRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatingRoot),
            builder: (context) => routeBuilders[initialRoute]!(context),
          ),
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRouter,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {
      tabNavigatingRoot: (context) => _getScreen(context, item),
    };
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.home:
        return BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            locationRepository: context.read<LocationRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(HomeLoad()),
          child: HomeScreen(),
        );
      case BottomNavItem.chats:
        return BlocProvider<ChatsBloc>(
          create: (_) => ChatsBloc(
            locationRepository: context.read<LocationRepository>(),
            chatRepository: context.read<ChatRepository>(),
          )..add(ChatsUpdateList()),
          child: ChatsScreen(),
        );
      case BottomNavItem.profile:
        return BlocProvider(
          create: (context) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
          )..add(
              ProfileLoadUser(),
            ),
          child: ProfileScreen(),
        );

      default:
        return Scaffold();
    }
  }
}

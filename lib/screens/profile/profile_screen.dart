import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapko_bloc/blocs/blocs.dart';
import 'package:mapko_bloc/repositories/keys/keys_repository.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:mapko_bloc/screens/profile/widgets/widgets.dart';
import 'package:mapko_bloc/widgets/widgets.dart';

import '../screens.dart';
import 'bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(
            ProfileLoadUser(),
          ),
        child: ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    return Column(
      children: [
        state.status == ProfileStatus.loading
            ? RefreshProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProfileInfo(
                    username: state.user.username, bio: state.user.email),
              ),
        ListTile(
          title: Text('LogOut'),
          leading: Icon(Icons.logout),
          onTap: () {
            context.read<AuthBloc>().add(AuthLogoutReuested());
            KeysRepository().navKey.currentState!.pushNamedAndRemoveUntil(
                  LoginScreen.routeName,
                  (route) => true,
                );
          },
        ),
      ],
    );
  }
}

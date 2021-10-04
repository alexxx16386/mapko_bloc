import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapko_bloc/models/models.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:mapko_bloc/widgets/widgets.dart';

import '../screens.dart';
import 'bloc/chats_bloc.dart';

class ChatsScreen extends StatelessWidget {
  static const String id = '/chats';
  static Route route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider<ChatsBloc>(
        create: (_) => ChatsBloc(
          locationRepository: context.read<LocationRepository>(),
          chatRepository: context.read<ChatRepository>(),
        )..add(
            ChatsUpdateList(),
          ),
        child: ChatsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsBloc, ChatsState>(
      listener: (context, state) {
        if (state.status == ChatsStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure.message,
              title: '',
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Chats'),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ChatsState state) {
    switch (state.status) {
      case ChatsStatus.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ChatsBloc>().add(ChatsUpdateList());
          },
          child: ListView.builder(
            itemCount: state.chats.length,
            itemBuilder: (BuildContext context, int index) {
              Chat chat = state.chats[index];
              return ListTile(
                leading: Icon(Icons.group),
                title: Text(chat.name),
                onTap: () => Navigator.of(context).pushNamed(
                  ChatScreen.routeName,
                  arguments: ChatScreenArgs(chat: chat),
                ),
              );
            },
          ),
        );
    }
  }
}

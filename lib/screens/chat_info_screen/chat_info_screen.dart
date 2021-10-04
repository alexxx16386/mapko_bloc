import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapko_bloc/blocs/blocs.dart';
import 'package:mapko_bloc/models/models.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:mapko_bloc/repositories/token/token_repository.dart';
import 'package:mapko_bloc/widgets/widgets.dart';

import 'bloc/chatinfo_bloc.dart';

class ChatInfoScreenArgs {
  final Chat chat;

  const ChatInfoScreenArgs({required this.chat});
}

class ChatInfoScreen extends StatelessWidget {
  static const String routeName = '/chat_info';
  static Route route({required ChatInfoScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ChatInfoBloc>(
        create: (_) => ChatInfoBloc(
          chatRepository: context.read<ChatRepository>(),
        )..add(
            ChatInfoInit(chat: args.chat),
          ),
        child: ChatInfoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatInfoBloc, ChatInfoState>(
      listener: (context, state) {
        if (state.status == ChatInfoStatus.error) {
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
          appBar: AppBar(),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ChatInfoState state) {
    switch (state.status) {
      case ChatInfoStatus.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ChatInfoBloc>().add(ChatInfoLoad());
          },
          child: ListView(
            children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.group,
                            size: 64,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            state.chat.name,
                            style: TextStyle(fontSize: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: _leaveJoinButton(context, state),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.group,
                      size: 32,
                    ),
                    title: Text(
                      'Members',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ] +
                state.members
                    .map((member) => ListTile(
                          leading: Icon(Icons.person),
                          title: Text(member.username),
                        ))
                    .toList(),
          ),
        );
    }
  }

  Widget _leaveJoinButton(BuildContext context, ChatInfoState state) {
    return state.isMembership
        ? FloatingActionButton.extended(
            label: Text('Выйти'),
            icon: Icon(Icons.person_remove),
            onPressed: () => context.read<ChatInfoBloc>().add(ChatInfoLeave()),
          )
        : FloatingActionButton.extended(
            label: Text('Присоединиться'),
            icon: Icon(Icons.person_add),
            onPressed: () => context.read<ChatInfoBloc>().add(ChatInfoJoin()),
          );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapko_bloc/models/models.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:mapko_bloc/screens/chat_screen/bloc/chat_bloc.dart';
import 'package:mapko_bloc/screens/screens.dart';
import 'package:mapko_bloc/widgets/widgets.dart';

class ChatScreenArgs {
  final Chat chat;

  const ChatScreenArgs({required this.chat});
}

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';
  static Route route({required ChatScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ChatBloc>(
        create: (_) => ChatBloc(
          chatRepository: context.read<ChatRepository>(),
          userRepository: context.read<UserRepository>(),
        )..add(
            ChatInit(chat: args.chat),
          ),
        child: ChatScreen(),
      ),
    );
  }

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state.status == ChatStatus.error) {
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
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(state.chat.name),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    ChatInfoScreen.routeName,
                    arguments: ChatInfoScreenArgs(chat: state.chat),
                  ),
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
            body: _buildBody(context, state),
            bottomNavigationBar: BottomAppBar(
              child: state.isMembership
                  ? _buildInputArea(context)
                  : _buildJoinButton(context),
            ),
            // bottomNavigationBar:
          ),
        );
      },
    );
  }

  TextButton _buildJoinButton(BuildContext context) {
    return TextButton(
      child: Text('Присоединиться'),
      onPressed: () {
        context.read<ChatBloc>().add(ChatJoin());
      },
    );
  }

  Row _buildInputArea(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.photo),
          iconSize: 25,
          color: Theme.of(context).primaryColor,
          onPressed: () {},
        ),
        Expanded(
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration.collapsed(
              hintText: 'Send a message..',
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          iconSize: 25,
          color: Theme.of(context).primaryColor,
          onPressed: () async {
            if (_textEditingController.text.isNotEmpty) {
              context.read<ChatBloc>().add(
                    ChatSendMessage(text: _textEditingController.text),
                  );
              _textEditingController.clear();
            }
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ChatState state) {
    switch (state.status) {
      case ChatStatus.error:
        return Center(
          child: Text('error'),
        );
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ChatBloc>().add(ChatLoad());
          },
          child: ListView(
            reverse: true,
            children: <Widget>[
                  if (state.status == ChatStatus.loading)
                    Center(child: RefreshProgressIndicator())
                ] +
                state.messages
                    .map((message) => ListTile(
                          leading: Icon(Icons.person),
                          title: Text(message.user.username),
                          subtitle: Text(message.text),
                        ))
                    .toList()
                    .reversed
                    .toList(),
          ),
        );
    }
  }
}

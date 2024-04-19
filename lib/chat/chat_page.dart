import 'dart:async';

import 'package:flutter/material.dart';

import 'message.dart';
import 'profile.dart';
import 'constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 import 'package:timeago/timeago.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ChatPage(),
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Stream<List<Message>> _messagesStream;
  final Map<String, Profile> _profileCache = {};
  dynamic id;
  dynamic userTo;
  dynamic myUserId;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      id = ModalRoute.of(context)?.settings.arguments as Map?;
      userTo = id['user_to'];
    });
    myUserId = supabase.auth.currentUser!.id;
    print('this is my user id $myUserId');
    _messagesStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        //  .inFilter('profile_id', [userTo, myUserId])
        .order('created_at')
        .map((maps) => maps
        .map((map) => Message.fromMap(map: map, myUserId: myUserId))
        .toList());
    // print(_messagesStream);
    super.initState();
  }

  Future<void> _loadProfileCache(String profileId) async {
    try{
      if (_profileCache[profileId] != null) {
      return;
    }
    final data =
    await supabase.from('profile').select().eq('user_id', profileId).single();
    final profile = Profile.fromMap(data);
    setState(() {
      _profileCache[profileId] = profile;
    });
    }
    catch(_){
      print('exceptionnnnn');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<Message>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                    child: Text('Start your conversation now :)'),
                  )
                      : ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      /// I know it's not good to include code that is not related
                      /// to rendering the widget inside build method, but for
                      /// creating an app quick and dirty, it's fine 😂
                      _loadProfileCache(message.profileId);
                      // if (message.userTo == userTo || message.userTo == myUserId) {
                      //   return _ChatBubble(
                      //   message: message,
                      //   profile: _profileCache[message.profileId],
                      // );
                      // } else {
                      //    return const SizedBox(height: 1);
                      // }
                      return _ChatBubble(
                        message: message,
                        profile: _profileCache[message.profileId],
                      );
                    },
                  ),
                ),
                const _MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends StatefulWidget {
  const _MessageBar({
    Key? key,
  }) : super(key: key);

  @override
  State<_MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;
  dynamic userTo;
  dynamic id;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _submitMessage(),
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
    Future.delayed(Duration.zero, () async {
      id = ModalRoute.of(context)?.settings.arguments as Map?;
      userTo = id['user_to'];
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final text = _textController.text;
    final myUserId = supabase.auth.currentUser!.id;
    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    try {
      await supabase.from('messages').insert({
        'profile_id': myUserId,
        'content': text,
        'user_to': userTo
      });
    } on PostgrestException catch (error) {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
    required this.profile,
  }) : super(key: key);

  final Message message;
  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null
              ? preloader
              : Text(profile!.username.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.createdAt, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
        message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}

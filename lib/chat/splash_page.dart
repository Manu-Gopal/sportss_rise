import 'package:flutter/material.dart';
import 'chat_page.dart';
// import 'register_page.dart';
import 'constants.dart';

/// Page to redirect users to the appropriate page depending on the initial auth state
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await for for the widget to mount
    await Future.delayed(Duration.zero);

    final session = supabase.auth.currentSession;
    if (session == null) {
      // ignore: use_build_context_synchronously
      // Navigator.of(context)
      //     .pushAndRemoveUntil(RegisterPage.route(), (route) => false);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushAndRemoveUntil(ChatPage.route(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: preloader);
  }
}

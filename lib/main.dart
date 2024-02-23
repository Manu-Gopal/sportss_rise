import 'package:flutter/material.dart';
// import 'package:sportss_rise/screens/athlete_account.dart';
// import 'package:sportss_rise/screens/athlete_login.dart';
import 'package:sportss_rise/screens/homepage.dart';
import 'package:sportss_rise/screens/sports_authority_account.dart';
import 'package:sportss_rise/screens/sports_authority_home.dart';
import 'package:sportss_rise/screens/sports_authority_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
    url: dotenv.env['URL']!,
    anonKey: dotenv.env['PUBLIC_KEY']!
  );
  runApp(const SportsRise());
}

class SportsRise extends StatelessWidget {
  const SportsRise({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SportsRise",
      initialRoute: '/',
      routes: {
        '/' : (context) => const HomePage(),
        '/sports_authority_login' :(context) => const SportsAuthorityLogin(),
        // '/athlete_login' :(context) => const AthleteLogin(),
        '/sports_authority_account' :(context) => SportsAuthorityAccount(),
        // '/athlete_account' :(context) => AthleteAccount(),
        '/sports_authority_home' :(context) => const SportsAuthorityHome(),
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sportss_rise/chat/chat_page.dart';
import 'package:sportss_rise/screens/athlete_badminton.dart';
import 'package:sportss_rise/screens/athlete_basketball.dart';
import 'package:sportss_rise/screens/athlete_connect.dart';
import 'package:sportss_rise/screens/athlete_connect_video.dart';
import 'package:sportss_rise/screens/athlete_cricket.dart';
import 'package:sportss_rise/screens/athlete_edit_profile.dart';
import 'package:sportss_rise/screens/athlete_follow_list.dart';
import 'package:sportss_rise/screens/athlete_following_list.dart';
import 'package:sportss_rise/screens/athlete_football.dart';
import 'package:sportss_rise/screens/athlete_main.dart';
import 'package:sportss_rise/screens/athlete_network.dart';
import 'package:sportss_rise/screens/athlete_profile.dart';
import 'package:sportss_rise/screens/athlete_profile_video.dart';
import 'package:sportss_rise/screens/athlete_search.dart';
import 'package:sportss_rise/screens/athlete_swimming.dart';
import 'package:sportss_rise/screens/athlete_volleyball.dart';
import 'package:sportss_rise/screens/coach_add_news.dart';
import 'package:sportss_rise/screens/coach_athlete_connect.dart';
import 'package:sportss_rise/screens/coach_athlete_search.dart';
import 'package:sportss_rise/screens/coach_athlete_search_page.dart';
import 'package:sportss_rise/screens/coach_homepage.dart';
import 'package:sportss_rise/screens/coach_login.dart';
import 'package:sportss_rise/screens/coach_manage_news.dart';
import 'package:sportss_rise/screens/homepage.dart';
import 'package:sportss_rise/screens/athlete_account.dart';
import 'package:sportss_rise/screens/athlete_home.dart';
import 'package:sportss_rise/screens/athlete_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sportss_rise/screens/news_search.dart';
import 'package:sportss_rise/screens/news_view.dart';
import 'package:sportss_rise/screens/picture_view.dart';
import 'package:sportss_rise/screens/sai_add_coach.dart';
import 'package:sportss_rise/screens/sai_coach_profile.dart';
import 'package:sportss_rise/screens/sai_coach_search_page.dart';
import 'package:sportss_rise/screens/sai_coaches_search.dart';
import 'package:sportss_rise/screens/sai_homepage.dart';
import 'package:sportss_rise/screens/sai_news_search_page.dart';
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
        '/athlete_login' :(context) => const AthleteLogin(),
        '/athlete_account' :(context) => const AthleteAccount(),
        '/athlete_main' :(context) => const AthleteMain(),
        '/athlete_profile' :(context) => const AthleteProfile(),
        '/athlete_profile_video':(context) => const AthleteProfileVideo(),
        '/athlete_edit_profile' :(context) => const AthleteEditProfile(),
        '/athlete_home' :(context) => const AthleteHome(),
        '/athlete_network' :(context) => const AthleteNetwork(),
        '/athlete_football':(context) => const AthleteFootball(),
        '/athlete_cricket':(context) => const AthleteCricket(),
        '/athlete_badminton':(context) => const AthleteBadminton(),
        '/athlete_basketball':(context) => const AthleteBasketball(),
        '/athlete_swimming':(context) => const AthleteSwimming(),
        '/athlete_volleyball':(context) => const AthleteVolleyball(),
        '/athlete_search':(context) => const AthleteSearch(),
        '/athlete_connect':(context) => const AthleteConnect(),
        '/athlete_connect_video':(context) => const AthleteConnectVideo(),
        '/athlete_follow_list':(context) => const AthleteFollowList(),
        '/athlete_following_list':(context) => const AthleteFollowingList(),
        '/sai_homepage':(context) => const SaiHomePage(),
        '/add_coach':(context) => const SaiAddCoach(),
        '/sai_coaches_search':(context) => const SaiCoachesSearch(),
        '/sai_coach_search':(context) => const SaiCoachSearchPage(),
        '/sai_coach_profile' :(context) => const SaiCoachProfile(),
        '/coach_homepage':(context) => const CoachHomePage(),
        '/coach_login':(context) => const CoachLogin(),
        '/coach_athlete_search':(context) => const CoachAthleteSearch(),
        'coach_athlete_search_page':(context) => const CoachAthleteSearchPage(),
        '/coach_athlete_connect':(context) => const CoachAthleteConnect(),
        '/picture_view':(context) => const PictureView(),
        '/add_news':(context) => const CoachAddNews(),
        '/news_search':(context) => const NewsSearch(),
        '/coach_manage_news':(context) => const CoachManageNews(),
        '/news_view':(context) => const NewsView(),
        '/chat_page':(context) => const ChatPage(),
        '/sai_coach_search_page':(context) => const SaiCoachSearchPage(),
        '/sai_news_search_page':(context) => const SaiNewsSearchPage(),
      },
    );
  }
}
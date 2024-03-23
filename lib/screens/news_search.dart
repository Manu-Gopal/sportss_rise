import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewsSearch extends StatefulWidget {
  const NewsSearch({super.key});

  @override
  State<NewsSearch> createState() => _NewsSearchState();
}

class _NewsSearchState extends State<NewsSearch> {

  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
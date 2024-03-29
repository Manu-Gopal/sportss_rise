import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  dynamic newsId;
  dynamic imageUrl;
  dynamic newsDetails;
  bool isLoading = true;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      newsId = ModalRoute.of(context)?.settings.arguments as Map?;

      await getNews();
    });
  }

  Future getNews() async {
    newsDetails =
        await supabase.from('news').select().match({'id': newsId['news_id']});

    final id = newsDetails[0]['id'];

    if (newsDetails[0]['image'] == true) {
      final String publicUrl = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl('news_images/$id');

      setState(() {
        imageUrl = publicUrl;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: Center(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "News Details",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the entire Row
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/picture_view',
                      arguments: {'imageUrl': imageUrl},
                    );
                  },
                  child: Container(
                    width: 250.0, // Increase the width for a larger image
                    height: 250.0, // Increase the height for a larger image
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                      image: imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imageUrl == null
                        ? const Text('No Image Available')
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Text("Loading...")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        newsDetails[0]['headline'] ??
                            "", // Handle potential null value
                        style: const TextStyle(fontSize: 25.0),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true, // Adjust font size as needed
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
            isLoading
                ? const Text("Loading...")
                : Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const SizedBox(width: 10), // Small space at the left
    Expanded(
      // Ensures the text fills available space
      child: Text(
        newsDetails[0]['description'] ?? "",
        style: const TextStyle(
          fontSize: 18.0,
          overflow: TextOverflow
              .ellipsis, // Truncate if text overflows
        ),
        maxLines: 3, // Limit the number of lines displayed
      ),
    ),
  ],
),

          ],
        ),
      ),
    );
  }
}

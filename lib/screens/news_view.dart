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
        title: const Text('News', style: TextStyle(fontFamily: 'Poppins'),),
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
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
                    fontFamily: 'Poppins'
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
                  MainAxisAlignment.center,
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
                    width: 250.0,
                    height: 250.0,
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
                        ? const Text('No Image Available', style: TextStyle(fontFamily: 'RobotoSlab'),)
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
                            "",
                        style: const TextStyle(fontFamily: 'RobotoSlab', fontSize: 25.0),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            isLoading
                ? const Text("Loading...")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          newsDetails[0]['description'] ?? "",
                          style: const TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 18.0,
                            overflow: TextOverflow
                                .ellipsis,
                          ),
                          maxLines: 3,
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

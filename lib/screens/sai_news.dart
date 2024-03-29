import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaiNews extends StatefulWidget {
  const SaiNews({super.key});

  @override
  State<SaiNews> createState() => _SaiNewsState();
}

class _SaiNewsState extends State<SaiNews> {

  final TextEditingController searchController = TextEditingController();
  final supabase = Supabase.instance.client;
  dynamic newsList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future getNews() async {
    setState(() {
      isLoading = true;
    });
    final newsStream =
        supabase.from('news').stream(primaryKey: ['id']).order('id');
    setState(() {
      newsList = newsStream;
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                  onTap: () {
                    if (searchController.text.isNotEmpty) {
                      Navigator.pushNamed(context, '/news_search',
                          arguments: {'searchText': searchController.text});
                    }
                  },
                  child: const Icon(Icons.search),
                )),
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 55),
                  Expanded(
                    child: Text(
                      'News',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder(
                  stream: newsList,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final newsList = snapshot.data!;
                      return ListView.builder(
                        itemCount: newsList.length,
                        itemBuilder: (context, index) {
                          final news = newsList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context, '/news_view',
                                arguments: {'news_id':news['id']}
                              );
                            },
                            child: Card(
                              elevation: 9,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Handle profile picture view navigation
                                        Navigator.pushNamed(
                                          context,
                                          '/picture_view',
                                          arguments: {
                                            'imageUrl': news['image_url']
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 80.0,
                                        height: 80.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          image: news['image_url'] != null
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                      news['image_url']),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: news['image_url'] == null
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                // Wrap Text with Expanded
                                                child: Text(
                                                  news['description'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap:
                                                      true, // Enable soft wrap
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Optionally add additional text widgets below headline
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
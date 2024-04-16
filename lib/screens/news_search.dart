import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewsSearch extends StatefulWidget {
  const NewsSearch({super.key});

  @override
  State<NewsSearch> createState() => _NewsSearchState();
}

class _NewsSearchState extends State<NewsSearch> {
  final supabase = Supabase.instance.client;
  final TextEditingController searchController = TextEditingController();
  dynamic newsDetails;
  bool isLoading = true;
  // List newsList = [];
  dynamic newsList;
  List newsStream = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      newsDetails = ModalRoute.of(context)?.settings.arguments as Map?;
      getNews();
    });
  }

  Future getNews() async {
    setState(() {
      isLoading = true;
    });

    newsStream = await supabase
        .from('news')
        .select()
        .ilike('headline', '%${newsDetails["searchText"]}%');
    // .ilike('description', '%${newsDetails["searchText"]}%');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search", style: TextStyle(fontFamily: 'Poppins'),),
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
        // centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: isLoading
                      ? const Text('')
                      : newsStream.isEmpty
                          ? const Text('No News')
                          : ListView.builder(
                              itemCount: newsStream.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                              Navigator.pushNamed(
                                context, '/news_view',
                                arguments: {'news_id':newsStream[index]['id']}
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Handle profile picture view navigation
                                            Navigator.pushNamed(
                                              context,
                                              '/picture_view',
                                              arguments: {
                                                'imageUrl': newsStream[index]
                                                    ['image_url']
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
                                              image: newsStream[index]
                                                          ['image_url'] !=
                                                      null
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          newsStream[index]
                                                              ['image_url']),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                            ),
                                            child: newsStream[0]['image_url'] ==
                                                    null
                                                ? const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                        ),
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
                                                    newsStream[index]
                                                        ['headline'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      fontFamily: 'RobotoSlab'
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap:
                                                        true, // Enable soft wrap
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                  
                                )
                            
                                );
                                
                              }))
            ],
          ),
        ),
      ),
    );
  }
}

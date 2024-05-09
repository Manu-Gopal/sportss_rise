import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoachManageNews extends StatefulWidget {
  const CoachManageNews({super.key});

  @override
  State<CoachManageNews> createState() => _CoachManageNewsState();
}

class _CoachManageNewsState extends State<CoachManageNews> {
  final TextEditingController searchController = TextEditingController();
  final supabase = Supabase.instance.client;
  dynamic currentUserID = Supabase.instance.client.auth.currentUser!.id;
  dynamic newsList;
  bool isLoading = false;

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
        title: const Text('SportsRise',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        // centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 11, 72, 103),
      ),
      drawer: const CustomDrawer(),
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
                          fontFamily: 'Poppins'),
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
                                context,
                                '/news_view',
                                arguments: {'news_id': news['id']},
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
                                child: Stack(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
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
                                        const SizedBox(width: 7),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          '/news_view',
                                                          arguments: {
                                                            'news_id':
                                                                news['id']
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        news['headline'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'RobotoSlab',
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: -15,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        color:
                                            news['created_by'] == currentUserID
                                                ? Colors.red
                                                : Colors.grey,
                                        onPressed: news['created_by'] ==
                                                currentUserID
                                            ? () async {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Confirm Delete"),
                                                      content: const Text(
                                                          "Are you sure you want to delete?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              "Cancel"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await supabase
                                                                .from('news')
                                                                .delete()
                                                                .match({
                                                              'created_by':
                                                                  currentUserID
                                                            });
                                                            setState(() {
                                                              newsList.removeAt(
                                                                  index);
                                                            });
                                                            // ignore: use_build_context_synchronously
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                              content: Text(
                                                                  'News Deleted Successfully.'),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          3),
                                                            ));
                                                            // ignore: use_build_context_synchronously
                                                            Navigator.pop(
                                                                context); // Close the dialog
                                                          },
                                                          child: const Text(
                                                              "Delete"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                // await supabase.from('news').delete().match({'created_by':currentUserID});
                                              }
                                            : null,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_news');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 231, 162, 87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20), // Adjust the value for circular edges
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24), // Adjust the padding for size
                ),
                child: const Text(
                  'Add News',
                  style: TextStyle(
                      color: Colors.white, // Set the text color
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoSlab'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final supabase = Supabase.instance.client;
  dynamic useremail = '';

  @override
  void initState() {
    super.initState();
    useremail = supabase.auth.currentUser!.email;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            accountEmail: Text(useremail,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            decoration: const BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                image: AssetImage('images/sai_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            onTap: () async {
              await Supabase.instance.client.auth.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, '/');
            },
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.black,
            ),
            title: const Text(
              "Log Out",
              style: TextStyle(
                  // fontFamily: 'RobotoSlab',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

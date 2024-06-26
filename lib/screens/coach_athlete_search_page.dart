import 'package:flutter/material.dart';
import 'package:sportss_rise/chat/constants.dart';

class CoachAthleteSearchPage extends StatefulWidget {
  const CoachAthleteSearchPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CoachAthleteSearchPageState createState() => _CoachAthleteSearchPageState();
}

class _CoachAthleteSearchPageState extends State<CoachAthleteSearchPage> {
  final TextEditingController searchController = TextEditingController();
  dynamic searchDetails;
  dynamic searchList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    searchDetails = await supabase
        .from('search')
        .stream(primaryKey: ['id'])
        .eq('category', 'coach_athlete')
        .order('id');

    setState(() {
      searchList = searchDetails;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      
      backgroundColor: Colors.grey[200],
      body: Container(
        
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/search.png"),
            
          ),
          
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 5.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const BackButton(),
                  SizedBox(
                    height: 52,
                    width: screenWidth * 0.8,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        filled: true,
                        fillColor: Colors.white70,
                        prefixIcon: GestureDetector(
                          onTap: () async {
                            if (searchController.text.isNotEmpty) {
                              try {
                                await supabase.from('search').insert({
                                  'content': searchController.text,
                                  'category': 'coach_athlete'
                                });
                                // ignore: use_build_context_synchronously
                                Navigator.pushNamed(
                                  context,
                                  '/sai_coaches_search',
                                  arguments: {
                                    'searchText': searchController.text
                                  },
                                );
                              } catch (error) {
                                print(error.toString());
                              }
                            }
                          },
                          child: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Colors.grey), // Adjust border radius here
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    'Recent Searches',
                    style: TextStyle(fontSize: 17, fontFamily: 'RobotoSlab'),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: StreamBuilder(
                  stream: searchList,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && searchList != null) {
                      final searchListData = snapshot.data;
                      if (searchListData.length > 0) {
                      return ListView.builder(
                        itemCount: searchListData.length,
                        itemBuilder: (context, index) {
                          final search = searchListData[index];
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  searchController.text = search['content'];
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: Text(
                                    search['content'],
                                    style: const TextStyle(fontSize: 16.0, fontFamily: 'RobotoSlab'),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () async {
                                  await supabase
                                      .from('search')
                                      .delete()
                                      .eq('content', search['content'])
                                      .eq('category', 'coach_athlete');
                                  setState(() {
                                    searchListData.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 60),
                            Text(
                              'No Recent Searches',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RobotoSlab'
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    } 
                    else {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Recent Searches',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RobotoSlab'
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}

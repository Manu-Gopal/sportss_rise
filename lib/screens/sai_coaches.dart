import 'package:flutter/material.dart';

class SaiCoaches extends StatefulWidget {
  const SaiCoaches({super.key});

  @override
  State<SaiCoaches> createState() => _SaiCoachesState();
}

class _SaiCoachesState extends State<SaiCoaches> {

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coaches'),
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
                      if (searchController.text.isNotEmpty){
                        Navigator.pushNamed(context,'/sai_coaches_search', arguments: {
                          'searchText': searchController.text
                        });
                      }
                    },
                    child: const Icon(Icons.search),
                  )
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_coach');
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
                    'Add Coach',
                    style: TextStyle(
                      color: Colors.white, // Set the text color
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
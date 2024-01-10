import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imageUrls = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 400), () {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.unsplash.com/photos/random?count=36&client_id=Yte7gbZLt_59ZtngWJ3Wgt4QD2-OJmv7ALc-YO8bLjY'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> urls = data.map((image) => image['urls']['regular'].toString()).toList();
      setState(() {
        imageUrls = urls;
      });
    } else {
      throw Exception('Failed to load photos');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          children: [
            const Icon(Icons.photo_album),
            const SizedBox(width: 35),
            const Text('My Photos', style: TextStyle(color: Colors.black, fontSize: 25.0)),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: isLoading?
       Center(
              child: CircularProgressIndicator(
                strokeWidth: 6.0,
                color: Colors.White,
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullViewPage(imageUrl: imageUrls[index]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 5.0,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class FullViewPage extends StatefulWidget {
  final String imageUrl;

  FullViewPage({required this.imageUrl});

  @override
  _FullViewPageState createState() => _FullViewPageState();
}

class _FullViewPageState extends State<FullViewPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 400), () {
      fetchData();
    });
  }

  Future<void> fetchData() async {
     setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(widget.imageUrl));
    if (response.statusCode == 200) {
      
    } else {
      throw Exception('Failed to load photos');
    }

    setState(() {
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 221, 161, 139),
        title: Row(
          children: [
            Text('Full View Images', style: TextStyle(color: Colors.black, fontSize: 25.0)),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: Stack(
        children: [
          Center(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                strokeWidth: 7.0,
              ),
            ),
        ],
      ),
    );
  }
}

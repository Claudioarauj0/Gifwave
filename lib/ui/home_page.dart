import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:giphy/ui/gif_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;
  final TextEditingController _searchController = TextEditingController();

  Future<Map<String, dynamic>> _getGifs() async {
    String baseUrl = "https://api.giphy.com/v1/gifs/";
    String apiKey = "Hajh2f9qeug3w622zJmLGk20KbTqtdTL";

    String endpoint = _search.isEmpty
        ? "trending?api_key=$apiKey&limit=21&offset=$_offset&rating=g&bundle=messaging_non_clips"
        : "search?api_key=$apiKey&q=$_search&limit=21&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips";

    Uri uri = Uri.parse(baseUrl + endpoint);

    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar os gifs');
    }
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "GifWave",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return createGifTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    // ignore: unnecessary_null_comparison
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.00),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (index < snapshot.data["data"].length) {
          return GestureDetector(
            child: Image.network(
              snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index])));
            },
           onLongPress: (){
              share(snapshot.data['data'][index]['images']['fixed_height']['url']);
            },
          );
        } else {
          return GestureDetector(
              child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add,
                color: Colors.white,
                size: 70.0,
              ),
              Text(
                "Carregar mais...",
                style: TextStyle(color: Colors.white, fontSize: 22.0),
              )
            ],
          ),
           onTap: () {
              setState(() {
                _offset += 19;
              });
            }, // Fechei o onTap corretamente.
          );
        }
      },
    );
  }
}

void share(data) {
}
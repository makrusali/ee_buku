import 'package:ee_buku/screens/content_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ee_buku/content_model.dart';
import 'loding_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loadingState = true;
  List<Content> _content = [];

  @override
  void initState() {
    super.initState();

    getContentData();
    setState(() {});
  }

  Future getContentData() async {
    try {
      Uri url = Uri.parse(
          "https://raw.githubusercontent.com/makrusali/ee_buku_repo/main/konten.json");
      final response = await http.get(url);
      final Map<String, dynamic> data;

      if (response.statusCode == 200) {
        data = (json.decode(response.body) as Map<String, dynamic>);

        ContentModel content = ContentModel.fromJson(data);

        setState(() {
          _content = content.content as List<Content>;
          loadingState = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Moco Tulisan',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  loadingState = true;
                });
                getContentData();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.black,
                size: 34,
              )),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: loadingState == true
            ? const LoadingAnimation()
            : Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    //text
                    Container(
                      margin:
                          const EdgeInsets.only(left: 16, top: 6, bottom: 12),
                      alignment: Alignment.centerLeft,
                      child: const Text('Ayo Moco gawe Hape Mu!'),
                    ),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _content.length,
                            itemBuilder: ((context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ContentScreen(
                                            _content[index].contentUrl == null
                                                ? "Null"
                                                : _content[index]
                                                    .contentUrl
                                                    .toString(),
                                            _content[index].title == null
                                                ? "Null"
                                                : _content[index]
                                                    .title
                                                    .toString())),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 16),
                                  height: 140,
                                  width: MediaQuery.of(context).size.width - 32,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 12, top: 12, bottom: 12),
                                        width: 128,
                                        height: 128,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                _content[index].imageUrl == null
                                                    ? "Null"
                                                    : _content[index]
                                                        .imageUrl
                                                        .toString()),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              height: 94,
                                              child: Text(
                                                _content[index].title == null
                                                    ? "Null"
                                                    : _content[index]
                                                        .title
                                                        .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

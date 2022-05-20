import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'loding_widget.dart';

class ContentScreen extends StatefulWidget {
  final String _contentUrl;
  final String _contentTitle;
  const ContentScreen(this._contentUrl, this._contentTitle, {Key? key})
      : super(key: key);
  @override
  State<ContentScreen> createState() {
    // ignore: no_logic_in_create_state
    return _ContentScreenState(_contentUrl, _contentTitle);
  }
}

class _ContentScreenState extends State<ContentScreen> {
  final String _contentUrl;
  final String _contentTitle;
  String content = "Null";
  bool _loadingState = true;

  _ContentScreenState(this._contentUrl, this._contentTitle);

  @override
  void initState() {
    super.initState();
    getContentData();
  }

  Future getContentData() async {
    try {
      Uri url = Uri.parse(_contentUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          content = response.body.toString();
          _loadingState = false;
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
        title: Text(_contentTitle,
            style: const TextStyle(
                color: Colors.black, overflow: TextOverflow.ellipsis)),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: _loadingState == true
          ? const LoadingAnimation()
          : ListView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.vertical,
              children: [
                MarkdownBody(
                  data: content,
                  selectable: true,
                  onTapLink: (text, href, title) {
                    // ignore: deprecated_member_use
                    href != null ? launch(href) : null;
                  },
                )
              ],
            ),
      backgroundColor: Colors.white,
    );
  }
}

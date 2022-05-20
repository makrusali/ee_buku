class ContentModel {
  List<Content>? content;

  ContentModel({this.content});

  ContentModel.fromJson(Map<String, dynamic> json) {
    if (json['Content'] != null) {
      content = <Content>[];
      json['Content'].forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['Content'] = content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  String? title;
  String? imageUrl;
  String? contentUrl;

  Content({this.title, this.imageUrl, this.contentUrl});

  Content.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    imageUrl = json['ImageUrl'];
    contentUrl = json['ContentUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Title'] = title;
    data['ImageUrl'] = imageUrl;
    data['ContentUrl'] = contentUrl;
    return data;
  }
}

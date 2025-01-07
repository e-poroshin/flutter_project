class NewsArticle {
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? source;

  NewsArticle({this.title, this.description, this.urlToImage, this.source});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      source: json['source']?['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'source': source,
    };
  }

  factory NewsArticle.fromMap(Map<String, dynamic> map) {
    return NewsArticle(
      title: map['title'],
      description: map['description'],
      urlToImage: map['urlToImage'],
      source: map['source'],
    );
  }
}

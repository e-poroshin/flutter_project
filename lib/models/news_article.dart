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
}
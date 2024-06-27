
class News  {
  News({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
    required this.content,
    required this.author,
    required this.publisher,
    this.isLiked = false,
  });

  final String title;
  final String description;
  final String imageUrl;
  final DateTime publishedAt;
  final String content;
  final String author;
  final String publisher;
  bool isLiked;

  @override
  String toString() {
    return 'News{title: $title, description: $description, imageUrl: $imageUrl, publishedAt: $publishedAt, content: $content, author: $author, publisher: $publisher, isLiked: $isLiked}';
  }

}

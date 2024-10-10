
class MediaPost {
  final String id;
  final String mediaProductType;
  final String mediaType;
  final String? mediaUrl;
  final String permalink;
  final Map<String, dynamic> owner;
  final String username;
  final String? text;
  final String timestamp;
  final String shortcode;
  final String? thumbnailUrl;
  final Map<String, dynamic>? children;
  final bool isQuotePost;

  MediaPost({
    required this.id,
    required this.mediaProductType,
    required this.mediaType,
    this.mediaUrl,
    required this.permalink,
    required this.owner,
    required this.username,
    this.text,
    required this.timestamp,
    required this.shortcode,
    this.thumbnailUrl,
    this.children,
    required this.isQuotePost,
  });

  // Factory constructor to create a MediaPost object from JSON
  factory MediaPost.fromJson(Map<String, dynamic> json) {
    return MediaPost(
      id: json['id'],
      mediaProductType: json['media_product_type'],
      mediaType: json['media_type'],
      mediaUrl: json['media_url'],
      permalink: json['permalink'],
      owner: json['owner'],
      username: json['username'],
      text: json['text'],
      timestamp: json['timestamp'],
      shortcode: json['shortcode'],
      thumbnailUrl: json['thumbnail_url'],
      children: json['children'],
      isQuotePost: json['is_quote_post'],
    );
  }

  // Method to convert a MediaPost object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_product_type': mediaProductType,
      'media_type': mediaType,
      'media_url': mediaUrl,
      'permalink': permalink,
      'owner': owner,
      'username': username,
      'text': text,
      'timestamp': timestamp,
      'shortcode': shortcode,
      'thumbnail_url': thumbnailUrl,
      'children': children,
      'is_quote_post': isQuotePost,
    };
  }
}

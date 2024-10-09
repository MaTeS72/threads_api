import 'package:dio/dio.dart';

abstract class ThreadsApi {
  factory ThreadsApi(String accessToken) => _ThreadsApi(accessToken);

  ThreadsProfileService get profile;

  ThreadsMediaService get media;
}

class _ThreadsApi implements ThreadsApi {
  final String accessToken;

  _ThreadsApi(this.accessToken)
      : profile = ThreadsProfileService(accessToken),
        media = ThreadsMediaService(accessToken);

  @override
  final ThreadsProfileService profile;

  @override
  final ThreadsMediaService media;
}

// ThreadsProfileService

abstract class ThreadsProfileService {
  factory ThreadsProfileService(String accessToken) =>
      _ThreadsProfileService(accessToken);

  Future<ProfileInfo> getUserProfile({
    required String userId,
  });
}

class _ThreadsProfileService implements ThreadsProfileService {
  final String accessToken;

  _ThreadsProfileService(this.accessToken);

  /// Get the profile of a user.

  @override
  Future<ProfileInfo> getUserProfile({
    required String userId,
  }) async {
    try {
      final response = await Dio()
          .get('https://graph.threads.net/v1.0/$userId', queryParameters: {
        'fields':
            'id,username,name,threads_profile_picture_url,threads_biography',
        'access_token': accessToken,
      });

      return ProfileInfo.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get user profile');
    }
  }
}

// ThreadsMediaService

abstract class ThreadsMediaService {
  factory ThreadsMediaService(String accessToken) =>
      _ThreadsMediaService(accessToken);

  Future<List<MediaPost>> getUserThreads({
    required String userId,
  });

  Future<MediaPost> getThreadById({
    required String postId,
  });

  Future<String> createThreadContainer({
    required String userId,
    required String text,
  });

  Future<String> postThread({
    required String userId,
    required String mediaContainerId,
  });
}

class _ThreadsMediaService implements ThreadsMediaService {
  final String accessToken;

  _ThreadsMediaService(this.accessToken);

  /// Get the threads of a user.

  @override
  Future<List<MediaPost>> getUserThreads({
    required String userId,
  }) async {
    try {
      final response = await Dio().get(
          'https://graph.threads.net/v1.0/$userId/threads',
          queryParameters: {
            'fields':
                'id,media_product_type,media_type,media_url,permalink,owner,username,text,timestamp,shortcode,thumbnail_url,children,is_quote_post,quote_post_id',
            'access_token': accessToken,
          });

      final data = response.data['data']
          .map<MediaPost>((post) => MediaPost.fromJson(post))
          .toList();

      return data;
    } catch (e) {
      throw Exception('Failed to get user Threads');
    }
  }

  @override
  Future<MediaPost> getThreadById({
    required String postId,
  }) async {
    try {
      final response = await Dio()
          .get('https://graph.threads.net/v1.0/$postId', queryParameters: {
        'fields':
            'id,media_product_type,media_type,media_url,permalink,owner,username,text,timestamp,shortcode,thumbnail_url,children,is_quote_post',
        'access_token': accessToken,
      });

      final data = MediaPost.fromJson(response.data);

      return data;
    } catch (e) {
      throw Exception('Failed to get Thread post');
    }
  }

  @override
  Future<String> createThreadContainer(
      {required String userId,
      String? text,
      String? imageUrl,
      String mediaType = 'TEXT'}) async {
    assert(text != null || imageUrl != null);
    try {
      final response = await Dio().post(
          'https://graph.threads.net/v1.0/$userId/threads',
          queryParameters: {
            'media_type': mediaType,
            'text': text,
            'image_url': imageUrl,
            'access_token': accessToken,
          });

      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to get user Threads $e');
    }
  }

  @override
  Future<String> postThread({
    required String userId,
    required String mediaContainerId,
  }) async {
    try {
      final response = await Dio().post(
          'https://graph.threads.net/v1.0/$userId/threads_publish',
          queryParameters: {
            'creation_id': mediaContainerId,
            'access_token': accessToken,
          });

      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to get user Threads $e');
    }
  }
}

class ProfileInfo {
  final String id;
  final String username;
  final String name;
  final String threadsProfilePictureUrl;
  final String threadsBiography;

  ProfileInfo({
    required this.id,
    required this.username,
    required this.name,
    required this.threadsProfilePictureUrl,
    required this.threadsBiography,
  });

  // Factory constructor to create a ProfileInfo object from JSON
  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      threadsProfilePictureUrl: json['threads_profile_picture_url'],
      threadsBiography: json['threads_biography'],
    );
  }

  // Method to convert a ProfileInfo object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'threads_profile_picture_url': threadsProfilePictureUrl,
      'threads_biography': threadsBiography,
    };
  }
}

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

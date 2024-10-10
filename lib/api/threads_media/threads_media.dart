import 'package:threads_api/api/base_service.dart';
import 'package:threads_api/api/models/media_post.dart';

abstract class ThreadsMediaService {
  factory ThreadsMediaService({required String accessToken}) =>
      _ThreadsMediaService(accessToken: accessToken);

  Future<List<MediaPost>> getUserThreads({
    required String userId,
  });

  Future<MediaPost> getThreadById({
    required String postId,
  });

  Future<String> createThreadContainer(
      {required String userId,
      String? text,
      String? imageUrl,
      String mediaType});

  Future<String> postThread({
    required String userId,
    required String mediaContainerId,
  });
}

class _ThreadsMediaService extends BaseService implements ThreadsMediaService {
  _ThreadsMediaService({required super.accessToken});

  /// Get the threads of a user.

  @override
  Future<List<MediaPost>> getUserThreads({
    required String userId,
  }) async {
    try {
      final response = await super.get(
          'https://graph.threads.net/v1.0/$userId/threads',
          queryParameters: {
            'fields':
                'id,media_product_type,media_type,media_url,permalink,owner,username,text,timestamp,shortcode,thumbnail_url,children,is_quote_post,quote_post_id',
          });

      return response.data['data']
          .map<MediaPost>((thread) => MediaPost.fromJson(thread))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user Threads');
    }
  }

  @override
  Future<MediaPost> getThreadById({
    required String postId,
  }) async {
    try {
      final response = await super
          .get('https://graph.threads.net/v1.0/$postId', queryParameters: {
        'fields':
            'id,media_product_type,media_type,media_url,permalink,owner,username,text,timestamp,shortcode,thumbnail_url,children,is_quote_post',
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
      final response = await super.post(
          'https://graph.threads.net/v1.0/$userId/threads',
          queryParameters: {
            'media_type': mediaType,
            'text': text,
            'image_url': imageUrl,
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
      final response = await super.post(
          'https://graph.threads.net/v1.0/$userId/threads_publish',
          queryParameters: {
            'creation_id': mediaContainerId,
          });

      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to get user Threads $e');
    }
  }
}

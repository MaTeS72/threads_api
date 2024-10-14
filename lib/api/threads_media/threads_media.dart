import 'package:threads_api/api/base_service.dart';
import 'package:threads_api/api/models/fields.dart';
import 'package:threads_api/api/models/media_post.dart';

abstract class ThreadsMediaService {
  factory ThreadsMediaService({required String accessToken}) =>
      _ThreadsMediaService(accessToken: accessToken);

  Future<List<MediaPost>> getUserThreads({
    required String userId,
    List<MediaFields>? fields,
  });

  Future<MediaPost> getThreadById({
    required String postId,
    List<MediaFields>? fields,
  });

  Future<String> createThreadContainer({
    required String userId,
    String? text,
    String? imageUrl,
    String? inReplyToId,
    String? quotePostId,
    String mediaType,
    bool isCarouselItem,
    List<String>? children,
  });

  Future<String> postThread({
    required String userId,
    required String mediaContainerId,
  });

  Future<String> repostThread({
    required String postId,
  });

  Future<List<MediaPost>> getReplies({
    required String postId,
    List<MediaFields>? fields,
  });

  Future<List<MediaPost>> getConversations({
    required String postId,
    List<MediaFields>? fields,
  });

  Future<Map<String, dynamic>> getMediaInsights({
    required String postId,
    List<MediaInsightFields>? fields,
  });
}

class _ThreadsMediaService extends BaseService implements ThreadsMediaService {
  _ThreadsMediaService({required super.accessToken});

  /// Get the threads of a user.

  @override
  Future<List<MediaPost>> getUserThreads({
    required String userId,
    List<MediaFields>? fields,
  }) async {
    try {
      final response = await super.get(
          'https://graph.threads.net/v1.0/$userId/threads',
          queryParameters: {
            'fields': getFieldsParam(fields),
          });

      return response.data['data']
          .map<MediaPost>((thread) => MediaPost.fromJson(thread))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user Threads $e');
    }
  }

  @override
  Future<MediaPost> getThreadById({
    required String postId,
    List<MediaFields>? fields,
  }) async {
    try {
      final response = await super
          .get('https://graph.threads.net/v1.0/$postId', queryParameters: {
        'fields': getFieldsParam(fields),
      });

      final data = MediaPost.fromJson(response.data);

      return data;
    } catch (e) {
      throw Exception('Failed to get Thread post $e');
    }
  }

  @override
  Future<String> createThreadContainer(
      {required String userId,
      String? text,
      String? imageUrl,
      String? inReplyToId,
      String mediaType = 'TEXT',
      String? quotePostId,
      bool? isCarouselItem,
      List<String>? children}) async {
    assert(text != null || imageUrl != null);
    try {
      final response = await super.post(
          'https://graph.threads.net/v1.0/$userId/threads',
          queryParameters: {
            'media_type': mediaType,
            'text': text,
            'image_url': imageUrl,
            'quote_post_id': quotePostId,
            'reply_to_id': inReplyToId,
            'is_carousel_item': isCarouselItem,
            'children': children?.join(',')
          });

      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to post container $e');
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
      throw Exception('Failed to post Thread $e');
    }
  }

  @override
  Future<String> repostThread({
    required String postId,
  }) async {
    try {
      final response = await super.post(
        'https://graph.threads.net/v1.0/$postId/repost',
      );

      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to post Thread $e');
    }
  }

  @override
  Future<List<MediaPost>> getReplies({
    required String postId,
    List<MediaFields>? fields, // Optional fields parameter
  }) async {
    try {
      final response = await super.get(
        'https://graph.threads.net/v1.0/$postId/replies',
        queryParameters: {
          'fields': getFieldsParam(fields),
        },
      );

      return response.data['data']
          .map<MediaPost>((reply) => MediaPost.fromJson(reply))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch replies $e');
    }
  }

  @override
  Future<List<MediaPost>> getConversations({
    required String postId,
    List<MediaFields>? fields, // Optional fields parameter
  }) async {
    try {
      final response = await super.get(
        'https://graph.threads.net/v1.0/$postId/conversation',
        queryParameters: {
          'fields': getFieldsParam(fields),
        },
      );

      return response.data['data']
          .map<MediaPost>((conversation) => MediaPost.fromJson(conversation))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch conversations $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMediaInsights({
    required String postId,
    List<MediaInsightFields>? fields,
  }) async {
    try {
      final response = await super.get(
          'https://graph.threads.net/v1.0/$postId/insights',
          queryParameters: {
            'metric': getMediaInsightFieldsParam(fields),
          });

      final insights = response.data['data'] as List<dynamic>;

      // Process the insights to create the desired map
      final Map<String, dynamic> insightsMap = {};

      for (var insight in insights) {
        final String name = insight['name'];
        final int value = insight['values'][0]['value'];
        insightsMap[name] = value;
      }

      return insightsMap;
    } catch (e) {
      throw Exception('Failed to get media insights $e');
    }
  }
}

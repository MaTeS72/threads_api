import 'package:threads_api/api/base_service.dart';
import 'package:threads_api/api/models/media_post.dart';
import 'package:threads_api/api/models/profile_info.dart';

abstract class ThreadsProfileService {
  factory ThreadsProfileService({required String accessToken}) =>
      _ThreadsProfileService(accessToken: accessToken);

  Future<ProfileInfo> getUserProfile({
    required String userId,
  });

  Future<Map<String, dynamic>> getProfileInsights({
    required String userId,
  });

  Future<List<MediaPost>> getUserReplies({
    required String userId,
  });
}

class _ThreadsProfileService extends BaseService
    implements ThreadsProfileService {
  _ThreadsProfileService({required super.accessToken});

  /// Get the profile of a user.

  @override
  Future<ProfileInfo> getUserProfile({
    required String userId,
  }) async {
    try {
      final response = await super
          .get('https://graph.threads.net/v1.0/$userId', queryParameters: {
        'fields':
            'id,username,name,threads_profile_picture_url,threads_biography',
      });

      return ProfileInfo.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get user profile');
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileInsights({
    required String userId,
  }) async {
    try {
      final response = await super.get(
          'https://graph.threads.net/v1.0/$userId/threads_insights',
          queryParameters: {
            'metric': 'followers_count',
          });

      return response.data;
    } catch (e) {
      throw Exception('Failed to get user profile insights');
    }
  }

  @override
  Future<List<MediaPost>> getUserReplies({
    required String userId,
  }) async {
    try {
      final response = await super.get(
        'https://graph.threads.net/v1.0/$userId/replies',
        queryParameters: {
          'fields': 'id,text,username,permalink,timestamp,media_product_type,'
              'media_type,media_url,shortcode,thumbnail_url,children,'
              'is_quote_post,has_replies,root_post,replied_to,is_reply,'
              'is_reply_owned_by_me,reply_audience',
        },
      );

      return response.data['data']
          .map<MediaPost>((reply) => MediaPost.fromJson(reply))
          .toList();
    } catch (e) {
      throw Exception('Failed to retrieve user replies');
    }
  }
}

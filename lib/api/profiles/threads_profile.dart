import 'package:threads_api/api/base_service.dart';
import 'package:threads_api/api/models/fields.dart';
import 'package:threads_api/api/models/media_post.dart';
import 'package:threads_api/api/models/profile_info.dart';

abstract class ThreadsProfileService {
  factory ThreadsProfileService({required String accessToken}) =>
      _ThreadsProfileService(accessToken: accessToken);

  Future<ProfileInfo> getUserProfile({
    required String userId,
    List<ProfileFields>? fields,
  });

  Future<Map<String, dynamic>> getProfileInsights({
    required String userId,
    List<ProfileInsightFields>? fields,
  });

  Future<List<MediaPost>> getUserReplies({
    required String userId,
    List<MediaFields>? fields,
  });
}

class _ThreadsProfileService extends BaseService
    implements ThreadsProfileService {
  _ThreadsProfileService({required super.accessToken});

  /// Get the profile of a user.

  @override
  Future<ProfileInfo> getUserProfile({
    required String userId,
    List<ProfileFields>? fields,
  }) async {
    try {
      final response = await super
          .get('https://graph.threads.net/v1.0/$userId', queryParameters: {
        'fields': getProfileFieldsParam(fields),
      });

      return ProfileInfo.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get user profile');
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileInsights({
    required String userId,
    List<ProfileInsightFields>? fields,
  }) async {
    try {
      final response = await super.get(
          'https://graph.threads.net/v1.0/$userId/threads_insights',
          queryParameters: {
            'metric': getUserInsightFieldsParam(fields),
          });

      return response.data;
    } catch (e) {
      throw Exception('Failed to get user profile insights');
    }
  }

  @override
  Future<List<MediaPost>> getUserReplies({
    required String userId,
    List<MediaFields>? fields,
  }) async {
    try {
      final response = await super.get(
        'https://graph.threads.net/v1.0/$userId/replies',
        queryParameters: {
          'fields': getFieldsParam(fields),
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

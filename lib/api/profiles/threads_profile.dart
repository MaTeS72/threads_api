import 'package:threads_api/api/base_service.dart';
import 'package:threads_api/api/models/fields.dart';
import 'package:threads_api/api/models/media_post.dart';
import 'package:threads_api/api/models/profile_info.dart';

abstract class ThreadsProfileService {
  factory ThreadsProfileService({required String accessToken}) =>
      _ThreadsProfileService(accessToken: accessToken);

  /// Retrieves profile information for a specific user by their unique user ID.
  ///
  /// This method fetches the profile information of a user on Threads. You can
  /// specify which profile fields to retrieve by passing a list of `ProfileFields`.
  /// If no fields are specified, the API will return a default set of profile
  /// details.
  ///
  /// ## Parameters:
  /// - `userId` (required): The unique identifier of the user whose profile is
  ///   being requested.
  /// - `fields` (optional): A list of `ProfileFields` to specify which specific
  ///   profile fields to include in the response. If no fields are provided,
  ///   the API returns a default set of fields.
  ///
  /// ## Returns:
  /// - A `Future` that resolves to a `ProfileInfo` object representing the
  ///   user's profile information, such as their name, username, bio, and
  ///   other details.
  ///
  /// ## Errors:
  /// - Throws an `Exception` if the API request fails or if an error occurs
  ///   while processing the response.
  ///
  /// ## API Reference:
  /// - [Get User Profile](https://developers.facebook.com/docs/threads/threads-profiles)
  ///
  /// Example usage:
  /// ```dart
  /// final profile = await threadsMediaService.getUserProfile(
  ///   userId: '1234567890',
  ///   fields: [ProfileFields.id, ProfileFields.username, ProfileFields.bio],
  /// );
  /// ```
  Future<ProfileInfo> getUserProfile({
    required String userId,
    List<ProfileFields>? fields,
  });

  Future<Map<String, dynamic>> getProfileInsights({
    required String userId,
    List<ProfileInsightFields>? fields,
  });

  // Retrieves a list of all replies made by a specific user by their unique user ID.
  ///
  /// This method fetches all replies created by a user on Threads. Optionally,
  /// you can specify which fields to include in the response by passing a list
  /// of `MediaFields`.
  ///
  /// ## Parameters:
  /// - `userId` (required): The unique identifier of the user whose replies
  ///   are being requested.
  /// - `fields` (optional): A list of `MediaFields` to define specific fields
  ///   to include in the response. If no fields are specified, the API returns
  ///   a default set of fields.
  ///
  /// ## Returns:
  /// - A `Future` that resolves to a list of `MediaPost` objects representing
  ///   the replies made by the user.
  ///
  /// ## Errors:
  /// - Throws an `Exception` if the API request fails or if an error occurs
  ///   while processing the response.
  ///
  /// ## API Reference:
  /// - [Retrieve a List of All a User’s Replies](https://developers.facebook.com/docs/threads/reply-management#retrieve-a-list-of-all-a-user-s-replies)
  ///
  /// Example usage:
  /// ```dart
  /// final replies = await threadsMediaService.getUserReplies(
  ///   userId: '1234567890',
  ///   fields: [MediaFields.id, MediaFields.message],
  /// );
  /// ```
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

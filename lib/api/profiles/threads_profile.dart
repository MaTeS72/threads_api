import 'package:threads_api/api/base_service.dart';
import 'package:threads_api/api/models/profile_info.dart';

abstract class ThreadsProfileService {
  factory ThreadsProfileService({required String accessToken}) =>
      _ThreadsProfileService(accessToken: accessToken);

  Future<ProfileInfo> getUserProfile({
    required String userId,
  });
}

class _ThreadsProfileService extends BaseService implements ThreadsProfileService {


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
}

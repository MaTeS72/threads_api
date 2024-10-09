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

  Future<Map<String, dynamic>> getUserThreads({
    required String userId,
  });
}

class _ThreadsMediaService implements ThreadsMediaService {
  final String accessToken;

  _ThreadsMediaService(this.accessToken);

  /// Get the threads of a user.

  @override
  Future<Map<String, dynamic>> getUserThreads({
    required String userId,
  }) {
    return Future.value({});
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

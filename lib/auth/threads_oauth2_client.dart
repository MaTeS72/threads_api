// import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class ThreadsOAuthClient {
  final Dio _dio = Dio();

  final String clientId;
  final String clientSecret;
  final String redirectUri;

  ThreadsOAuthClient({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
  });

  /// Step 1: Build the authorization URL
  String getAuthorizationUrl(List<String> scopes) {
    final queryParams = {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': 'https://openvibe.social/callback',
      'scope': scopes.join(' '),
      'state': '1'
    };

    final uri = Uri.https('threads.net', '/oauth/authorize', queryParams);
    print(uri.toString());
    return uri.toString();
  }
//https://threads.net/oauth/authorize?response_type=code&client_id=902521734538274&redirect_uri=com.example.oauth%3A%2F%2Fcallback%2F&scope=threads_basic+threads_content_publish+threads_read_replies+threads_manage_replies+threads_manage_insights&state=1
  /// Step 2: Open a web popup to authenticate the user
  Future<String> authenticate({
    required String callbackUrlScheme,
    required List<String> scopes,
  }) async {
    final authUrl = getAuthorizationUrl(scopes);

   // Open the authorization URL in the default browser
    final result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: callbackUrlScheme,
    );

    // The `result` contains the final redirect URL with the code
    final code = Uri.parse(result).queryParameters['code'];
    if (code != null) {
      await exchangeCodeForToken(code);
    } else {
      throw Exception('Authorization failed');
    }
    return '';
  }

  /// Step 3: Exchange authorization code for access token
  Future<Map<String, dynamic>> exchangeCodeForToken(String authorizationCode) async {
    final response = await _dio.post(
      'https://graph.threads.net/oauth/access_token',
      data: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
        'code': authorizationCode,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to exchange code for access token');
    }
  }

  /// Step 4: Refresh access token (Optional)
  Future<Map<String, dynamic>> refreshAccessToken(String refreshToken) async {
    final response = await _dio.get(
      'https://graph.threads.net/refresh_access_token',
      queryParameters: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to refresh access token');
    }
  }
}

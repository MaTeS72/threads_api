// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:flutter/material.dart';
import 'package:threads_api/auth/threads_oauth2_client.dart';

void main() {
  runApp(const MaterialApp(home: Example()));
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late ThreadsOAuthClient client;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    client = ThreadsOAuthClient(
      clientId: '1595607288056648', // Replace with your app's client ID
      clientSecret:
          '3f03e02970aae4df6d2c73f1f978b64c', // Replace with your app's client secret
      redirectUri: 'com.example.oauth:/',
          // 'com.example.oauth://callback/', // Replace with the redirect URI set in your app
    );
  }

  void authenticateUser() async {
    final scopes = [
      'threads_basic',
      // 'threads_content_publish',
      // 'threads_read_replies',
      // 'threads_manage_replies',
      // 'threads_manage_insights'
    ]; // Threads API scopes
    final authorizationCode = await client.authenticate(
      callbackUrlScheme: 'com.example.oauth', // Your app's custom scheme
      scopes: scopes,
    );

    print('Authorization Code: $authorizationCode');

    // Step 3: Exchange the authorization code for an access token
    final tokenResponse = await client.exchangeCodeForToken(authorizationCode);

    print('Access Token: ${tokenResponse['access_token']}');
  }

  void refreshUserToken() async {
    final refreshToken =
        'EXISTING_REFRESH_TOKEN'; // Use the saved refresh token

    final newTokenResponse = await client.refreshAccessToken(refreshToken);

    print('New Access Token: ${newTokenResponse['access_token']}');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text('Access Token: $_accessToken'),
              ElevatedButton(
                onPressed: () async {
                  authenticateUser();
                },
                child: const Text('Push!'),
              )
            ],
          ),
        ),
      );
}

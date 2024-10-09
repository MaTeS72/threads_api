// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:flutter/material.dart';
import 'package:threads_api/auth/scopes.dart';
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
      redirectUri: 'https://threads-redirect-test.web.app/example',
    );
  }

  void authenticateUser() async {
    final scopes = [
      Scope.threadsBasic,
      // Scope.threadsContentPublish,
    ]; // Threads API scopes
    final shortLiveToken = await client.authenticate(
      callbackUrlScheme: 'com.example.oauth', // Your app's custom scheme
      scopes: scopes,
    );

    final longLiveToken =
        await client.exchangeForLongLivedToken(shortLiveToken);

    print(longLiveToken);
  }

  void refreshUserToken() async {
    const refreshToken =
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

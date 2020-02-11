// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        final String routeName = settings.name;
        if (routeName.isEmpty) {
          return null;
        }
        final RouteDescription description =
            RouteDescription.fromRawString(routeName);
        final Widget page = _buildForRouteDescription(description);
        return MaterialPageRoute<dynamic>(
            builder: (_) => page, settings: settings);
      },
    );
  }

  Widget _buildForRouteDescription(RouteDescription description) {
    // First try to find the page name in query params.
    switch (description.queryParams['page']) {
      case '/':
        return HomeScreen();
      case '/home':
        return HomeScreen();
      case '/login':
        return LoginPage();
    }

    // Else, try the path itself.
    switch (description.path) {
      case '/':
        return HomeScreen();
      case '/home':
        return HomeScreen();
      case '/login':
        return LoginPage();
    }

    return null;
  }
}

class RouteDescription {
  final String path;
  final Map<String, String> queryParams;

  const RouteDescription._(this.path, this.queryParams);

  factory RouteDescription.fromRawString(String raw) {
    final int queryStringIndex = raw.indexOf('?');
    String path;
    Map<String, String> queryParams;
    if (queryStringIndex == -1) {
      path = raw;
      queryParams = <String, String>{};
    } else {
      path = raw.substring(0, queryStringIndex);
      queryParams = _parseQueryString(raw.substring(queryStringIndex + 1));
    }
    return RouteDescription._(path, queryParams);
  }

  static Map<String, String> _parseQueryString(String queryString) {
    final List<String> parts = queryString.split('&');
    final Iterable<MapEntry<String, String>> entries = parts.map((String part) {
      final List<String> kv = part.split('=');
      assert(kv.length <= 2);
      if (kv.length == 1) {
        return MapEntry<String, String>(kv[0], '1'); // or "true".
      }
      return MapEntry<String, String>(kv[0], kv[1]);
    });
    return Map<String, String>.fromEntries(entries);
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text('Push /login'),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            RaisedButton(
              child: const Text('Push ?page=/login'),
              onPressed: () {
                Navigator.pushNamed(context, '?page=/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login page'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text('Push /'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            RaisedButton(
              child: const Text('Push /home'),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            RaisedButton(
              child: const Text('Push ?page=/home'),
              onPressed: () {
                Navigator.pushNamed(context, '?page=/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}

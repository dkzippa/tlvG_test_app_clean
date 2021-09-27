import 'package:app_01/app_config.dart';
import 'package:app_01/screens/screen_search.dart';
import 'package:app_01/search_provider.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchProvider(
      url: AppConfig.graphqlEndpoint,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: PageSearch(),
      ),
    );
  }
}

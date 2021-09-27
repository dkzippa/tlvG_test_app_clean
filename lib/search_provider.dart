import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> clientFor({
  required String url,
}) {
  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(url),
    ),
  );
}

class SearchProvider extends StatelessWidget {
  final String? url;
  final Widget? child;
  final ValueNotifier<GraphQLClient> client;

  SearchProvider({@required this.url, @required this.child}) : client = clientFor(url: url!);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: child,
    );
  }
}

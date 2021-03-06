import 'package:app_01/models/mission_model.dart';
import 'package:app_01/widgets/astronaut_animation.dart';
import 'package:app_01/widgets/missions_list_item.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../app_config.dart';

class MissionsList extends StatefulWidget {
  final String? searchStr;
  const MissionsList({Key? key, this.searchStr}) : super(key: key);

  @override
  _MissionsListState createState() => _MissionsListState();
}

class _MissionsListState extends State<MissionsList> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String qFetchMissions = """
      query Launches(\$mission_name: String!, \$limit: Int!, \$offset: Int!) {        
        launches(find: {mission_name:\$mission_name}, limit: \$limit, offset: \$offset, sort: "launch_year") {
          id
          mission_name
          details                              
          launch_success
          launch_year
        }        
      }
    """;

    return Query(
      options: QueryOptions(
        fetchPolicy: FetchPolicy.cacheFirst,
        document: gql(qFetchMissions),
        variables: <String, dynamic>{'offset': 0, "mission_name": widget.searchStr, 'limit': AppConfig.limitPerPage},
      ),
      builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Expanded(child: Center(child: Text(result.exception.toString())));
        }
        if (result.isLoading && result.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<MissionModel> missions = result.data!['launches'].map<MissionModel>((missionJsonData) {
          return MissionModel.fromJson(missionJsonData);
        }).toList();

        if (missions.length == 0) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Text('No matches found. Please choose another names, for example "Falcon", "Star", etc',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                  AstronautAnimation(),
                ],
              ),
            ),
          );
        }

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  // color: Colors.yellow,
                  width: double.infinity,
                  height: 100,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: missions.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int idx) {
                      return MissionsListItem(mission: missions[idx]);
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //
                  FetchMoreOptions opts = FetchMoreOptions(
                    variables: {'offset': missions.length},
                    updateQuery: (previousResultData, fetchMoreResultData) {
                      final List<dynamic> repos = [
                        ...previousResultData!['launches'] as List<dynamic>,
                        ...fetchMoreResultData!['launches'] as List<dynamic>
                      ];
                      fetchMoreResultData['launches'] = repos;
                      return fetchMoreResultData;
                    },
                  );

                  fetchMore!(opts);
                },
                child: Text('LOAD MORE'),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:app_01/models/mission_model.dart';
import 'package:app_01/widgets/missions_list_item.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';

class MissionsList extends StatefulWidget {
  final String? searchStr;
  const MissionsList({Key? key, this.searchStr}) : super(key: key);

  @override
  _MissionsListState createState() => _MissionsListState();
}

class _MissionsListState extends State<MissionsList> {
  @override
  Widget build(BuildContext context) {
    String readRepositories = """
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
        document: gql(readRepositories),
        variables: <String, dynamic>{'offset': 0, "mission_name": widget.searchStr, 'limit': 10},
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

        print('\n\n\n\n ------------- \n GET 1 missions.length: ' + result.data.toString());

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
                  Lottie.network('https://assets5.lottiefiles.com/packages/lf20_Bu8wPm.json'),
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
                    itemCount: missions.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int idx) {
                      return MissionsListItem(mission: missions[idx]);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

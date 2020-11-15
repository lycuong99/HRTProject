import 'package:hire_remote_team/models/team.dart';

import 'package:hire_remote_team/providers/networking.dart';

class TeamService {
  NetWorkHelper _netWorkHelper;

  Future<TeamListModel> getRecommendTeams() async {
    String url = TeamConst.URL_GET_RECOMMEND;
    _netWorkHelper = NetWorkHelper(url: url);
    var teams = await _netWorkHelper.getData();
    print(teams);
    TeamListModel teamList = TeamListModel.fromJson(teams);
    return teamList;
  }

  Future<Team> getTeam(teamId) async {
    String url = TeamConst.getURLTeamProfile(teamId);
    _netWorkHelper = NetWorkHelper(url: url);

    var teamJson = await _netWorkHelper.getData();
    print("-- Team InFo: " + teamJson.toString());
    if (teamJson != null) {
      return Team.fromJson(teamJson);
    }
    throw Exception('Failed to load post');
  }

  // Team getExampleTeam() {
  //   Team example = Team(
  //       id: "abcdert",
  //       description:
  //           'Men marry women with the hope they will never change. Women marry men with the hope they will change. Invariably they are both disappointed',
  //       name: "Albert Einstein Team",
  //       leaderId: 'asnkdnqkdd');
  //   return example;
  // }

  // List<Team> getExampleTeams() {
  //   Team example = Team(
  //       id: "abcdert",
  //       salarySuggest: 340,
  //       description:
  //           'Men marry women with the hope they will never change. Women marry men with the hope they will change. Invariably they are both disappointed',
  //       name: "Albert Einstein Team",
  //       leaderId: 'asnkdnqkdd');
  //
  //   Team example1 = Team(
  //       id: "abcaaaa",
  //       salarySuggest: 120,
  //       description:
  //           "I'm selfish, impatient and a little insecure. I make mistakes, I am out of control and at times hard to handle. But if you can't handle me at my worst, then you sure as hell don't deserve me at my best.",
  //       name: "BilGate Team",
  //       leaderId: 'assas');
  //
  //   Team example2 = Team(
  //       id: "abcaaaa",
  //       salarySuggest: 129,
  //       description:
  //           "I'm selfish, impatient and a little insecure. I make mistakes, I am out of control and at times hard to handle. But if you can't handle me at my worst, then you sure as hell don't deserve me at my best.",
  //       name: "Do Nam Trump",
  //       leaderId: 'assassas');
  //   List<Team> teamList = [example, example1, example2];
  //
  //   return teamList;
  // }
}

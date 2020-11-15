import 'package:flutter/material.dart';
import 'package:hire_remote_team/blocs/search_bloc.dart';
import 'package:hire_remote_team/components/filter_modal_bottom.dart';
import 'package:hire_remote_team/components/team_card.dart';
import 'package:hire_remote_team/models/filter.dart';
import 'package:hire_remote_team/models/team.dart';
import 'package:hire_remote_team/ultilites/constants.dart';

typedef ChangeSelectedSortItemCallback = void Function(SortItem sortItem);

class SearchAppBarDelegate extends SearchDelegate<String> {
  FilterObj filterObj = FilterObj();
  SortItem _sortBy;
  final SearchTeamsBloc _searchBloc = SearchTeamsBloc();

  SearchAppBarDelegate() {
    _sortBy = SortItem(sortBy: Sort.NONE);
    filterObj = FilterObj();
  }

  Future<void> updateResult() async {
    await _searchBloc.fetchResultSearch(query, filterObj, _sortBy.sortBy);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
      IconButton(
        icon: Icon(Icons.tune),
        onPressed: () async {
          filterObj = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => FilterModalBottom(
              onPressed: () {
                Navigator.pop(context);
              },
              filterObj: filterObj,
            ),
          );

          updateResult();
        },
      ),
    ];
  }

  @override
  void showResults(BuildContext context) async {
    // TODO: implement showResults
    await updateResult();
    super.showResults(context);
  }

  @override
  void showSuggestions(BuildContext context) {
    // TODO: implement showSuggestions
    super.showSuggestions(context);
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    bool isExpan = false;
    return Center(
      child: Column(
        children: [
          Expansionpanel(
            selectedSortItem: _sortBy,
            onChange: (SortItem sortItemValue) async {
              _sortBy = sortItemValue;
              await updateResult();
            },
          ),
          ResultTeamCard(
            name: 'FPTU Team',
            imgUrl: 'images/avatar_2.jpg',
            rating: 4.2,
          ),
          Expanded(
            child: StreamBuilder<TeamListModel>(
              stream: _searchBloc.stream,
              builder: (context, AsyncSnapshot<TeamListModel> snapshot) {
                if (snapshot.hasData) {
                  return _buildTeamResult(snapshot);
                } else {
                  return Center(child: Text('No recode'));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTeamResult(AsyncSnapshot<TeamListModel> snapshot) {
    List<Team> recommendTeams = snapshot.data.results;
    return ListView(
      children: recommendTeams
          .map((team) => ResultTeamCard(
                name: team.name,
                imgUrl: 'images/avatar_2.jpg',
                rating: team.averageRating,
              ))
          .toList(),
    );

    // return ListView.builder(
    //     primary: true,
    //     shrinkWrap: false,
    //     padding: EdgeInsets.all(1),
    //     scrollDirection: Axis.vertical,
    //     itemCount: recommendTeams.length ?? 0,
    //     itemBuilder: (context, index) {
    //       double paddingLeft = 10;
    //       if (index == 0) {
    //         paddingLeft = kPaddingHorizonApp;
    //       }
    //       Team team = recommendTeams[index];
    //       return ResultTeamCard(
    //         name: team.name,
    //         imgUrl: 'images/avatar_2.jpg',
    //         rating: team.averageRating,
    //       );
    //     });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Item> items = [
      Item(title: 'apple'),
      Item(title: 'mango'),
      Item(title: 'banana'),
      Item(title: 'pineapple'),
      Item(title: 'orange'),
      Item(title: 'oranges'),
    ];
    List<Item> suggestionList = query.isEmpty
        ? items
        : items.where((element) => element.title.startsWith(query)).toList();
    return suggestionList.isEmpty
        ? Text("no result found")
        : ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(suggestionList[index].title),
                onTap: () {
                  showResults(context);
                },
              );
            },
            itemCount: suggestionList.length,
          );
  }
}

class Item {
  final String title;

  Item({@required this.title});
}

List<Item> items = [
  Item(title: 'apple'),
  Item(title: 'mango'),
  Item(title: 'banana'),
  Item(title: 'pineapple'),
  Item(title: 'orange'),
  Item(title: 'oranges'),
];

class Expansionpanel extends StatefulWidget {
  Sort sortBy;
  Expansionpanel({this.sortBy, this.selectedSortItem, this.onChange});
  SortItem selectedSortItem;
  ChangeSelectedSortItemCallback onChange;
  @override
  _ExpansionpanelState createState() => _ExpansionpanelState();
}

class _ExpansionpanelState extends State<Expansionpanel> {
  bool isExpan = false;
  List<SortItem> sortItems =
      Sort.values.map((e) => SortItem(sortBy: e)).toList();
  List<Widget> sortList = [];
  // SortItem selectedSortItem = SortItem(sortBy: Sort.NONE);
  Sort sortBy;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    // selectedSortItem = sortItems[0];
    // print(selectedSortItem.getSortString());
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        isExpan = !isExpan;
        setState(() {});
      },
      children: [
        ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              isExpan = isExpanded;
              return ListTile(
                  leading: Icon(Icons.sort),
                  title: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Sort by ',
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                          text: '${widget.selectedSortItem.getSortString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black))
                    ]),
                  ));
            },
            isExpanded: isExpan,
            body: Column(
              children: sortItems.map((e) {
                return ListTile(
                  title: Text(e.getSortString()),
                  selected: widget.selectedSortItem.sortBy == e.sortBy,
                  onTap: () {
                    isExpan = !isExpan;
                    sortBy = e.sortBy;
                    widget.selectedSortItem = e;

                    widget.onChange(e);
                    setState(() {});
                  },
                );
              }).toList(),
            ))
      ],
    );
  }
}

class SortItem {
  Sort sortBy;
  // bool isSelected;

  SortItem({this.sortBy});

  getSortString() {
    switch (sortBy) {
      case Sort.BY_MAX_PRICE:
        return 'Price Increase';
      case Sort.BY_MIN_PRICE:
        return 'Price Decrease';
      case Sort.BY_MOST_PROJECT:
        return 'Amount of Received Project';
      case Sort.BY_RATING:
        return 'Rating';
      case Sort.NONE:
        return 'None';
    }
  }
}

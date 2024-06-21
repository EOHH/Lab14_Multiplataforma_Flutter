import 'package:lab14_flutter/team.dart';
import 'package:lab14_flutter/team_database.dart';
import 'package:lab14_flutter/team_details_view.dart';
import 'package:flutter/material.dart';

class TeamsView extends StatefulWidget {
  const TeamsView({super.key});

  @override
  State<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends State<TeamsView> {
  TeamDatabase teamDatabase = TeamDatabase.instance;
  List<TeamModel> teams = [];

  @override
  void initState() {
    refreshTeams();
    super.initState();
  }

  @override
  dispose() {
    //close the database
    teamDatabase.close();
    super.dispose();
  }

  ///Gets all the teams from the database and updates the state
  refreshTeams() {
    teamDatabase.readAll().then((value) {
      setState(() {
        teams = value;
      });
    });
  }

  ///Navigates to the TeamDetailsView and refreshes the teams after the navigation
  goToTeamDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TeamDetailsView(teamId: id)),
    );
    refreshTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: teams.isEmpty
            ? const Text(
                'No Teams yet',
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  final team = teams[index];
                  return GestureDetector(
                    onTap: () => goToTeamDetailsView(id: team.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                team.name,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                'Founded: ${team.foundingYear}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'Last Championship: ${team.lastChampDate.toString().split(' ')[0]}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToTeamDetailsView(),
        tooltip: 'Create Team',
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lab14_flutter/team.dart';
import 'package:lab14_flutter/team_database.dart';

class TeamDetailsView extends StatefulWidget {
  const TeamDetailsView({super.key, this.teamId});
  final int? teamId;

  @override
  State<TeamDetailsView> createState() => _TeamDetailsViewState();
}

class _TeamDetailsViewState extends State<TeamDetailsView> {
  TeamDatabase teamDatabase = TeamDatabase.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController foundingYearController = TextEditingController();
  TextEditingController lastChampDateController = TextEditingController();
  late TeamModel team;
  bool isLoading = false;
  bool isNewTeam = false;

  @override
  void initState() {
    refreshTeams();
    super.initState();
  }

  ///Gets the team from the database and updates the state if the teamId is not null else it sets the isNewTeam to true
  refreshTeams() {
    if (widget.teamId == null) {
      setState(() {
        isNewTeam = true;
      });
      return;
    }
    teamDatabase.read(widget.teamId!).then((value) {
      setState(() {
        team = value;
        nameController.text = team.name;
        foundingYearController.text = team.foundingYear.toString();
        lastChampDateController.text = team.lastChampDate.toIso8601String().split('T')[0];
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    foundingYearController.dispose();
    lastChampDateController.dispose();
    super.dispose();
  }

  ///Saves the team to the database and pops the view
  saveTeam() {
    final name = nameController.text;
    final foundingYear = int.tryParse(foundingYearController.text);
    final lastChampDate = DateTime.tryParse(lastChampDateController.text);

    if (name.isNotEmpty && foundingYear != null && lastChampDate != null) {
      final newTeam = TeamModel(
        name: name,
        foundingYear: foundingYear,
        lastChampDate: lastChampDate,
      );
      if (isNewTeam) {
        teamDatabase.create(newTeam);
      } else {
        final updatedTeam = team.copy(
          name: name,
          foundingYear: foundingYear,
          lastChampDate: lastChampDate,
        );
        teamDatabase.update(updatedTeam);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNewTeam ? 'New Team' : 'Edit Team'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Team Name'),
                  ),
                  TextField(
                    controller: foundingYearController,
                    decoration: const InputDecoration(labelText: 'Founding Year'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: lastChampDateController,
                    decoration: const InputDecoration(labelText: 'Last Championship Date'),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveTeam,
                    child: Text(isNewTeam ? 'Create' : 'Update'),
                  ),
                ],
              ),
            ),
    );
  }
}

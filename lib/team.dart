class TeamFields {
  static const List<String> values = [
    id,
    name,
    foundingYear,
    lastChampDate,
  ];
  static const String tableName = 'teams';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String id = '_id';
  static const String name = 'name';
  static const String foundingYear = 'founding_year';
  static const String lastChampDate = 'last_champ_date';
}

class TeamModel {
   int? id;
  final String name;
  final int foundingYear;
  final DateTime lastChampDate;
  
  TeamModel({
    this.id,
    required this.name,
    required this.foundingYear,
    required this.lastChampDate,
  });
  
   Map<String, Object?> toJson() => {
        TeamFields.id: id,
        TeamFields.name: name,
        TeamFields.foundingYear: foundingYear,
        TeamFields.lastChampDate: lastChampDate.toIso8601String(),
      };

  factory TeamModel.fromJson(Map<String, Object?> json) => TeamModel(
        id: json[TeamFields.id] as int?,
        name: json[TeamFields.name] as String,
        foundingYear: json[TeamFields.foundingYear] as int,
        lastChampDate: DateTime.parse(json[TeamFields.lastChampDate] as String),
      );
      
  TeamModel copy({
    int? id,
    String? name,
    int? foundingYear,
    DateTime? lastChampDate,
  }) =>
      TeamModel(
        id: id ?? this.id,
        name: name ?? this.name,
        foundingYear: foundingYear ?? this.foundingYear,
        lastChampDate: lastChampDate ?? this.lastChampDate,
      );
}

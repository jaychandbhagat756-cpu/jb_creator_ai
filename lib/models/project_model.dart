import 'package:hive/hive.dart';

part 'project_model.g.dart';

@HiveType(typeId: 1)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final DateTime createdAt;

  ProjectModel({
    required this.name,
    required this.description,
    required this.createdAt,
  });
}
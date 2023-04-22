



import 'dart:ffi';
import 'package:floor/floor.dart';

@entity
class ToDoDetail{
  @PrimaryKey()/*(autoGenerate: true)*/
  String id;
  String title;
  String description;
  String priority;
  String dueDate;
  String createdDate;

  ToDoDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.createdDate,
  });
}
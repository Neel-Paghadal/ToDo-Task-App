
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:todoapp/Dao_class.dart';
import 'detailClass.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'db_class.g.dart';



@Database(version: 1, entities: [ToDoDetail])
abstract class ToDoData extends FloorDatabase{
  ToDoDetailDao get detailDao;
}
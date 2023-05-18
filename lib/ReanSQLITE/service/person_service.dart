import 'dart:io';
import 'package:flutter_local_storage11_12/ReanSQLITE/model/person_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class PersonService{
  static const databaseName="learningsqlite.db";
  static const tableName="tbperson";
  static const colid="id";
  static const colname="name";
  static const colgender="gender";
  static const colage="age";
  static const colimage="image";

  Future<Database> initializeData()async{
    Directory directory = await getTemporaryDirectory();
    String directoryTemp = directory.path;
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String appDocPath = appDirectory.path;
    String path = await getDatabasesPath();

    return openDatabase(
      join(path,databaseName),
      version: 1,
      onCreate: (db, version) async{
        return db.execute(
          'CREATE TABLE $tableName($colid INTEGER PRIMARY KEY,$colname TEXT NOT NULL,$colgender TEXT NOT NULL,$colage INTEGER NOT NULL,$colimage TEXT NOT NULL)'
        );
      },
    );
  }

  // Create
  Future<void> createPerson(Person person) async{
    final db = await initializeData();
    await db.insert(tableName, person.fromJson());
    print('>>>>Created Person....');
  }

  // Read
  Future<List<Person>> readPerson()async{
    final db = await initializeData();
    List<Map<String,dynamic>> data = await db.query(tableName);
    return data.map((e) => Person.toJson(e)).toList();
  }

  // Update
  Future<void> updatePerson(Person person)async{
    final db = await initializeData();
    await db.update(
      tableName,
      person.fromJson(),
      where: '$colid=?',
      whereArgs: [person.id]
    );
    print('>>>>Updated Person....');
  }

  // Delete
  Future<void> deletePerson(int id)async{
     final db = await initializeData();
     await db.delete(
      tableName,
      where: '$colid=?',
      whereArgs: [id]
     );
     print('>>>>Deleted Person....');
  }

}
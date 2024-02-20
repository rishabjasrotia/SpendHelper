import 'package:spendhelper/widgets/cardwidget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DbManager {
  Database? _database = null;
  
  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "spendhelper.db"),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE keys_data (id INTEGER PRIMARY KEY autoincrement, key TEXT, value TEXT)",
          );
        });
    return _database;
  }
  
  Future<int?> insertData(Model model) async {
    await openDb();
    int? a= await _database?.insert('keys_data', model.toJson());
    return a;
  }
  
  Future<List<Model>> getDataList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database!.rawQuery('SELECT * FROM keys_data');
  
    return List.generate(maps.length, (i) {
      return Model(
          id: maps[i]['id'],
          key: maps[i]['key'],
          value: maps[i]['value']);
    });
  }

  getData() async {
    await openDb();
    List<Map> resultSet = await _database!.rawQuery('SELECT * FROM keys_data');
    return resultSet ;
  }
  
  Future<int> updateData(Model model) async {
    await openDb();
    return await _database!.update('keys_data', model.toJson(),
        where: "id = ?", whereArgs: [model.id]);
  }
  
  Future<void> deleteData(Model model) async {
    await openDb();
    await _database!.delete('keys_data', where: "id = ?", whereArgs: [model.id]);
  }
}

class Model {
  int? id;
  String? key;
  String? value;
 
  Model({this.id, this.key, this.value});
 
  Model fromJson(json) {
    return Model(
        id: json['id'], key: json['key'], value: json['"age"']);
  }
  Map<String, dynamic> toJson() {
    return {'key': key, 'value': value};
  }
 
}

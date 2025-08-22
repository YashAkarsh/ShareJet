import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sharejet/models/cardDataType.dart';

class DataBase{
  
  static sqflite.Database? _db;

  static final DataBase instance=DataBase._constructor();

  Future<sqflite.Database> get database async{
    if(_db!=null) return _db!;
    _db=await getDataBase();
    return _db!;
  }
  
  DataBase._constructor();

  Future<sqflite.Database> getDataBase() async {
    final dataBaseDirPath= await sqflite.getDatabasesPath();
    final dataBasePath=join(dataBaseDirPath,'db.db');
    final dataBase=await sqflite.openDatabase(
      dataBasePath,
      version: 1,
      onCreate: (db, version) => {
        db.execute(
          '''
          CREATE TABLE devices(
          
          id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
          name TEXT DEFAULT 'Device',
          ip TEXT NOT NULL UNIQUE,
          status INTEGER NOT NULL DEFAULT 0
          )
          '''
        )
      },
    );
    return dataBase;
  }

  Future<void> updateDevices(String name,String ip ,int? id) async{
    final db=await database;
    if(id==null){
    await db.insert('devices', {
      'name': name,
      'ip': ip
    });
    }
    else{
      await db.update('devices', 
      where: 'id= ?',
      whereArgs: [id],
      {
        'name': name,
        'ip': ip
      }
      );
    }
  }

  Future<void> updateDeviceStatus(int id,int status)async{
    final db=await database;
    await db.update('devices',
    where: 'id= ?', 
    whereArgs: [id],
    {
      'status':status
    });
    
  }

  Future<int> deleteDevice(int id) async{
    final db=await database;
    return await db.delete('devices',where: 'id=?',whereArgs: [id]);
  }

  Future<List<CardType>> getDevices() async{
    final db=await database;
    final data=await db.query('devices');
    List<CardType> cards=data.map(
      (e)=>CardType(
      id: e['id'] as int, deviceName: e['name'] as String, ip: e['ip'] as String, status:e['status'] as int)
      ).toList();
    return cards;
  }
}
import 'package:flutter/material.dart';
import 'package:sharejet/database/db.dart';

class DisplayDevices extends StatelessWidget {
  final DataBase _db = DataBase.instance;
  final String device_name, ip_address;
  final int id;
  final bool status;


  final Future<void> Function(int id) onDelete;

  DisplayDevices({
    super.key,
    required this.id,
    required this.device_name,
    required this.ip_address,
    required this.status,
    required this.onDelete
  });

  void deleteDevice(int id) async{
    await _db.deleteDevice(id);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 330,
        child: Card(
          margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Text(
                        device_name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit),
                        style: IconButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.greenAccent.withAlpha(70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                indent: 30,
                endIndent: 30,
                thickness: 3,
                radius: BorderRadius.circular(20),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Icon(
                  Icons.desktop_windows_rounded,
                  size: 50,
                ),
              ),
              Container(
                margin: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ip Address: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          ip_address,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          status ? 'Sharing' : 'Not Sharing',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async{
                        await onDelete(id);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

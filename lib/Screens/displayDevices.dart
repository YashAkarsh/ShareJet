import 'package:flutter/material.dart';
import 'package:sharejet/Screens/addDeviceScreen.dart';
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
    required this.onDelete,
  });

  void deleteDevice(int id) async {
    await _db.deleteDevice(id);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 330,
        child: Stack(
          children: [
            // The main card
            Card(
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
              elevation: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      right: 15,
                      left: 15,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 30,
                            width: 180,
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  device_name,
                              
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: SizedBox(
                            height: 30,
                            child: IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    
                                    return AddDeviceScreen(id:id,name: device_name,ip: ip_address,);
                                  },
                                );
                              },
                              iconSize: 15,
                              icon: Icon(Icons.edit),
                              style: IconButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.greenAccent.withAlpha(
                                  70,
                                ),
                              ),
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
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Icon(Icons.desktop_windows_rounded, size: 50),
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
                            SizedBox(width: 132,height: 25,child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text(ip_address, style: TextStyle(fontSize: 20)))),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Status: ', style: TextStyle(fontSize: 20)),
                            Text(
                              status ? 'Sharing' : 'Not Sharing',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            await onDelete(id);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Status indicator at bottom right
            Positioned(
              bottom: 30,
              right: 50,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: status ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

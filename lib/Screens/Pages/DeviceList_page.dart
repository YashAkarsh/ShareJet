
import 'package:flutter/material.dart';
import 'package:sharejet/Screens/displayDevices.dart';
import 'package:sharejet/database/db.dart';
import 'package:sharejet/models/cardDataType.dart';


class DeviceListPage extends StatefulWidget {
  List<CardType> devices_list;
  final Future<void> Function() OnRefresh;
  DeviceListPage({super.key,required List<CardType> this.devices_list,required this.OnRefresh});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  final DataBase _db=DataBase.instance;

  @override
  void initState() {
    super.initState();
    // fetchDevices();
  }

  Future<void> deleteDevice(int id) async {
  await _db.deleteDevice(id);
  // after deletion, fetch updated devices list and update state
  final updatedDevices = await _db.getDevices();
  setState(() {
    widget.devices_list = updatedDevices;
  });
}
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.OnRefresh,
      color: Colors.greenAccent,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.red,
              ),
              child: widget.devices_list.isEmpty
                  ? const Center(
                      child: Text(
                        'No devices added!',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                    padding: EdgeInsets.only(bottom: 50,top:30),
                    itemCount: widget.devices_list.length,
                    
                    itemBuilder: (context,index){
                    
                    return DisplayDevices(id: widget.devices_list[index].id, device_name: widget.devices_list[index].deviceName,ip_address:  widget.devices_list[index].ip,status: widget.devices_list[index].status==0?false:true,onDelete: deleteDevice,);
                  })
            ),
          ),
        ],
      ),
    );
  }
}
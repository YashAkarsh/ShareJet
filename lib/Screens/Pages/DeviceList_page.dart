
import 'package:flutter/material.dart';
import 'package:sharejet/models/cardDataType.dart';


class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  @override
  Widget build(BuildContext context) {
    List<CardType> devices = [];

    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.red,
            ),
            child: devices.isEmpty
                ? const Center(
                    child: Text(
                      'No devices added!',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  )
                : const Center(child: Text('Listing available devices')),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sharejet/models/cardDataType.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CardType> devices = [];
  final screens=[_HomeScreenState];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
        foregroundColor: Colors.white,
        elevation: 10,
        child: const Icon(Icons.add, size: 32),
      ),

      appBar: AppBar(
        title: Row(
          spacing: 10,
          children: [
            Icon(Icons.adobe, size: 35, color: const Color.fromARGB(255, 0, 0, 0)),

            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 10),
              child: Row(
                children: [
                  Text('Share'),
                  Text('Jet', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(
            indent: 15,
            endIndent: 15,
            radius: BorderRadius.circular(20),
            thickness: 3,
          ),
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [BoxShadow(color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),offset: Offset(0, 20),blurRadius: 20)]
          ),
        ),
      ),
    );
  }
}

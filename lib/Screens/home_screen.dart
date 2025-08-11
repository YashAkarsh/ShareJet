import 'package:flutter/material.dart';
import 'package:sharejet/Screens/Pages/DeviceList_page.dart';
import 'package:sharejet/Screens/Pages/FilesPage.dart';
import 'package:sharejet/Screens/addDeviceScreen.dart';
import 'package:sharejet/database/db.dart';
import 'package:sharejet/models/cardDataType.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataBase _db=DataBase.instance;
  List<CardType> devices=[];
  int pg_index = 0;

  @override
  void initState() {
    super.initState();
    pg_index = 0;
    fetchDevices();
  }

  Future<void> fetchDevices() async{
    final fetchedData=await _db.getDevices();
    setState(() {
      devices=fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [DeviceListPage(devices_list:devices), FilesPage()];

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 85),
        child: FloatingActionButton(
          
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context)  {
                return const AddDeviceScreen();
              },
            );
            await fetchDevices();

          },
          shape: const CircleBorder(),
          backgroundColor: Colors.greenAccent.withOpacity(0.7),
          foregroundColor: Colors.white,
          elevation: 10,
          child: const Icon(Icons.add, size: 32),
        ),
      ),

      appBar: AppBar(
        title: Row(
          spacing: 10,
          children: [
            Icon(Icons.adobe, size: 35, color: Colors.greenAccent),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 10),
              child: Row(
                children: [
                  const Text('Share'),
                  Text('Jet', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                size: 30,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          // Main content
          Positioned.fill(
            child: screens[pg_index],
          ),

          // Floating transparent bottom nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 80),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3), // transparent
                borderRadius: BorderRadius.circular(40),
              ),
              child: Stack(
                children: [
                  // Sliding white background
                  AnimatedAlign(
                    alignment: pg_index == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 90,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  // Icons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            pg_index = 0;
                          });
                        },
                        child: SizedBox(
                          width: 80,
                          height: double.infinity,
                          child: Icon(
                            Icons.home,
                            size: 30,
                            color: pg_index == 0 ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            pg_index = 1;
                          });
                        },
                        child: SizedBox(
                          width: 80,
                          height: double.infinity,
                          child: Icon(
                            Icons.folder,
                            size: 30,
                            color: pg_index == 1 ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

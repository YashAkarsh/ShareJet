

import 'package:flutter/material.dart';
import 'package:sharejet/Screens/Pages/DeviceList_page.dart';
import 'package:sharejet/Screens/Pages/FilesPage.dart';
import 'package:sharejet/models/cardDataType.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = [DeviceListPage(), FilesPage()];
  int pg_index = 0;

  @override
  void initState() {

    super.initState();
    pg_index = 0;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: Colors.greenAccent.withOpacity(1),
        foregroundColor: Colors.white,
        elevation: 10,
        child: const Icon(Icons.add, size: 32),
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
                  Text('Share'),
                  Text('Jet', style: TextStyle(fontWeight: FontWeight.bold)),
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
              icon: Icon(
                Icons.settings,
                size: 30,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ],
      ),
      // body:
      body: screens[pg_index],
      bottomNavigationBar: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
          // border: Border.all(
          //   color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.25), // frosted border
          //   width: 0.5,
          // ),
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
    );
  }
}

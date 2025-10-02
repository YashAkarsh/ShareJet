import 'package:flutter/material.dart';
import 'package:sharejet/Screens/Pages/DeviceList_page.dart';
import 'package:sharejet/Screens/Pages/FilesPage.dart';
import 'package:sharejet/Screens/addDeviceScreen.dart';
import 'package:sharejet/database/db.dart';
import 'package:sharejet/models/cardDataType.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataBase _db = DataBase.instance;
  List<CardType> devices = [];
  int pg_index = 0;

  // Download state
  double progress = 0.0;
  String status = "Idle";
  String current_device_name='OnePlus Nord CE4 5G';
  @override
  void initState() {
    super.initState();
    pg_index = 0;
    openLocalFile();
    // getDeviceName();
    fetchDevices().then((_) {
      if (devices.isNotEmpty) {
        for (var device in devices){
        // Start download immediately after devices fetched
        startDownload("http://${device.ip}:8000/download/${current_device_name}");
        }
      }
    });
  }
  Future<void> openLocalFile() async {
  Directory dir = await getApplicationDocumentsDirectory();
  String filePath = "${dir.path}/SharedFiles";

  if (File(filePath).existsSync()) {
    print('opened');
    OpenFile.open(filePath);
  } else {
    print("File not found locally. Download first.");
  }
}

  Future<void> fetchDevices() async {
    final fetchedData = await _db.getDevices();
    setState(() {
      devices = fetchedData;
    });
    await connectDevices();
  }

  // fetch mobile device name

  Future<void> getDeviceName() async {
  final deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    current_device_name="${androidInfo.manufacturer} ${androidInfo.model}";
    // return "${androidInfo.manufacturer} ${androidInfo.model}";

  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    // return iosInfo.name; // e.g. "Yash’s iPhone"
    current_device_name=iosInfo.name;

  } else if (Platform.isWindows) {
    final windowsInfo = await deviceInfoPlugin.windowsInfo;
    current_device_name= windowsInfo.computerName;
  } else if (Platform.isLinux) {
    final linuxInfo = await deviceInfoPlugin.linuxInfo;
    current_device_name= linuxInfo.name;
  } else if (Platform.isMacOS) {
    final macInfo = await deviceInfoPlugin.macOsInfo;
    current_device_name= macInfo.computerName;
  }
  else{

  current_device_name= "Unknown Device";
  }
}

  Future<void> connectDevices() async {
    for (var device in devices) {
      try {
        final uri = Uri.parse('http://${device.ip}:8000');
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          final Map<String,dynamic> data = jsonDecode(response.body);
          print(data['files_pending']);
          
          _db.updateDeviceStatus(device.id, 1);
        } else {
          _db.updateDeviceStatus(device.id, 0);
        }
      } catch (e) {
        _db.updateDeviceStatus(device.id, 0);
      }
    }
  }

  Future<void> refresh() async {
    await fetchDevices();
    await connectDevices();
  }


  // ---------- DOWNLOAD + UNZIP ----------
  Future<String> downloadZip(String url) async {
    Dio dio = Dio();
    Directory dir = await getApplicationDocumentsDirectory();
    String zipPath = "${dir.path}/shared_files.zip";

    await dio.download(
      url,
      zipPath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          setState(() {
            progress = received / total;
          });
        }
      },
    );

    return zipPath;
  }

  Future<String> unzipFile(String zipPath) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String extractPath = "${dir.path}/SharedFiles";
    Directory(extractPath).createSync(recursive: true);

    final bytes = File(zipPath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      final data = file.content as List<int>;
      File("$extractPath/$filename")
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    }

    return extractPath;
  }

  void startDownload(String url) async {
    setState(() {
      status = "Downloading...";
      progress = 0.0;
    });

    try {
      String zipPath = await downloadZip(url);

      setState(() {
        status = "Unzipping...";
      });

      await unzipFile(zipPath);

      setState(() {
        status = "Done!";
        progress = 1.0;
      });

      // Hide after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => status = "Idle");
      });
    } catch (e) {
      setState(() {
        status = "Idle";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DeviceListPage(devices_list: devices, OnRefresh: fetchDevices),
      FilesPage(),
    ];

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 85),
        child: FloatingActionButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddDeviceScreen();
              },
            );
            await refresh();
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
                  Text(
                    'Jet',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          // Main content
          Positioned.fill(child: screens[pg_index]),

          // Progress bar overlay
          if (status != "Idle")
            Positioned(
              left: 0,
              right: 0,
              bottom: 90,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black.withOpacity(0.6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(status, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      color: Colors.greenAccent,
                    ),
                  ],
                ),
              ),
            ),

          // Bottom navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 80),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Stack(
                children: [
                  AnimatedAlign(
                    alignment: pg_index == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Container(
                      width: 90,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => setState(() => pg_index = 0),
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
                        onTap: () => setState(() => pg_index = 1),
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

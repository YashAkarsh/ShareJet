import 'package:flutter/material.dart';
import 'package:sharejet/database/db.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final DataBase _db=DataBase.instance;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  bool _isFocused1 = false;
  bool _isFocused2 = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();

  String hintName = 'Name';
  String hintIp = 'Ip Address';

  double width1 = 150.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode1.addListener(() {
      setState(() {
        if (_focusNode1.hasFocus) {
          _isFocused1 = true;
          width1 = 300.0;
          // hintName='';
        } else {
          _isFocused1 = false;
        }
      });
    });

    _focusNode2.addListener(() {
      setState(() {
        if (_focusNode2.hasFocus) {
          _isFocused2 = true;
          // hintIp = '';
        } else {
          _isFocused2 = false;
        }
      });
    });
  }

  void save(String name,String ip) async {
    print("name: "+name);
    print("ip: "+ip);

    await _db.updateDevices(name, ip);
    Navigator.pop(context,true);
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context, {int? id}) {
    return AlertDialog(
      title: Text(
        textAlign: TextAlign.center,
        id == null ? 'Add Device' : 'Edit Device',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          TextField(
            controller: _nameController,
            // autofocus: true,
            focusNode: _focusNode1,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: _isFocused1 ? '' : 'Name',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
            ),

            textAlign: TextAlign.center,
          ),

          TextField(
            // autofocus: true,
            controller: _ipController,
            keyboardType: TextInputType.number,
            focusNode: _focusNode2,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: _isFocused2 ? '' : 'Ip Address',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
            ),

            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
              onPressed: () => save(_nameController.text,_ipController.text.toString()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.withAlpha(420),
                elevation: 10,
                shadowColor: Colors.black.withAlpha(250),
              ),

              child: Row(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,

                children: [
                  Icon(Icons.add, color: Colors.black, size: 25),
                  Text(
                    'Add',
                    style: TextStyle(color: Colors.black, fontSize: 20),
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

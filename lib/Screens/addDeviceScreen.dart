import 'package:flutter/material.dart';
import 'package:sharejet/database/db.dart';

class AddDeviceScreen extends StatefulWidget {
  final int? id;
  final String? name;
  final String? ip;
  const AddDeviceScreen({super.key, this.id, this.name,this.ip});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final DataBase _db=DataBase.instance;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  bool _isFocused1 = false;
  bool _isFocused2 = false;

  late TextEditingController _nameController;
  late TextEditingController _ipController;

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
    widget.id!=null?
    {
    _nameController=TextEditingController(text: widget.name),
    _ipController=TextEditingController(text: widget.ip)
    }
    :
    {
    _nameController=TextEditingController(),
    _ipController=TextEditingController()
    };

  }

  void save(String name,String ip,int? id) async {
    if(id==null && name.isNotEmpty && ip.isNotEmpty){
    await _db.updateDevices(name, ip,null);
      Navigator.pop(context,true);

    }
    else if(id!=null && name.isNotEmpty && ip.isNotEmpty){
    await _db.updateDevices(name, ip,id);
      Navigator.pop(context,true);
    }

  }

  // void update(String name, String ip) async{
  //   await _db.
  // }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        textAlign: TextAlign.center,
        widget.id == null ? 'Add Device' : 'Edit Device',
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
              onPressed: () => widget.id==null? save(_nameController.text,_ipController.text.toString(),null):save(_nameController.text,_ipController.text.toString(),widget.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                elevation: 0,
                shadowColor: Colors.black.withAlpha(250),
              ),

              child: Row(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,

                children: [
                  Icon(Icons.add, color: const Color.fromARGB(255, 255, 255, 255), size: 25),
                  Text(
                    'Add',
                    style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 20),
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

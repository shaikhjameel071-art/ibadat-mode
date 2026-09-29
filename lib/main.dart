import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));

class Home extends StatefulWidget {
  State<Home> createState() => _H();
}

class _H extends State<Home> {
  int i = 0, c = 0;
  bool on = false, auto = true;
  final tel = Telephony.instance;

  @override
  void initState() {
    super.initState();
    tel.requestPhoneAndSmsPermissions;
    tel.listenIncomingCalls(onNewIncomingCall: (call) {
      if (on && auto) {
        tel.sendSms(
            to: call.callerId?? "",
            message: "Assalamu Alaikum, Namaz me hu. Baad me call karta hu - Ibadat Mode");
      }
    });
  }

  Future<void> gps() async {
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) await Geolocator.requestPermission();
    try {
      await Geolocator.getCurrentPosition();
      setState(() => on =!on);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("GPS ON karo")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ibadat Mode"), backgroundColor: Colors.green[700]),
      body: [
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.mosque, size: 100, color: Colors.green),
          Text(on? "IBADAT ON" : "IBADAT OFF", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ElevatedButton(onPressed: gps, child: Text(on? "BAND KARO" : "SHURU KARO")),
          SwitchListTile(title: Text("Call pe Auto SMS"), value: auto, onChanged: (v) => setState(() => auto = v))
        ])),
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("$c", style: TextStyle(fontSize: 80, color: Colors.green)),
          GestureDetector(onTap: () => setState(() => c++), child: Container(width: 150, height: 150, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle), child: Icon(Icons.fingerprint, color: Colors.white, size: 80))),
          ElevatedButton(onPressed: () => setState(() => c = 0), child: Text("Reset"))
        ])),
        ListView(children: [ListTile(title: Text("Ar-Rahman")), ListTile(title: Text("Ar-Raheem")), ListTile(title: Text("Al-Malik"))]),
        ListView(children: [Card(child: ListTile(title: Text("Allahumma inni as'aluka ilman nafi'an")))])
      ][i],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: i,
          onTap: (x) => setState(() => i = x),
          selectedItemColor: Colors.green[700],
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.mosque), label: "Ibadat"),
            BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: "Tasbih"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "99 Names"),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Dua")
          ]),
    );
  }
}

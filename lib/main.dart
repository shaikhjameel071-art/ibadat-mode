import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() { runApp(IbadatModeApp()); }

class IbadatModeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ibadat Mode',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isActive = false;
  bool isSilentNow = false;
  Position? currentPos;
  double radius = 150;
  String statusText = "Masjid ke paas auto silent hoga";
  Timer? timer;
  List<Map<String, dynamic>> masjids = [{"name": "Masjid", "lat": 0.0, "lng": 0.0}];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _requestPerms();
  }

  _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      isActive = p.getBool('isActive')?? false;
      radius = p.getDouble('radius')?? 150;
    });
    if (isActive) _start();
  }

  _savePrefs() async {
    final p = await SharedPreferences.getInstance();
    p.setBool('isActive', isActive);
    p.setDouble('radius', radius);
  }

  _requestPerms() async {
    await Permission.location.request();
    await Permission.locationAlways.request();
  }

  _start() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 15), (t) => _check());
    _check();
  }

  _stop() { timer?.cancel(); }

  Future<void> _check() async {
    if (!isActive) return;
    try {
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() => currentPos = pos);
      bool near = false;
      for (var m in masjids) {
        if (m['lat'] == 0.0) continue;
        double d = Geolocator.distanceBetween(pos.latitude, pos.longitude, m['lat'], m['lng']);
        if (d <= radius) { near = true; break; }
      }
      setState(() {
        if (near) { isSilentNow = true; statusText = "🕌 Masjid ke paas - Silent ON"; }
        else { isSilentNow = false; statusText = "Masjid se door - Normal"; }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ibadat Mode'), backgroundColor: Colors.green[700], foregroundColor: Colors.white, centerTitle: true),
      body: Padding(padding: EdgeInsets.all(20), child: Column(children: [
        Card(color: isSilentNow? Colors.orange[100] : Colors.green[50], child: Padding(padding: EdgeInsets.all(20), child: Column(children: [
          Icon(isSilentNow? Icons.volume_off : Icons.volume_up, size: 60, color: isSilentNow? Colors.orange : Colors.green),
          SizedBox(height: 10),
          Text(statusText, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (currentPos!= null) Text("Lat: ${currentPos!.latitude.toStringAsFixed(4)}", style: TextStyle(fontSize: 11)),
        ]))),
        SizedBox(height: 20),
        SwitchListTile(title: Text("Ibadat Mode Active", style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text("Masjid ke paas auto silent"), value: isActive, activeColor: Colors.green, onChanged: (v){ setState(()=> isActive=v); _savePrefs(); if(v) _start(); else _stop(); }),
        Divider(),
        ListTile(title: Text("Radius: ${radius.toInt()}m"), subtitle: Slider(value: radius, min: 50, max: 500, divisions: 9, label: "${radius.toInt()}m", onChanged: (v){ setState(()=> radius=v); _savePrefs(); })),
        Spacer(),
        ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], foregroundColor: Colors.white, minimumSize: Size(double.infinity, 50)), icon: Icon(Icons.add_location_alt), label: Text("Add Masjid Location"), onPressed: () async { Position pos = await Geolocator.getCurrentPosition(); setState(()=> masjids.add({"name": "Masjid ${masjids.length}", "lat": pos.latitude, "lng": pos.longitude})); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Masjid saved! Ab iske ${radius.toInt()}m me auto silent hoga."))); }),
        SizedBox(height: 10), Text("Allah aapki ibadat qubool kare", style: TextStyle(color: Colors.grey)),
      ])),
    );
  }
}

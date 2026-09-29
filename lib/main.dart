import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isOn = true;
  List<String> masjids = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      masjids = p.getStringList('masjids')?? [];
      isOn = p.getBool('isOn')?? true;
    });
  }

  addMasjid() async {
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Settings me jaake Location Allow karo")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location le rahe hain...")),
      );

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final p = await SharedPreferences.getInstance();
      masjids.add("${pos.latitude},${pos.longitude}");
      await p.setStringList('masjids', masjids);

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Masjid Add ho gayi! Alhamdulillah")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e - GPS ON karo")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ibadat Mode"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: Text("Ibadat Mode ON", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              value: isOn,
              activeColor: Colors.green,
              onChanged: (v) async {
                final p = await SharedPreferences.getInstance();
                await p.setBool('isOn', v);
                setState(() {
                  isOn = v;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addMasjid,
              child: Text("Masjid Add Karo", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              masjids.isEmpty
                 ? "Masjid Add Karo taaki auto-silent chalu ho"
                  : "${masjids.length} Masjid save hai",
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: masjids.length,
                itemBuilder: (ctx, i) => Card(
                  child: ListTile(
                    leading: Icon(Icons.mosque, color: Colors.green),
                    title: Text("Masjid ${i + 1}"),
                    subtitle: Text(masjids[i]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final p = await SharedPreferences.getInstance();
                        setState(() {
                          masjids.removeAt(i);
                        });
                        await p.setStringList('masjids', masjids);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

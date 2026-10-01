import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// APNI PURI KEY YAHAN LAGAO - jo...leuU se end hoti hai
const String GEMINI_API_KEY = "YAHAN_PURI_KEY_PASTE_KARO";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: IbadatHome()));
}

class IbadatHome extends StatefulWidget {
  const IbadatHome({super.key});
  @override
  State<IbadatHome> createState() => _IbadatHomeState();
}

class _IbadatHomeState extends State<IbadatHome> {
  int tab = 0;
  int tasbih = 0;
  String status = "Masjid check...";
  String aiAns = "Assalamu Alaikum! Sawal puchiye...";
  final ctrl = TextEditingController();
  bool load = false;

  checkLoc() async {
    try {
      await Geolocator.requestPermission();
      var p = await Geolocator.getCurrentPosition();
      double d = Geolocator.distanceBetween(p.latitude, p.longitude, 19.0330, 73.0297);
      setState(() => status = d < 100? "Masjid ${d.toInt()}m paas - Silent ON 🔕" : "Masjid se ${d.toInt()}m door");
    } catch (e) {
      setState(() => status = "Location ON karo");
    }
  }

  askAI() async {
    if (ctrl.text.isEmpty) return;
    setState(() => load = true);
    try {
      final m = GenerativeModel(model: 'gemini-1.5-flash', apiKey: GEMINI_API_KEY);
      final r = await m.generateContent([Content.text(ctrl.text)]);
      setState(() { aiAns = r.text?? "Jawab nahi"; load = false; });
    } catch (e) {
      setState(() { aiAns = "Key Error: $e"; load = false; });
    }
  }

  @override
  void initState() { super.initState(); checkLoc(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2215),
      appBar: AppBar(title: const Text("Ibadat Mode عبادة"), backgroundColor: const Color(0xFF0A2215), foregroundColor: Colors.white),
      body: [
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ const Icon(Icons.mosque, size: 80, color: Colors.white), Padding(padding: EdgeInsets.all(16), child: Text(status, style: TextStyle(color: Colors.greenAccent))), ElevatedButton(onPressed: checkLoc, child: Text("Masjid Check")) ])),
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Text("$tasbih", style: TextStyle(fontSize: 80, color: Colors.green)), GestureDetector(onTap: () { HapticFeedback.lightImpact(); setState(() => tasbih++); }, child: Container(width: 150, height: 150, decoration: BoxDecoration(color: Color(0xFF1B3A2A), shape: BoxShape.circle), child: Icon(Icons.fingerprint, size: 70, color: Colors.white))), TextButton(onPressed: () => setState(() => tasbih = 0), child: Text("Reset")) ])),
        Padding(padding: EdgeInsets.all(16), child: Column(children: [ Expanded(child: SingleChildScrollView(child: Text(aiAns, style: TextStyle(color: Colors.white)))), if (load) CircularProgressIndicator(), Row(children: [ Expanded(child: TextField(controller: ctrl, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Wuzu ka tarika?"))), IconButton(onPressed: askAI, icon: Icon(Icons.send, color: Colors.greenAccent)) ]) ])),
      ][tab],
      bottomNavigationBar: BottomNavigationBar(currentIndex: tab, onTap: (i) => setState(() => tab = i), backgroundColor: Color(0xFF0A2215), selectedItemColor: Colors.green, unselectedItemColor: Colors.white54, items: [ BottomNavigationBarItem(icon: Icon(Icons.mosque), label: "Ibadat"), BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: "Tasbih"), BottomNavigationBarItem(icon: Icon(Icons.book), label: "AI") ]),
    );
  }
}

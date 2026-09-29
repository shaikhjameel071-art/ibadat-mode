import 'package:flutter/material.dart';

void main() => runApp(IbadatApp());

class IbadatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ibadat Mode',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final screens = [TasbihScreen(), AllahNamesScreen(), DuaScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ibadat Mode - عبادت'), backgroundColor: Colors.green.shade800, centerTitle: true),
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.green.shade800,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'Tasbih'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: '99 Names'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Duain'),
        ],
      ),
    );
  }
}

class TasbihScreen extends StatefulWidget {
  @override
  _TasbihScreenState createState() => _TasbihScreenState();
}
class _TasbihScreenState extends State<TasbihScreen> {
  int count = 0;
  String tasbih = "سُبْحَانَ ٱللَّٰهِ";
  List<String> azkar = ["سُبْحَانَ ٱللَّٰهِ", "ٱلْحَمْدُ لِلَّٰهِ", "ٱللَّٰهُ أَكْبَرُ", "لَا إِلَٰهَ إِلَّا ٱللَّٰهُ", "أَسْتَغْفِرُ ٱللَّٰهَ"];
  int azkarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(tasbih, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
        SizedBox(height: 20),
        Text("$count", style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () => setState(() => count++),
          child: Container(width: 180, height: 180, decoration: BoxDecoration(color: Colors.green.shade800, shape: BoxShape.circle, boxShadow: [BoxShadow(blurRadius: 10)]), child: Center(child: Text('TAP', style: TextStyle(color: Colors.white, fontSize: 30)))),
        ),
        SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(onPressed: () => setState(() => count = 0), child: Text('Reset')),
          SizedBox(width: 10),
          ElevatedButton(onPressed: () => setState(() { azkarIndex = (azkarIndex+1)%azkar.length; tasbih = azkar[azkarIndex]; count=0; }), child: Text('Next Zikr')),
        ])
      ]),
    );
  }
}

class AllahNamesScreen extends StatelessWidget {
  final List<Map<String,String>> names = [
    {"ar":"ٱلرَّحْمَٰنُ","en":"Ar-Rahman","mean":"The Most Merciful"},
    {"ar":"ٱلرَّحِيمُ","en":"Ar-Raheem","mean":"The Most Compassionate"},
    {"ar":"ٱلْمَلِكُ","en":"Al-Malik","mean":"The King"},
    {"ar":"ٱلْقُدُّوسُ","en":"Al-Quddus","mean":"The Holy"},
    {"ar":"ٱلسَّلَامُ","en":"As-Salam","mean":"Peace"},
    {"ar":"ٱلْمُؤْمِنُ","en":"Al-Mumin","mean":"Guardian"},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 99,
      itemBuilder: (c,i){
        if(i < names.length) {
          return Card(margin: EdgeInsets.symmetric(horizontal:12, vertical:6), child: ListTile(leading: CircleAvatar(backgroundColor: Colors.green.shade800, child: Text("${i+1}", style: TextStyle(color: Colors.white))), title: Text(names[i]["ar"]!, style: TextStyle(fontSize:22, fontWeight:FontWeight.bold)), subtitle: Text("${names[i]["en"]} - ${names[i]["mean"]}")));
        } else {
          return Card(margin: EdgeInsets.symmetric(horizontal:12, vertical:6), child: ListTile(leading: CircleAvatar(child: Text("${i+1}")), title: Text("ٱللَّٰهُ - Allah Name ${i+1}")));
        }
      },
    );
  }
}

class DuaScreen extends StatelessWidget {
  final List<Map<String,String>> duas = [
    {"title":"Pareshani Ki Dua","ar":"اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا","mean":"Ya Allah mushkil aasan farma"},
    {"title":"Gham Door Ki Dua","ar":"لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ","mean":"Yunus AS ki dua - har gham door"},
    {"title":"Rizq Ke Liye","ar":"اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ","mean":"Halal rizq ki dua"},
    {"title":"Shifa Ki Dua","ar":"أَذْهِبِ الْبَاسَ رَبَّ النَّاسِ","mean":"Bimari se shifa ki dua"},
    {"title":"Hifazat Ki Dua","ar":"اللَّهُمَّ إِنَّا نَجْعَلُكَ فِي نُحُورِهِمْ","mean":"Dushman se hifazat"},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: duas.length,
      itemBuilder: (c,i){
        return Card(margin: EdgeInsets.all(12), elevation:4, child: Padding(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(duas[i]["title"]!, style: TextStyle(fontWeight:FontWeight.bold, fontSize:18, color: Colors.green.shade800)),
          Divider(),
          Text(duas[i]["ar"]!, style: TextStyle(fontSize:22, fontWeight:FontWeight.bold), textAlign: TextAlign.right),
          SizedBox(height:10),
          Text(duas[i]["mean"]!, style: TextStyle(color: Colors.black87)),
        ]))),
      },
    );
  }
}

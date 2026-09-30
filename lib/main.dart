import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const IbadatApp());
}

class IbadatApp extends StatelessWidget {
  const IbadatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mosque, size: 80, color: Colors.white),
              SizedBox(height: 20),
              Text("Ibadat Mode ON", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Sirf Zaroori Calls", style: TextStyle(color: Colors.white54)),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                  SystemNavigator.pop();
                },
                child: Text("Ibadat Khatam"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

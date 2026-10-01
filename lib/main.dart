import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const String GEMINI_API_KEY = "AIzaSyAvL9dWGeMWH1gW8Cfm8bKj6bZvZxZxZ_PURI_KEY_YAHAN";

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MaterialApp(debugShowCheckedModeBanner:false, home:IbadatHome()));
}

class IbadatHome extends StatefulWidget{ const IbadatHome({super.key}); @override State<IbadatHome> createState()=> _IbadatHomeState(); }
class _IbadatHomeState extends State<IbadatHome>{
  int tab=0; int tasbih=0; String status="Masjid check kar rahe..."; String aiAns="Assalamu Alaikum! Koi deeni sawal puchiye...";
  final ctrl=TextEditingController(); bool load=false;
  
  checkLoc() async {
    try{
      await Geolocator.requestPermission();
      var p=await Geolocator.getCurrentPosition();
      double d=Geolocator.distanceBetween(p.latitude,p.longitude,19.0330,73.0297);
      setState(()=> status= d<100? "Masjid ${d.toInt()}m paas - Silent ON 🔕" : "Masjid se ${d.toInt()}m door");
    }catch(e){ setState(()=> status="Location ON karo bhai"); }
  }
  
  askAI() async {
    if(ctrl.text.isEmpty) return;
    setState(()=> load=true);
    try{
      final m=GenerativeModel(model:'gemini-1.5-flash', apiKey:GEMINI_API_KEY);
      final r=await m.generateContent([Content.text(ctrl.text)]);
      setState((){ aiAns=r.text??"Jawab nahi mila"; load=false; });
    }catch(e){ setState((){ aiAns

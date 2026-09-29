import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main(){runApp(MaterialApp(home:HomePage(),debugShowCheckedModeBanner:false));}
class HomePage extends StatefulWidget{@override _HomePageState createState()=>_HomePageState();}
class _HomePageState extends State<HomePage>{
bool isOn=false;List<String> masjids=[];
@override void initState(){super.initState();loadData();}
loadData() async{final p=await SharedPreferences.getInstance();setState((){masjids=p.getStringList('masjids')??[];isOn=p.getBool('isOn')??false;});}
add() async{var pm=await Geolocator.checkPermission();if(pm==LocationPermission.denied){pm=await Geolocator.requestPermission();}Position pos=await Geolocator.getCurrentPosition();final p=await SharedPreferences.getInstance();masjids.add("${pos.latitude},${pos.longitude}");await p.setStringList('masjids',masjids);setState((){});}
@override Widget build(BuildContext c){return Scaffold(appBar:AppBar(title:Text("Ibadat Mode"),backgroundColor:Colors.green,foregroundColor:Colors.white),body:Column(children:[SwitchListTile(title:Text("Ibadat Mode"),value:isOn,activeColor:Colors.green,onChanged:(v) async{final p=await SharedPreferences.getInstance();await p.setBool('isOn',v);setState((){isOn=v;});}),ElevatedButton(onPressed:add,child:Text("Masjid Add Karo")),Expanded(child:ListView.builder(itemCount:masjids.length,itemBuilder:(x,i)=>ListTile(title:Text("Masjid ${i+1}"),subtitle:Text(masjids[i]))))]));}
}

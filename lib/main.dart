import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()=>runApp(MaterialApp(home:H(),debugShowCheckedModeBanner:false));
class H extends StatefulWidget{State<H> createState()=>S();}
class S extends State<H>{
bool o=false;List<String> m=[];initState(){super.initState();l();}
l() async{var p=await SharedPreferences.getInstance();setState((){m=p.getStringList('m')??[];o=p.getBool('o')??false;});}
a() async{var q=await Geolocator.checkPermission();if(q==LocationPermission.denied){q=await Geolocator.requestPermission();}var r=await Geolocator.getCurrentPosition();var p=await SharedPreferences.getInstance();m.add("${r.latitude},${r.longitude}");p.setStringList('m',m);setState((){});}
Widget build(c)=>Scaffold(appBar:AppBar(title:Text("Ibadat Mode"),backgroundColor:Colors.green),body:Column(children:[SwitchListTile(title:Text("Ibadat Mode ON"),value:o,onChanged:(v) async{var p=await SharedPreferences.getInstance();p.setBool('o',v);setState(()=>o=v);}),ElevatedButton(onPressed:a,child:Text("Masjid Add Karo")),Expanded(child:ListView.builder(itemCount:m.length,itemBuilder:(x,i)=>ListTile(title:Text("Masjid ${i+1}"),subtitle:Text(m[i]))))]));
}

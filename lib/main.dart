import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()=>runApp(MaterialApp(home:HomePage(),debugShowCheckedModeBanner:false));
class HomePage extends StatefulWidget{ @override _HomePageState createState()=>_HomePageState();}
class _HomePageState extends State<HomePage>{
bool on=false; List<String> list=[]; String txt="Masjid ke paas auto silent";
@override void initState(){super.initState();_load();}
_load()async{final p=await SharedPreferences.getInstance();setState((){list=p.getStringList('m')??[];on=p.getBool('on')??false;});}
_start(){Timer.periodic(Duration(seconds:15),(t)async{if(!on)return;try{Position pos=await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.high);for(var s in list){var a=s.split(',');double d=Geolocator.distanceBetween(pos.latitude,pos.longitude,double.parse(a[0]),double.parse(a[1]));if(d<150){setState(()=>txt="🕌 Masjid ke paas - Silent ON");return;}}setState(()=>txt="Masjid se door - Normal");}catch(e){}});}
_add()async{var pm=await Geolocator.checkPermission();if(pm==LocationPermission.denied) pm=await Geolocator.requestPermission();Position pos=await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.high);final p=await SharedPreferences.getInstance();list.add("${pos.latitude},${pos.longitude}");await p.setStringList('m',list);setState((){});ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Masjid Added!')));}
@override Widget build(BuildContext c){return Scaffold(appBar:AppBar(title:Text('Ibadat Mode'),backgroundColor:Colors.green,foregroundColor:Colors.white),body:Padding(padding:EdgeInsets.all(16),child:Column(children:[Text(txt,style:TextStyle(fontWeight:FontWeight.bold,fontSize:16)),SwitchListTile(title:Text('Ibadat Mode ON'),value:on,onChanged:(v)async{final p=await SharedPreferences.getInstance();await p.setBool('on',v);setState(()=>on=v);if(v)_start();},activeColor:Colors.green),SizedBox(height:10),ElevatedButton(onPressed:_add,style:ElevatedButton.styleFrom(backgroundColor:Colors.green,foregroundColor:Colors.white,minimumSize:Size(double.infinity,50)),child:Text('Add Masjid Location')),SizedBox(height:10),Expanded(child:ListView.builder(itemCount:list.length,itemBuilder:(c,i)=>Card(child:ListTile(leading:Icon(Icons.mosque,color:Colors.green),title:Text("Masjid ${i+1}"),subtitle:Text(list[i]))))))])));}}

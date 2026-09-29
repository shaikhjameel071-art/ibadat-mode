import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){runApp(MaterialApp(home:HomePage(),debugShowCheckedModeBanner:false));}

class HomePage extends StatefulWidget{
@override
_HomePageState createState()=>_HomePageState();
}

class _HomePageState extends State<HomePage>{
bool isOn=false;
List<String> masjids=[];
String status="Ibadat Mode Band Hai";

@override
void initState(){super.initState();loadData();}

loadData() async{
final p=await SharedPreferences.getInstance();
setState((){
masjids=p.getStringList('

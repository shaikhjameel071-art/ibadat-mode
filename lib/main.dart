import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));
class Home extends StatefulWidget {
  State<Home> createState() => _H();
}
class _H extends State<Home> {
  int i = 0, c = 0;
  bool on = false, auto = true;
  final tel = Telephony.instance;

  @override
  void initState() {
    super.initState();
    tel.requestPhoneAndSmsPermissions;
    tel.listenIncomingCall(onNewIncomingCall: (call) {
      if (on && auto) {
        tel.sendSms(to: call.callerId?? "", message: "Assalamu Alaikum, Namaz me hu. Baad me call karta hu - Ibadat Mode");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ibadat Mode"), backgroundColor: Colors.green[700], foregroundColor: Colors.white, centerTitle: true),
      body: [
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.mosque, size: 100, color: Colors.green),
          Text(on? "IBADAT ON" : "IBADAT OFF", style:

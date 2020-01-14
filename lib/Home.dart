import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var beaconList = List();
  dynamic _streamRanging;
  _startRanging() async {
    try {
      // if you want to manage manual checking about the required permissions
     // await flutterBeacon.initializeScanning;

      // or if you want to include automatic checking permission
      await flutterBeacon.initializeAndCheckScanning;
    } catch(e) {
      // library failed to initialize, check code and message
    }

    final regions = <Region>[];

    if (Platform.isIOS) {
      // iOS platform, at least set identifier and proximityUUID for region scanning
      regions.add(Region(
          identifier: 'Apple Airlocate',
          proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
    } else {
      // android platform, it can ranging out of beacon that filter all of Proximity UUID
      regions.add(Region(identifier: 'com.beacon'));
    }

// to start ranging beacons
    _streamRanging = flutterBeacon.ranging(regions).listen((RangingResult result) {
      // result contains a region and list of beacons found
      // list can be empty if no matching beacons were found in range
      setState(() {
        for(var item in result.beacons){
          beaconList.add("MacAddress: "+item.macAddress +"\n ProximityUUID: "+ item.proximityUUID);
        }
      });
    });
  }

  _stopRanging(){
    _streamRanging.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detect beacons"),
      ),
      body:  Padding(
        padding: const EdgeInsets.fromLTRB(42, 20, 0, 0),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        child: Text("Start finding"),
                        onPressed: () {
                          _startRanging();
                        }
                    ),
                  ),
                  RaisedButton(
                      child: Text("Stop finding"),
                      onPressed: (){
                        _stopRanging();
                      }
                  ),

                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(child: Text(beaconList.toString()))
                ],
              )
            ],
          ),

        ),
      ),
    );
  }
}

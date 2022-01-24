import 'dart:collection';
import 'dart:io';

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motb_ble/models/ble_model.dart';
import 'package:motb_ble/views/bleSearchView.dart';

final floorInfoProvider = StateProvider<List>((ref) => []);

class BLEMapView extends HookConsumerWidget {
  const BLEMapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = useStreamController();
    final bleDeviceMap = ref.watch(bleListProvider.state);
    final bleDeviceList = ref.watch(floorInfoProvider.state);
    final bleDeviceListController = ref.read(floorInfoProvider.state);

    fetch() async {
      BeaconsPlugin.listenToBeacons(stream);
      BeaconsPlugin.setDebugLevel(0);

      // if you need to monitor also major and minor use the original version and not this fork
      BeaconsPlugin.addRegion("myBeacon", "FE913213-B311-4A42-8C16-47FAEAC938DB").then((result) {
        print('running');
      });

      //Send 'true' to run in background [OPTIONAL]

      //IMPORTANT: Start monitoring once scanner is setup & ready (only for Android)
      if (Platform.isAndroid) {
        BeaconsPlugin.channel.setMethodCallHandler((call) async {
          if (call.method == 'scannerReady') {
            await BeaconsPlugin.startMonitoring();
          }
        });
      } else if (Platform.isIOS) {
        await BeaconsPlugin.startMonitoring();
      }

      stream.stream.listen(
        (data) {
          if (data.isNotEmpty) {
            final BLE ble = BLE.fromJson(data);

            if (ble.distance > 0) {
              final newList = [
                ble.major,
                ble.minor.toString()[0],
                ble.minor.toString()[1],
                ble.minor.toString()[2]
              ];

              final Map<String, BLE> newMap = {...ref.read(bleListProvider.state).state};
              newMap['Major${ble.major}minor${ble.minor}'] = ble;

              ref.read(bleListProvider.state).state = newMap;
              ref.read(floorInfoProvider.state).state = [...newList];
            }
          }
        },
        onDone: () {
          print('=========done=========');
        },
        onError: (error) {
          print("Error: $error");
        },
      );
    }

    stopFetch() async {
      BeaconsPlugin.stopMonitoring();
      ref.read(bleListProvider.state).state = {};
    }

    fetch();

    final Map<String, BLE> sortedDeviceList = SplayTreeMap.from(
        ref.watch(bleListProvider.state).state,
        (key1, key2) =>
            bleDeviceMap.state[key1]!.distance.compareTo(bleDeviceMap.state[key2]!.distance));

    BLE nearestBleDevice = sortedDeviceList.entries.first.value;
    return bleDeviceList.state.length > 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  '${nearestBleDevice.proximity} minor: ${nearestBleDevice.minor} ${nearestBleDevice.distance}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Raw data: ${bleDeviceList.state}')],
              ),
              Text(
                  'You are on floor: ${bleDeviceList.state[0].toString() == '0' ? 'tbd' : bleDeviceList.state[0]}',
                  textScaleFactor: 2),
              Text(
                  'You are in gallery: ${bleDeviceList.state[1].toString() == '0' ? 'tbd' : bleDeviceList.state[1].toString()}',
                  textScaleFactor: 2),
              Text(
                  'You are near: ${bleDeviceList.state[2].toString() == '0' ? 'tbd' : 'Great Isaiah Scroll'}',
                  textScaleFactor: 2),
            ],
          )
        : Text('empty');
  }
}

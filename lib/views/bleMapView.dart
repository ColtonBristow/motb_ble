import 'dart:collection';
import 'dart:io';

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motb_ble/models/ble_model.dart';
import 'package:motb_ble/views/bleSearchView.dart';

class BLEMapView extends HookConsumerWidget {
  const BLEMapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = useStreamController();
    final bleDeviceList = ref.watch(bleListProvider.state);
    final bleDeviceListController = ref.read(bleListProvider.state);

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
            final Map<String, BLE> newMap = {...ref.read(bleListProvider.state).state};
            newMap['Major${ble.major}minor${ble.minor}'] = ble;

            ref.read(bleListProvider.state).state = newMap;
          }
        },
        onDone: () {
          print('done');
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

    final Map<String, BLE> sortedDeviceList =
        SplayTreeMap.from(bleDeviceList.state, (key1, key2) => bleDeviceList.state[key1]!.distance.compareTo(bleDeviceList.state[key2]!.distance));

    BLE nearestBleDevice = sortedDeviceList.entries.first.value;

    fetch();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [],
        ),
        Text(nearestBleDevice.minor.toString(), textScaleFactor: 2),
      ],
    );
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motb_ble/models/ble_model.dart';
import 'package:motb_ble/repositories/customException.dart';

final BlESListControllerProvider = StateNotifierProvider<BlESListController, AsyncValue<Map<String, BLE>>>((ref) => BlESListController(ref.read));

final groupListExceptionProvider = StateProvider<CustomException?>((_) => null);

class BlESListController extends StateNotifier<AsyncValue<Map<String, BLE>>> {
  final Reader read;
  final StreamController streamController = useStreamController();

  BlESListController(this.read) : super(AsyncValue.data({})) {
    retrieveBlES();
  }

  Future<void> retrieveBlES({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    try {
      BeaconsPlugin.listenToBeacons(streamController);
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

      streamController.stream.listen(
        (data) {
          if (data.isNotEmpty) {
            final BLE ble = BLE.fromJson(data);
            final Map<String, BLE> newMap = {};
            newMap['Major${ble.major}minor${ble.minor}'] = ble;

            state.whenData((devices) => state = AsyncValue.data(devices..addAll(newMap)));
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        },
      );
    } on CustomException catch (e) {
      state = AsyncValue.error(e);
    }
  }
}

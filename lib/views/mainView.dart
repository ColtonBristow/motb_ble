import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:motb_ble/views/widgets/bleResultWidget.dart';

final indexProvider = StateProvider<int>((ref) => 0);

class MainView extends ConsumerStatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> with WidgetsBindingObserver {
  //! create vars and init plugin
  @override
  Widget build(BuildContext context) {
    final views = [
      BLEResultWidget(),
      Column(),
      Column(),
      Column(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COLTONS BLE POC ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: views[0],
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: SnakeNavigationBar.color(
        currentIndex: ref.watch(indexProvider.state).state,
        backgroundColor: Theme.of(context).cardColor,
        onTap: (index) {
          ref.read(indexProvider.state).state = index;
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        snakeShape: SnakeShape.indicator,
        padding: Platform.isIOS ? EdgeInsets.fromLTRB(20, 0, 20, 0) : EdgeInsets.fromLTRB(20, 0, 20, 10),
        snakeViewColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        behaviour: SnakeBarBehaviour.floating,
        elevation: 3,
        items: [
          BottomNavigationBarItem(
            icon: Icon(LineIcons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.map),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.bluetooth),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.cog),
          )
        ],
      ),
    );
  }
}

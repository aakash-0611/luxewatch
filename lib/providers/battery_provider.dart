import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryProvider extends ChangeNotifier {
  final Battery _battery = Battery();

  int _level = 0;
  BatteryState _state = BatteryState.unknown;

  int get level => _level;

  /// 👈 THIS IS WHAT WAS MISSING
  bool get isCharging => _state == BatteryState.charging;

  BatteryProvider() {
    _init();
  }

  Future<void> _init() async {
    _level = await _battery.batteryLevel;
    _state = await _battery.batteryState;

    _battery.onBatteryStateChanged.listen((state) {
      _state = state;
      notifyListeners();
    });

    notifyListeners();
  }
}

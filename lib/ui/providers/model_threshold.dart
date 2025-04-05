import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModelThresholdProvider extends StateNotifier<int> {
  ModelThresholdProvider() : super(50);
  void changeThreshold(double value) => state = value.round();
}

final modelThresholdProvider =
    StateNotifierProvider<ModelThresholdProvider, int>(
        (ref) => ModelThresholdProvider());

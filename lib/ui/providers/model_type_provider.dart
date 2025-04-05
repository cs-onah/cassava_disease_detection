import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ModelType { version2, version3, http }

class ModelTypeProvider extends StateNotifier<ModelType> {
  ModelTypeProvider() : super(ModelType.http);

  void changeType(ModelType type) => state = type;
}

final modelTypeProvider = StateNotifierProvider<ModelTypeProvider, ModelType>(
    (ref) => ModelTypeProvider());

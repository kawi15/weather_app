import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/services/units_service.dart';

import '../../../data/enums/units.dart';


class UnitsCubit extends Cubit<Units> {
  final UnitsService service;

  UnitsCubit(this.service) : super(Units.metric);

  Future<void> loadUnits() async {
    final units = await service.loadUnits();
    emit(units);
  }

  Future<void> updateUnits(Units newUnits) async {
    await service.saveUnits(newUnits);
    emit(newUnits);
  }
}
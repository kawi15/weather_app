import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/data/enums/units.dart';
import 'package:weather/data/services/units_service.dart';
import 'package:weather/presentation/blocs/units/units_cubit.dart';

class MockUnitsService extends Mock implements UnitsService {}

void main() {
  late MockUnitsService mockService;
  late UnitsCubit cubit;

  setUp(() {
    mockService = MockUnitsService();
    cubit = UnitsCubit(mockService);
  });

  test('initial state is Units.metric', () {
    expect(cubit.state, Units.metric);
  });

  test('loadUnits emits the units returned by service', () async {
    when(() => mockService.loadUnits()).thenAnswer((_) async => Units.imperial);

    await cubit.loadUnits();

    expect(cubit.state, Units.imperial);
  });

  test('updateUnits saves the new units and emits them', () async {
    when(() => mockService.saveUnits(Units.standard))
        .thenAnswer((_) async => Future.value());

    await cubit.updateUnits(Units.standard);

    verify(() => mockService.saveUnits(Units.standard)).called(1);

    expect(cubit.state, Units.standard);
  });
}

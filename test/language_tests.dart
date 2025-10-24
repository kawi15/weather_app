import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weather/presentation/blocs/language/language_cubit.dart';



class MockStorage extends Mock implements HydratedStorage {}

void main() {
  late HydratedStorage storage;

  setUp(() {
    storage = MockStorage();
    HydratedBloc.storage = storage;
  });

  test('initial state is English', () {
    when(() => storage.read(any())).thenReturn(null);

    final cubit = LanguageCubit();
    expect(cubit.state, const Locale('en'));
  });

  test('changeLanguage updates the state', () {
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any())).thenAnswer((_) async {});

    final cubit = LanguageCubit();
    cubit.changeLanguage(const Locale('pl'));

    expect(cubit.state, const Locale('pl'));
  });
}

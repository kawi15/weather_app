import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class LanguageCubit extends HydratedCubit<Locale> {
  LanguageCubit() : super(const Locale('en'));

  void changeLanguage(Locale locale) => emit(locale);

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final code = json['languageCode'] as String?;
    return code != null ? Locale(code) : null;
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {'languageCode': state.languageCode};
  }
}
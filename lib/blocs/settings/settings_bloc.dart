import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// 앱 전역 설정(글씨 크기 등)을 관리하는 BLoC.
///
/// 글씨 배율(textScale)은 MaterialApp.builder 에서 MediaQuery.textScaler 에
/// 적용되어 전 화면에 반영된다. shared_preferences 로 영구 저장한다.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsLoaded>(_onLoaded);
    on<TextScaleChanged>(_onTextScaleChanged);
  }

  static const String _prefsKey = 'text_scale_level';

  /// 앱 시작 시 저장된 설정을 불러온다.
  Future<void> _onLoaded(
    SettingsLoaded event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idx = prefs.getInt(_prefsKey);
      if (idx != null && idx >= 0 && idx < TextScaleLevel.values.length) {
        emit(state.copyWith(level: TextScaleLevel.values[idx]));
      }
    } catch (e) {
      debugPrint('⚙️ [SettingsBloc] 설정 로드 실패: $e');
    }
  }

  /// 글씨 크기 단계를 변경하고 저장한다.
  Future<void> _onTextScaleChanged(
    TextScaleChanged event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(level: event.level));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_prefsKey, event.level.index);
    } catch (e) {
      debugPrint('⚙️ [SettingsBloc] 설정 저장 실패: $e');
    }
  }
}

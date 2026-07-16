import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangangbus/theme/app_colors.dart';
import 'package:hangangbus/blocs/clock/clock_bloc.dart';
import 'package:hangangbus/blocs/faq/faq_bloc.dart';
import 'package:hangangbus/blocs/navigation/navigation_bloc.dart';
import 'package:hangangbus/blocs/realtime/realtime_bloc.dart';
import 'package:hangangbus/blocs/schedule/schedule_bloc.dart';
import 'package:hangangbus/blocs/story/story_bloc.dart';
import 'package:hangangbus/blocs/weather/weather_bloc.dart';
import 'package:hangangbus/blocs/settings/settings_bloc.dart';
import 'package:hangangbus/repositories/content_repository.dart';
import 'package:hangangbus/repositories/realtime_repository.dart';
import 'package:hangangbus/repositories/schedule_repository.dart';
import 'package:hangangbus/repositories/weather_repository.dart';
import 'package:hangangbus/l10n/app_localizations.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'screens/tab1_home.dart' as home;
import 'screens/tab2_schedule.dart' as schedule;
import 'screens/tab3_story.dart';
import 'screens/tab4_faq.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // env 파일 로드
  // 카카오맵 SDK 초기화
  final kakaoAppKey = dotenv.env['KAKAO_APP_KEY'] ?? '';
  if (kakaoAppKey.isEmpty) {
    throw Exception('KAKAO_APP_KEY가 .env 파일에 설정되지 않았습니다.');
  }

  try {
    AuthRepository.initialize(appKey: kakaoAppKey);
    debugPrint('✅ 카카오맵 초기화 완료!');
  } catch (e) {
    debugPrint('❌ 카카오맵 초기화 실패: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => const WeatherRepository()),
        RepositoryProvider(create: (_) => const RealtimeRepository()),
        RepositoryProvider(create: (_) => const ScheduleRepository()),
        RepositoryProvider(create: (_) => const ContentRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavigationBloc()),
          BlocProvider(
            create: (_) => SettingsBloc()..add(const SettingsLoaded()),
          ),
          BlocProvider(create: (_) => ClockBloc()..add(const ClockStarted())),
          BlocProvider(
            create: (ctx) =>
                WeatherBloc(ctx.read<WeatherRepository>())
                  ..add(const WeatherSubscriptionRequested()),
          ),
          BlocProvider(
            create: (ctx) =>
                RealtimeBloc(ctx.read<RealtimeRepository>())
                  ..add(const RealtimeSubscriptionRequested()),
          ),
          BlocProvider(
            create: (ctx) => ScheduleBloc(ctx.read<ScheduleRepository>()),
          ),
          BlocProvider(create: (_) => StoryBloc()),
          BlocProvider(create: (_) => FaqBloc()),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settings) {
            return MaterialApp(
              title: '한강버스 가이드',
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                // 앱 전역 글씨 배율 적용 (고령층 큰글씨 기능).
                // 상한 1.6으로 클램프해 레이아웃 깨짐 방지.
                final scaler = TextScaler.linear(settings.textScale);
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: scaler),
                  child: child!,
                );
              },
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
                primaryColor: AppColors.primary, // 한강 블루
                scaffoldBackgroundColor: AppColors.background,
                splashFactory: InkRipple.splashFactory,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  titleTextStyle: TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  iconTheme: IconThemeData(color: AppColors.ink),
                ),
              ),
              home: const MainBase(),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ko'),
                Locale('en'),
                Locale('ja'),
                Locale('zh'),
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                if (locale == null) return const Locale('ko');
                for (final supported in supportedLocales) {
                  if (supported.languageCode == locale.languageCode) {
                    return supported;
                  }
                }
                return const Locale('ko'); // fallback: 한국어
              },
            );
          },
        ),
      ),
    );
  }
}

class MainBase extends StatelessWidget {
  const MainBase({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const screens = [
      home.Tab1Home(),
      schedule.Tab2Schedule(),
      Tab3Story(),
      Tab4Faq(),
    ];

    final currentIndex = context.select(
      (NavigationBloc bloc) => bloc.state.currentIndex,
    );

    void selectTab(int index) {
      HapticFeedback.lightImpact();
      context.read<NavigationBloc>().add(NavTabSelected(index));
    }

    return Scaffold(
      body: SafeArea(child: screens[currentIndex]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.hairline)),
        ),
        child: SafeArea(
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Colors.transparent,
              overlayColor: WidgetStatePropertyAll(
                AppColors.primary.withValues(alpha: 0.06),
              ),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  );
                }
                return const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.inkTertiary,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(
                    color: AppColors.primary,
                    size: 25,
                  );
                }
                return const IconThemeData(
                  color: AppColors.inkTertiary,
                  size: 24,
                );
              }),
            ),
            child: NavigationBar(
              height: 60,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedIndex: currentIndex,
              onDestinationSelected: selectTab,
              animationDuration: const Duration(milliseconds: 200),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                  label: l10n.navHome, // 다국어 적용
                ),
                NavigationDestination(
                  icon: const Icon(Icons.schedule_outlined),
                  selectedIcon: const Icon(Icons.schedule_rounded),
                  label: l10n.navSchedule,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.auto_stories_outlined),
                  selectedIcon: const Icon(Icons.auto_stories_rounded),
                  label: l10n.navGuide,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.help_outline_rounded),
                  selectedIcon: const Icon(Icons.help_rounded),
                  label: l10n.navFaq,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

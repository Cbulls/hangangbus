import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @timetableTitle.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get timetableTitle;

  /// No description provided for @directionMagokToYeouido.
  ///
  /// In en, this message translates to:
  /// **'Magok → Yeouido'**
  String get directionMagokToYeouido;

  /// No description provided for @directionYeouidoToMagok.
  ///
  /// In en, this message translates to:
  /// **'Yeouido → Magok'**
  String get directionYeouidoToMagok;

  /// No description provided for @dockMagok.
  ///
  /// In en, this message translates to:
  /// **'Magok'**
  String get dockMagok;

  /// No description provided for @dockMangwon.
  ///
  /// In en, this message translates to:
  /// **'Mangwon'**
  String get dockMangwon;

  /// No description provided for @dockYeouido.
  ///
  /// In en, this message translates to:
  /// **'Yeouido'**
  String get dockYeouido;

  /// No description provided for @dockApgujeong.
  ///
  /// In en, this message translates to:
  /// **'Apgujeong'**
  String get dockApgujeong;

  /// No description provided for @dockOksu.
  ///
  /// In en, this message translates to:
  /// **'Oksu'**
  String get dockOksu;

  /// No description provided for @dockTtukseom.
  ///
  /// In en, this message translates to:
  /// **'Ttukseom'**
  String get dockTtukseom;

  /// No description provided for @dockJamsil.
  ///
  /// In en, this message translates to:
  /// **'Jamsil'**
  String get dockJamsil;

  /// No description provided for @directionToYeouido.
  ///
  /// In en, this message translates to:
  /// **'To Yeouido'**
  String get directionToYeouido;

  /// No description provided for @directionToMagok.
  ///
  /// In en, this message translates to:
  /// **'To Magok'**
  String get directionToMagok;

  /// No description provided for @directionToJamsil.
  ///
  /// In en, this message translates to:
  /// **'To Jamsil'**
  String get directionToJamsil;

  /// No description provided for @nextBoat.
  ///
  /// In en, this message translates to:
  /// **'Next Boat'**
  String get nextBoat;

  /// No description provided for @firstBoat.
  ///
  /// In en, this message translates to:
  /// **'First Boat'**
  String get firstBoat;

  /// No description provided for @lastBoat.
  ///
  /// In en, this message translates to:
  /// **'Last Boat'**
  String get lastBoat;

  /// No description provided for @departIn.
  ///
  /// In en, this message translates to:
  /// **'Departs {time}'**
  String departIn(String time);

  /// No description provided for @serviceClosedToday.
  ///
  /// In en, this message translates to:
  /// **'Service Ended for Today'**
  String get serviceClosedToday;

  /// No description provided for @tomorrowFirstBoat.
  ///
  /// In en, this message translates to:
  /// **'First boat tomorrow {time}'**
  String tomorrowFirstBoat(String time);

  /// No description provided for @transferHub.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transferHub;

  /// No description provided for @yeouidoTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Yeouido Transfer'**
  String get yeouidoTransferTitle;

  /// No description provided for @routeOverview.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get routeOverview;

  /// No description provided for @boundFor.
  ///
  /// In en, this message translates to:
  /// **'To {dock}'**
  String boundFor(String dock);

  /// No description provided for @minutesLeft.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesLeft(int minutes);

  /// No description provided for @hoursMinutesLeft.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String hoursMinutesLeft(int hours, int minutes);

  /// No description provided for @departed.
  ///
  /// In en, this message translates to:
  /// **'Departed'**
  String get departed;

  /// No description provided for @storyPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Han River Stories'**
  String get storyPageTitle;

  /// No description provided for @storyPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'History & Food near each dock'**
  String get storyPageSubtitle;

  /// No description provided for @categoryHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get categoryHistory;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @infoLabelLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get infoLabelLocation;

  /// No description provided for @infoLabelAccess.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get infoLabelAccess;

  /// No description provided for @infoLabelPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get infoLabelPeriod;

  /// No description provided for @infoLabelHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get infoLabelHours;

  /// No description provided for @infoLabelPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get infoLabelPrice;

  /// No description provided for @dockSuffix.
  ///
  /// In en, this message translates to:
  /// **'{dockName} Dock'**
  String dockSuffix(String dockName);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Han River Bus'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live Operation Status'**
  String get homeSubtitle;

  /// No description provided for @nextArrival.
  ///
  /// In en, this message translates to:
  /// **'Next Departure'**
  String get nextArrival;

  /// No description provided for @freeShuttle.
  ///
  /// In en, this message translates to:
  /// **'Free Shuttle'**
  String get freeShuttle;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @parkingSpacesAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} spaces available'**
  String parkingSpacesAvailable(int count);

  /// No description provided for @parkingSpacesSuffix.
  ///
  /// In en, this message translates to:
  /// **'{count} spaces'**
  String parkingSpacesSuffix(int count);

  /// No description provided for @parkingSpacesTotal.
  ///
  /// In en, this message translates to:
  /// **'Available out of {count} total'**
  String parkingSpacesTotal(int count);

  /// No description provided for @fullTimetable.
  ///
  /// In en, this message translates to:
  /// **'Full Timetable'**
  String get fullTimetable;

  /// No description provided for @nearbyAttractions.
  ///
  /// In en, this message translates to:
  /// **'Nearby Attractions'**
  String get nearbyAttractions;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get todayLabel;

  /// No description provided for @statTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get statTrips;

  /// No description provided for @statPassengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get statPassengers;

  /// No description provided for @statOnTime.
  ///
  /// In en, this message translates to:
  /// **'On-Time'**
  String get statOnTime;

  /// No description provided for @liveStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get liveStatusLabel;

  /// No description provided for @liveDataUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get liveDataUnavailable;

  /// No description provided for @liveUpdatedJustNow.
  ///
  /// In en, this message translates to:
  /// **'Updated just now'**
  String get liveUpdatedJustNow;

  /// No description provided for @liveUpdatedAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {minutes}m ago'**
  String liveUpdatedAgo(int minutes);

  /// No description provided for @statTodayTrips.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Trips'**
  String get statTodayTrips;

  /// No description provided for @statCongestion.
  ///
  /// In en, this message translates to:
  /// **'Congestion'**
  String get statCongestion;

  /// No description provided for @statBikesShort.
  ///
  /// In en, this message translates to:
  /// **'Bikes'**
  String get statBikesShort;

  /// No description provided for @statParkingShort.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get statParkingShort;

  /// No description provided for @congestionRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get congestionRelaxed;

  /// No description provided for @congestionNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get congestionNormal;

  /// No description provided for @congestionSlightlyBusy.
  ///
  /// In en, this message translates to:
  /// **'Slightly Busy'**
  String get congestionSlightlyBusy;

  /// No description provided for @congestionBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get congestionBusy;

  /// No description provided for @congestionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get congestionUnknown;

  /// No description provided for @statusNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get statusNormal;

  /// No description provided for @statusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get statusPartial;

  /// No description provided for @statusStopped.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get statusStopped;

  /// No description provided for @facilityConvenienceStore.
  ///
  /// In en, this message translates to:
  /// **'Convenience Store'**
  String get facilityConvenienceStore;

  /// No description provided for @facilityRamen.
  ///
  /// In en, this message translates to:
  /// **'Ramen Zone'**
  String get facilityRamen;

  /// No description provided for @facilityFastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast Food'**
  String get facilityFastFood;

  /// No description provided for @facilityCafe.
  ///
  /// In en, this message translates to:
  /// **'Café'**
  String get facilityCafe;

  /// No description provided for @dockSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} Dock'**
  String dockSheetTitle(String name);

  /// No description provided for @realtimeStatus.
  ///
  /// In en, this message translates to:
  /// **'Live Status'**
  String get realtimeStatus;

  /// No description provided for @weatherInfo.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherInfo;

  /// No description provided for @hourlyForecast.
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get hourlyForecast;

  /// No description provided for @fullForecast.
  ///
  /// In en, this message translates to:
  /// **'View 24h Forecast'**
  String get fullForecast;

  /// No description provided for @weatherForecast24h.
  ///
  /// In en, this message translates to:
  /// **'24-Hour Forecast'**
  String get weatherForecast24h;

  /// No description provided for @accessInfo.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get accessInfo;

  /// No description provided for @walkingMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min walk'**
  String walkingMinutes(int minutes);

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @scheduleAndMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get scheduleAndMap;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like {temp}°'**
  String feelsLike(String temp);

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get windSpeed;

  /// No description provided for @fineDust.
  ///
  /// In en, this message translates to:
  /// **'Dust Level'**
  String get fineDust;

  /// No description provided for @updatedMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated 5m ago'**
  String get updatedMinutesAgo;

  /// No description provided for @currentPopulation.
  ///
  /// In en, this message translates to:
  /// **'Population'**
  String get currentPopulation;

  /// No description provided for @bikeShare.
  ///
  /// In en, this message translates to:
  /// **'Bike Share'**
  String get bikeShare;

  /// No description provided for @bikeStationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Stations'**
  String bikeStationsCount(int count);

  /// No description provided for @bikesAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} Available'**
  String bikesAvailable(int count);

  /// No description provided for @weeklyForecast.
  ///
  /// In en, this message translates to:
  /// **'View Weekly Forecast'**
  String get weeklyForecast;

  /// No description provided for @dustGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get dustGood;

  /// No description provided for @dustNormal.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get dustNormal;

  /// No description provided for @dustBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get dustBad;

  /// No description provided for @dustVeryBad.
  ///
  /// In en, this message translates to:
  /// **'Very Bad'**
  String get dustVeryBad;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'Service Ended'**
  String get statusClosed;

  /// No description provided for @endOfService.
  ///
  /// In en, this message translates to:
  /// **'Service Ended'**
  String get endOfService;

  /// No description provided for @boardingDeclaration.
  ///
  /// In en, this message translates to:
  /// **'Passenger Check-in'**
  String get boardingDeclaration;

  /// No description provided for @statTripsValue.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String statTripsValue(int count);

  /// No description provided for @statPassengersValue.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String statPassengersValue(int count);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navGuide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get navGuide;

  /// No description provided for @navFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get navFaq;

  /// No description provided for @tabFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get tabFaq;

  /// No description provided for @tabSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety Rules'**
  String get tabSafety;

  /// No description provided for @safetyTitleLifeVest.
  ///
  /// In en, this message translates to:
  /// **'Life Vest Location'**
  String get safetyTitleLifeVest;

  /// No description provided for @safetyLifeVestAdult.
  ///
  /// In en, this message translates to:
  /// **'One adult life vest is provided in the storage compartment under each seat.'**
  String get safetyLifeVestAdult;

  /// No description provided for @safetyLifeVestChild.
  ///
  /// In en, this message translates to:
  /// **'Life vests for infants and children are stored in a separate cabin cabinet. Please ask a crew member.'**
  String get safetyLifeVestChild;

  /// No description provided for @safetyLifeVestAccess.
  ///
  /// In en, this message translates to:
  /// **'Life vest compartments remain unlocked at all times for immediate access during emergencies.'**
  String get safetyLifeVestAccess;

  /// No description provided for @safetyTitleHowToWear.
  ///
  /// In en, this message translates to:
  /// **'How to Wear a Life Vest'**
  String get safetyTitleHowToWear;

  /// No description provided for @safetyWearStep1.
  ///
  /// In en, this message translates to:
  /// **'Open the storage compartment under your seat and take out the life vest.'**
  String get safetyWearStep1;

  /// No description provided for @safetyWearStep2.
  ///
  /// In en, this message translates to:
  /// **'Place the life vest over your head.'**
  String get safetyWearStep2;

  /// No description provided for @safetyWearStep3.
  ///
  /// In en, this message translates to:
  /// **'Fasten the front buckles until you hear a \'click\'.'**
  String get safetyWearStep3;

  /// No description provided for @safetyWearStep4.
  ///
  /// In en, this message translates to:
  /// **'Pull the waist straps tight so the vest fits snugly to your body.'**
  String get safetyWearStep4;

  /// No description provided for @safetyWearStep5.
  ///
  /// In en, this message translates to:
  /// **'After entering the water, pull the red handle (CO2 inflator) firmly to inflate the vest.'**
  String get safetyWearStep5;

  /// No description provided for @safetyWearTip.
  ///
  /// In en, this message translates to:
  /// **'If it fails to inflate automatically, blow into the yellow oral inflation tube.'**
  String get safetyWearTip;

  /// No description provided for @safetyTitleEvacuation.
  ///
  /// In en, this message translates to:
  /// **'Emergency Evacuation'**
  String get safetyTitleEvacuation;

  /// No description provided for @safetyEvacExit.
  ///
  /// In en, this message translates to:
  /// **'Emergency exits are located at both the front (bow) and rear (stern). Please locate them upon boarding.'**
  String get safetyEvacExit;

  /// No description provided for @safetyEvacCalm.
  ///
  /// In en, this message translates to:
  /// **'In case of emergency, stay calm and evacuate through designated exits following crew instructions.'**
  String get safetyEvacCalm;

  /// No description provided for @safetyEvacStay.
  ///
  /// In en, this message translates to:
  /// **'Never leave your seat until the vessel has come to a complete stop.'**
  String get safetyEvacStay;

  /// No description provided for @safetyEvacRescue.
  ///
  /// In en, this message translates to:
  /// **'After evacuation, move to the dock or rescue boat. Emergency teams are on standby for immediate dispatch.'**
  String get safetyEvacRescue;

  /// No description provided for @safetyTitleReporting.
  ///
  /// In en, this message translates to:
  /// **'How to Report an Emergency'**
  String get safetyTitleReporting;

  /// No description provided for @safetyReportCall.
  ///
  /// In en, this message translates to:
  /// **'Notify a crew member immediately, or call the Hangang Bus Center or 119.'**
  String get safetyReportCall;

  /// No description provided for @safetyReportTube.
  ///
  /// In en, this message translates to:
  /// **'Lifebuoys (ring buoys) on board can be thrown to rescue someone in the water.'**
  String get safetyReportTube;

  /// No description provided for @safetyReportQR.
  ///
  /// In en, this message translates to:
  /// **'You must complete the boarding report via QR code before departure for rapid rescue in an emergency.'**
  String get safetyReportQR;

  /// No description provided for @safetyTitleAttention.
  ///
  /// In en, this message translates to:
  /// **'Boarding Precautions'**
  String get safetyTitleAttention;

  /// No description provided for @safetyAttentionWave.
  ///
  /// In en, this message translates to:
  /// **'The vessel may shake due to waves, especially when other boats pass. Please hold onto the handrails.'**
  String get safetyAttentionWave;

  /// No description provided for @safetyAttentionDeck.
  ///
  /// In en, this message translates to:
  /// **'To access the outdoor deck, you must first complete the boarding report via the onboard QR code.'**
  String get safetyAttentionDeck;

  /// No description provided for @safetyAttentionDanger.
  ///
  /// In en, this message translates to:
  /// **'Never enter restricted areas such as the electrical equipment room.'**
  String get safetyAttentionDanger;

  /// No description provided for @safetyAttentionBike.
  ///
  /// In en, this message translates to:
  /// **'Personal bicycles are allowed, but \'Ttareungyi\' and electric scooters (including e-bikes) are prohibited.'**
  String get safetyAttentionBike;

  /// No description provided for @safetyAttentionChild.
  ///
  /// In en, this message translates to:
  /// **'When traveling with children, you may request assistance from the crew to prevent missing children.'**
  String get safetyAttentionChild;

  /// No description provided for @emergencyBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'In Case of Emergency'**
  String get emergencyBannerTitle;

  /// No description provided for @emergencyBannerContact.
  ///
  /// In en, this message translates to:
  /// **'Report to Crew  |  119'**
  String get emergencyBannerContact;

  /// No description provided for @emergencyBannerRescue.
  ///
  /// In en, this message translates to:
  /// **'Real-time connection with River Police & Fire Rescue'**
  String get emergencyBannerRescue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get timetableTitle => 'Timetable';

  @override
  String get directionMagokToYeouido => 'Magok → Yeouido';

  @override
  String get directionYeouidoToMagok => 'Yeouido → Magok';

  @override
  String get dockMagok => 'Magok';

  @override
  String get dockMangwon => 'Mangwon';

  @override
  String get dockYeouido => 'Yeouido';

  @override
  String get dockApgujeong => 'Apgujeong';

  @override
  String get dockOksu => 'Oksu';

  @override
  String get dockTtukseom => 'Ttukseom';

  @override
  String get dockJamsil => 'Jamsil';

  @override
  String get directionToYeouido => 'To Yeouido';

  @override
  String get directionToMagok => 'To Magok';

  @override
  String get directionToJamsil => 'To Jamsil';

  @override
  String get nextBoat => 'Next Boat';

  @override
  String get firstBoat => 'First Boat';

  @override
  String get lastBoat => 'Last Boat';

  @override
  String departIn(String time) {
    return 'Departs $time';
  }

  @override
  String get serviceClosedToday => 'Service Ended for Today';

  @override
  String tomorrowFirstBoat(String time) {
    return 'First boat tomorrow $time';
  }

  @override
  String get transferHub => 'Transfer';

  @override
  String get yeouidoTransferTitle => 'Yeouido Transfer';

  @override
  String get routeOverview => 'Route';

  @override
  String boundFor(String dock) {
    return 'To $dock';
  }

  @override
  String minutesLeft(int minutes) {
    return '$minutes min';
  }

  @override
  String hoursMinutesLeft(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get departed => 'Departed';

  @override
  String get storyPageTitle => 'Han River Stories';

  @override
  String get storyPageSubtitle => 'History & Food near each dock';

  @override
  String get categoryHistory => 'History';

  @override
  String get categoryFood => 'Food';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get infoLabelLocation => 'Location';

  @override
  String get infoLabelAccess => 'Access';

  @override
  String get infoLabelPeriod => 'Period';

  @override
  String get infoLabelHours => 'Hours';

  @override
  String get infoLabelPrice => 'Price';

  @override
  String dockSuffix(String dockName) {
    return '$dockName Dock';
  }

  @override
  String get homeTitle => 'Han River Bus';

  @override
  String get homeSubtitle => 'Live Operation Status';

  @override
  String get nextArrival => 'Next Departure';

  @override
  String get freeShuttle => 'Free Shuttle';

  @override
  String get parking => 'Parking';

  @override
  String parkingSpacesAvailable(int count) {
    return '$count spaces available';
  }

  @override
  String parkingSpacesSuffix(int count) {
    return '$count spaces';
  }

  @override
  String parkingSpacesTotal(int count) {
    return 'Available out of $count total';
  }

  @override
  String get fullTimetable => 'Full Timetable';

  @override
  String get nearbyAttractions => 'Nearby Attractions';

  @override
  String get todayLabel => 'TODAY';

  @override
  String get statTrips => 'Trips';

  @override
  String get statPassengers => 'Passengers';

  @override
  String get statOnTime => 'On-Time';

  @override
  String get liveStatusLabel => 'LIVE';

  @override
  String get liveDataUnavailable => 'No data';

  @override
  String get liveUpdatedJustNow => 'Updated just now';

  @override
  String liveUpdatedAgo(int minutes) {
    return 'Updated ${minutes}m ago';
  }

  @override
  String get statTodayTrips => 'Today\'s Trips';

  @override
  String get statCongestion => 'Congestion';

  @override
  String get statBikesShort => 'Bikes';

  @override
  String get statParkingShort => 'Parking';

  @override
  String get congestionRelaxed => 'Relaxed';

  @override
  String get congestionNormal => 'Normal';

  @override
  String get congestionSlightlyBusy => 'Slightly Busy';

  @override
  String get congestionBusy => 'Busy';

  @override
  String get congestionUnknown => 'Unknown';

  @override
  String get statusNormal => 'Normal';

  @override
  String get statusPartial => 'Partial';

  @override
  String get statusStopped => 'Suspended';

  @override
  String get facilityConvenienceStore => 'Convenience Store';

  @override
  String get facilityRamen => 'Ramen Zone';

  @override
  String get facilityFastFood => 'Fast Food';

  @override
  String get facilityCafe => 'Café';

  @override
  String dockSheetTitle(String name) {
    return '$name Dock';
  }

  @override
  String get realtimeStatus => 'Live Status';

  @override
  String get weatherInfo => 'Weather';

  @override
  String get hourlyForecast => 'Hourly Forecast';

  @override
  String get fullForecast => 'View 24h Forecast';

  @override
  String get weatherForecast24h => '24-Hour Forecast';

  @override
  String get accessInfo => 'Access';

  @override
  String walkingMinutes(int minutes) {
    return '$minutes min walk';
  }

  @override
  String get facilities => 'Facilities';

  @override
  String get scheduleAndMap => 'Map';

  @override
  String feelsLike(String temp) {
    return 'Feels like $temp°';
  }

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind';

  @override
  String get fineDust => 'Dust Level';

  @override
  String get updatedMinutesAgo => 'Updated 5m ago';

  @override
  String get currentPopulation => 'Population';

  @override
  String get bikeShare => 'Bike Share';

  @override
  String bikeStationsCount(int count) {
    return '$count Stations';
  }

  @override
  String bikesAvailable(int count) {
    return '$count Available';
  }

  @override
  String get weeklyForecast => 'View Weekly Forecast';

  @override
  String get dustGood => 'Good';

  @override
  String get dustNormal => 'Moderate';

  @override
  String get dustBad => 'Bad';

  @override
  String get dustVeryBad => 'Very Bad';

  @override
  String get statusClosed => 'Service Ended';

  @override
  String get endOfService => 'Service Ended';

  @override
  String get boardingDeclaration => 'Passenger Check-in';

  @override
  String statTripsValue(int count) {
    return '$count';
  }

  @override
  String statPassengersValue(int count) {
    return '$count';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navGuide => 'Guide';

  @override
  String get navFaq => 'FAQ';

  @override
  String get tabFaq => 'FAQ';

  @override
  String get tabSafety => 'Safety Rules';

  @override
  String get safetyTitleLifeVest => 'Life Vest Location';

  @override
  String get safetyLifeVestAdult =>
      'One adult life vest is provided in the storage compartment under each seat.';

  @override
  String get safetyLifeVestChild =>
      'Life vests for infants and children are stored in a separate cabin cabinet. Please ask a crew member.';

  @override
  String get safetyLifeVestAccess =>
      'Life vest compartments remain unlocked at all times for immediate access during emergencies.';

  @override
  String get safetyTitleHowToWear => 'How to Wear a Life Vest';

  @override
  String get safetyWearStep1 =>
      'Open the storage compartment under your seat and take out the life vest.';

  @override
  String get safetyWearStep2 => 'Place the life vest over your head.';

  @override
  String get safetyWearStep3 =>
      'Fasten the front buckles until you hear a \'click\'.';

  @override
  String get safetyWearStep4 =>
      'Pull the waist straps tight so the vest fits snugly to your body.';

  @override
  String get safetyWearStep5 =>
      'After entering the water, pull the red handle (CO2 inflator) firmly to inflate the vest.';

  @override
  String get safetyWearTip =>
      'If it fails to inflate automatically, blow into the yellow oral inflation tube.';

  @override
  String get safetyTitleEvacuation => 'Emergency Evacuation';

  @override
  String get safetyEvacExit =>
      'Emergency exits are located at both the front (bow) and rear (stern). Please locate them upon boarding.';

  @override
  String get safetyEvacCalm =>
      'In case of emergency, stay calm and evacuate through designated exits following crew instructions.';

  @override
  String get safetyEvacStay =>
      'Never leave your seat until the vessel has come to a complete stop.';

  @override
  String get safetyEvacRescue =>
      'After evacuation, move to the dock or rescue boat. Emergency teams are on standby for immediate dispatch.';

  @override
  String get safetyTitleReporting => 'How to Report an Emergency';

  @override
  String get safetyReportCall =>
      'Notify a crew member immediately, or call the Hangang Bus Center or 119.';

  @override
  String get safetyReportTube =>
      'Lifebuoys (ring buoys) on board can be thrown to rescue someone in the water.';

  @override
  String get safetyReportQR =>
      'You must complete the boarding report via QR code before departure for rapid rescue in an emergency.';

  @override
  String get safetyTitleAttention => 'Boarding Precautions';

  @override
  String get safetyAttentionWave =>
      'The vessel may shake due to waves, especially when other boats pass. Please hold onto the handrails.';

  @override
  String get safetyAttentionDeck =>
      'To access the outdoor deck, you must first complete the boarding report via the onboard QR code.';

  @override
  String get safetyAttentionDanger =>
      'Never enter restricted areas such as the electrical equipment room.';

  @override
  String get safetyAttentionBike =>
      'Personal bicycles are allowed, but \'Ttareungyi\' and electric scooters (including e-bikes) are prohibited.';

  @override
  String get safetyAttentionChild =>
      'When traveling with children, you may request assistance from the crew to prevent missing children.';

  @override
  String get emergencyBannerTitle => 'In Case of Emergency';

  @override
  String get emergencyBannerContact => 'Report to Crew  |  119';

  @override
  String get emergencyBannerRescue =>
      'Real-time connection with River Police & Fire Rescue';
}

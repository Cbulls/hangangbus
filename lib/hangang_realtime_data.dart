// models/hangang_realtime_data.dart

class HangangRealtimeData {
  final String areaName;
  final PopulationData? population;
  final List<BikeStation> bikeStations;
  final List<ParkingLot> parkingLots;

  HangangRealtimeData({
    required this.areaName,
    this.population,
    this.bikeStations = const [],
    this.parkingLots = const [],
  });

  factory HangangRealtimeData.fromJson(
    Map<String, dynamic> json,
    String areaName,
  ) {
    // 실시간 인구
    final populationList = json['LIVE_PPLTN_STTS'] as List?;
    final populationData = populationList != null && populationList.isNotEmpty
        ? PopulationData.fromJson(populationList[0])
        : null;

    // 따릉이
    final bikeList = json['SBIKE_STTS'] as List?;
    final bikes = bikeList?.map((e) => BikeStation.fromJson(e)).toList() ?? [];

    // 주차장
    final parkingList = json['PRK_STTS'] as List?;
    final parkings =
        parkingList?.map((e) => ParkingLot.fromJson(e)).toList() ?? [];

    return HangangRealtimeData(
      areaName: areaName,
      population: populationData,
      bikeStations: bikes,
      parkingLots: parkings,
    );
  }
}

class PopulationData {
  final String currentMin;
  final String currentMax;
  final String congestLevel;
  final String maleRate;
  final String femaleRate;

  PopulationData({
    required this.currentMin,
    required this.currentMax,
    required this.congestLevel,
    required this.maleRate,
    required this.femaleRate,
  });

  factory PopulationData.fromJson(Map<String, dynamic> json) {
    return PopulationData(
      currentMin: json['AREA_PPLTN_MIN']?.toString() ?? '0',
      currentMax: json['AREA_PPLTN_MAX']?.toString() ?? '0',
      congestLevel: json['AREA_CONGEST_LVL']?.toString() ?? '정보 없음',
      maleRate: json['MALE_PPLTN_RATE']?.toString() ?? '0',
      femaleRate: json['FEMALE_PPLTN_RATE']?.toString() ?? '0',
    );
  }

  String get estimatedPopulation {
    final min = int.tryParse(currentMin) ?? 0;
    final max = int.tryParse(currentMax) ?? 0;
    final avg = ((min + max) / 2).round();
    return avg.toString();
  }
}

class BikeStation {
  final String name;
  final int available;
  final int total;

  BikeStation({
    required this.name,
    required this.available,
    required this.total,
  });

  factory BikeStation.fromJson(Map<String, dynamic> json) {
    return BikeStation(
      name: json['STTN_NM']?.toString() ?? '정보 없음',
      available: int.tryParse(json['STTN_HOLD_CNT']?.toString() ?? '0') ?? 0,
      total: int.tryParse(json['STTN_CRADLE_CNT']?.toString() ?? '0') ?? 0,
    );
  }

  double get availabilityRate {
    if (total == 0) return 0;
    return (available / total) * 100;
  }
}

class ParkingLot {
  final String name;
  final int total;
  final int available;

  ParkingLot({
    required this.name,
    required this.total,
    required this.available,
  });

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      name: json['PRK_NM']?.toString() ?? '정보 없음',
      total: int.tryParse(json['PRK_TPKCT']?.toString() ?? '0') ?? 0,
      available: int.tryParse(json['PRK_AVAL_TPKCT']?.toString() ?? '0') ?? 0,
    );
  }

  double get occupancyRate {
    if (total == 0) return 0;
    return ((total - available) / total) * 100;
  }
}

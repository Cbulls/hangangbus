// --- 모델 정의 ---
class StoryItem {
  final String category; // 'FOOD' or 'HISTORY'
  final String title;
  final String subtitle;
  final String imageUrl;
  final String description;
  final String dockName;
  final String? displayDockName;
  final String accessInfo;
  final String? openingHours; // 맛집용
  final String? priceRange; // 맛집용
  final String? historicalPeriod; // 역사용

  StoryItem({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.description,
    required this.dockName,
    this.displayDockName,
    required this.accessInfo,
    this.openingHours,
    this.priceRange,
    this.historicalPeriod,
  });
}

class FaqItem {
  final String question;
  final String answer;
  FaqItem({required this.question, required this.answer});
}

// --- 더미 데이터 ---

// 1. 스토리/맛집 데이터
// 🆕 선착장별 더미 데이터
final List<StoryItem> dummyStories = [
  // ========== 여의도 선착장 ==========
  // 역사
  StoryItem(
    category: 'HISTORY',
    title: '여의도 윤중제',
    subtitle: '한강의 범람을 막아낸 제방의 역사',
    imageUrl: 'assets/images/yeoui_yunje.jpg',
    description:
        '여의도를 둘러싼 윤중제는 1968년 한강개발사업의 일환으로 축조되었습니다. '
        '이전까지 여의도는 홍수 때마다 침수되는 모래섬이었으나, '
        '윤중제 덕분에 현재의 정치·금융 중심지로 발전할 수 있었습니다.\n\n'
        '제방을 따라 조성된 산책로는 시민들의 휴식 공간이자 벚꽃 명소로 사랑받고 있습니다.',
    dockName: '여의도',
    accessInfo: '선착장에서 도보 5분',
    historicalPeriod: '1968년 축조',
  ),
  StoryItem(
    category: 'HISTORY',
    title: '63빌딩과 여의도 개발',
    subtitle: '대한민국 랜드마크의 탄생',
    imageUrl: 'assets/images/63building.jpeg',
    description:
        '1985년 완공된 63빌딩은 당시 아시아에서 가장 높은 건물이었습니다. '
        '황금빛 외관은 한강의 물결을 형상화한 것으로, '
        '대한민국의 경제 성장을 상징하는 건축물입니다.\n\n'
        '여의도는 1970년대부터 국회의사당, 방송국, 금융기관이 들어서며 '
        '대한민국의 정치·경제·문화의 중심지로 자리잡았습니다.',
    dockName: '여의도',
    accessInfo: '선착장에서 도보 10분',
    historicalPeriod: '1985년',
  ),
  StoryItem(
    category: 'HISTORY',
    title: '여의도 광장과 5.16 광장',
    subtitle: '시민 광장으로의 변천사',
    imageUrl: 'assets/images/yeoui_plaza.jpg',
    description:
        '현재의 여의도공원은 원래 5.16 광장이라는 이름의 아스팔트 광장이었습니다. '
        '군사 퍼레이드와 대규모 집회를 위해 조성되었으나, '
        '1999년 시민의 휴식 공간인 공원으로 재탄생했습니다.\n\n'
        '잔디광장, 한국 전통의 숲, 자연생태의 숲으로 구성되어 '
        '도심 속 자연을 만끽할 수 있는 명소가 되었습니다.',
    dockName: '여의도',
    accessInfo: '선착장에서 도보 8분',
    historicalPeriod: '1999년 공원 조성',
  ),

  // 맛집
  StoryItem(
    category: 'FOOD',
    title: '전주콩나물국밥',
    subtitle: '30년 전통의 해장 맛집',
    imageUrl: 'assets/images/kongnamul.jpg',
    description:
        '1990년부터 여의도에서 영업해온 전주 스타일 콩나물국밥 전문점입니다. '
        '얼큰한 국물에 고소한 콩나물, 부드러운 밥이 어우러져 '
        '한강 유람 후 든든한 한 끼 식사로 완벽합니다.\n\n'
        '새벽부터 영업해 아침 식사나 해장으로도 인기가 높으며, '
        '인근 직장인들의 단골 맛집으로 유명합니다.',
    dockName: '여의도',
    accessInfo: '선착장에서 도보 7분',
    openingHours: '05:00 - 22:00 (월요일 휴무)',
    priceRange: '8,000원 - 12,000원',
  ),
  StoryItem(
    category: 'FOOD',
    title: '더 플레이스',
    subtitle: '한강뷰 루프탑 레스토랑',
    imageUrl: 'assets/images/theplace.jpg',
    description:
        '63빌딩 인근에 위치한 루프탑 레스토랑으로 한강과 여의도 전경을 한눈에 담을 수 있습니다. '
        '모던 유러피안 요리를 선보이며, 특히 석양이 지는 시간대의 분위기가 환상적입니다.\n\n'
        '데이트나 기념일 식사로 추천하며, 예약은 필수입니다.',
    dockName: '여의도',
    accessInfo: '선착장에서 도보 12분',
    openingHours: '11:30 - 22:00',
    priceRange: '30,000원 - 80,000원',
  ),
  StoryItem(
    category: 'FOOD',
    title: '이태리부대찌개',
    subtitle: '독특한 퓨전의 향연',
    imageUrl: 'assets/images/italy_budae.jpg',
    description:
        '부대찌개에 파스타 면과 모차렐라 치즈를 더한 독특한 퓨전 요리로 유명합니다. '
        'SNS에서 화제가 되며 젊은 층 사이에서 인기 폭발 중인 맛집입니다.\n\n'
        '얼큰한 국물에 쫄깃한 파스타 면의 조화가 일품이며, '
        '점심시간에는 대기가 필수입니다.',
    dockName: '여의도',
    accessInfo: '선착장에서 도보 15분',
    openingHours: '11:00 - 21:00',
    priceRange: '12,000원 - 18,000원',
  ),

  // ========== 망원 선착장 ==========
  // 역사
  StoryItem(
    category: 'HISTORY',
    title: '망원정과 조선시대 유람',
    subtitle: '한강을 바라보던 정자의 흔적',
    imageUrl: 'assets/images/mangwonjeong.jpg',
    description:
        '망원(望遠)이란 이름은 조선시대 이곳에 있던 망원정(望遠亭)에서 유래했습니다. '
        '망원정은 한강의 경치를 조망하기 위해 세워진 정자로, '
        '선비들이 시를 짓고 풍류를 즐기던 명소였습니다.\n\n'
        '현재 망원정은 남아있지 않지만, 망원한강공원에 그 이름이 계승되어 '
        '여전히 많은 시민들이 한강의 아름다운 풍경을 감상하고 있습니다.',
    dockName: '망원',
    accessInfo: '선착장에서 도보 3분',
    historicalPeriod: '조선시대',
  ),
  StoryItem(
    category: 'HISTORY',
    title: '양화진 외국인 선교사 묘원',
    subtitle: '한국 근대사의 산 교육장',
    imageUrl: 'assets/images/yanghwajin.jpg',
    description:
        '양화진은 19세기 후반부터 한국에 온 외국인 선교사들의 묘지로 사용되었습니다. '
        '언더우드, 아펜젤러 등 한국 근대 교육과 의료에 헌신한 선교사들이 잠들어 있으며, '
        '현재는 역사 교육의 장으로 활용되고 있습니다.\n\n'
        '양화진외국인선교사묘원역사관에서 그들의 삶과 업적을 배울 수 있습니다.',
    dockName: '망원',
    accessInfo: '선착장에서 마을버스 10분',
    historicalPeriod: '1890년대~',
  ),
  StoryItem(
    category: 'HISTORY',
    title: '망원시장의 변천',
    subtitle: '전통시장에서 핫플레이스로',
    imageUrl: 'assets/images/mangwon_market.jpg',
    description:
        '1970년대 형성된 망원시장은 마포구 주민들의 생활 중심지였습니다. '
        '2000년대 들어 젊은 예술가들이 모여들며 독특한 카페와 가게들이 생겨났고, '
        '현재는 전통과 현대가 공존하는 문화 공간으로 재탄생했습니다.\n\n'
        '신선한 재료를 파는 전통 상점과 감각적인 카페가 어우러진 '
        '망원시장만의 독특한 분위기를 느낄 수 있습니다.',
    dockName: '망원',
    accessInfo: '선착장에서 도보 12분',
    historicalPeriod: '1970년대 형성',
  ),

  // 맛집
  StoryItem(
    category: 'FOOD',
    title: '옥동식 (돼지곰탕)',
    subtitle: '흑백요리사 출연! 맑은 국물의 깊은 맛',
    imageUrl: 'assets/images/okdongsik.jpg',
    description:
        '미쉐린 가이드와 흑백요리사에 소개된 돼지곰탕 맛집입니다. '
        '24시간 이상 끓여낸 사골 국물에 부드러운 돼지고기가 어우러져 '
        '깊고 진한 맛을 자랑합니다.\n\n'
        '한강 유람 후 따뜻한 국물이 생각날 때 추천하며, '
        '점심시간에는 1시간 이상 대기가 일반적입니다.',
    dockName: '망원',
    accessInfo: '선착장에서 도보 10분',
    openingHours: '11:00 - 21:00 (재료 소진 시 조기 마감)',
    priceRange: '11,000원 - 15,000원',
  ),
  StoryItem(
    category: 'FOOD',
    title: '연남방앗간',
    subtitle: '수제 떡볶이와 튀김의 성지',
    imageUrl: 'assets/images/yeonnam_mill.jpg',
    description:
        '망원시장 인근의 핫플레이스로, 쫄깃한 가래떡과 매콤달콤한 소스가 일품인 수제 떡볶이 전문점입니다. '
        '바삭한 튀김과 함께 즐기면 환상의 조합이 완성됩니다.\n\n'
        '인스타그램 감성의 인테리어와 넓은 야외 테라스가 있어 '
        '친구들과 가볍게 즐기기 좋습니다.',
    dockName: '망원',
    accessInfo: '선착장에서 도보 15분',
    openingHours: '12:00 - 21:00 (화요일 휴무)',
    priceRange: '8,000원 - 15,000원',
  ),
  StoryItem(
    category: 'FOOD',
    title: '성수커피공장',
    subtitle: '망원동 감성 카페의 원조',
    imageUrl: 'assets/images/seongsu_coffee.jpg',
    description:
        '망원동 골목 깊숙이 자리잡은 로스터리 카페로, 직접 로스팅한 원두로 '
        '진한 향과 깊은 맛의 커피를 선보입니다.\n\n'
        '빈티지한 인테리어와 조용한 분위기가 특징이며, '
        '한강 산책 후 여유로운 시간을 보내기 완벽한 장소입니다.',
    dockName: '망원',
    accessInfo: '선착장에서 도보 13분',
    openingHours: '10:00 - 22:00',
    priceRange: '5,000원 - 8,000원',
  ),

  // ========== 마곡 선착장 ==========
  // 역사
  StoryItem(
    category: 'HISTORY',
    title: '겸재 정선의 양화진도',
    subtitle: '진경산수화의 대가가 그린 한강',
    imageUrl: 'assets/images/gyeomjae_yanghwa.jpg',
    description:
        '조선 후기 화가 겸재 정선(1676-1759)은 양화진 일대의 풍경을 여러 작품에 담았습니다. '
        '특히 "양화진도"는 한강을 배경으로 한 진경산수화의 걸작으로 평가받습니다.\n\n'
        '겸재정선미술관에서 그의 작품을 감상하며 300년 전 화가가 바라본 '
        '한강의 모습을 상상해볼 수 있습니다.',
    dockName: '마곡',
    accessInfo: '선착장에서 마을버스 15분',
    historicalPeriod: '18세기',
  ),
  StoryItem(
    category: 'HISTORY',
    title: '김포공항과 항공 산업',
    subtitle: '대한민국 하늘길의 시작',
    imageUrl: 'assets/images/gimpo_airport.jpg',
    description:
        '1958년 개항한 김포공항은 대한민국 항공 산업의 출발점입니다. '
        '한국전쟁 중 미군이 사용하던 활주로를 민간 공항으로 전환하며 시작되었고, '
        '2001년 인천공항 개항 전까지 대한민국의 관문 역할을 했습니다.\n\n'
        '현재는 국내선과 단거리 국제선을 운영하며, '
        '인근 마곡지구는 첨단 산업 단지로 발전했습니다.',
    dockName: '마곡',
    accessInfo: '선착장에서 버스 20분',
    historicalPeriod: '1958년 개항',
  ),
  StoryItem(
    category: 'HISTORY',
    title: '마곡지구 개발',
    subtitle: '서울의 신(新) R&D 허브',
    imageUrl: 'assets/images/magok_district.jpg',
    description:
        '2000년대 후반부터 개발이 시작된 마곡지구는 '
        '서울시의 미래 성장동력으로 기획된 첨단 산업 단지입니다.\n\n'
        'LG사이언스파크를 비롯한 R&D 기업들이 입주해 있으며, '
        '친환경 스마트시티를 목표로 조성되어 녹지 공간과 문화 시설이 풍부합니다.',
    dockName: '마곡',
    accessInfo: '선착장에서 도보 10분',
    historicalPeriod: '2000년대 후반~',
  ),

  // 맛집
  StoryItem(
    category: 'FOOD',
    title: '마곡회관',
    subtitle: '신선한 활어회의 명가',
    imageUrl: 'assets/images/magok_hoegwan.jpg',
    description:
        '30년 전통의 활어회 전문점으로, 매일 아침 수산시장에서 공수한 '
        '신선한 활어를 맛볼 수 있습니다.\n\n'
        '푸짐한 양과 싱싱한 회, 얼큰한 매운탕까지 '
        '한강 유람 후 특별한 한 끼로 추천합니다.',
    dockName: '마곡',
    accessInfo: '선착장에서 도보 8분',
    openingHours: '11:00 - 22:00',
    priceRange: '40,000원 - 80,000원 (2인 기준)',
  ),
  StoryItem(
    category: 'FOOD',
    title: 'LG 아트센터 카페',
    subtitle: '문화와 미식의 결합',
    imageUrl: 'assets/images/lg_artcenter_cafe.jpg',
    description:
        'LG 아트센터 내부에 위치한 모던한 카페로, '
        '공연 관람 전후로 여유로운 시간을 보낼 수 있습니다.\n\n'
        '세련된 인테리어와 다양한 베이커리, 고급 커피를 즐길 수 있으며, '
        '아트센터의 문화 프로그램과 연계하여 방문하면 더욱 좋습니다.',
    dockName: '마곡',
    accessInfo: '선착장에서 도보 12분',
    openingHours: '10:00 - 20:00 (공연 일정에 따라 연장)',
    priceRange: '6,000원 - 12,000원',
  ),
  StoryItem(
    category: 'FOOD',
    title: '봄날의곰',
    subtitle: '수제 디저트 카페',
    imageUrl: 'assets/images/springbear.jpg',
    description:
        '마곡 주민들 사이에서 소문난 수제 케이크와 디저트 전문 카페입니다. '
        '매일 아침 직접 만드는 케이크와 쿠키는 재료 본연의 맛을 살린 것이 특징입니다.\n\n'
        '아늑한 분위기와 귀여운 곰 인테리어가 SNS에서 인기를 끌고 있으며, '
        '주말에는 대기가 있을 수 있습니다.',
    dockName: '마곡',
    accessInfo: '선착장에서 도보 15분',
    openingHours: '11:00 - 21:00 (월요일 휴무)',
    priceRange: '6,000원 - 15,000원',
  ),
];

// 2. FAQ 데이터
final List<FaqItem> faqData = [
  FaqItem(
    question: '기후동행카드를 사용할 수 있나요?',
    answer: '네, 가능합니다. 단, 따릉이 결합권이 아닌 일반권/청년권 등을 확인해주세요.',
  ),
  FaqItem(question: '반려동물 탑승이 가능한가요?', answer: '케이지(이동장)에 넣은 경우에만 탑승이 가능합니다.'),
  FaqItem(
    question: '유모차나 자전거를 실을 수 있나요?',
    answer: '유모차는 가능하며, 자전거는 선착장 내 거치대에 보관하셔야 합니다 (선내 반입 불가).',
  ),
];

// 3. 주간 날씨 데이터 (간단 리스트)
final List<Map<String, String>> weeklyWeather = [
  {'day': '오늘', 'icon': '☀️', 'temp': '24°'},
  {'day': '내일', 'icon': '☁️', 'temp': '22°'},
  {'day': '수', 'icon': '🌧️', 'temp': '19°'},
  {'day': '목', 'icon': '☀️', 'temp': '25°'},
  {'day': '금', 'icon': '🌤️', 'temp': '24°'},
];

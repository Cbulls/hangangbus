// data/attraction_data.dart
//
// 한강 주요 관광지 데이터. 좌표는 실측 기준.
// 다국어 분기는 DataProvider 와 동일하게 languageCode 로 처리한다(여기선 Map 내장).

import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:hangangbus/models/attraction.dart';

List<Attraction> hangangAttractions = [
  Attraction(
    id: 'attr_nodeul',
    position: LatLng(37.5177627, 126.9596671),
    category: AttractionCategory.island,
    name: {'ko': '노들섬', 'en': 'Nodeul Island', 'ja': 'ノドゥル島', 'zh': '鹭得岛'},
    tagline: {
      'ko': '한강 위 음악·예술 복합문화공간',
      'en': 'Music & art island on the Han River',
      'ja': '漢江に浮かぶ音楽・芸術の複合文化空間',
      'zh': '汉江上的音乐·艺术综合文化空间',
    },
    description: {
      'ko':
          '한강 한가운데 위치한 섬으로, 공연장·서점·음식점·잔디밭이 어우러진 문화 명소입니다. 노을과 야경 감상 명소로도 유명합니다.',
      'en':
          'An island in the middle of the Han River with live venues, bookstores, eateries and lawns. A favorite spot for sunsets and night views.',
      'ja': '漢江の中ほどに位置する島で、ライブ会場・書店・飲食店・芝生が調和した文化スポット。夕焼けと夜景の名所としても有名です。',
      'zh': '位于汉江中央的岛屿，汇聚演出场地、书店、餐厅与草坪的文化胜地。也是观赏晚霞与夜景的著名地点。',
    },
    nearestDock: '여의도',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_banpo',
    position: LatLng(37.5126335, 126.9984783),
    category: AttractionCategory.fountain,
    name: {
      'ko': '반포 달빛무지개분수',
      'en': 'Banpo Moonlight Rainbow Fountain',
      'ja': '盤浦月光虹噴水',
      'zh': '盘浦月光彩虹喷泉',
    },
    tagline: {
      'ko': '반포대교의 세계 최장 교량 분수쇼',
      'en': "World's longest bridge fountain show",
      'ja': '盤浦大橋の世界最長の橋噴水ショー',
      'zh': '盘浦大桥的世界最长桥梁喷泉秀',
    },
    description: {
      'ko':
          '반포대교 양옆에서 물줄기가 음악에 맞춰 무지개빛으로 쏟아지는 분수쇼입니다. 저녁 시간대에 약 20분간 운영되며 한강의 대표 야경 명소입니다.',
      'en':
          'A fountain show where water cascades from both sides of Banpo Bridge in rainbow colors set to music. Runs about 20 minutes in the evening — a signature Han River night view.',
      'ja': '盤浦大橋の両側から水が音楽に合わせて虹色に流れ落ちる噴水ショー。夕方に約20分間運営され、漢江を代表する夜景スポットです。',
      'zh': '在盘浦大桥两侧随音乐喷出彩虹色水柱的喷泉秀。傍晚运营约20分钟，是汉江代表性的夜景胜地。',
    },
    nearestDock: null,
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_seonyudo',
    position: LatLng(37.5431196, 126.9001167),
    category: AttractionCategory.park,
    name: {'ko': '선유도공원', 'en': 'Seonyudo Park', 'ja': 'ソニュ島公園', 'zh': '仙游岛公园'},
    tagline: {
      'ko': '정수장을 재생한 생태 공원',
      'en': 'Eco park reborn from a water plant',
      'ja': '浄水場を再生した生態公園',
      'zh': '由净水厂改造的生态公园',
    },
    description: {
      'ko':
          '옛 정수장을 재활용해 만든 한강의 생태 공원으로, 물과 식물이 어우러진 독특한 산책로가 매력적입니다. 사진 명소로도 인기가 많습니다.',
      'en':
          'A Han River eco park created by repurposing a former water treatment plant, with unique trails blending water and greenery. A popular photo spot.',
      'ja': '旧浄水場を再活用して造られた漢江の生態公園で、水と植物が調和した独特な散策路が魅力。写真スポットとしても人気です。',
      'zh': '利用旧净水厂改造而成的汉江生态公园，水与植物交融的独特步道极具魅力。也是热门拍照地。',
    },
    nearestDock: '망원',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_63',
    position: LatLng(37.5198332, 126.9400724),
    category: AttractionCategory.landmark,
    name: {'ko': '63빌딩', 'en': '63 Building', 'ja': '63ビル', 'zh': '63大厦'},
    tagline: {
      'ko': '여의도의 황금빛 랜드마크',
      'en': "Yeouido's golden landmark",
      'ja': '汝矣島の黄金色のランドマーク',
      'zh': '汝矣岛的金色地标',
    },
    description: {
      'ko':
          '1985년 완공된 여의도의 상징적 마천루로, 전망대·아쿠아리움·미술관을 갖추고 있습니다. 한강과 서울 스카이라인을 한눈에 담을 수 있습니다.',
      'en':
          "Yeouido's iconic skyscraper completed in 1985, featuring an observatory, aquarium and art gallery. Offers sweeping views of the Han River and Seoul skyline.",
      'ja': '1985年完工の汝矣島の象徴的な高層ビルで、展望台・水族館・美術館を備えています。漢江とソウルのスカイラインを一望できます。',
      'zh': '1985年竣工的汝矣岛标志性摩天大楼，设有观景台·水族馆·美术馆。可将汉江与首尔天际线尽收眼底。',
    },
    nearestDock: '여의도',
    imageUrl: 'assets/images/63building.jpg',
  ),
  Attraction(
    id: 'attr_lotte',
    position: LatLng(37.5125295, 127.102305),
    category: AttractionCategory.landmark,
    name: {
      'ko': '롯데월드타워 서울스카이',
      'en': 'Lotte World Tower Seoul Sky',
      'ja': 'ロッテワールドタワー ソウルスカイ',
      'zh': '乐天世界大厦 首尔天空',
    },
    tagline: {
      'ko': '국내 최고층 전망대',
      'en': "Korea's highest observation deck",
      'ja': '韓国最高層の展望台',
      'zh': '韩国最高层观景台',
    },
    description: {
      'ko':
          '123층 555m 높이의 국내 최고층 빌딩으로, 117~123층 서울스카이 전망대에서 서울 전경과 한강을 360도로 조망할 수 있습니다. 세계 최고 높이의 유리 바닥 전망대가 있습니다.',
      'en':
          "Korea's tallest building at 555m (123 floors). The Seoul Sky observatory (floors 117–123) offers 360° views of Seoul and the Han River, with the world's highest glass-floor deck.",
      'ja':
          '123階555mの韓国最高層ビルで、117〜123階のソウルスカイ展望台からソウルの全景と漢江を360度見渡せます。世界最高の高さのガラス床展望台があります。',
      'zh': '123层555米的韩国最高建筑，117〜123层的首尔天空观景台可360度俯瞰首尔全景与汉江，设有世界最高的玻璃地板观景台。',
    },
    nearestDock: '잠실',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_seoulforest',
    position: LatLng(37.5443878, 127.0374424),
    category: AttractionCategory.park,
    name: {'ko': '서울숲', 'en': 'Seoul Forest', 'ja': 'ソウルの森', 'zh': '首尔林'},
    tagline: {
      'ko': '도심 속 거대한 생태 숲',
      'en': 'A vast ecological forest in the city',
      'ja': '都心の巨大な生態の森',
      'zh': '都市中的大型生态森林',
    },
    description: {
      'ko':
          '도심 한가운데 자리한 대규모 공원으로, 생태숲·사슴방사장·문화예술공간이 어우러져 있습니다. 성수동 카페거리와 가까워 함께 둘러보기 좋습니다.',
      'en':
          'A large urban park combining ecological woods, a deer enclosure and cultural spaces. Close to the Seongsu café district for an easy combined visit.',
      'ja': '都心の中心にある大規模な公園で、生態の森・鹿放牧場・文化芸術空間が調和しています。聖水洞のカフェ街に近く、一緒に巡るのに最適です。',
      'zh': '位于市中心的大型公园，融合生态林·鹿苑·文化艺术空间。邻近圣水洞咖啡街，适合一同游览。',
    },
    nearestDock: '서울숲',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_ichon',
    position: LatLng(37.5169202, 126.9717022),
    category: AttractionCategory.park,
    name: {
      'ko': '이촌한강공원',
      'en': 'Ichon Hangang Park',
      'ja': '二村漢江公園',
      'zh': '二村汉江公园',
    },
    tagline: {
      'ko': '가족 친화 스포츠·피크닉 공원',
      'en': 'Family-friendly sports & picnic park',
      'ja': '家族向けスポーツ・ピクニック公園',
      'zh': '亲子运动·野餐公园',
    },
    description: {
      'ko':
          '놀이터·테니스장·축구장·스케이트장 등 다양한 체육시설과 자전거길을 갖춘 가족 친화 공원입니다. 서울세계불꽃축제 관람 명소로도 알려져 있습니다.',
      'en':
          'A family-friendly park with playgrounds, tennis and football courts, a skating rink and cycling paths. Also known as a great spot for the Seoul fireworks festival.',
      'ja':
          '遊び場・テニスコート・サッカー場・スケート場など多彩な体育施設とサイクリングロードを備えた家族向け公園。ソウル世界花火大会の観覧名所としても知られています。',
      'zh': '设有游乐场·网球场·足球场·滑冰场等多种体育设施及自行车道的亲子公园。也是观赏首尔世界烟花节的著名地点。',
    },
    nearestDock: null,
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_ttukseom',
    position: LatLng(37.5293507, 127.0699562),
    category: AttractionCategory.park,
    name: {
      'ko': '뚝섬한강공원',
      'en': 'Ttukseom Hangang Park',
      'ja': 'トゥクソム漢江公園',
      'zh': '纛岛汉江公园',
    },
    tagline: {
      'ko': '수상레저와 드론쇼의 명소',
      'en': 'Water sports & drone show spot',
      'ja': '水上レジャーとドローンショーの名所',
      'zh': '水上休闲与无人机秀胜地',
    },
    description: {
      'ko':
          '수영장·윈드서핑 등 수상레저 시설이 풍부하고, 자전거·피크닉을 즐기기 좋은 공원입니다. 드론쇼와 일몰 감상지로도 인기가 많습니다.',
      'en':
          'A park rich in water sports facilities like a pool and windsurfing, great for cycling and picnics. Popular for drone shows and sunset views.',
      'ja':
          'プール・ウィンドサーフィンなど水上レジャー施設が豊富で、サイクリングやピクニックに最適な公園。ドローンショーと日没鑑賞地としても人気です。',
      'zh': '泳池·风帆冲浪等水上休闲设施丰富，适合骑行与野餐的公园。也以无人机秀和日落观赏地而广受欢迎。',
    },
    nearestDock: '뚝섬',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_yeouido',
    position: LatLng(37.5267106, 126.9347112),
    category: AttractionCategory.park,
    name: {
      'ko': '여의도한강공원',
      'en': 'Yeouido Hangang Park',
      'ja': '汝矣島漢江公園',
      'zh': '汝矣岛汉江公园',
    },
    tagline: {
      'ko': '벚꽃과 피크닉의 대표 명소',
      'en': 'Iconic cherry blossom & picnic spot',
      'ja': '桜とピクニックの代表名所',
      'zh': '樱花与野餐的代表胜地',
    },
    description: {
      'ko':
          '봄철 벚꽃과 한강 피크닉으로 가장 사랑받는 공원입니다. 자전거·돗자리·텐트 대여가 가능하고 수상 스타벅스와 편의점도 있습니다.',
      'en':
          'The most beloved park for spring cherry blossoms and Han River picnics. Bike, mat and tent rentals are available, plus a floating Starbucks and convenience stores.',
      'ja':
          '春の桜と漢江ピクニックで最も愛される公園。自転車・レジャーシート・テントのレンタルが可能で、水上スターバックスやコンビニもあります。',
      'zh': '春季樱花与汉江野餐最受喜爱的公园。可租赁自行车·野餐垫·帐篷，还有水上星巴克与便利店。',
    },
    nearestDock: '여의도',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_mangwon',
    position: LatLng(37.5527919, 126.8985613),
    category: AttractionCategory.park,
    name: {
      'ko': '망원한강공원',
      'en': 'Mangwon Hangang Park',
      'ja': '望遠漢江公園',
      'zh': '望远汉江公园',
    },
    tagline: {
      'ko': '노을이 아름다운 로컬 감성 공원',
      'en': 'Local-favorite park with great sunsets',
      'ja': '夕焼けが美しいローカル感性の公園',
      'zh': '晚霞优美的本地风情公园',
    },
    description: {
      'ko':
          '여의도·반포보다 한적하고 여유로운 분위기의 공원입니다. 노을 명소로 유명하며, 인근 망원시장에서 먹거리를 사 와 피크닉을 즐기기 좋습니다.',
      'en':
          'A more laid-back park than Yeouido or Banpo. Famous for sunsets — grab food from nearby Mangwon Market for a riverside picnic.',
      'ja':
          '汝矣島・盤浦より静かでゆったりした雰囲気の公園。夕焼けの名所として有名で、近くの望遠市場で食べ物を買ってピクニックを楽しむのに最適です。',
      'zh': '比汝矣岛·盘浦更清静悠闲的公园。以晚霞闻名，可在邻近的望远市场买些美食享受江边野餐。',
    },
    nearestDock: '망원',
    imageUrl: null,
  ),

  // ========== 추가 한강공원 ==========
  Attraction(
    id: 'attr_gwangnaru',
    position: LatLng(37.5487859, 127.1200384),
    category: AttractionCategory.park,
    name: {
      'ko': '광나루한강공원',
      'en': 'Gwangnaru Hangang Park',
      'ja': '広津漢江公園',
      'zh': '广渡口汉江公园',
    },
    tagline: {
      'ko': '한강 동쪽 끝의 한적한 자연 공원',
      'en': 'Tranquil park at the eastern end of the Han River',
      'ja': '漢江東端の静かな自然公園',
      'zh': '汉江东端的清静自然公园',
    },
    description: {
      'ko':
          '한강공원 중 가장 동쪽에 위치해 비교적 한적하며, 수영장·테니스장 등 체육시설과 자전거길이 잘 갖춰져 있습니다. 야경과 드론 발사장으로도 알려져 있습니다.',
      'en':
          'The easternmost Hangang park, relatively quiet, with a pool, tennis courts and cycling paths. Known for night views and a drone launch pad.',
      'ja':
          '漢江公園の中で最も東に位置し比較的静かで、プール・テニスコートなどの体育施設とサイクリングロードが整っています。夜景でも知られています。',
      'zh': '位于汉江公园最东端，相对清静，配有泳池·网球场等体育设施及自行车道。也以夜景闻名。',
    },
    nearestDock: null,
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_jamsilpark',
    position: LatLng(37.5175896, 127.0867236),
    category: AttractionCategory.park,
    name: {
      'ko': '잠실한강공원',
      'en': 'Jamsil Hangang Park',
      'ja': '蚕室漢江公園',
      'zh': '蚕室汉江公园',
    },
    tagline: {
      'ko': '드론쇼와 피크닉의 인기 공원',
      'en': 'Popular park for drone shows & picnics',
      'ja': 'ドローンショーとピクニックの人気公園',
      'zh': '无人机秀与野餐的人气公园',
    },
    description: {
      'ko':
          '넓은 잔디밭과 모래놀이장, 자전거길을 갖춘 인기 공원입니다. 주말 드론쇼·분수쇼가 열리며 한강 유람선 선착장과도 연결됩니다.',
      'en':
          'A popular park with wide lawns, a sand play area and cycling paths. Weekend drone and fountain shows are held, and it connects to a river cruise dock.',
      'ja': '広い芝生と砂遊び場、サイクリングロードを備えた人気公園。週末にドローン・噴水ショーが開かれ、漢江遊覧船乗り場とも繋がっています。',
      'zh': '拥有宽阔草坪·沙坑·自行车道的人气公园。周末举办无人机·喷泉秀，并与汉江游船码头相连。',
    },
    nearestDock: '잠실',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_jamwon',
    position: LatLng(37.5206865, 127.0122724),
    category: AttractionCategory.park,
    name: {
      'ko': '잠원한강공원',
      'en': 'Jamwon Hangang Park',
      'ja': '蚕院漢江公園',
      'zh': '蚕院汉江公园',
    },
    tagline: {
      'ko': '노을과 수영장이 있는 강변 공원',
      'en': 'Riverside park with sunsets & a pool',
      'ja': '夕焼けとプールのある川辺の公園',
      'zh': '有晚霞与泳池的江边公园',
    },
    description: {
      'ko':
          '한강을 따라 길게 이어진 녹지 공원으로, 여름 야외 수영장과 자전거길이 인기입니다. 수상 스타벅스와 노을 피크닉 명소로 알려져 있습니다.',
      'en':
          'A long green park along the Han River, popular for its summer outdoor pool and cycling paths. Known for a floating Starbucks and sunset picnics.',
      'ja':
          '漢江沿いに長く続く緑地公園で、夏の屋外プールとサイクリングロードが人気。水上スターバックスと夕焼けピクニックの名所として知られています。',
      'zh': '沿汉江绵延的绿地公园，夏季户外泳池与自行车道很受欢迎。以水上星巴克与晚霞野餐闻名。',
    },
    nearestDock: '압구정',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_banpopark',
    position: LatLng(37.5103503, 126.9952372),
    category: AttractionCategory.park,
    name: {
      'ko': '반포한강공원',
      'en': 'Banpo Hangang Park',
      'ja': '盤浦漢江公園',
      'zh': '盘浦汉江公园',
    },
    tagline: {
      'ko': '달빛무지개분수의 본거지',
      'en': 'Home of the Moonlight Rainbow Fountain',
      'ja': '月光虹噴水の本拠地',
      'zh': '月光彩虹喷泉的所在地',
    },
    description: {
      'ko':
          '반포대교 달빛무지개분수로 유명한 공원으로, 저녁 분수쇼와 피크닉의 대표 명소입니다. 세빛섬과 인접해 함께 둘러보기 좋습니다.',
      'en':
          'Famous for the Banpo Bridge Moonlight Rainbow Fountain — a top spot for evening fountain shows and picnics. Adjacent to Sebitseom islets.',
      'ja': '盤浦大橋の月光虹噴水で有名な公園で、夕方の噴水ショーとピクニックの代表名所。セビッ島に隣接しています。',
      'zh': '以盘浦大桥月光彩虹喷泉闻名的公园，是傍晚喷泉秀与野餐的代表胜地。紧邻塞光岛。',
    },
    nearestDock: null,
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_yanghwa',
    position: LatLng(37.5383005, 126.902265),
    category: AttractionCategory.park,
    name: {
      'ko': '양화한강공원',
      'en': 'Yanghwa Hangang Park',
      'ja': '楊花漢江公園',
      'zh': '杨花汉江公园',
    },
    tagline: {
      'ko': '선유도와 이어지는 한적한 공원',
      'en': 'Quiet park linked to Seonyudo',
      'ja': 'ソニュ島とつながる静かな公園',
      'zh': '与仙游岛相连的清静公园',
    },
    description: {
      'ko': '선유도공원과 다리로 연결된 한적한 강변 공원으로, 러닝과 산책에 좋습니다. 다리 아래 대형 야외 운동시설이 있습니다.',
      'en':
          'A quiet riverside park connected to Seonyudo Park by bridge, great for running and walking. Has a large outdoor gym under the bridge.',
      'ja': 'ソニュ島公園と橋でつながった静かな川辺の公園で、ランニングや散歩に最適。橋の下に大型屋外運動施設があります。',
      'zh': '通过桥与仙游岛公园相连的清静江边公园，适合跑步与散步。桥下设有大型户外健身设施。',
    },
    nearestDock: '망원',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_nanji',
    position: LatLng(37.5667873, 126.8780119),
    category: AttractionCategory.park,
    name: {
      'ko': '난지한강공원',
      'en': 'Nanji Hangang Park',
      'ja': '蘭芝漢江公園',
      'zh': '兰芝汉江公园',
    },
    tagline: {
      'ko': '캠핑과 페스티벌의 넓은 공원',
      'en': 'Spacious park for camping & festivals',
      'ja': 'キャンプとフェスティバルの広い公園',
      'zh': '露营与庆典的宽阔公园',
    },
    description: {
      'ko':
          '캠핑장과 넓은 잔디밭으로 유명한 공원으로, 대형 페스티벌이 자주 열립니다. 하늘공원·노을공원과 가까워 함께 즐기기 좋습니다.',
      'en':
          'Known for its campsite and wide lawns, often hosting large festivals. Close to Haneul Park and Noeul Park for a combined visit.',
      'ja': 'キャンプ場と広い芝生で有名な公園で、大型フェスティバルがよく開かれます。空公園・夕焼け公園に近いです。',
      'zh': '以露营场与宽阔草坪闻名的公园，常举办大型庆典。邻近天空公园·晚霞公园。',
    },
    nearestDock: '망원',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_gangseo',
    position: LatLng(37.5880848, 126.8152348),
    category: AttractionCategory.park,
    name: {
      'ko': '강서한강공원',
      'en': 'Gangseo Hangang Park',
      'ja': '江西漢江公園',
      'zh': '江西汉江公园',
    },
    tagline: {
      'ko': '생태습지의 자연 친화 공원',
      'en': 'Nature-friendly park with eco wetlands',
      'ja': '生態湿地の自然志向の公園',
      'zh': '生态湿地的自然亲和公园',
    },
    description: {
      'ko':
          '한강 서쪽 끝에 위치한 생태습지 공원으로, 철새와 야생화를 볼 수 있는 자연 친화적 공간입니다. 자전거길과 산책로가 잘 정비되어 있습니다.',
      'en':
          'An eco-wetland park at the western end of the Han River, a nature-friendly space to see migratory birds and wildflowers. Well-maintained trails and cycling paths.',
      'ja': '漢江西端に位置する生態湿地公園で、渡り鳥や野花が見られる自然志向の空間。サイクリングロードと散策路がよく整備されています。',
      'zh': '位于汉江西端的生态湿地公园，是观赏候鸟与野花的自然亲和空间。自行车道与步道维护良好。',
    },
    nearestDock: '마곡',
    imageUrl: null,
  ),

  // ========== 문화/역사 명소 ==========
  Attraction(
    id: 'attr_sayuksin',
    position: LatLng(37.5135242, 126.9498529),
    category: AttractionCategory.culture,
    name: {'ko': '사육신묘', 'en': 'Saryuksin Shrine', 'ja': '死六臣墓', 'zh': '死六臣墓'},
    tagline: {
      'ko': '단종 복위를 꾀한 여섯 충신의 묘역',
      'en': 'Tomb of six loyal subjects of King Danjong',
      'ja': '端宗復位を図った六忠臣の墓域',
      'zh': '为端宗复位而献身的六忠臣墓地',
    },
    description: {
      'ko':
          '노량진에 위치한 사육신묘는 조선 단종의 복위를 꾀하다 처형된 성삼문·박팽년 등 여섯 충신을 기리는 묘역입니다. 한강을 내려다보는 조용한 역사 공원으로, 충절의 상징입니다.',
      'en':
          'Located in Noryangjin, this shrine honors six loyal subjects — Seong Sam-mun, Park Paeng-nyeon and others — executed for attempting to restore King Danjong. A quiet historical park overlooking the Han River, a symbol of loyalty.',
      'ja':
          '鷺梁津に位置する死六臣墓は、朝鮮の端宗復位を図り処刑された成三問・朴彭年など六人の忠臣を称える墓域です。漢江を見下ろす静かな歴史公園で、忠節の象徴です。',
      'zh': '位于鹭梁津的死六臣墓，纪念为复位朝鲜端宗而被处决的成三问·朴彭年等六位忠臣。是俯瞰汉江的清静历史公园，忠节的象征。',
    },
    nearestDock: '여의도',
    imageUrl: null,
  ),

  // ========== 선착장 주변 도보권 명소 ==========
  // --- 마곡 주변 ---
  Attraction(
    id: 'attr_yangcheon',
    position: LatLng(37.5729567, 126.8398344),
    category: AttractionCategory.culture,
    name: {
      'ko': '양천향교',
      'en': 'Yangcheon Hyanggyo',
      'ja': '陽川郷校',
      'zh': '阳川乡校',
    },
    tagline: {
      'ko': '서울에 유일하게 남은 향교',
      'en': "Seoul's only surviving Confucian school",
      'ja': 'ソウルに唯一残る郷校',
      'zh': '首尔唯一现存的乡校',
    },
    description: {
      'ko':
          '1411년 건립된, 서울에 유일하게 남아 있는 조선시대 향교(국립 교육기관)입니다. 대성전과 명륜당이 잘 보존되어 있어 조선의 교육·제례 문화를 엿볼 수 있습니다.',
      'en':
          'Built in 1411, the only surviving Joseon-era hyanggyo (state Confucian school) in Seoul. Its well-preserved halls offer a glimpse into Joseon education and ancestral rites.',
      'ja': '1411年に建立された、ソウルに唯一残る朝鮮時代の郷校（国立教育機関）。大成殿と明倫堂がよく保存されています。',
      'zh': '建于1411年，是首尔唯一现存的朝鲜时代乡校（国立教育机构）。大成殿与明伦堂保存完好。',
    },
    nearestDock: '마곡',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_botanic',
    position: LatLng(37.5694132, 126.8350252),
    category: AttractionCategory.park,
    name: {
      'ko': '서울식물원',
      'en': 'Seoul Botanic Park',
      'ja': 'ソウル植物園',
      'zh': '首尔植物园',
    },
    tagline: {
      'ko': '도심 속 거대한 식물 정원',
      'en': 'A vast plant garden in the city',
      'ja': '都心の巨大な植物庭園',
      'zh': '都市中的大型植物园',
    },
    description: {
      'ko':
          '마곡에 자리한 대형 식물원으로, 온실에서 세계 12개 도시의 식물을 만날 수 있습니다. 호수와 습지원, 야외 정원이 어우러져 사계절 산책 명소입니다.',
      'en':
          'A large botanical garden in Magok with a greenhouse showcasing plants from 12 world cities. Lakes, wetlands and outdoor gardens make it a year-round walking spot.',
      'ja': '麻谷にある大型植物園で、温室で世界12都市の植物に出会えます。湖と湿地園、屋外庭園が調和した四季の散策名所です。',
      'zh': '位于麻谷的大型植物园，温室展示世界12个城市的植物。湖泊·湿地园·户外花园交融，是四季皆宜的散步胜地。',
    },
    nearestDock: '마곡',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_gyeomjae',
    position: LatLng(37.5722129, 126.8384499),
    category: AttractionCategory.culture,
    name: {
      'ko': '겸재정선미술관',
      'en': 'Gyeomjae Jeongseon Art Museum',
      'ja': '謙斎鄭敾美術館',
      'zh': '谦斋郑敾美术馆',
    },
    tagline: {
      'ko': '진경산수화의 대가를 기리는 미술관',
      'en': 'Museum honoring a master of true-view landscape',
      'ja': '真景山水画の巨匠を称える美術館',
      'zh': '纪念真景山水画大师的美术馆',
    },
    description: {
      'ko':
          '조선 후기 진경산수화의 대가 겸재 정선이 양천현감으로 재임했던 인연으로 세워진 미술관입니다. 그의 작품과 한강을 그린 진경산수화를 만날 수 있습니다.',
      'en':
          'A museum built to honor Gyeomjae Jeong Seon, master of true-view landscape painting, who once served as the local magistrate here. Features his works depicting the Han River.',
      'ja': '朝鮮後期の真景山水画の巨匠・謙斎鄭敾が陽川県監を務めた縁で建てられた美術館。漢江を描いた真景山水画に出会えます。',
      'zh': '为纪念曾任阳川县监的朝鲜后期真景山水画大师谦斋郑敾而建的美术馆。可欣赏其描绘汉江的真景山水画。',
    },
    nearestDock: '마곡',
    imageUrl: null,
  ),

  // --- 망원 주변 ---
  Attraction(
    id: 'attr_mangwonmarket',
    position: LatLng(37.5559018, 126.9062854),
    category: AttractionCategory.landmark,
    name: {'ko': '망원시장', 'en': 'Mangwon Market', 'ja': '望遠市場', 'zh': '望远市场'},
    tagline: {
      'ko': '정겨운 로컬 전통시장',
      'en': 'A charming local traditional market',
      'ja': '情緒あふれるローカル伝統市場',
      'zh': '充满人情味的本地传统市场',
    },
    description: {
      'ko':
          '망원동의 활기찬 전통시장으로, 저렴한 길거리 음식과 신선한 먹거리가 가득합니다. 크로켓·닭강정 등 명물 먹거리로 유명해 한강 피크닉 장보기 명소입니다.',
      'en':
          'A lively traditional market in Mangwon full of cheap street food and fresh produce. Famous for croquettes and fried chicken — a great spot to grab picnic food for the river.',
      'ja': '望遠洞の活気ある伝統市場で、安い屋台料理と新鮮な食材が豊富。コロッケ・ヤンニョムチキンなどの名物で有名です。',
      'zh': '望远洞充满活力的传统市场，遍布廉价街头小吃与新鲜食材。以可乐饼·炸鸡等名吃闻名，是汉江野餐采购胜地。',
    },
    nearestDock: '망원',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_jeoldusan',
    position: LatLng(37.544006, 126.9116079),
    category: AttractionCategory.culture,
    name: {
      'ko': '절두산순교성지',
      'en': "Jeoldusan Martyrs' Shrine",
      'ja': '切頭山殉教聖地',
      'zh': '切头山殉教圣地',
    },
    tagline: {
      'ko': '한강을 굽어보는 천주교 성지',
      'en': 'Catholic shrine overlooking the Han River',
      'ja': '漢江を見下ろすカトリック聖地',
      'zh': '俯瞰汉江的天主教圣地',
    },
    description: {
      'ko':
          '병인박해 때 순교한 천주교 신자들을 기리는 성지로, 한강이 내려다보이는 언덕에 자리합니다. 성당과 박물관, 야외 십자가의 길이 있어 조용히 사색하기 좋습니다.',
      'en':
          'A Catholic shrine honoring martyrs of the 1866 persecution, set on a hill overlooking the Han River. Has a chapel, museum and outdoor Stations of the Cross for quiet reflection.',
      'ja': '丙寅迫害で殉教したカトリック信者を称える聖地で、漢江を見下ろす丘にあります。聖堂と博物館、屋外の十字架の道があります。',
      'zh': '纪念丙寅迫害殉教天主教信徒的圣地，坐落于俯瞰汉江的山丘上。设有圣堂·博物馆与户外苦路，适合静思。',
    },
    nearestDock: '망원',
    imageUrl: null,
  ),

  // --- 압구정 주변 ---
  Attraction(
    id: 'attr_nudake',
    position: LatLng(37.5254165, 127.0356387),
    category: AttractionCategory.landmark,
    name: {
      'ko': '누데이크 하우스 도산',
      'en': 'NUDAKE Haus Dosan',
      'ja': 'ヌデイク ハウス島山',
      'zh': 'NUDAKE Haus Dosan',
    },
    tagline: {
      'ko': '예술 같은 디저트 카페',
      'en': 'An art-like dessert café',
      'ja': 'アートのようなデザートカフェ',
      'zh': '如艺术品般的甜点咖啡馆',
    },
    description: {
      'ko':
          '젠틀몬스터가 만든 미래적 디저트 카페로, 검은 크루아상 등 독창적인 디저트와 전위적 공간 연출로 유명합니다. 압구정 트렌드세터들의 핫플레이스입니다.',
      'en':
          'A futuristic dessert café by Gentle Monster, famous for avant-garde treats like the black croissant and striking interiors. A hotspot for Apgujeong trendsetters.',
      'ja': 'ジェントルモンスターが手がけた未来的なデザートカフェで、黒いクロワッサンなど独創的なデザートと前衛的な空間で有名です。',
      'zh': 'Gentle Monster打造的未来感甜点咖啡馆，以黑色可颂等独创甜点与前卫空间闻名。是狎鸥亭潮人的热门去处。',
    },
    nearestDock: '압구정',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_hyundaidept',
    position: LatLng(37.5273268, 127.0274265),
    category: AttractionCategory.landmark,
    name: {
      'ko': '현대백화점 압구정본점',
      'en': 'Hyundai Department Store',
      'ja': '現代百貨店 狎鴎亭本店',
      'zh': '现代百货 狎鸥亭总店',
    },
    tagline: {
      'ko': '압구정역과 연결된 백화점',
      'en': 'Department store linked to Apgujeong Station',
      'ja': '狎鴎亭駅直結の百貨店',
      'zh': '与狎鸥亭站相连的百货店',
    },
    description: {
      'ko':
          '압구정역과 바로 연결된 고급 백화점으로, 지하 식품관과 5층 식당가가 특히 인기입니다. 쇼핑과 식사를 한 번에 즐길 수 있습니다.',
      'en':
          'An upscale department store directly connected to Apgujeong Station, with a popular basement food hall and 5th-floor restaurants. Shopping and dining in one place.',
      'ja': '狎鴎亭駅直結の高級百貨店で、地下の食品館と5階のレストラン街が特に人気。ショッピングと食事を一度に楽しめます。',
      'zh': '与狎鸥亭站直接相连的高级百货店，地下食品馆与5楼餐饮街尤其受欢迎。可一站式购物与用餐。',
    },
    nearestDock: '압구정',
    imageUrl: null,
  ),

  // --- 여의도 주변 ---
  Attraction(
    id: 'attr_assembly',
    position: LatLng(37.5318046, 126.9141547),
    category: AttractionCategory.landmark,
    name: {
      'ko': '국회의사당',
      'en': 'National Assembly Building',
      'ja': '国会議事堂',
      'zh': '国会议事堂',
    },
    tagline: {
      'ko': '대한민국 입법의 중심',
      'en': "Center of Korea's legislature",
      'ja': '韓国の立法の中心',
      'zh': '韩国立法的中心',
    },
    description: {
      'ko':
          '푸른 돔이 상징적인 대한민국 국회의사당입니다. 넓은 잔디 광장과 조형물이 있고, 사전 예약하면 본회의장 견학 투어도 가능합니다. 봄 벚꽃길로도 유명합니다.',
      'en':
          "Korea's National Assembly, marked by its iconic blue dome. Has a wide lawn plaza and sculptures; guided tours of the main hall are available by reservation. Famous for spring cherry blossoms.",
      'ja': '青いドームが象徴的な韓国の国会議事堂。広い芝生広場と造形物があり、事前予約で本会議場の見学ツアーも可能。春の桜並木でも有名です。',
      'zh': '以蓝色穹顶为象征的韩国国会议事堂。设有宽阔草坪广场与雕塑，预约可参加议事厅参观团。也以春季樱花路闻名。',
    },
    nearestDock: '여의도',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_ifc',
    position: LatLng(37.5250243, 126.9258867),
    category: AttractionCategory.landmark,
    name: {'ko': 'IFC몰', 'en': 'IFC Mall', 'ja': 'IFCモール', 'zh': 'IFC购物中心'},
    tagline: {
      'ko': '여의도의 대형 복합 쇼핑몰',
      'en': "Yeouido's large complex shopping mall",
      'ja': '汝矣島の大型複合ショッピングモール',
      'zh': '汝矣岛的大型综合购物中心',
    },
    description: {
      'ko':
          '여의도 한강공원 인근의 대형 지하 쇼핑몰로, 패션·식당·영화관이 모여 있습니다. 지하철과 연결돼 접근성이 좋아 한강 나들이와 함께 즐기기 좋습니다.',
      'en':
          'A large underground mall near Yeouido Hangang Park with fashion, dining and a cinema. Connected to the subway for easy access — great to combine with a river outing.',
      'ja': '汝矣島漢江公園近くの大型地下ショッピングモールで、ファッション・レストラン・映画館が集まっています。地下鉄直結でアクセス良好です。',
      'zh': '汝矣岛汉江公园附近的大型地下购物中心，汇聚时尚·餐饮·影院。与地铁相连，交通便利，适合与汉江出游结合。',
    },
    nearestDock: '여의도',
    imageUrl: null,
  ),

  // --- 잠실 주변 ---
  Attraction(
    id: 'attr_olympicpark',
    position: LatLng(37.5206868, 127.1214941),
    category: AttractionCategory.park,
    name: {
      'ko': '올림픽공원',
      'en': 'Olympic Park',
      'ja': 'オリンピック公園',
      'zh': '奥林匹克公园',
    },
    tagline: {
      'ko': '88올림픽의 유산, 거대한 도심 공원',
      'en': 'Legacy of the 88 Olympics, a vast city park',
      'ja': '88オリンピックの遺産、巨大な都心公園',
      'zh': '88奥运的遗产，巨大的都市公园',
    },
    description: {
      'ko':
          '1988 서울올림픽을 기념하는 대규모 공원으로, 넓은 잔디밭과 조각 작품, 호수가 어우러져 있습니다. "나홀로나무" 등 사진 명소가 많아 산책과 피크닉에 좋습니다.',
      'en':
          'A large park commemorating the 1988 Seoul Olympics, blending wide lawns, sculptures and a lake. Many photo spots like the "Lonely Tree" make it great for walks and picnics.',
      'ja': '1988ソウルオリンピックを記念する大規模公園で、広い芝生と彫刻、湖が調和しています。「一本木」など写真スポットが多いです。',
      'zh': '纪念1988首尔奥运的大型公园，宽阔草坪·雕塑·湖泊交融。"孤独的树"等拍照胜地众多，适合散步与野餐。',
    },
    nearestDock: '잠실',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_lotteworld',
    position: LatLng(37.5111158, 127.0981670),
    category: AttractionCategory.landmark,
    name: {'ko': '롯데월드', 'en': 'Lotte World', 'ja': 'ロッテワールド', 'zh': '乐天世界'},
    tagline: {
      'ko': '실내외를 아우르는 대형 테마파크',
      'en': 'A large indoor-outdoor theme park',
      'ja': '屋内外を網羅する大型テーマパーク',
      'zh': '室内外兼具的大型主题公园',
    },
    description: {
      'ko':
          '세계 최대 규모의 실내 테마파크와 호수 위 매직아일랜드로 이루어진 종합 놀이공원입니다. 사계절 즐길 수 있어 잠실의 대표 명소입니다.',
      'en':
          "An amusement complex of the world's largest indoor theme park and the lakeside Magic Island. Enjoyable year-round — Jamsil's signature attraction.",
      'ja': '世界最大級の屋内テーマパークと湖上のマジックアイランドからなる総合遊園地。四季を通じて楽しめる蚕室の代表名所です。',
      'zh': '由世界最大室内主题公园与湖上魔幻岛组成的综合游乐园。四季皆可游玩，是蚕室的代表性景点。',
    },
    nearestDock: '잠실',
    imageUrl: null,
  ),
  Attraction(
    id: 'attr_seokchon',
    position: LatLng(37.5113096, 127.1051525),
    category: AttractionCategory.park,
    name: {'ko': '석촌호수', 'en': 'Seokchon Lake Park', 'ja': '石村湖', 'zh': '石村湖'},
    tagline: {
      'ko': '롯데타워를 품은 벚꽃 호수',
      'en': 'Cherry blossom lake by Lotte Tower',
      'ja': 'ロッテタワーを望む桜の湖',
      'zh': '映衬乐天塔的樱花湖',
    },
    description: {
      'ko':
          '롯데월드타워를 배경으로 한 도심 호수공원으로, 봄철 벚꽃 명소로 유명합니다. 동호·서호로 나뉘어 산책과 조깅에 좋고 야경도 아름답습니다.',
      'en':
          'An urban lake park set against Lotte World Tower, famous for spring cherry blossoms. Split into East and West lakes, great for walks and jogging, with lovely night views.',
      'ja': 'ロッテワールドタワーを背景にした都心の湖公園で、春の桜の名所として有名。東湖・西湖に分かれ散策やジョギングに最適です。',
      'zh': '以乐天世界大厦为背景的都市湖泊公园，以春季樱花闻名。分东湖·西湖，适合散步与慢跑，夜景也很美。',
    },
    nearestDock: '잠실',
    imageUrl: null,
  ),

  // --- 서울숲/뚝섬 주변 ---
  Attraction(
    id: 'attr_seongsu',
    position: LatLng(37.5446148, 127.0580149),
    category: AttractionCategory.landmark,
    name: {
      'ko': '성수동 카페거리',
      'en': 'Seongsu Café Street',
      'ja': '聖水洞カフェ通り',
      'zh': '圣水洞咖啡街',
    },
    tagline: {
      'ko': '힙스터들의 감성 카페 거리',
      'en': "A hipster's trendy café street",
      'ja': 'ヒップスターの感性カフェ通り',
      'zh': '潮人的文艺咖啡街',
    },
    description: {
      'ko':
          '낡은 공장과 창고를 개조한 개성 넘치는 카페와 편집숍이 모인 거리입니다. 서울숲과 가까워 함께 둘러보기 좋은, 서울에서 가장 트렌디한 동네입니다.',
      'en':
          'A street of distinctive cafés and select shops converted from old factories and warehouses. Close to Seoul Forest — one of Seoul\'s trendiest neighborhoods to explore together.',
      'ja':
          '古い工場や倉庫を改造した個性的なカフェやセレクトショップが集まる通り。ソウルの森に近く、一緒に巡るのに最適な最もトレンディな街です。',
      'zh': '由旧工厂与仓库改造而成、汇聚个性咖啡馆与买手店的街区。邻近首尔林，是首尔最潮的街区之一，适合一同游览。',
    },
    nearestDock: '서울숲',
    imageUrl: null,
  ),
];

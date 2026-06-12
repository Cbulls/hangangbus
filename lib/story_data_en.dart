import 'package:hangangbus/data.dart';

final List<StoryItem> storyDataEn = [
  // ========== Yeouido ==========
  StoryItem(
    category: 'HISTORY',
    title: 'Yeouido Yunjungje Embankment',
    subtitle: 'The levee that tamed the Han River floods',
    imageUrl: 'assets/images/yeoui_yunje.jpeg',
    description:
        'The Yunjungje embankment encircling Yeouido was constructed in 1968 as part of the Han River Development Project. '
        'Before its construction, Yeouido was little more than a sandbar that flooded every monsoon season. '
        'Thanks to the embankment, the island transformed into the political and financial hub it is today.\n\n'
        'The walking path along the levee is now a beloved spot for cherry blossoms and leisurely strolls.',
    dockName: '여의도',
    displayDockName: 'Yeouido',
    accessInfo: '5-min walk from dock',
    historicalPeriod: 'Built in 1968',
  ),
  StoryItem(
    category: 'HISTORY',
    title: '63 Building & Yeouido Development',
    subtitle: 'The birth of a national landmark',
    imageUrl: 'assets/images/63building.jpg',
    description:
        'Completed in 1985, the 63 Building was the tallest structure in Asia at the time. '
        'Its golden facade evokes the waves of the Han River and stands as a symbol of South Korea\'s economic rise.\n\n'
        'From the 1970s, the National Assembly, broadcasters, and major financial institutions moved in, '
        'making Yeouido the political, economic, and cultural heart of Korea.',
    dockName: '여의도',
    displayDockName: 'Yeouido',
    accessInfo: '22-min walk from dock',
    historicalPeriod: '1985',
  ),
  StoryItem(
    category: 'HISTORY',
    title: 'Yeouido Park',
    subtitle: 'From military grounds to citizens\' park',
    imageUrl: 'assets/images/yeoui_plaza.jpg',
    description:
        'What is now Yeouido Park was once an asphalt expanse called 5.16 Square, '
        'built for military parades and mass rallies. In 1999 it was reimagined as a public green space.\n\n'
        'Today the park features a lawn plaza, a Korean traditional forest, and a natural ecology forest - '
        'a rare refuge of nature in the heart of the city.',
    dockName: '여의도',
    displayDockName: 'Yeouido',
    accessInfo: '15-min walk from dock',
    historicalPeriod: 'Park established 1999',
  ),
  StoryItem(
    category: 'FOOD',
    title: 'Hosiubo Yeouido TP Tower',
    subtitle: 'Premium Hanwoo Dining by Chef Ho-yun Kim',
    imageUrl: 'assets/images/hosiubo.jpeg',
    description:
        'A premium Hanwoo (Korean beef) restaurant by Chef Ho-yun Kim from "Culinary Class Wars." It offers modern Hanwoo courses and charcoal-grilled beef. '
        'Located in the new TP Tower, it boasts a sophisticated interior and luxurious atmosphere.\n\n'
        'With refined side dishes and delicate service, it is the perfect space for business meetings or special anniversary dinners.',
    dockName: '여의도',
    displayDockName: 'Yeouido',
    accessInfo: '10-min walk from dock (TP Tower 2F)',
    openingHours: '11:00 - 22:00 (Break 15:00 - 17:00)',
    priceRange: '₩50,000 - ₩150,000',
  ),
  StoryItem(
    category: 'FOOD',
    title: 'Jinjujip',
    subtitle: 'Yeouido\'s Iconic Cold Soy Milk Noodle Restaurant',
    imageUrl: 'assets/images/jinjujeob.jpeg',
    description:
        'One of Yeouido\'s best-known long-running restaurants, famous for its signature thick kongguksu (cold soy milk noodles) with a rich, savory flavor. '
        'Chicken Kal-guksu and Spicy Bibim-guksu are also must-try delicacies along with their hearty dumplings.\n\n'
        'While there is always a line regardless of the season, the rotation is fast. It is considered soul food for local office workers.',
    dockName: '여의도',
    displayDockName: 'Yeouido',
    accessInfo: '15-min walk from dock (Yeouido Dept. Store B1)',
    openingHours: '10:00 - 20:00 (Closed on Sundays)',
    priceRange: '₩12,000 - ₩15,000',
  ),
  StoryItem(
    category: 'FOOD',
    title: 'Yido Yeouido',
    subtitle: 'Refined Korean Dining & Clear Beef Soup',
    imageUrl: 'assets/images/yido.png',
    description:
        'A premium Korean restaurant offering clear, deeply flavored gomtang (beef soup), boiled beef slices, and refined Korean dishes. '
        'By minimizing additives and focusing on natural ingredients, it provides a healthy meal loved by all generations.\n\n'
        'Its modern design makes it an ideal spot for a calm and dignified meal in the heart of bustling Yeouido.',
    dockName: '여의도',
    displayDockName: 'Yeouido',
    accessInfo: '12-min walk from dock (near Finance Tower)',
    openingHours: '11:00 - 21:30 (Break 15:00 - 17:00)',
    priceRange: '₩15,000 - ₩45,000',
  ),

  // ========== Mangwon ==========
  StoryItem(
    category: 'HISTORY',
    title: 'Mangwonjeong Pavilion & Joseon Leisure',
    subtitle: 'Echoes of a riverside pavilion',
    imageUrl: 'assets/images/mangwonjeong.jpeg',
    description:
        'The name "Mangwon" ("gazing far") comes from the Mangwonjeong Pavilion of the Joseon Dynasty, '
        'a popular retreat where scholars enjoyed poetry and river views.\n\n'
        'Though the pavilion is gone, its legacy lives on at Mangwon Han River Park, '
        'where visitors still come to admire the same beautiful scenery.',
    dockName: '망원',
    displayDockName: 'Mangwon',
    accessInfo: '3-min walk from dock',
    historicalPeriod: 'Joseon Dynasty',
  ),
  StoryItem(
    category: 'HISTORY',
    title: 'Yanghwajin Foreign Missionary Cemetery',
    subtitle: 'A living classroom of modern Korean history',
    imageUrl: 'assets/images/yanghwajin.jpg',
    description:
        'Since the late 19th century, Yanghwajin has been the resting place for foreign missionaries in Korea. '
        'Pioneers like Underwood and Appenzeller, who shaped modern Korean education and healthcare, are buried here.\n\n'
        'The on-site history museum preserves their stories and serves as an important site of historical education.',
    dockName: '망원',
    displayDockName: 'Mangwon',
    accessInfo: '10-min by village bus from dock',
    historicalPeriod: '1890s onward',
  ),
  StoryItem(
    category: 'HISTORY',
    title: 'The Evolution of Mangwon Market',
    subtitle: 'From neighborhood market to cultural hotspot',
    imageUrl: 'assets/images/mangwon_market.jpeg',
    description:
        'Formed in the 1970s, Mangwon Market was the commercial heart of Mapo District. '
        'In the 2000s, young artists moved in and new cafés and shops emerged, '
        'transforming it into a vibrant space where tradition and modernity coexist.\n\n'
        'Fresh produce stalls and stylish coffee shops sit side by side, '
        'creating a one-of-a-kind atmosphere.',
    dockName: '망원',
    displayDockName: 'Mangwon',
    accessInfo: '12-min walk from dock',
    historicalPeriod: 'Established 1970s',
  ),
  StoryItem(
    category: 'FOOD',
    title: 'Okdongsik',
    subtitle: 'Michelin Bib Gourmand Clear Pork Gomtang',
    imageUrl: 'assets/images/okdongsik.jpeg',
    description:
        'The main branch of Chef Ok Dong-sik from "Culinary Class Wars." It serves dwaeji-gomtang, a pork soup with a clear broth unlike traditional cloudy pork soups. '
        'Made exclusively with Berkshire K pork, the meat offers exceptional umami and is elegantly served in traditional brassware.\n\n'
        'A regular on the Michelin Bib Gourmand list, its bar-style seating makes it perfect for solo diners.',
    dockName: '망원',
    displayDockName: 'Mangwon',
    accessInfo: '44-10, Yanghwa-ro 7-gil, Mapo-gu, Seoul',
    openingHours: '11:00 - 22:00 (Break 15:00 - 17:00)',
    priceRange: '₩10,000 - ₩16,000',
  ),
  StoryItem(
    category: 'FOOD',
    title: 'Gohyangjib',
    subtitle: 'Legendary Affordable Kalguksu in Mangwon Market',
    imageUrl: 'assets/images/gohyangjib.jpeg',
    description:
        'A legendary local spot in Mangwon Market known for its affordable yet deeply flavored kalguksu (knife-cut noodle soup) and sujebi. '
        'The handmade dough provides a chewy texture that pairs perfectly with their fresh Geotjeori (spicy salad-like kimchi).\n\n'
        'An essential Mangwon-dong experience where you can enjoy a hearty meal amidst the vibrant market atmosphere.',
    dockName: '망원',
    displayDockName: 'Mangwon',
    accessInfo: '28, Poeun-ro 8-gil, Mapo-gu, Seoul',
    openingHours: '11:00 - 21:00',
    priceRange: '₩5,000 - ₩8,000',
  ),
  StoryItem(
    category: 'FOOD',
    title: 'Osteria Sam Kim',
    subtitle: 'Chef Sam Kim\'s Cozy Italian Open Kitchen',
    imageUrl: 'assets/images/osteriasamkim.jpeg',
    description:
        'An Italian restaurant run by the famous Chef Sam Kim. You can watch the cooking process through the open kitchen, which serves pasta and steaks made with fresh seasonal ingredients.\n\n'
        'Popular as a date spot for couples, it offers high-quality cuisine within the cozy and trendy atmosphere unique to Mangwon-dong.',
    dockName: '망원',
    displayDockName: 'Mangwon',
    accessInfo: '71, Huiujeong-ro 20-gil, Mapo-gu, Seoul',
    openingHours: '11:30 - 22:00 (Break 14:30 - 17:30 / Closed on Sundays)',
    priceRange: '₩25,000 - ₩60,000',
  ),

  // ========== Magok ==========
  StoryItem(
    category: 'HISTORY',
    title: 'Gyeomjae Jeong Seon Museum',
    subtitle: 'Magok and the Master of True-View Landscape Painting',
    imageUrl: 'assets/images/gyeomjae_museum.jpeg',
    description:
        'Gyeomjae Jeong Seon (1676-1759), a grand master of the late Joseon Dynasty, served as magistrate at the Yangcheon-hyeon Office (now Gayang-dong, Gangseo-gu) at the age of 65. '
        'Captivated by the stunning scenery of the Han River during his stay, he created numerous masterpieces including "Gyeonggyo Myeongseungcheop."\n\n'
        'The Gyeomjae Jeong Seon Museum stands on the very grounds where his artistic soul flourished. Visitors can witness the original 300-year-old landscape of the Han River through the works of one of the most brilliant artists in Korean history.',
    dockName: '마곡',
    displayDockName: 'Magok',
    accessInfo: '36, Yangcheon-ro 47-gil, Gangseo-gu, Seoul',
    historicalPeriod: 'Late Joseon (18th Century)',
  ),
  StoryItem(
    category: 'HISTORY',
    title: 'Gimpo Airport & Korean Aviation',
    subtitle: 'Where South Korea first took flight',
    imageUrl: 'assets/images/gimpo_airport.jpg',
    description:
        'Opened in 1958, Gimpo Airport launched South Korea\'s civil aviation industry. '
        'Converted from a U.S. military airfield used during the Korean War, '
        'it served as the nation\'s main gateway until Incheon Airport opened in 2001.\n\n'
        'It now handles domestic and short-haul international flights, '
        'while the nearby Magok district has become a high-tech industrial hub.',
    dockName: '마곡',
    displayDockName: 'Magok',
    accessInfo: '20-min by bus from dock',
    historicalPeriod: 'Opened 1958',
  ),
  StoryItem(
    category: 'HISTORY',
    title: 'Magok District Development',
    subtitle: 'Seoul\'s new R&D hub',
    imageUrl: 'assets/images/magok_district.jpg',
    description:
        'Development of Magok began in the late 2000s as Seoul\'s vision for a future-ready advanced industrial complex.\n\n'
        'Home to LG Science Park and numerous R&D companies, '
        'it was designed as an eco-friendly smart city with abundant green spaces and cultural amenities.',
    dockName: '마곡',
    displayDockName: 'Magok',
    accessInfo: '10-min walk from dock',
    historicalPeriod: 'Late 2000s onward',
  ),
  StoryItem(
    category: 'FOOD',
    title: 'Lolly Bobs',
    subtitle: 'Premium Korean Snack Bar Loved by Locals',
    imageUrl: 'assets/images/lollybobs.jpeg',
    description:
        'A popular bunsik (Korean snack food) spot near Magoknaru Station, offering a wide variety of gimbap, tteokbokki, and pork cutlets. '
        'Their gimbap, rolled with fresh and generous ingredients, is a favorite lunch choice for busy office workers.\n\n'
        'With its reasonable prices and clean taste, it\'s the perfect place to grab a quick bite or pack a meal before a Han River stroll.',
    dockName: '마곡',
    displayDockName: 'Magok',
    accessInfo: '6, Magokjungang 5-ro, Gangseo-gu, Seoul',
    openingHours: '08:00 - 21:00 (Sat until 20:00 / Closed on Sundays)',
    priceRange: '₩5,000 - ₩12,000',
  ),
  StoryItem(
    category: 'FOOD',
    title: 'Eunhasikdang',
    subtitle: 'Hearty Home-style Korean Dining',
    imageUrl: 'assets/images/eunhasikdang.jpeg',
    description:
        'Located near LG Arts Center Seoul and Seoul Botanic Park, this restaurant serves clean and refined Korean set meals. '
        'The mild, healthy side dishes and main courses make it a great place to visit with family or children.\n\n'
        'Enjoy a meal in a calm, warm atmosphere with modern interior design. Highly recommended after a visit to the Botanic Park.',
    dockName: '마곡',
    displayDockName: 'Magok',
    accessInfo: '161, Magokdong-ro, Gangseo-gu, Seoul',
    openingHours: '11:00 - 21:30 (Break 15:30 - 17:00)',
    priceRange: '₩10,000 - ₩20,000',
  ),
  StoryItem(
    category: 'FOOD',
    title: '153 Gimbap',
    subtitle: 'Honest Handmade Gimbap with Heart',
    imageUrl: 'assets/images/153gimbap.jpeg',
    description:
        'A hidden gem in Magok known for using high-quality ingredients with minimal artificial additives. '
        'From their classic "153 Gimbap" to the well-stuffed Tuna and Cheese options, every roll tastes like a healthy, homemade meal.\n\n'
        'Ideal for those seeking a simple yet nutritious meal, it is also a popular choice for picnic lunches at Seoul Botanic Park.',
    dockName: '마곡',
    displayDockName: 'Magok',
    accessInfo: '161-11, Magokjungang-ro, Gangseo-gu, Seoul',
    openingHours:
        '07:30 - 20:00 (Closed when ingredients run out / Closed on Sundays)',
    priceRange: '₩4,000 - ₩8,000',
  ),
];

final List<FaqItem> faqDataEn = [
  FaqItem(
    question: 'Can I use the Climate Card (Gihudonghaeng Card)?',
    answer:
        'Yes. Please make sure you have the standard or youth pass, not the combined Ttareungyi (bike-share) pass.',
  ),
  FaqItem(
    question: 'Are pets allowed on board?',
    answer:
        'Pets are only permitted if placed inside a carrier or travel cage.',
  ),
  FaqItem(
    question: 'Can I bring a stroller or bicycle?',
    answer:
        'Strollers are welcome on board. Bicycles must be stored in the designated rack at the dock and cannot be brought onto the vessel.',
  ),
];

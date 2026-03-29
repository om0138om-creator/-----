/// خصائص OpenType الكاملة
/// هذا الملف يحتوي على جميع خصائص OpenType المدعومة
class OpenTypeFeatures {
  /// قائمة كاملة بجميع خصائص OpenType
  static const Map<String, OpenTypeFeature> allFeatures = {
    // ==================== Ligatures ====================
    'liga': OpenTypeFeature(
      tag: 'liga',
      name: 'Standard Ligatures',
      nameAr: 'الربط القياسي',
      description: 'Replaces a sequence of glyphs with a single glyph',
      descriptionAr: 'استبدال سلسلة من الحروف بحرف واحد مركب',
      category: FeatureCategory.ligatures,
      defaultEnabled: true,
    ),
    'dlig': OpenTypeFeature(
      tag: 'dlig',
      name: 'Discretionary Ligatures',
      nameAr: 'الربط الاختياري',
      description: 'Optional ligatures for stylistic purposes',
      descriptionAr: 'ربط اختياري لأغراض جمالية',
      category: FeatureCategory.ligatures,
      defaultEnabled: false,
    ),
    'clig': OpenTypeFeature(
      tag: 'clig',
      name: 'Contextual Ligatures',
      nameAr: 'الربط السياقي',
      description: 'Ligatures that depend on context',
      descriptionAr: 'ربط يعتمد على السياق',
      category: FeatureCategory.ligatures,
      defaultEnabled: true,
    ),
    'rlig': OpenTypeFeature(
      tag: 'rlig',
      name: 'Required Ligatures',
      nameAr: 'الربط المطلوب',
      description: 'Ligatures required for correct text rendering',
      descriptionAr: 'ربط مطلوب لعرض النص بشكل صحيح',
      category: FeatureCategory.ligatures,
      defaultEnabled: true,
    ),
    'hlig': OpenTypeFeature(
      tag: 'hlig',
      name: 'Historical Ligatures',
      nameAr: 'الربط التاريخي',
      description: 'Historical ligature forms',
      descriptionAr: 'أشكال ربط تاريخية',
      category: FeatureCategory.ligatures,
      defaultEnabled: false,
    ),
    
    // ==================== Alternates ====================
    'calt': OpenTypeFeature(
      tag: 'calt',
      name: 'Contextual Alternates',
      nameAr: 'البدائل السياقية',
      description: 'Replaces glyphs based on context',
      descriptionAr: 'استبدال الحروف بناءً على السياق',
      category: FeatureCategory.alternates,
      defaultEnabled: true,
    ),
    'salt': OpenTypeFeature(
      tag: 'salt',
      name: 'Stylistic Alternates',
      nameAr: 'البدائل الأسلوبية',
      description: 'Alternative stylistic forms',
      descriptionAr: 'أشكال بديلة أسلوبية',
      category: FeatureCategory.alternates,
      defaultEnabled: false,
    ),
    'swsh': OpenTypeFeature(
      tag: 'swsh',
      name: 'Swash',
      nameAr: 'الزخرفة المنحنية',
      description: 'Decorative swash variants',
      descriptionAr: 'متغيرات زخرفية منحنية',
      category: FeatureCategory.alternates,
      defaultEnabled: false,
    ),
    'cswh': OpenTypeFeature(
      tag: 'cswh',
      name: 'Contextual Swash',
      nameAr: 'الزخرفة السياقية',
      description: 'Contextual swash variants',
      descriptionAr: 'متغيرات زخرفية سياقية',
      category: FeatureCategory.alternates,
      defaultEnabled: false,
    ),
    'titl': OpenTypeFeature(
      tag: 'titl',
      name: 'Titling',
      nameAr: 'العناوين',
      description: 'Forms optimized for large sizes',
      descriptionAr: 'أشكال محسنة للأحجام الكبيرة',
      category: FeatureCategory.alternates,
      defaultEnabled: false,
    ),
    'rand': OpenTypeFeature(
      tag: 'rand',
      name: 'Randomize',
      nameAr: 'العشوائية',
      description: 'Random alternate forms',
      descriptionAr: 'أشكال بديلة عشوائية',
      category: FeatureCategory.alternates,
      defaultEnabled: false,
    ),
    'hist': OpenTypeFeature(
      tag: 'hist',
      name: 'Historical Forms',
      nameAr: 'الأشكال التاريخية',
      description: 'Historical character forms',
      descriptionAr: 'أشكال الحروف التاريخية',
      category: FeatureCategory.alternates,
      defaultEnabled: false,
    ),
    'ornm': OpenTypeFeature(
      tag: 'ornm',
      name: 'Ornaments',
      nameAr: 'الزخارف',
      description: 'Ornamental characters',
      descriptionAr: 'حروف زخرفية',
      category: FeatureCategory.alternates,
      defaultEnabled: false,
    ),
    
    // ==================== Stylistic Sets ====================
    'ss01': OpenTypeFeature(
      tag: 'ss01',
      name: 'Stylistic Set 1',
      nameAr: 'المجموعة الأسلوبية 1',
      description: 'First stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الأولى',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss02': OpenTypeFeature(
      tag: 'ss02',
      name: 'Stylistic Set 2',
      nameAr: 'المجموعة الأسلوبية 2',
      description: 'Second stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الثانية',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss03': OpenTypeFeature(
      tag: 'ss03',
      name: 'Stylistic Set 3',
      nameAr: 'المجموعة الأسلوبية 3',
      description: 'Third stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الثالثة',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss04': OpenTypeFeature(
      tag: 'ss04',
      name: 'Stylistic Set 4',
      nameAr: 'المجموعة الأسلوبية 4',
      description: 'Fourth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الرابعة',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss05': OpenTypeFeature(
      tag: 'ss05',
      name: 'Stylistic Set 5',
      nameAr: 'المجموعة الأسلوبية 5',
      description: 'Fifth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الخامسة',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss06': OpenTypeFeature(
      tag: 'ss06',
      name: 'Stylistic Set 6',
      nameAr: 'المجموعة الأسلوبية 6',
      description: 'Sixth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية السادسة',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss07': OpenTypeFeature(
      tag: 'ss07',
      name: 'Stylistic Set 7',
      nameAr: 'المجموعة الأسلوبية 7',
      description: 'Seventh stylistic set',
      descriptionAr: 'المجموعة الأسلوبية السابعة',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss08': OpenTypeFeature(
      tag: 'ss08',
      name: 'Stylistic Set 8',
      nameAr: 'المجموعة الأسلوبية 8',
      description: 'Eighth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الثامنة',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss09': OpenTypeFeature(
      tag: 'ss09',
      name: 'Stylistic Set 9',
      nameAr: 'المجموعة الأسلوبية 9',
      description: 'Ninth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية التاسعة',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss10': OpenTypeFeature(
      tag: 'ss10',
      name: 'Stylistic Set 10',
      nameAr: 'المجموعة الأسلوبية 10',
      description: 'Tenth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية العاشرة',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss11': OpenTypeFeature(
      tag: 'ss11',
      name: 'Stylistic Set 11',
      nameAr: 'المجموعة الأسلوبية 11',
      description: 'Eleventh stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الحادية عشر',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss12': OpenTypeFeature(
      tag: 'ss12',
      name: 'Stylistic Set 12',
      nameAr: 'المجموعة الأسلوبية 12',
      description: 'Twelfth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الثانية عشر',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss13': OpenTypeFeature(
      tag: 'ss13',
      name: 'Stylistic Set 13',
      nameAr: 'المجموعة الأسلوبية 13',
      description: 'Thirteenth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الثالثة عشر',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss14': OpenTypeFeature(
      tag: 'ss14',
      name: 'Stylistic Set 14',
      nameAr: 'المجموعة الأسلوبية 14',
      description: 'Fourteenth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الرابعة عشر',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss15': OpenTypeFeature(
      tag: 'ss15',
      name: 'Stylistic Set 15',
      nameAr: 'المجموعة الأسلوبية 15',
      description: 'Fifteenth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الخامسة عشر',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss16': OpenTypeFeature(
      tag: 'ss16',
      name: 'Stylistic Set 16',
      nameAr: 'المجموعة الأسلوبية 16',
      description: 'Sixteenth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية السادسة عشر',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss17': OpenTypeFeature(
      tag: 'ss17',
      name: 'Stylistic Set 17',
      nameAr: 'المجموعة الأسلوبية 17',
      description: 'Seventeenth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية السابعة عشر',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss18': OpenTypeFeature(
      tag: 'ss18',
      name: 'Stylistic Set 18',
      nameAr: 'المجموعة الأسلوبية 18',
      description: 'Eighteenth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية الثامنة عشر',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss19': OpenTypeFeature(
      tag: 'ss19',
      name: 'Stylistic Set 19',
      nameAr: 'المجموعة الأسلوبية 19',
      description: 'Nineteenth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية التاسعة عشر',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    'ss20': OpenTypeFeature(
      tag: 'ss20',
      name: 'Stylistic Set 20',
      nameAr: 'المجموعة الأسلوبية 20',
      description: 'Twentieth stylistic set',
      descriptionAr: 'المجموعة الأسلوبية العشرون',
      category: FeatureCategory.stylisticSets,
      defaultEnabled: false,
    ),
    
    // ==================== Case ====================
    'smcp': OpenTypeFeature(
      tag: 'smcp',
      name: 'Small Caps',
      nameAr: 'الحروف الكبيرة الصغيرة',
      description: 'Lowercase to small capitals',
      descriptionAr: 'تحويل الحروف الصغيرة إلى حروف كبيرة صغيرة',
      category: FeatureCategory.case_,
      defaultEnabled: false,
    ),
    'c2sc': OpenTypeFeature(
      tag: 'c2sc',
      name: 'Caps to Small Caps',
      nameAr: 'تحويل الكبيرة للصغيرة',
      description: 'Uppercase to small capitals',
      descriptionAr: 'تحويل الحروف الكبيرة إلى حروف كبيرة صغيرة',
      category: FeatureCategory.case_,
      defaultEnabled: false,
    ),
    'pcap': OpenTypeFeature(
      tag: 'pcap',
      name: 'Petite Capitals',
      nameAr: 'الحروف الصغيرة جداً',
      description: 'Lowercase to petite capitals',
      descriptionAr: 'تحويل الحروف الصغيرة إلى حروف صغيرة جداً',
      category: FeatureCategory.case_,
      defaultEnabled: false,
    ),
    'c2pc': OpenTypeFeature(
      tag: 'c2pc',
      name: 'Caps to Petite Caps',
      nameAr: 'تحويل للحروف الصغيرة جداً',
      description: 'Uppercase to petite capitals',
      descriptionAr: 'تحويل الحروف الكبيرة إلى حروف صغيرة جداً',
      category: FeatureCategory.case_,
      defaultEnabled: false,
    ),
    'unic': OpenTypeFeature(
      tag: 'unic',
      name: 'Unicase',
      nameAr: 'حالة واحدة',
      description: 'Mixed case forms',
      descriptionAr: 'أشكال مختلطة الحالة',
      category: FeatureCategory.case_,
      defaultEnabled: false,
    ),
    'case': OpenTypeFeature(
      tag: 'case',
      name: 'Case-Sensitive Forms',
      nameAr: 'الأشكال الحساسة للحالة',
      description: 'Case-sensitive punctuation',
      descriptionAr: 'علامات ترقيم حساسة للحالة',
      category: FeatureCategory.case_,
      defaultEnabled: false,
    ),
    
    // ==================== Numeric ====================
    'lnum': OpenTypeFeature(
      tag: 'lnum',
      name: 'Lining Figures',
      nameAr: 'الأرقام المصفوفة',
      description: 'Uniform height numbers',
      descriptionAr: 'أرقام بارتفاع موحد',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    'onum': OpenTypeFeature(
      tag: 'onum',
      name: 'Oldstyle Figures',
      nameAr: 'الأرقام التقليدية',
      description: 'Varying height numbers',
      descriptionAr: 'أرقام بارتفاعات متفاوتة',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    'pnum': OpenTypeFeature(
      tag: 'pnum',
      name: 'Proportional Figures',
      nameAr: 'الأرقام التناسبية',
      description: 'Varying width numbers',
      descriptionAr: 'أرقام بعرض متناسب',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    'tnum': OpenTypeFeature(
      tag: 'tnum',
      name: 'Tabular Figures',
      nameAr: 'الأرقام الجدولية',
      description: 'Fixed width numbers',
      descriptionAr: 'أرقام بعرض ثابت',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    'frac': OpenTypeFeature(
      tag: 'frac',
      name: 'Fractions',
      nameAr: 'الكسور',
      description: 'Diagonal fractions',
      descriptionAr: 'كسور قطرية',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    'afrc': OpenTypeFeature(
      tag: 'afrc',
      name: 'Alternative Fractions',
      nameAr: 'الكسور البديلة',
      description: 'Stacked fractions',
      descriptionAr: 'كسور مكدسة',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    'ordn': OpenTypeFeature(
      tag: 'ordn',
      name: 'Ordinals',
      nameAr: 'الأعداد الترتيبية',
      description: 'Ordinal forms (1st, 2nd)',
      descriptionAr: 'أشكال الأعداد الترتيبية',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    'zero': OpenTypeFeature(
      tag: 'zero',
      name: 'Slashed Zero',
      nameAr: 'الصفر المشطوب',
      description: 'Zero with slash',
      descriptionAr: 'صفر مع خط',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    'numr': OpenTypeFeature(
      tag: 'numr',
      name: 'Numerators',
      nameAr: 'البسط',
      description: 'Numerator forms',
      descriptionAr: 'أشكال البسط',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    'dnom': OpenTypeFeature(
      tag: 'dnom',
      name: 'Denominators',
      nameAr: 'المقام',
      description: 'Denominator forms',
      descriptionAr: 'أشكال المقام',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    'sinf': OpenTypeFeature(
      tag: 'sinf',
      name: 'Scientific Inferiors',
      nameAr: 'الأرقام السفلية العلمية',
      description: 'Subscript forms for science',
      descriptionAr: 'أشكال منخفضة للعلوم',
      category: FeatureCategory.numeric,
      defaultEnabled: false,
    ),
    
    // ==================== Position ====================
    'sups': OpenTypeFeature(
      tag: 'sups',
      name: 'Superscript',
      nameAr: 'الحروف العلوية',
      description: 'Superscript forms',
      descriptionAr: 'أشكال علوية',
      category: FeatureCategory.position,
      defaultEnabled: false,
    ),
    'subs': OpenTypeFeature(
      tag: 'subs',
      name: 'Subscript',
      nameAr: 'الحروف السفلية',
      description: 'Subscript forms',
      descriptionAr: 'أشكال سفلية',
      category: FeatureCategory.position,
      defaultEnabled: false,
    ),
    
    // ==================== Spacing ====================
    'kern': OpenTypeFeature(
      tag: 'kern',
      name: 'Kerning',
      nameAr: 'تقنين المسافات',
      description: 'Adjusts space between glyphs',
      descriptionAr: 'ضبط المسافة بين الحروف',
      category: FeatureCategory.spacing,
      defaultEnabled: true,
    ),
    'cpsp': OpenTypeFeature(
      tag: 'cpsp',
      name: 'Capital Spacing',
      nameAr: 'تباعد الحروف الكبيرة',
      description: 'Extra space for capitals',
      descriptionAr: 'مسافة إضافية للحروف الكبيرة',
      category: FeatureCategory.spacing,
      defaultEnabled: false,
    ),
    'palt': OpenTypeFeature(
      tag: 'palt',
      name: 'Proportional Alternate Widths',
      nameAr: 'العرض التناسبي البديل',
      description: 'Proportional width for CJK',
      descriptionAr: 'عرض تناسبي للغات شرق آسيا',
      category: FeatureCategory.spacing,
      defaultEnabled: false,
    ),
    'halt': OpenTypeFeature(
      tag: 'halt',
      name: 'Alternate Half Widths',
      nameAr: 'نصف العرض البديل',
      description: 'Half width forms',
      descriptionAr: 'أشكال نصف العرض',
      category: FeatureCategory.spacing,
      defaultEnabled: false,
    ),
    
    // ==================== Arabic Specific ====================
    'init': OpenTypeFeature(
      tag: 'init',
      name: 'Initial Forms',
      nameAr: 'الأشكال الأولية',
      description: 'Initial position forms',
      descriptionAr: 'أشكال الموضع الأولي',
      category: FeatureCategory.arabic,
      defaultEnabled: true,
    ),
    'medi': OpenTypeFeature(
      tag: 'medi',
      name: 'Medial Forms',
      nameAr: 'الأشكال الوسطية',
      description: 'Medial position forms',
      descriptionAr: 'أشكال الموضع الوسطي',
      category: FeatureCategory.arabic,
      defaultEnabled: true,
    ),
    'fina': OpenTypeFeature(
      tag: 'fina',
      name: 'Final Forms',
      nameAr: 'الأشكال النهائية',
      description: 'Final position forms',
      descriptionAr: 'أشكال الموضع النهائي',
      category: FeatureCategory.arabic,
      defaultEnabled: true,
    ),
    'isol': OpenTypeFeature(
      tag: 'isol',
      name: 'Isolated Forms',
      nameAr: 'الأشكال المنفصلة',
      description: 'Isolated position forms',
      descriptionAr: 'أشكال الموضع المنفصل',
      category: FeatureCategory.arabic,
      defaultEnabled: true,
    ),
    'falt': OpenTypeFeature(
      tag: 'falt',
      name: 'Final Glyph on Line Alternates',
      nameAr: 'بدائل الحرف الأخير',
      description: 'Alternate forms for line endings',
      descriptionAr: 'أشكال بديلة لنهايات السطور',
      category: FeatureCategory.arabic,
      defaultEnabled: false,
    ),
    'jalt': OpenTypeFeature(
      tag: 'jalt',
      name: 'Justification Alternates',
      nameAr: 'بدائل الضبط',
      description: 'Alternate forms for justification',
      descriptionAr: 'أشكال بديلة لضبط النص',
      category: FeatureCategory.arabic,
      defaultEnabled: false,
    ),
    'mset': OpenTypeFeature(
      tag: 'mset',
      name: 'Mark Positioning via Substitution',
      nameAr: 'وضع العلامات بالاستبدال',
      description: 'Mark positioning through substitution',
      descriptionAr: 'تحديد موضع العلامات عبر الاستبدال',
      category: FeatureCategory.arabic,
      defaultEnabled: true,
    ),
    
    // ==================== Mark Positioning ====================
    'mark': OpenTypeFeature(
      tag: 'mark',
      name: 'Mark Positioning',
      nameAr: 'وضع العلامات',
      description: 'Positioning marks relative to base',
      descriptionAr: 'تحديد موضع العلامات بالنسبة للقاعدة',
      category: FeatureCategory.marks,
      defaultEnabled: true,
    ),
    'mkmk': OpenTypeFeature(
      tag: 'mkmk',
      name: 'Mark to Mark Positioning',
      nameAr: 'وضع العلامة للعلامة',
      description: 'Positioning marks relative to marks',
      descriptionAr: 'تحديد موضع العلامات بالنسبة للعلامات',
      category: FeatureCategory.marks,
      defaultEnabled: true,
    ),
    
    // ==================== Vertical ====================
    'vkrn': OpenTypeFeature(
      tag: 'vkrn',
      name: 'Vertical Kerning',
      nameAr: 'تقنين المسافات العمودي',
      description: 'Vertical kerning adjustments',
      descriptionAr: 'ضبط المسافات العمودية',
      category: FeatureCategory.vertical,
      defaultEnabled: false,
    ),
    'vert': OpenTypeFeature(
      tag: 'vert',
      name: 'Vertical Alternates',
      nameAr: 'البدائل العمودية',
      description: 'Vertical forms for CJK',
      descriptionAr: 'أشكال عمودية للغات شرق آسيا',
      category: FeatureCategory.vertical,
      defaultEnabled: false,
    ),
    'vrt2': OpenTypeFeature(
      tag: 'vrt2',
      name: 'Vertical Alternates Rotation',
      nameAr: 'دوران البدائل العمودية',
      description: 'Vertical alternates with rotation',
      descriptionAr: 'بدائل عمودية مع دوران',
      category: FeatureCategory.vertical,
      defaultEnabled: false,
    ),
    
    // ==================== CJK Specific ====================
    'jp78': OpenTypeFeature(
      tag: 'jp78',
      name: 'JIS78 Forms',
      nameAr: 'أشكال JIS78',
      description: 'JIS 1978 character forms',
      descriptionAr: 'أشكال حروف JIS 1978',
      category: FeatureCategory.cjk,
      defaultEnabled: false,
    ),
    'jp83': OpenTypeFeature(
      tag: 'jp83',
      name: 'JIS83 Forms',
      nameAr: 'أشكال JIS83',
      description: 'JIS 1983 character forms',
      descriptionAr: 'أشكال حروف JIS 1983',
      category: FeatureCategory.cjk,
      defaultEnabled: false,
    ),
    'jp90': OpenTypeFeature(
      tag: 'jp90',
      name: 'JIS90 Forms',
      nameAr: 'أشكال JIS90',
      description: 'JIS 1990 character forms',
      descriptionAr: 'أشكال حروف JIS 1990',
      category: FeatureCategory.cjk,
      defaultEnabled: false,
    ),
    'jp04': OpenTypeFeature(
      tag: 'jp04',
      name: 'JIS2004 Forms',
      nameAr: 'أشكال JIS2004',
      description: 'JIS 2004 character forms',
      descriptionAr: 'أشكال حروف JIS 2004',
      category: FeatureCategory.cjk,
      defaultEnabled: false,
    ),
    'trad': OpenTypeFeature(
      tag: 'trad',
      name: 'Traditional Forms',
      nameAr: 'الأشكال التقليدية',
      description: 'Traditional Chinese forms',
      descriptionAr: 'أشكال صينية تقليدية',
      category: FeatureCategory.cjk,
      defaultEnabled: false,
    ),
    'smpl': OpenTypeFeature(
      tag: 'smpl',
      name: 'Simplified Forms',
      nameAr: 'الأشكال المبسطة',
      description: 'Simplified Chinese forms',
      descriptionAr: 'أشكال صينية مبسطة',
      category: FeatureCategory.cjk,
      defaultEnabled: false,
    ),
    'ruby': OpenTypeFeature(
      tag: 'ruby',
      name: 'Ruby Notation Forms',
      nameAr: 'أشكال تدوين روبي',
      description: 'Small forms for ruby annotations',
      descriptionAr: 'أشكال صغيرة للتعليقات',
      category: FeatureCategory.cjk,
      defaultEnabled: false,
    ),
    
    // ==================== Character Variants ====================
    'cv01': OpenTypeFeature(
      tag: 'cv01',
      name: 'Character Variant 1',
      nameAr: 'متغير الحرف 1',
      description: 'First character variant',
      descriptionAr: 'المتغير الأول للحرف',
      category: FeatureCategory.characterVariants,
      defaultEnabled: false,
    ),
    'cv02': OpenTypeFeature(
      tag: 'cv02',
      name: 'Character Variant 2',
      nameAr: 'متغير الحرف 2',
      description: 'Second character variant',
      descriptionAr: 'المتغير الثاني للحرف',
      category: FeatureCategory.characterVariants,
      defaultEnabled: false,
    ),
    'cv03': OpenTypeFeature(
      tag: 'cv03',
      name: 'Character Variant 3',
      nameAr: 'متغير الحرف 3',
      description: 'Third character variant',
      descriptionAr: 'المتغير الثالث للحرف',
      category: FeatureCategory.characterVariants,
      defaultEnabled: false,
    ),
    'cv04': OpenTypeFeature(
      tag: 'cv04',
      name: 'Character Variant 4',
      nameAr: 'متغير الحرف 4',
      description: 'Fourth character variant',
      descriptionAr: 'المتغير الرابع للحرف',
      category: FeatureCategory.characterVariants,
      defaultEnabled: false,
    ),
    'cv05': OpenTypeFeature(
      tag: 'cv05',
      name: 'Character Variant 5',
      nameAr: 'متغير الحرف 5',
      description: 'Fifth character variant',
      descriptionAr: 'المتغير الخامس للحرف',
      category: FeatureCategory.characterVariants,
      defaultEnabled: false,
    ),
    'cv06': OpenTypeFeature(
      tag: 'cv06',
      name: 'Character Variant 6',
      nameAr: 'متغير الحرف 6',
      description: 'Sixth character variant',
      descriptionAr: 'المتغير السادس للحرف',
      category: FeatureCategory.characterVariants,
      defaultEnabled: false,
    ),
    'cv07': OpenTypeFeature(
      tag: 'cv07',
      name: 'Character Variant 7',
      nameAr: 'متغير الحرف 7',
      description: 'Seventh character variant',
      descriptionAr: 'المتغير السابع للحرف',
      category: FeatureCategory.characterVariants,
      defaultEnabled: false,
    ),
    'cv08': OpenTypeFeature(
      tag: 'cv08',
      name: 'Character Variant 8',
      nameAr: 'متغير الحرف 8',
      description: 'Eighth character variant',
      descriptionAr: 'المتغير الثامن للحرف',
      category: FeatureCategory.characterVariants,
      defaultEnabled: false,
    ),
    'cv09': OpenTypeFeature(
      tag: 'cv09',
      name: 'Character Variant 9',
      nameAr: 'متغير الحرف 9',
      description: 'Ninth character variant',
      descriptionAr: 'المتغير التاسع للحرف',
      category: FeatureCategory.characterVariants,
      defaultEnabled: false,
    ),
    'cv10': OpenTypeFeature(
      tag: 'cv10',
      name: 'Character Variant 10',
      nameAr: 'متغير الحرف 10',
      description: 'Tenth character variant',
      descriptionAr: 'المتغير العاشر للحرف',
      category: FeatureCategory.characterVariants,
      defaultEnabled: false,
    ),
    
    // ==================== Localized Forms ====================
    'locl': OpenTypeFeature(
      tag: 'locl',
      name: 'Localized Forms',
      nameAr: 'الأشكال المحلية',
      description: 'Language-specific forms',
      descriptionAr: 'أشكال خاصة باللغة',
      category: FeatureCategory.localized,
      defaultEnabled: true,
    ),
    
    // ==================== Other ====================
    'aalt': OpenTypeFeature(
      tag: 'aalt',
      name: 'Access All Alternates',
      nameAr: 'الوصول لجميع البدائل',
      description: 'Access to all alternates',
      descriptionAr: 'الوصول لجميع البدائل المتاحة',
      category: FeatureCategory.other,
      defaultEnabled: false,
    ),
    'ccmp': OpenTypeFeature(
      tag: 'ccmp',
      name: 'Glyph Composition/Decomposition',
      nameAr: 'تركيب/تفكيك الحروف',
      description: 'Composite character handling',
      descriptionAr: 'معالجة الحروف المركبة',
      category: FeatureCategory.other,
      defaultEnabled: true,
    ),
    'rclt': OpenTypeFeature(
      tag: 'rclt',
      name: 'Required Contextual Alternates',
      nameAr: 'البدائل السياقية المطلوبة',
      description: 'Required contextual forms',
      descriptionAr: 'أشكال سياقية مطلوبة',
      category: FeatureCategory.other,
      defaultEnabled: true,
    ),
    'rvrn': OpenTypeFeature(
      tag: 'rvrn',
      name: 'Required Variation Alternates',
      nameAr: 'بدائل التنويع المطلوبة',
      description: 'Required variation forms',
      descriptionAr: 'أشكال تنويع مطلوبة',
      category: FeatureCategory.other,
      defaultEnabled: true,
    ),
    'size': OpenTypeFeature(
      tag: 'size',
      name: 'Optical Size',
      nameAr: 'الحجم البصري',
      description: 'Optical size forms',
      descriptionAr: 'أشكال الحجم البصري',
      category: FeatureCategory.other,
      defaultEnabled: false,
    ),
  };
  
  /// الحصول على الخصائص حسب الفئة
  static List<OpenTypeFeature> getByCategory(FeatureCategory category) {
    return allFeatures.values
        .where((feature) => feature.category == category)
        .toList();
  }
  
  /// الحصول على الخصائص المفعلة افتراضياً
  static List<OpenTypeFeature> getDefaultEnabled() {
    return allFeatures.values
        .where((feature) => feature.defaultEnabled)
        .toList();
  }
}

/// نموذج خاصية OpenType
class OpenTypeFeature {
  final String tag;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final FeatureCategory category;
  final bool defaultEnabled;
  
  const OpenTypeFeature({
    required this.tag,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.category,
    required this.defaultEnabled,
  });
}

/// فئات خصائص OpenType
enum FeatureCategory {
  ligatures,
  alternates,
  stylisticSets,
  case_,
  numeric,
  position,
  spacing,
  arabic,
  marks,
  vertical,
  cjk,
  characterVariants,
  localized,
  other,
}

/// امتداد للحصول على اسم الفئة
extension FeatureCategoryExtension on FeatureCategory {
  String get name {
    switch (this) {
      case FeatureCategory.ligatures:
        return 'Ligatures';
      case FeatureCategory.alternates:
        return 'Alternates';
      case FeatureCategory.stylisticSets:
        return 'Stylistic Sets';
      case FeatureCategory.case_:
        return 'Case';
      case FeatureCategory.numeric:
        return 'Numeric';
      case FeatureCategory.position:
        return 'Position';
      case FeatureCategory.spacing:
        return 'Spacing';
      case FeatureCategory.arabic:
        return 'Arabic';
      case FeatureCategory.marks:
        return 'Marks';
      case FeatureCategory.vertical:
        return 'Vertical';
      case FeatureCategory.cjk:
        return 'CJK';
      case FeatureCategory.characterVariants:
        return 'Character Variants';
      case FeatureCategory.localized:
        return 'Localized';
      case FeatureCategory.other:
        return 'Other';
    }
  }
  
  String get nameAr {
    switch (this) {
      case FeatureCategory.ligatures:
        return 'الربط';
      case FeatureCategory.alternates:
        return 'البدائل';
      case FeatureCategory.stylisticSets:
        return 'المجموعات الأسلوبية';
      case FeatureCategory.case_:
        return 'الحالة';
      case FeatureCategory.numeric:
        return 'الأرقام';
      case FeatureCategory.position:
        return 'الموضع';
      case FeatureCategory.spacing:
        return 'التباعد';
      case FeatureCategory.arabic:
        return 'العربية';
      case FeatureCategory.marks:
        return 'العلامات';
      case FeatureCategory.vertical:
        return 'العمودي';
      case FeatureCategory.cjk:
        return 'شرق آسيا';
      case FeatureCategory.characterVariants:
        return 'متغيرات الحروف';
      case FeatureCategory.localized:
        return 'المحلية';
      case FeatureCategory.other:
        return 'أخرى';
    }
  }
}

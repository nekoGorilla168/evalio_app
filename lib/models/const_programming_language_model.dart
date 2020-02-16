class ProgrammingLangMap {
  static const plMap = {
    "001": "Java",
    "002": "Ruby",
    "003": "Python",
    "004": "Go",
    "005": "JavaScript",
    "006": "C/C++",
    "007": "C#",
    "008": "Scala",
    "009": "Rust",
    "010": "Haskell",
    "011": "HTML",
    "012": "CSS",
    "013": "Spring Boot",
    "014": "Play Framework",
    "015": "Ruby on Rails",
    "016": "Django",
    "017": "Vue",
    "018": "React",
    "019": "Angular",
    "020": "Dart",
    "021": "AWS",
    "022": "GCP",
    "023": "Azure",
    "024": "Firebase",
    "025": "Heroku",
    "026": "Swift",
    "027": "Kotlin",
    "028": "Objective-C",
    "029": "Bootstrap",
    "030": "Flask",
    "031": "その他",
  };

  // プログラミング言語名のリスト
  static List<String> pLangNames = plMap.entries.map((e) => e.value).toList();
}

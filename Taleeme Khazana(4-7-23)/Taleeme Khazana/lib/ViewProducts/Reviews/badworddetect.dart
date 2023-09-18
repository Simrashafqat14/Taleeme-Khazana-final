import 'package:fyp_project/ViewProducts/Reviews/badwordslist.dart';

List<String> badWords = urduWords + englishwords;
bool Badworddetector(String text) {
  for (String badWord in badWords) {
    if (text.contains(badWord)) {
      print(true);
      return true;
    }
  }
  print(false);
  return false;
}


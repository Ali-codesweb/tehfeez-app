
class MurajahModel {
  int siparah;
  int pages;
  int tambeeh;
  int talqeen;
  bool isOpened = false;
  double marks;
  MurajahModel(
    this.siparah,
    this.pages,
    this.tambeeh,
    this.talqeen,
    this.isOpened,
    this.marks,
  );

  // Map toJson() => {
  //       'siparah_number': siparah,
  //       'total_pages': pages,
  //       'siparah_tambeeh': tambeeh,
  //       'siparah_talqeen': talqeen,
  //       'marks':marks
  //     };

  Map toMap() {
    return {
      'siparah_number': siparah,
      'total_pages': pages,
      'siparah_tambeeh': tambeeh,
      'siparah_talqeen': talqeen,
      'marks':marks
    };
  }
}

class JuzHaliModel {
  int pageNumber = 0;
  int pageTambeeh = 0;
  int pageTalqeen = 0;
  bool checked;
  JuzHaliModel({
    required this.pageNumber,
    required this.pageTambeeh,
    required this.pageTalqeen,
    required this.checked,
    
  });

  Map toJson() => {
        'page_number': pageNumber,
        'page_tambeeh': pageTambeeh,
        'page_talqeen': pageTalqeen,
      };
  Map toMap() {
    return {
      'page_number': pageNumber,
      'page_tambeeh': pageTambeeh,
      'page_talqeen': pageTalqeen,
    };
  }
}

class EntryModel {
  int studentId;
  String studentName;
  int juzHaliFrom;
  int juzHaliTill;
  // int jadeedSiparah;
  int jadeedAyat;
  int jadeedTambeeh;
  int jadeedSurat;
  String jadeedSuratName;
  bool isJuzhali;
  // int jadeedPage;
  EntryModel({
    required this.studentId,
    required this.juzHaliFrom,
    required this.juzHaliTill,
    required this.jadeedAyat,
    // required this.jadeedSiparah,
    required this.jadeedTambeeh,
    required this.jadeedSurat,
    // required this.jadeedPage,
    required this.studentName,
    required this.jadeedSuratName,
    required this.isJuzhali,
  });

  Map toJson() => {
        'student_id': studentId,
        'juzhali_from': juzHaliFrom,
        'juzhali_till': juzHaliTill,
        // 'jadeed_siparah': jadeedSiparah,
        'jadeed_tambeeh': jadeedTambeeh,
        'jadeed_surat': jadeedSuratName,
        'jadeed_surat_ayat': jadeedAyat,
        // 'jadeed_page': jadeedPage,
      };

  Map toMap() {
    return {
      'student_id': studentId,
      'juzhali_from': juzHaliFrom,
      'juzhali_till': juzHaliTill,
      // 'jadeed_siparah': jadeedSiparah,
      'jadeed_tambeeh': jadeedTambeeh,
      'jadeed_surat': jadeedSuratName,
      'jadeed_surat_ayat': jadeedAyat,
      // 'jadeed_page': jadeedPage,
    };
  }
}


class Last15EntriesModel {
  String date;
  double juzHali;
  int murajahs;


  Last15EntriesModel({
    required this.date,
    required this.juzHali,
    required this.murajahs,
  });
}
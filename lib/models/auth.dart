class TeacherModel {
  int id;
  String name;
  String username;
  String email = 'No email';
  String token;
  String mobileNumber;
  int students;

  TeacherModel(
      {required this.id,
      required this.username,
      required this.name,
      required this.email,
      required this.students,
      required this.token,
      required this.mobileNumber});

  Map toMap(){
    return{
      'name':name,
      'token':token
    };
  }
}

class StudentModel {
  int id;
  // true = male, false = female
  bool gender;
  String name;
  String teacher;
  String mobileNumber;
  String email;
  DateTime dateJoined;
  String profilePicture = '';
  int currentSana;
  DateTime dateOfBirth;
  int currentJadeedSurat;
  int currentJadeedSuratAyat;
  double avgJuzhali;
  double avgMurajah;
  double avgAttendance;

  StudentModel({
    required this.id,
    required this.gender,
    required this.name,
    required this.teacher,
    required this.mobileNumber,
    required this.email,
    required this.dateJoined,
    required this.profilePicture,
    required this.currentSana,
    required this.dateOfBirth,
    required this.currentJadeedSurat,
    required this.avgJuzhali,
    required this.avgMurajah,
    required this.avgAttendance,
    required this.currentJadeedSuratAyat,
  });
}

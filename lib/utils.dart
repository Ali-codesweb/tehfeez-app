import 'package:tehfeez/models/entry.dart';

String todayDateString() {
  DateTime _today = DateTime.now();
  String _previewText =
      'Your Today\'s Repport:\n\nDate: ${_today.day} / ${_today.month} / ${_today.year}\n\n\n';
  return _previewText;
}

double murajahMark(MurajahModel _murajah) {
  double _marks = 10 -
      ((_murajah.tambeeh / (_murajah.pages * 2)) +
          (_murajah.talqeen / (_murajah.pages * 1)));
  return _marks;
}
  double getJuzhaliMarks(List<JuzHaliModel> _checkedJuzhali) {
    
    double _marksJuzHali = 10;
    double _tambeeMarks = 1 / 4;
    double _talqeenMarks = 1 / 2;

    if (_checkedJuzhali.length <= 2) {
      print('under 2');
      _tambeeMarks = 1 / 2;
      _talqeenMarks = 1;
    } else if (_checkedJuzhali.length <= 6) {
      print('it is under 6');
      _tambeeMarks = 1 / 3;
      _talqeenMarks = 1 / 2;
    } else if (_checkedJuzhali.length >= 7) {
      print('it is under 7');
    }
    print(_tambeeMarks);
    print(_talqeenMarks);
    for (var i = 0; i < _checkedJuzhali.length; i++) {
      final _page = _checkedJuzhali[i];
      _marksJuzHali -= ((_page.pageTambeeh * _tambeeMarks) +
          (_page.pageTalqeen * _talqeenMarks));
    }
    return _marksJuzHali;
  }


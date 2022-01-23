import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tehfeez/enums.dart' as en;
import 'package:tehfeez/models/entry.dart';
import 'package:tehfeez/utils.dart';
import 'package:tehfeez/widgets/custom_alert.dart';
import 'package:tehfeez/widgets/murajah.dart';
import 'package:url_launcher/url_launcher.dart';

class Entry with ChangeNotifier {
  // static const URL = 'http://192.168.218.220:8000/api/';
  static const URL = 'https://tehfeez.herokuapp.com/api/';

  List<MurajahModel> _murajah = [
    // MurajahModel(1, 1, 0, 0, true),
  ];
  List<MurajahModel> get murajah {
    return _murajah;
  }

  List<JuzHaliModel> checkedJuzHali() {
    List<JuzHaliModel> _checkedJuzhali =
        _juzHali.where((element) => element.checked == true).toList();
        return _checkedJuzhali;
  }
  void clearData(){
    _juzHali = [];
    _murajah=[];
  }
  var token;

  String getStringToCopy() {
    String _spaces = '\t\t\t\t\t\t\t\t\t\t\t\t';
    String _toCopy = '';
    if (entry.studentName != '' || entry.studentName != 'Anonymous')
      _toCopy += 'Name : *${entry.studentName}*\n\n\n';
    _toCopy += todayDateString();

    if (murajah.length > 0) {
      _toCopy += '*Murajah:* \n\n';
      _toCopy += 'Siparah: \t\tTambeeh\t\t\t\tTalqeen\t\t\t\tMarks:\n\n';
      for (var i = 0; i < murajah.length; i++) {
        final _murajah = murajah[i];
        double _marks = murajahMark(_murajah);
        print(_marks);
        _toCopy +=
            '\t${_murajah.siparah.toString()}$_spaces${_murajah.tambeeh.toString()}$_spaces${_murajah.talqeen.toString()}\t\t\t\t\t\t\t\t${_marks.toString()}\n\n';
      }
    } else {
      _toCopy += '*No Murajah Today*\n\n';
    }
    if(_entry.isJuzhali){
      if (_juzHali[0].pageNumber == 0)
      _toCopy += '*No Juzhali Today*\n\n';
    else {
      if (_juzHali.length > 1) {
        _toCopy +=
            '\n\n*JuzHali :* \n\nPage Number: \t\t\t\tTambeeh\t\t\t\tTalqeen\n\n';
        String _marksJuzHali = getJuzhaliMarks(checkedJuzHali()).toStringAsFixed(2);
        for (var i = 0; i < checkedJuzHali().length; i++) {
          final _page = checkedJuzHali()[i];
           _toCopy +=
            '\t\t\t\t${_page.pageNumber}\t\t\t\t\t\t\t\t\t\t\t\t${_page.pageTambeeh}\t\t\t\t\t\t\t\t\t\t${_page.pageTalqeen}\n\n';
         
        }
        _toCopy += '\n\n\nJuzhali marks: \t\t${_marksJuzHali}\n\n\n';
      } else {
        _toCopy += '*No Juzhali Today*';
      }
    }
    }else{
      _toCopy += '*No Juzhali Today*';
    }
    if (entry.jadeedSuratName != '') {
      _toCopy += '*Jadeed:*\n\n';
      _toCopy += 'Surat: ${entry.jadeedSuratName}\n';
      _toCopy += 'Aayat: ${entry.jadeedAyat}\n';
      _toCopy += 'Tambeeh: ${entry.jadeedTambeeh}\n';
    } else {
      _toCopy += '*No jadeed today*';
    }

    return _toCopy;
  }

  List<JuzHaliModel> _juzHali = [];
  bool allPages = true;
  generateJuzHaliList() {
    int pages = entry.juzHaliTill - entry.juzHaliFrom;

    _juzHali = List.generate(pages + 1, (index) {
      return JuzHaliModel(
          pageNumber: entry.juzHaliFrom + index,
          pageTambeeh: 0,
          pageTalqeen: 0,
          checked: true);
    });
  }

  List<JuzHaliModel> get juzHali {
    return _juzHali;
  }

  EntryModel _entry = EntryModel(
      studentId: 1,
      juzHaliFrom: 0,
      juzHaliTill: 0,
      jadeedTambeeh: 0,
      jadeedSurat: 1,
      jadeedSuratName: '',
      jadeedAyat: 1,
      studentName: '',
      isJuzhali: true);

  EntryModel get entry {
    return _entry;
  }

  List _previousEntries = [];
  List get previousEntries {
    return _previousEntries;
  }

  update(var studentName, int id, int jadeedSurat, String newToken) {
    entry.studentName = studentName != null ? studentName : '';
    entry.studentId = id;
    entry.jadeedSurat = jadeedSurat;
    token = newToken;
  }

  Future addEntry(BuildContext ctx) async {
    if (_murajah.length > 0) {
      for (var i = 0; i < _murajah.length; i++) {
        final _murajahSiparah = murajah[i];
        double _marks = 10 -
            ((_murajahSiparah.tambeeh / (_murajahSiparah.pages * 2)) +
                (_murajahSiparah.talqeen / (_murajahSiparah.pages * 1)));
        _murajahSiparah.marks = _marks;
      }
    } else {
      _murajah = [];
    }
    double _marksJuzHali = getJuzhaliMarks(_juzHali);

    if (_juzHali.length > 1 && _entry.isJuzhali) {
    } else {
      _juzHali = [];
    }
    Map _dataToSend = {
      'student_id': entry.studentId,
      'murajah': _murajah.map((element) {
        return element.toMap();
      }).toList(),
      'juzhali_from': _entry.isJuzhali ? _entry.juzHaliFrom : null,
      'juzhali_till': _entry.isJuzhali ? _entry.juzHaliTill : null,
      'juz_hali': checkedJuzHali().length > 1 ? checkedJuzHali(): [],
      'jadeed_surat': entry.jadeedSuratName,
      'jadeed_surat_ayat': entry.jadeedAyat,
      'jadeed_surat_number': entry.jadeedSurat,
      'jadeed_tambeeh': entry.jadeedTambeeh,
      'juzhali_marks': _entry.isJuzhali || _marksJuzHali != 10
          ? double.parse((_marksJuzHali).toStringAsFixed(2))
          : null
    };
    print(_dataToSend);
    final encodedData = json.encode(_dataToSend);
    try {
      final response = await http.post(Uri.parse(URL + 'add-entry/'),
          body: encodedData,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-type': 'Application/json'
          });
      final _data = json.decode(response.body);
      if (response.statusCode >= 400) {
        await showDialog(
            context: ctx,
            builder: (ctx) {
              return CustomAlert(ctx, _data['message'], 'Error');
            });
      } else {
        await showDialog(
            context: ctx,
            builder: (ctx) {
              return CustomAlert(ctx, _data['message'], 'Success');
            });
        // _juzHali = [];
        // _murajah = [];
      }
    } catch (error) {
      print(error);
    }
  }

  Future fetch15Entries(int id, int days, bool isPdf) async {
    try {
      var pdf = 'False';
      if (isPdf == true) {
        pdf = 'True';
        launch((URL + 'get-more-records/?days=$days&id=$id&isPdf=$pdf'),
            headers: {'Authorization': 'Bearer $token'});
        return;
      }
      final response = await http.get(
          Uri.parse(URL + 'get-more-records/?days=$days&id=$id&isPdf=$pdf'),
          headers: {
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode >= 400) {
        print(response.body);
      } else {
        if (pdf == 'False') {
          final _data = json.decode(response.body);
          _previousEntries = _data['entries'];
        }
        print(response.body);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  togglePanel(int siparah) {
    final _siparah =
        _murajah.firstWhere((element) => element.siparah == siparah);
    _siparah.isOpened = !_siparah.isOpened;
    notifyListeners();
  }

  addSiparah(BuildContext ctx) {
    final _newModel = MurajahModel(0, 1, 0, 0, true, 10);

    try {
      // ignore: unused_local_variable
      final _siparah = _murajah
          .firstWhere((element) => element.siparah == _newModel.siparah);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('You have already have this siparah in murajah.'),
        ),
      );
    } catch (e) {
      _murajah.add(_newModel);
    }
    notifyListeners();
  }

  removeMurajah(int murajahSiparah) {
    _murajah.removeWhere((element) => element.siparah == murajahSiparah);
    print(_murajah);
    notifyListeners();
  }

  addOrRemoveTambeeh(int siparah, TambeehActions action) {
    final _siparah =
        _murajah.firstWhere((element) => element.siparah == siparah);
    if (action == TambeehActions.Add) _siparah.tambeeh += 1;

    if (action == TambeehActions.Remove) _siparah.tambeeh -= 1;

    notifyListeners();
  }

  addOrRemoveTalqeen(int siparah, TalqeenActions action) {
    final _siparah =
        _murajah.firstWhere((element) => element.siparah == siparah);
    if (action == TalqeenActions.Add) _siparah.talqeen += 1;
    if (action == TalqeenActions.Remove) _siparah.talqeen -= 1;

    notifyListeners();
  }

  addOrRemoveMurajahTambeehTalqeen(
      int pageNumber, en.MurajahTalqeenTambeehEnum action) {
    final _page =
        juzHali.firstWhere((element) => element.pageNumber == pageNumber);
    if (action == en.MurajahTalqeenTambeehEnum.TambeehAdd)
      _page.pageTambeeh += 1;
    if (action == en.MurajahTalqeenTambeehEnum.TambeehRemove)
      _page.pageTambeeh -= 1;
    if (action == en.MurajahTalqeenTambeehEnum.TalqeenAdd)
      _page.pageTalqeen += 1;
    if (action == en.MurajahTalqeenTambeehEnum.TalqeenRemove)
      _page.pageTalqeen -= 1;
    notifyListeners();
  }

  addOrRemoveJuzhaliTambeehTalqeen(
      int pageNumber, en.JuzhaliTalqeenTambeehEnum action) {
    final _page =
        juzHali.firstWhere((element) => element.pageNumber == pageNumber);
    if (action == en.JuzhaliTalqeenTambeehEnum.TambeehAdd)
      _page.pageTambeeh += 1;
    if (action == en.JuzhaliTalqeenTambeehEnum.TambeehRemove)
      _page.pageTambeeh -= 1;
    if (action == en.JuzhaliTalqeenTambeehEnum.TalqeenAdd)
      _page.pageTalqeen += 1;
    if (action == en.JuzhaliTalqeenTambeehEnum.TalqeenRemove)
      _page.pageTalqeen -= 1;

    notifyListeners();
  }
}

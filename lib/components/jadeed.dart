import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data.dart';
import '../providers/auth.dart';
import '../providers/entry.dart';
import '../models/auth.dart';

// ignore: must_be_immutable
class Jadeed extends StatefulWidget {
  @override
  _JadeedState createState() => _JadeedState();
  int _stuId;
  Jadeed(this._stuId);
}

class _JadeedState extends State<Jadeed> {
  // ignore: non_constant_identifier_names
  TextEditingController surat_name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context,listen:false);
    final entryProvider = Provider.of<Entry>(context,listen:false);
    print('Jadeed widget rebuilt');
    final width = MediaQuery.of(context).size.width;
    final _student = authProvider.students.firstWhere(
      (element) => element.id == widget._stuId,
      orElse: () {
        return StudentModel(
          id: 1,
          gender: true,
          name: '',
          teacher: 'teacher',
          mobileNumber: '0000',
          email: 'No Email',
          dateJoined: DateTime.now(),
          profilePicture: '',
          currentSana: 0,
          dateOfBirth: DateTime.now(),
          currentJadeedSurat: 1,
          avgJuzhali: 1,
          avgMurajah: 1,
          avgAttendance: 1,
          currentJadeedSuratAyat: 1,
        );
      },
    );

    var dummyArray = List.from(quranData['references']!);

    dummyArray.removeRange(0, entryProvider.entry.jadeedSurat - 1);
    final _surat = dummyArray.firstWhere(
        (element) => element['number'] == entryProvider.entry.jadeedSurat,
        orElse: () => quranData['references']![0]);
  
    final _suratAyat =
        List.generate(_surat['numberOfAyahs'], (index) => index + 1);
    return Column(
      children: <Widget>[
        Text(
          'Jadeed',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: width * 0.065),
        ),
        Container(
          margin: EdgeInsets.only(left: width * 0.05),
          child: Row(
            children: <Widget>[
              Text(
                'Surat:',
                style: TextStyle(fontSize: width * 0.038),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: DropdownButton(
                    menuMaxHeight: double.infinity,
                    hint: Text(
                      'Surat Name',
                      style: TextStyle(
                          fontSize: width * 0.038, color: Colors.grey[600]),
                    ),
                    items: dummyArray
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e['englishName']),
                            value: e['number'],
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        entryProvider.entry.jadeedSurat = val as int;
                        entryProvider.entry.jadeedSuratName =
                            dummyArray.firstWhere((element) =>
                                element['number'] == val)['englishName'];
                      });
                      entryProvider.entry.jadeedAyat = 1;
                    },
                    value: entryProvider.entry.jadeedSurat),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            children: <Widget>[
              Text(
                'Aayat :',
                style: TextStyle(fontSize: width * 0.038),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DropdownButton(
                    menuMaxHeight: double.infinity,
                    hint: Text(
                      'Aayat',
                      style: TextStyle(
                          fontSize: width * 0.038, color: Colors.grey[600]),
                    ),
                    items: _suratAyat
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e.toString()),
                            value: e,
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        entryProvider.entry.jadeedAyat = val as int;
                        // s//     (element) => element['number'] == val as int)['englishName'];
                      });
                    },
                    value: entryProvider.entry.jadeedAyat),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            children: <Widget>[
              Text(
                'Tambeeh : ',
                style: TextStyle(fontSize: width * 0.038),
              ),
              Container(
                width: 100,
                child: TextField(
                  style: TextStyle(fontSize: width * 0.038),
                  keyboardType: TextInputType.number,
                  onSubmitted: (val) {
                    if (val == '') return;
                    entryProvider.entry.jadeedTambeeh = int.parse(val);
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

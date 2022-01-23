import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tehfeez/providers/entry.dart';
import '../utils.dart';

class Preview extends StatefulWidget {
  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  bool isOpened = true;

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<Entry>(context, listen: false);

    String _previewText = todayDateString();
    if (entryProvider.murajah.length > 0) {
      _previewText += ' Murajah: \n\n';
      _previewText += 'Siparah: \t\tTambeeh\t\t\t\tTalqeen\t\t\t\tMarks:\n\n';
      for (var i = 0; i < entryProvider.murajah.length; i++) {
        final _murajah = entryProvider.murajah[i];
        double _marks = double.parse(murajahMark(_murajah).toStringAsFixed(2));
        _previewText +=
            '\t\t\t\t\t\t${_murajah.siparah}\t\t\t\t\t\t\t\t\t\t\t\t\t\t${_murajah.tambeeh}\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t${_murajah.talqeen}\t\t\t\t\t\t\t\t\t\t\t\t$_marks\n\n';
      }
      _previewText += '\n\n';
    } else {
      _previewText += 'No Murajah Today\n\n';
    }
   if(entryProvider.entry.isJuzhali){
     if (entryProvider.checkedJuzHali()[0].pageNumber == 0)
      _previewText += '*No Juzhali Today*\n\n';
    else {
      if (entryProvider.juzHali.length > 1) {
        _previewText +=
            '\n\nJuzHali : \n\nPage Number: \t\t\t\tTambeeh\t\t\t\tTalqeen\n\n';
        String _marksJuzHali = getJuzhaliMarks(entryProvider.checkedJuzHali()).toStringAsFixed(2);
        for (var i = 0; i < entryProvider.checkedJuzHali().length; i++) {
          final _page = entryProvider.checkedJuzHali()[i];
           _previewText +=
            '\t\t\t\t${_page.pageNumber}\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t${_page.pageTambeeh}\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t${_page.pageTalqeen}\n\n';
         
        }
        _previewText += '\n\n\nJuzhali marks: \t\t${_marksJuzHali}\n\n\n';
      } else {
        _previewText += '*No Juzhali Today*';
      }
    }
   }else{
     _previewText += 'No Juzhali Today\n\n';
   }
    if (entryProvider.entry.jadeedSuratName != '') {
      _previewText += 'Jadeed:\n\n';
      _previewText += 'Surat: ${entryProvider.entry.jadeedSuratName}\n';
      _previewText += 'Aayat: ${entryProvider.entry.jadeedAyat}\n';
      _previewText += 'Tambeeh: ${entryProvider.entry.jadeedTambeeh}\n';
    } else {
      _previewText += 'No jadeed today';
    }
    print('preview rendered');
    final width = MediaQuery.of(context).size.width;
    return ExpansionPanelList(
        animationDuration: Duration(milliseconds: 500),
        expansionCallback: (int index, bool expanded) {
          setState(() {
            isOpened = !expanded;
          });
          print(isOpened);
        },
        elevation: 0,
        children: [
          ExpansionPanel(
            isExpanded: isOpened,
            headerBuilder: (context, yes) => Container(
              padding: EdgeInsets.only(left: width * 0.05),
              child: Row(children: [
                // Text('${widget.index+1}.'),
                Text(
                  'Preview',
                  style: TextStyle(
                    fontSize: width * 0.038,
                  ),
                ),
              ]),
            ),
            canTapOnHeader: true,
            backgroundColor: Colors.grey[200],
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                color: Colors.grey[100],
                child: Text(_previewText),
              ),
            ),
          ),
        ]);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tehfeez/screens/student_entry_report_screen.dart';
import '../providers/entry.dart';
import '../widgets/custom_size_button.dart';

class StudentReportScreen extends StatefulWidget {
  static const routeName = '/student-report';

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  var _isInit = true;
  var _loading = false;
  TextEditingController _monthsController = TextEditingController(text: '1');
  @override
  Widget build(BuildContext context) {
    final _arguments = ModalRoute.of(context)!.settings.arguments as int;
    // print(_arguments);

    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    if (_isInit) {
      setState(() {
        _loading = true;
      });
      Provider.of<Entry>(context)
          .fetch15Entries(_arguments, 15, false)
          .then((value) {
        setState(() {
          _loading = false;
        });
      });
      _isInit = false;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 50),
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 23),
                      child: Text(
                        'Student Report',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: width * 0.07,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(width * 0.05),
                          bottomLeft: Radius.circular(width * 0.05),
                          topRight: Radius.circular(width * 0.05),
                          bottomRight: Radius.circular(width * 0.05),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            offset: Offset(30, 30),
                            color: Colors.grey[100]!,
                          ),
                        ],
                      ),
                      child: DataTable(
                        columnSpacing: 26,
                        headingRowColor:
                            MaterialStateProperty.all(Colors.grey[300]),
                        showBottomBorder: true,
                        columns: [
                          DataColumn(
                              label: Center(
                            child: Text(
                              'Date',
                              textAlign: TextAlign.center,
                            ),
                          )),
                          DataColumn(
                            label: Text(
                              'Jadeed',
                              textAlign: TextAlign.center,
                              // maxLines: 2,
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: 100,
                              child: Text(
                                'JH Marks',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                        rows:
                            Provider.of<Entry>(context).previousEntries.map((e) {
                          return DataRow(
                              // onLongPress: () {
                              //   Navigator.of(context).pushNamed(
                              //       StudentEntryReportScreen.routeName,arguments: {
                              //         'message':'hello'
                              //       });
                              // },
                              
                              // color: MaterialStateProperty.all(Colors.red),
                              cells: [
                                DataCell(Container(
                                  width: 100,
                                  child: Text(
                                    e['date'],
                                    style: TextStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                                DataCell(Container(
                                  width: 80,
                                  child: Text(
                                    "${e['jadeed_surat'] == '' ? 'No jadeed' : '${e['jadeed_surat']} : ${e['jadeed_surat_ayat']}'}",
                                    style: TextStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                                DataCell(Container(
                                  width: 50,
                                  child: Text(
                                    e['juzhali_marks'] != null
                                        ? e['juzhali_marks'].toString()
                                        : "No Juzhali",
                                    style: TextStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                              ]);
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Text(
                        'Get More Records',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: height * 0.025, color: Colors.grey[600]),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: width * 0.4,
                          child: Row(
                            children: <Widget>[
                              Text('Months'),
                              SizedBox(
                                child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _monthsController),
                                width: width * 0.1,
                              )
                            ],
                          ),
                        ),
                        CustomSizeButton(
                          performingAction: () {
                            // ExtSt
                            // Permission.storage.request().then((_) {
                            if (_monthsController.text != '') {
                              Provider.of<Entry>(context, listen: false)
                                  .fetch15Entries(
                                      _arguments,
                                      int.parse(_monthsController.text) * 30,
                                      true);
                            }
                            return;
                            // });
                          },
                          icon: Text('Get records', textAlign: TextAlign.center),
                          height: height * 0.05,
                          width: width * 0.2,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

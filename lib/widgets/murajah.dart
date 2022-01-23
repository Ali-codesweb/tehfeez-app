import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tehfeez/models/entry.dart';
import 'package:tehfeez/providers/entry.dart';
import 'package:tehfeez/widgets/custom_size_button.dart';

enum TambeehActions { Add, Remove }
enum TalqeenActions { Add, Remove }

// ignore: must_be_immutable
class Murajah extends StatefulWidget {
  MurajahModel data;
  
  Murajah(this.data);

  @override
  _MurajahState createState() => _MurajahState();
}

class _MurajahState extends State<Murajah> {
  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<Entry>(context, listen: false);
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    void addOrRemoveTalqeen(TalqeenActions action) {
      if (widget.data.talqeen < 0) {
        widget.data.talqeen = widget.data.talqeen + 1;
        return;
      }
      entryProvider.addOrRemoveTalqeen(widget.data.siparah, action);
    }

    void addOrRemoveTambeeh(TambeehActions action) {
      if (widget.data.tambeeh < 0) {
        widget.data.tambeeh = widget.data.tambeeh + 1;
        return;
      }
      entryProvider.addOrRemoveTambeeh(widget.data.siparah, action);
    }

    
    var tambeehController =
        TextEditingController(text: widget.data.tambeeh.toString());
    var talqeenController =
        TextEditingController(text: widget.data.talqeen.toString());
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: 500),
      expansionCallback: (int index, bool expanded) {
        entryProvider.togglePanel(widget.data.siparah);
      },
      elevation: 0,
      children: [
        ExpansionPanel(
          isExpanded: widget.data.isOpened,
          headerBuilder: (context, yes) => Container(
            padding: EdgeInsets.only(left: width * 0.05),
            child: Row(children: [
              // Text('${widget.index+1}.'),
              Text('Siparah : ${widget.data.siparah}.',
                  style: TextStyle(
                    fontSize: width * 0.038,
                  )),
            ]),
          ),
          canTapOnHeader: true,
          backgroundColor: Colors.grey[200],
          body: SingleChildScrollView(
            child: Container(
              // height: height * 0.5,
              width: double.infinity,
              color: Colors.grey[100],
              child: Form(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: width * 0.15,
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: width * 0.039,
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              initialValue: widget.data.siparah.toString(),
                              decoration: InputDecoration(labelText: 'Siparah'),
                              validator: (val) {
                                if (val == '') return 'Please enter a siparah';
                              },
                              onChanged: (val) {
                                if (val.isEmpty) return;
                                try {
                                  // ignore: unused_local_variable
                                  final _catch = entryProvider.murajah.firstWhere(
                                      (element) =>
                                          element.siparah.toString() == val);
                                  return;
                                } catch (err) {
                                  widget.data.siparah = int.parse(val);
                                }
                              },
                            ),
                          ),
                          Container(
                            width: width * 0.15,
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: width * 0.039,
                              ),
                              initialValue: widget.data.pages.toString(),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: 'Pages'),
                              validator: (val) {
                                if (val == '')
                                  return 'Please enter number of pages';
                              },
                              onChanged: (val) {
                                if (val.isEmpty) return;
                                widget.data.pages = int.parse(val);
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: width * 0.19,
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: width * 0.039,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(labelText: 'Tambeeh'),
                          enabled: false,
                          controller: tambeehController,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomSizeButton(
                                performingAction: () {
                                  addOrRemoveTambeeh(TambeehActions.Add);
                                },
                                icon: Icon(Icons.add),
                                height: 28,
                                width: width * 0.15,
                                color: Theme.of(context).primaryColor),
                            CustomSizeButton(
                                performingAction: () {
                                  addOrRemoveTambeeh(TambeehActions.Remove);
                                },
                                icon: Icon(Icons.remove),
                                height:28,
                                width: width * 0.15,
                                color: Theme.of(context).primaryColor),
                          ],
                        ),
                      ),
                      Container(
                        width: width * 0.19,
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: width * 0.039,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(labelText: 'Talqeen'),
                          controller: talqeenController,
                          enabled: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomSizeButton(
                              color: Theme.of(context).primaryColor,
                              height: 28,
                              width: width * 0.15,
                              icon: Icon(Icons.add),
                              performingAction: () {
                                addOrRemoveTalqeen(TalqeenActions.Add);
                              },
                            ),
                            CustomSizeButton(
                              color: Theme.of(context).primaryColor,
                              height: 28,
                              width: width * 0.15,
                              icon: Icon(Icons.remove),
                              performingAction: () {
                                addOrRemoveTalqeen(TalqeenActions.Remove);
                              },
                            ),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                              entryProvider.removeMurajah(widget.data.siparah);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).errorColor),
                            ),
                            child: Text('Remove Siparah',
                                style: TextStyle(
                                  fontSize: width *0.024,
                                  color: Colors.white,
                                )),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tehfeez/enums.dart';
import 'package:tehfeez/providers/entry.dart';
import 'package:tehfeez/widgets/custom_size_button.dart';

// ignore: must_be_immutable
class JuzHali extends StatefulWidget {
  int pageNumber;
  JuzHali({
    required this.pageNumber,
  });

  @override
  State<JuzHali> createState() => _JuzHaliState();
}

class _JuzHaliState extends State<JuzHali> {
  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<Entry>(context);
    final _currentPage = entryProvider.juzHali
        .firstWhere((element) => element.pageNumber == widget.pageNumber);
    final _tambeehController =
        TextEditingController(text: _currentPage.pageTambeeh.toString());
    final _talqeenController =
        TextEditingController(text: _currentPage.pageTalqeen.toString());
    return Container(
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: <Widget>[
              !entryProvider.allPages
                  ? Checkbox(
                      value: _currentPage.checked,
                      onChanged: (value) {
                        _currentPage.checked = value!;
                        
                        setState(() {});
                      })
                  : SizedBox(),
              Text(widget.pageNumber.toString())
            ],
          ),
          JuzHaliSection(
            pageNumber: widget.pageNumber,
            controller: _tambeehController,
            labelText: 'Tambeeh',
            addOrRemoveTameeehTaqeen:
                entryProvider.addOrRemoveJuzhaliTambeehTalqeen,
            addEnum: JuzhaliTalqeenTambeehEnum.TambeehAdd,
            removeEnum: JuzhaliTalqeenTambeehEnum.TambeehRemove,
          ),
          JuzHaliSection(
            pageNumber: widget.pageNumber,
            controller: _talqeenController,
            labelText: 'Talqeen',
            addOrRemoveTameeehTaqeen:
                entryProvider.addOrRemoveJuzhaliTambeehTalqeen,
            addEnum: JuzhaliTalqeenTambeehEnum.TalqeenAdd,
            removeEnum: JuzhaliTalqeenTambeehEnum.TalqeenRemove,
          ),
        ],
      ),
    );
  }
}

class JuzHaliSection extends StatelessWidget {
  final pageNumber;
  TextEditingController controller;
  String labelText;
  Function addOrRemoveTameeehTaqeen;
  JuzhaliTalqeenTambeehEnum addEnum;
  JuzhaliTalqeenTambeehEnum removeEnum;
  JuzHaliSection({
    required this.pageNumber,
    required this.controller,
    required this.labelText,
    required this.addOrRemoveTameeehTaqeen,
    required this.addEnum,
    required this.removeEnum,
  });

  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final entryProvider = Provider.of<Entry>(context);

    return Column(
      children: [
        Container(
          width: width * 0.2,
          child: TextFormField(
            enabled: false,
            style: TextStyle(
              fontSize: width * 0.039,
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(labelText: labelText),
            validator: (val) {
              if (val == '') return 'Please enter a value';
            },
            onChanged: (val) {
              if (val.isEmpty) return;
            },
          ),
        ),
        Row(children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
              vertical: width * 0.01,
            ),
            child: CustomSizeButton(
              performingAction: () {
                addOrRemoveTameeehTaqeen(
                    pageNumber, addEnum);
              },
              icon: Icon(Icons.add),
              height: 28,
              width: width * 0.15,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.01, vertical: width * 0.02),
            child: CustomSizeButton(
              performingAction: () {
                addOrRemoveTameeehTaqeen(
                    pageNumber, removeEnum);
              },
              icon: Icon(Icons.remove),
              height: 28,
              width: width * 0.15,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ])
      ],
    );
  }
}

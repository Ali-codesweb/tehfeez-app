import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tehfeez/providers/entry.dart';
import 'package:tehfeez/widgets/murajah.dart';

class MurajahComp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('murajah comp rendered');
    final entryProvider = Provider.of<Entry>(context);
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: height * 0.035, bottom: height * 0.034),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.22,
                  ),
                  Text(
                    'Murajah',
                    style: TextStyle(
                        color: Colors.grey[600], fontSize: width * 0.06),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      entryProvider.addSiparah(context);
                    },
                    child: Text(
                      'Add Siparah',
                      style: TextStyle(fontSize: width * 0.022),
                      textAlign: TextAlign.center,
                    ),
                  )
                ]),
          ),
          ...entryProvider.murajah.asMap().entries.map((e) => Murajah(e.value)),
        ],
      ),
    );
  }
}

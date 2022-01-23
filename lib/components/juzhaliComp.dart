import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tehfeez/providers/entry.dart';
import 'package:tehfeez/widgets/juz_hali.dart';

class JuzHaliComp extends StatefulWidget {
  @override
  State<JuzHaliComp> createState() => _JuzHaliCompState();
}

class _JuzHaliCompState extends State<JuzHaliComp> {
  TextEditingController juzHaliFromController =
      TextEditingController(text: '0');
  TextEditingController juzHaliToController = TextEditingController(text: '0');
  @override
  Widget build(BuildContext context) {
    print('Juz hali comp rendered');
    final entryProvider = Provider.of<Entry>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // SizedBox(width: width * 0.28),
            SizedBox(
                width: width * 0.28,
                child: Checkbox(
                    value: entryProvider.entry.isJuzhali,
                    onChanged: (val) {
                      entryProvider.entry.isJuzhali =
                          !entryProvider.entry.isJuzhali;

                      setState(() {});
                    })),
            Text(
              entryProvider.entry.isJuzhali ? 'Juz hali' : 'No Juz hali',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: width * 0.055,
              ),
            ),
            entryProvider.entry.isJuzhali
                ? Container(
                    child: Row(
                    children: [
                      Text(
                        'All Pages: ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Switch(
                          value: entryProvider.allPages,
                          onChanged: (value) {
                            setState(() {});
                            entryProvider.allPages = !entryProvider.allPages;
                          })
                    ],
                  ))
                : SizedBox(
                    width: width * 0.28,
                  )
          ]),
        ),
        entryProvider.entry.isJuzhali
            ? Padding(
                padding: EdgeInsets.only(bottom: height * 0.015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: TextField(
                        controller: juzHaliFromController,
                        onChanged: (val) {
                          if (val == '') return;
                          entryProvider.entry.juzHaliFrom = int.parse(val);
                        },
                        decoration: InputDecoration(helperText: 'From'),
                        keyboardType: TextInputType.number,
                      ),
                      width: width * 0.2,
                    ),
                    Container(
                      child: TextField(
                        style: TextStyle(
                          fontSize: width * 0.039,
                        ),
                        // textAlign: TextAlign.center,
                        controller: juzHaliToController,
                        onSubmitted: (val) {
                          if (val == '') return;
                          entryProvider.entry.juzHaliTill = int.parse(val);
                          entryProvider.generateJuzHaliList();
                          setState(() {});
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(helperText: 'Till'),
                      ),
                      width: width * 0.2,
                    ),
                  ],
                ),
              )
            : SizedBox(),
        ...entryProvider.juzHali.map(
          (e) => entryProvider.entry.isJuzhali
              ? JuzHali(
                  pageNumber: e.pageNumber,
                )
              : SizedBox(),
        )
      ],
    );
  }
}

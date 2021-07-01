import 'package:flutter/material.dart';
import 'package:flutter_project/constants.dart';
import 'package:intl/intl.dart';
import 'package:country_code/country_code.dart';
import 'package:emoji_flag_converter/emoji_flag_converter.dart';

class ShipmentHistory extends StatelessWidget {
  late List checkpoints;

  ShipmentHistory(Object? args) {
    Map tempMap = args as Map;
    checkpoints = tempMap['checkpoints'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Shipment history")),
        body: buildListView(checkpoints));
  }

  ListView buildListView(checkpoints) {
    String prevDay = "";
    checkpoints = new List.from(checkpoints.reversed);
    String today = DateFormat("EEE, MMM d, y").format(DateTime.now());
    String yesterday = DateFormat("EEE, MMM d, y")
        .format(DateTime.now().add(Duration(days: -1)));
    return ListView.builder(
      itemCount: checkpoints.length,
      itemBuilder: (context, index) {
        Map checkpoint = checkpoints[index];

        DateTime date = DateTime.parse((checkpoint['checkpoint_time']));
        String dateString = DateFormat("EEE, MMM d, y").format(date);
        String countryCode = checkpoint['country_iso3'] != null
            ? CountryCode.tryParse(checkpoint['country_iso3'])!.alpha2
            : 'unk';
        String location = checkpoint['location'];

        if (today == dateString) {
          dateString = "Today";
        } else if (yesterday == dateString) {
          dateString = "Yesteday";
        }
        bool showHeader = prevDay != dateString;
        prevDay = dateString;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            showHeader
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      dateString,
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                : Offstage(),
            buildItem(index, context, date, countryCode, location),
          ],
        );
      },
    );
  }

  Widget buildItem(int index, BuildContext context, DateTime date,
      String countryCode, String location) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(width: 20),
          buildLine(index, context),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            // color: Theme.of(context).accentColor,
            child: Text(
              DateFormat("hh:mm a").format(date),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            flex: 1,
            child: buildItemInfo(context, countryCode, location),
          ),
        ],
      ),
    );
  }

  Card buildItemInfo(
      BuildContext context, String countryCode, String location) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  location,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                countryCode != 'unk'
                    ? EmojiConverter.fromAlpha2CountryCode(countryCode)
                    : 'UNK',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildLine(int index, BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              width: 2,
              color: kPrimaryColor,
            ),
          ),
          Container(
            width: 6,
            height: 6,
            decoration:
                BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 2,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

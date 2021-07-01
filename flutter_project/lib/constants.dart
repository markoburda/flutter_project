import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const kLightGrayColor = Color(0xFFDBDBDB);
const kDarkGrayColor = Color(0xFF272727);
const kBlackColor = Color(0xFF242424);
const kGreenColor = Color(0xFF32C671);
const kBlueColor = Color(0xFF3271b7);
const kCopperColor = Color(0xFFc67132);

const Map<String, Color> delivery_state = {
  "INFORECEIVED": kBlueColor,
  "DELIVERED": kGreenColor,
  "AVAILABLEFORPICKUP": kGreenColor,
  "PENDING": kBlueColor,
  "INTRANSIT": kCopperColor,
  "OUTFORDELIVERY": kCopperColor,
  "UNKNOWN": kLightGrayColor,
  "ATTEMPTFAIL": Colors.red,
  "EXCEPTION": Colors.red,
  "EXPIRED": Colors.red,
};

const Map<String, IconData> state_icons = {
  "DELIVERED": Icons.check_circle,
  "AVAILABLEFORPICKUP": Icons.check_circle,
  "PENDING": Icons.access_time,
  "INFORECEIVED": Icons.access_time,
  "INTRANSIT": Icons.local_shipping,
  "OUTFORDELIVERY": Icons.local_shipping,
  "UNKNOWN": Icons.help,
  "ATTEMPTFAIL": Icons.error,
  "EXCEPTION": Icons.error,
  "EXPIRED": Icons.access_time,
};

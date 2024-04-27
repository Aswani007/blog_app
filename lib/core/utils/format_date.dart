import 'package:intl/intl.dart';

//formate date with day monthName and year
String formateDatadMMMYYYY(DateTime dateTime) =>
    DateFormat('d MMM, yyyy').format(dateTime);

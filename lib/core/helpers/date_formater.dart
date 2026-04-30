import 'package:intl/intl.dart';

String dateFormater({required DateTime dateTime}) {
  return DateFormat('MMM d, yyyy \'at\' h:mm a').format(dateTime);
}

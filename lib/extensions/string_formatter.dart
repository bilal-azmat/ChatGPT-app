import 'package:intl/intl.dart';

extension StringFormatter on String
{
  String replaceCharacter(String from , String replace)
  {
    return replaceAll(from, replace) ;
  }
}


extension DateFormatter on String{

  String dateFormat(String date) {
    return DateFormat.yMMMEd().format(DateTime.parse(date));
  }
// ···

}
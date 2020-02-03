class Date{
  String _year;
  String _month;
  String _day;
  String _date;

  Date(this._date);

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  static String getYearMonth(String date) => date.substring(0, 4) + '-' + date.substring(4, 6);
  static String getDay(String date) => date.substring(6, 8);
  static String getWeekday(String date) => date.substring(8, 11);

}
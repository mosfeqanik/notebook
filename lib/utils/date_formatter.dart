class DateFormatter {
  static String getDateInFormat(String str) {
    String dateFormat = "";
    if (str != null) {
      String day = "";
      String month = "";
      String year = "";
      var newDate = str.split("-");
      year = newDate[0];
      month = newDate[1];
      day = newDate[2];

      String monthName = "";
      switch (month) {
        case "1":
        case "01":
          monthName = "Jan";
          break;
        case "2":
        case "02":
          monthName = "Feb";
          break;
        case "3":
        case "03":
          monthName = "Mar";
          break;
        case "4":
        case "04":
          monthName = "Apr";
          break;
        case "5":
        case "05":
          monthName = "May";
          break;
        case "6":
        case "06":
          monthName = "Jun";
          break;
        case "7":
        case "07":
          monthName = "Jul";
          break;
        case "8":
        case "08":
          monthName = "Aug";
          break;
        case "9":
        case "09":
          monthName = "Sept";
          break;
        case "10":
          monthName = "Oct";
          break;
        case "11":
          monthName = "Nov";
          break;
        case "12":
          monthName = "Dec";
          break;
      }
      dateFormat = day + " " + monthName + " " + year;
    }
    return dateFormat;
  }
}

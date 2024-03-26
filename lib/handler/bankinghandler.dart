import 'package:intl/intl.dart';
import 'package:spendhelper/handler/gsheethandler.dart';

updateGsheetBankDetails(data, bankName, bankBalance) async {
  final ss = await gSheetLoader();
  var sheet = ss.worksheetByTitle('Overall');
  const startcolumn = 29;
  var bankDates = await sheet?.values.column(28, fromRow: 2);
  var lastRow = bankDates!.length + 1;
  var lastDate = bankDates[bankDates.length - 1];

  //Google Data to Epoch base conversion
  var epoch = new DateTime(1899, 12, 30);
  lastDate = DateFormat('MM/dd/yyyy').format(epoch.add(new Duration(days: int.parse(lastDate)))).toString();

  // Current Date
  DateTime now = new DateTime.now();
  var currentDate = DateFormat('MM/dd/yyyy').format(new DateTime(now.year, now.month, now.day)).toString();
  if (currentDate == lastDate) {
    lastRow = lastRow;
  }else {
    lastRow = lastRow + 1;
  }

  //Update Data field with new balance
  data[bankName] = bankBalance.toString();
  final updateData = data.values.toList(); 
  await sheet.values.insertValue(currentDate, column: (startcolumn - 1), row: lastRow);
  // Update Gsheet with bank balance
  var column = 0;
  for (int i = 0; i < updateData.length; i++) {
    column = startcolumn + i;
    await sheet.values.insertValue(updateData[i], column: column, row: lastRow);
  }

  // Update the Total Field also.
  column = column + 1;
  var formulaVal = '=SUM(AC' + lastRow.toString() + '+AD' + lastRow.toString() + '+AE' + lastRow.toString() + '+AF' + lastRow.toString() + ')';
  await sheet.values.insertValue(formulaVal, column: column, row: lastRow);

}

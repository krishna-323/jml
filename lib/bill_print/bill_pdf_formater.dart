import 'dart:typed_data';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> generateBillPDF(List<dynamic> billList) async {
  // print('-----------billList-------------');
  // print(billList);
  final converter = AmountToWords();

  ///Styles.
  // TextStyle blueGrey200 = const TextStyle(color: PdfColors.blueGrey300);
  TextStyle fontSize15WithBold =  TextStyle(fontWeight: FontWeight.bold,fontSize: 15);

  TextStyle fontSize9WithBold =  TextStyle(fontWeight: FontWeight.bold,fontSize: 9);
  //TextStyle fontSize9 =const TextStyle(fontSize: 9);
  TextStyle fontSize10 =const TextStyle(fontSize: 10);
  TextStyle fontSize8WidthBold =TextStyle(fontWeight: FontWeight.bold,fontSize: 8,color: PdfColors.black);

  final pdf = Document();

  // // Load the image from assets
  // final image = MemoryImage(
  //   (await rootBundle.load('assets/logo/jmi_logo.png')).buffer.asUint8List(),
  // );
  BorderSide borderStyle= const BorderSide(color: PdfColors.black,width: 0.5);


  //Date Conversion.
  String formatDate(String dateString) {
    try {
      int milliseconds = int.parse(dateString.substring(6, dateString.length - 2));
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
      return formattedDate;
    } catch (e) {
      print('Error formatting date: $e');
      return '';
    }
  }

  // String formatToTwoDecimal(double number) {
  //   // Convert the number to a string with two decimal places
  //   String formattedNumber = number.toStringAsFixed(2);
  //
  //   // If the number is an integer, remove the ".00"
  //   if (formattedNumber.endsWith('.00')) {
  //     formattedNumber = formattedNumber.substring(0, formattedNumber.length - 3);
  //   }
  //   return formattedNumber;
  // }
  double textWidth1 = 45;
  double textWidth2= 80;
  Text collenStyle =  Text(" : ",style: fontSize8WidthBold);

  pdf.addPage(
    MultiPage(
      //maxPages: 200,
      margin:const EdgeInsets.all(20),
      crossAxisAlignment: CrossAxisAlignment.start,
      build: (context) => [
        Container(
            width: 1000,
            //height: 800,
            decoration:  BoxDecoration(
              border: Border(
                // left: borderStyle,
                // top:borderStyle,
                // right:borderStyle,
                // bottom:borderStyle,
              ),
            ),
            child: Column(children:[
              SizedBox(height: 30),
              Text(
                'JM FRICTECH INDIA PVT. LTD',
                style:fontSize15WithBold
              ),
              Text('',style: fontSize10),
              SizedBox(height: 20),
              Text(
                'BANK PAYMENT ADVICE',
                style: fontSize15WithBold
              ),
              SizedBox(height: 20),
             //First Table.
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Left side
                  Container(
                    height: 120,
                    decoration:  BoxDecoration(
                      border: Border(
                        left: borderStyle,
                        top:borderStyle,
                        right:borderStyle,
                        bottom:borderStyle,
                      ),
                    ),
                    child:  Padding(padding: const EdgeInsets.all(10),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //1 st.
                        Row(children: [
                          Container(width: textWidth1,child: Text('Paid To',style: fontSize8WidthBold)),
                          Text(" : ",style: fontSize8WidthBold),
                          Text("${billList[0]['SupplierName']??""}",style: fontSize10)
                        ]),
                        //2 sd.
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(width: textWidth1,child: Text('Address',style: fontSize8WidthBold)),
                              Text(" : ",style: fontSize8WidthBold),
                              Column(children: [
                                Container(width: 200,
                                    child:  Text("",
                                        style: fontSize10)
                                )
                              ])
                            ]),
                        //3 rd.
                        Row(children: [
                          Container(width: textWidth1,child: Text('Naration',style: fontSize8WidthBold)),
                          Text(" : ",style: fontSize8WidthBold),
                          Text("",style: fontSize10)
                        ]),
                      ],
                    ),)),
                  //Right side.
                  Container(height: 120,width: 280,
                      decoration:  BoxDecoration(
                        border: Border(
                          top:borderStyle,
                          right:borderStyle,
                          bottom:borderStyle,
                        ),
                      ),
                    child: Padding(padding: const EdgeInsets.all(10),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //1 st.
                        Row(children: [
                          Container(width: textWidth2,child: Text('Voucher No',style: fontSize8WidthBold)),
                          collenStyle,
                          Text("${billList[0]['AccountingDocument']??""}",style: fontSize10)
                        ]),

                        //2 sd.
                        Row(children: [
                          Container(width: textWidth2,child: Text('Doc. Date',style: fontSize8WidthBold)),
                          collenStyle,
                          Text(billList[0]['paymentdate'] != null ? formatDate(billList[0]['paymentdate']) : "",style: fontSize10)
                        ]),
                        //3 rd.
                        Row(children: [
                          Container(width: textWidth2,child: Text('Bank',style: fontSize8WidthBold)),
                          collenStyle,
                          Text("",style: fontSize10)
                        ]),
                        //4 th.
                        Row(children: [
                          Container(width: textWidth2,child: Text('Acc. No',style: fontSize8WidthBold)),
                          collenStyle,
                          Text("",style: fontSize10)
                        ]),
                        //5 th.
                        Row(children: [
                          Container(width: textWidth2,child: Text('Payment Mode',style: fontSize8WidthBold)),
                          collenStyle,
                          Text("",style: fontSize10)
                        ]),
                        //6 th.
                        Row(children: [
                          Container(width: textWidth2,child: Text('Cheque No./Date',style: fontSize8WidthBold)),
                          collenStyle,
                          Text("",style: fontSize10)
                        ]),
                        //7 th.
                        Row(children: [
                          Container(width: textWidth2,child: Text('Charges',style: fontSize8WidthBold)),
                          collenStyle,
                          Text("",style: fontSize10)
                        ]),
                        //8 th.
                        Row(children: [
                          Container(width: textWidth2,child: Text('Currency',style: fontSize8WidthBold)),
                          collenStyle,
                          Text("INR",style: fontSize10)
                        ]),
                        //9 th
                        Row(children: [
                          Container(width: textWidth2,child: Text('Payment Amount',style: fontSize8WidthBold)),
                          collenStyle,
                          Text("${billList[0]["PaidAmount"]}",style: fontSize10)
                        ]),
                      ],
                    ),))
                ],
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text(
                '${billList[0]['SupplierName']??""}',
                style: fontSize8WidthBold
              ),
              Text(
                  '${billList[0]["PaidAmount"]}',
                  style: fontSize8WidthBold
              ),
            ]),
              SizedBox(height: 20),

              TableHelper.fromTextArray(headerStyle: fontSize9WithBold,cellStyle: fontSize10,
                headers: [
                  'Bill Number',
                  'Bill Date',
                  'Bill Amount',
                  'TDS Amount',
                  'Pay Amount'
                ],
                data:
                [
                  for(int i=0;i<billList.length;i++)

                  ['${billList[i]['JENumber']??""}',
                    billList[i]['InvoiceDate'] != null ? formatDate(billList[i]['InvoiceDate']) : "",
                    '${billList[i]['InvoiceAmount']??""}',
                    '${billList[i]["TdsAmount"]??""}',
                    '${billList[i]["PaidAmount"]??""}'
                  ],

                ],
              ),
              SizedBox(height: 20),
              //Amount In Words.
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'In Words: ${converter.convertAmountToWords(double.parse(billList[0]["PaidAmount"]), ignoreDecimal: false)}',
                        style: fontSize8WidthBold
                    ),
                    Text(
                        '${billList[0]["PaidAmount"]}',
                        style: fontSize8WidthBold
                    ),
                  ]),
              SizedBox(height: 20),
              //Prepared By.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Prepared By',style: fontSize10),
                  Text("",style: fontSize10),
                  Text('',style: fontSize10),
                  Text('',style: fontSize10),
                ],
              ),
              SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('',style: fontSize10),
                    Text('Received the amount shown above',style: fontSize10),
                    Text('Signature',style: fontSize10),
              ]),

            ],),
        )
      ],
    ),
  );

  // log('------pdf-------');
  // log(pdf.runtimeType.toString());

  // Return PDF as bytes.
  return pdf.save();
}




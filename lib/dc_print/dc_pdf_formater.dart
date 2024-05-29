import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:indian_currency_to_word/indian_currency_to_word.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';


///Both 161 541 Goods movement type.
Future<Uint8List> generatePdf161And541(List<dynamic> responseData1, List<dynamic> responseData2) async {
  print('-----Goods Type---');
  print(responseData2[0]['GoodsMovementType']);
  final converter = AmountToWords();

  ///Styles.
  // TextStyle blueGrey200 = const TextStyle(color: PdfColors.blueGrey300);
  //TextStyle fontSize9WithBold =  TextStyle(fontWeight: FontWeight.bold,fontSize: 9);
  TextStyle fontSize9 =const TextStyle(fontSize: 9);
  TextStyle fontSize8 =const TextStyle(fontSize: 8);
  TextStyle fontSize8WidthBold =TextStyle(fontWeight: FontWeight.bold,fontSize: 8,color: PdfColors.black);
  double value = 0.0;
  double totalValue = 0.0;
  double cGST =0.0;
  double sGST =0.0;
  double iGST = 0.0;
  double cGSTFinal =0.0;
  double sGSTFinal =0.0;
  double iGSTFinal = 0.0;
  double qty=0.0;
  double price=0.0;
  //double taxableAmount =0.0;
  double totalAmount =0.0;


  final pdf = Document();

  // Load the image from assets
  final image = MemoryImage(
    (await rootBundle.load('assets/logo/jmi_logo.png')).buffer.asUint8List(),
  );
  BorderSide borderStyle= const BorderSide(color: PdfColors.black,width: 0.5);
  String taxCodes='';

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

  String formatToTwoDecimal(double number) {
    // Convert the number to a string with two decimal places
    String formattedNumber = number.toStringAsFixed(2);

    // If the number is an integer, remove the ".00"
    if (formattedNumber.endsWith('.00')) {
      formattedNumber = formattedNumber.substring(0, formattedNumber.length - 3);
    }
    return formattedNumber;
  }


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
                left: borderStyle,
                top:borderStyle,
                right:borderStyle,
                bottom:borderStyle,
              ),
            ),
            child: Column(children: [
              //First.
              Container(
                decoration:  BoxDecoration(
                  border: Border(
                    //top:borderStyle,
                    bottom:borderStyle,
                  ),
                ),

                child:    Padding(padding: const EdgeInsets.only(top: 2,right: 10,bottom: 2),
                    child:Align(alignment: Alignment.topRight,
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    // borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),

                                Text("ORIGINAL",style: fontSize8),]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    // borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("DUPLICATE",style: fontSize8),
                              ]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    //borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("TRIPLICATE",style: fontSize8),
                              ]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    //borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("EXTRA",style: fontSize8)
                              ])
                            ])
                      // Text("ORIGINAL FOR RECIPIENT",style: fontSize8)
                    ) ),
              ),
              //Second.
              Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(image, width: 100, height: 100),
                    SizedBox(width: 70),
                    Column(children: [
                      SizedBox(height: 5),
                      Text('JM FRICTECH INDIA PVT. LTD',style: fontSize8WidthBold),
                      SizedBox(height: 5),
                      Text('${responseData1[0]['HouseNumber']??""},${responseData1[0]['StreetName']??""}',style: fontSize8),
                      SizedBox(height: 5),
                      Text("${responseData1[0]['CityName']??""}-${responseData1[0]['PostalCode']??""}",style: fontSize8),
                      SizedBox(height: 5),
                      Text('${responseData1[0]['RegionName']??""},India-Phone: +914471131343 / 344 ',style: fontSize8),
                      SizedBox(height: 5),
                      Text('GSTN No :${responseData1[0]['TaxNumber3']??""}',style: fontSize8),
                      SizedBox(height: 10),
                    ])
                  ]),
              //Third
              Container(
                decoration:  BoxDecoration(
                  border: Border(
                    top:borderStyle,
                    bottom:borderStyle,
                  ),
                ),
                child:   Align(alignment: Alignment.center,
                    child:  Padding(padding: const EdgeInsets.only(top: 5,bottom: 5),
                      //Displaying Different Static Text.
                      child:Text(responseData2[0]['GoodsMovementType']=='161'?"DELIVERY CHALLAN":
                                 responseData2[0]['GoodsMovementType']=='541'? "DELIVERY CHALLAN - JOB ORDER": "",style: fontSize8WidthBold)

                      //Text("DELIVERY CHALLAN- JOB ORDER",style: fontSize8WidthBold),
                    )
                ),
              ),
              //four
              Row(children: [
                Expanded(flex: 2,child:Container(
                    height: 120,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("To:",style: fontSize8),
                              Padding(padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['Supplier']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['SupplierFullName']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text("${responseData1[0]['StreetName_1']??""}",style:fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['PostalCode_1']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Row(children: [
                                          Text('GSTIN/UIN',style: fontSize8WidthBold),
                                          Text(" :",style: fontSize8WidthBold),
                                          Text('${responseData1[0]['TaxNumber3']??""}',style: fontSize8WidthBold),
                                        ])

                                      ])
                              )
                            ]) )
                ), ),
                Expanded(flex: 1,child:  Container(height: 120,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("DC  No.",style: fontSize8WidthBold),
                          ),

                          Divider(thickness: 0.5,color: PdfColors.black),

                          Padding(padding: const EdgeInsets.only(left: 5,),
                            child:  Text("DC Date",style: fontSize8WidthBold),
                          ),
                        ]) ),
                ),
                Expanded(flex: 1,child: Container(height: 120,
                    decoration:  BoxDecoration(
                      border: Border(
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("${responseData1[0]['MaterialDocument']??""}",style: fontSize9),
                          ),

                          Divider(thickness: 0.5,color: PdfColors.black),

                          Padding(padding: const EdgeInsets.only(left: 5,),
                            child:

                            Text(
                            responseData2[0]['GoodsMovementType']=='541'?  formatDate(responseData1[0]['DocumentDate']):
                            responseData2[0]['GoodsMovementType']=='161'? formatDate(responseData1[0]['DocumentDate_1']) : "",style: fontSize9),

                          ),
                        ])
                ),)

              ]),
              //five.
              Container( height: 30,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('Mode Of Transport',style: fontSize8WidthBold))),
                    Expanded(flex: 1,child: Text('${responseData2[0]['YY1_ModeOftransport2_MMI']??""}',style: fontSize8)),
                    Expanded(flex: 1,child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          Padding(padding: const EdgeInsets.only(left: 5),child: Text('DC Type',style: fontSize8WidthBold),),
                          SizedBox(width: 101),
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          //Padding(padding: EdgeInsets.only(left: 50),child: Container(height: 30,width: 0.5,color: PdfColors.black))
                        ])),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        //Displaying Two DC Type Text.
                        child:
                        Text(responseData2[0]['GoodsMovementType']=='161'?"Supplier Returns":
                        responseData2[0]['GoodsMovementType']=='541'? "Returnable": "",style: fontSize9)

                        //Text('Returnable',style: fontSize9)
                    ))
                  ])
              ),
              //six
              Container( height: 30,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('Vehicle No',style: fontSize8WidthBold))),

                    Expanded(flex: 1,child:
                    Text(responseData2[0]['GoodsMovementType']=='161'?"${responseData1[0]['MaterialDocumentHeaderText']??""}":
                    responseData2[0]['GoodsMovementType']=='541'? '${responseData2[0]['YY1_VehicleNo_MMI']??""}': "",style: fontSize9)

                    //Text('${responseData1[0]['MaterialDocumentHeaderText']??""}',style: fontSize9),

                    ),
                    Expanded(flex: 1,child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          Padding(padding: const EdgeInsets.only(left: 5),child: Text('Ref No',style: fontSize8WidthBold),),
                          SizedBox(width: 108),
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          // Padding(padding: EdgeInsets.only(left: 50),child: Container(height: 30,width: 0.5,color: PdfColors.black))
                        ])),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        //Previously Mapped PurchaseOrder Key To Ref No.
                        child:
                        Text(responseData2[0]['GoodsMovementType']=='161'?"${responseData1[0]['PurchaseOrder_1']??""}":
                        responseData2[0]['GoodsMovementType']=='541'? '${responseData1[0]['PurchaseOrder']??""}': "",style: fontSize9)

                        //Text('${responseData1[0]['PurchaseOrder']??""}',style:fontSize9)
                         )
                         )
                  ])
              ),

              //seven table header.
              Container(height: 25,
                  decoration:  BoxDecoration(
                    color: PdfColors.grey,
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Padding(padding: const EdgeInsets.only(left: 5),
                        child: Container(width: 25,child: Text('Sl.No',style: fontSize8WidthBold))
                    ),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('ITEM CODE',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 3,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('DESCRIPTION',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('HSN',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child:  Text('QTY',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('UOM',style: fontSize8WidthBold))),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child:  Text('TAX RATE',style: fontSize8WidthBold))),

                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),

                        //Displaying Two Different Table Header.
                        child:Center(child: Text(responseData2[0]['GoodsMovementType']=='161'?"UNIT PRICE":
                        responseData2[0]['GoodsMovementType']=='541'? "PRICE": "",style: fontSize8WidthBold)),

                        //Text('StandardPrice',style: fontSize8WidthBold)
                    )),

                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('VALUE',style: fontSize8WidthBold))),

                  ])
              ),
              for(int i=0;i<responseData1.length;i++)
              //Eight Table Dynamic Header.
                LayoutBuilder(
                  builder: (context, constraints) {
                    qty = double.parse(responseData1[i]['QuantityInEntryUnit']??"");

                    try{
                      //161 Movement Type.
                      if(responseData2[0]['GoodsMovementType']=='161'){
                         price = double.parse(responseData1[i]['NetPriceAmount']??"");
                         print('----------price----------');
                         print(responseData1[i]['NetPriceAmount']);
                      }
                      //541 Movement Type.
                      else if(responseData2[0]['GoodsMovementType']=='541'){
                        price = double.parse(responseData1[i]['StandardPrice']??"");
                        print('----------price----------');
                        print(responseData1[i]['NetPriceAmount']);
                      }

                    }
                    catch(e){
                      print('--------Exception---------');
                      print(e);
                    }


                    value = qty*price;

                    totalValue += value;

                    print('---------totalValue----------');
                    print(totalValue);
                    // if(responseData1[i]['StandardPrice']=="V")

                    if(responseData1[i]['TaxCode']=='V0'){
                      cGST = 0;
                      sGST = 0;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V1'){
                      cGST = 2.5;
                      sGST = 2.5;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V2'){
                      cGST = 6;
                      sGST = 6;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }

                    else if(responseData1[i]['TaxCode']=='V3'){
                      cGST = 9;
                      sGST = 9;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V4'){
                      cGST = 14;
                      sGST = 14;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V5'){
                      iGST = 5;

                      iGSTFinal = ((iGST/100)*totalValue);
                      totalAmount = iGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V6'){
                      iGST = 12;

                      iGSTFinal = ((iGST/100)*totalValue);
                      totalAmount = iGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V7'){
                      iGST = 18;

                      iGSTFinal = ((iGST/100)*totalValue);
                      totalAmount = iGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V8'){
                      iGST = 28;

                      iGSTFinal = ((iGST/100)*totalValue);
                      totalAmount = iGSTFinal+totalValue;
                    }
                    else{
                      totalAmount = totalValue;
                    }

                    // print('--------totalAmount---------');
                    // print(totalAmount);

                    //TaxCodes Filter.
                    if(responseData1[i]['TaxCode']=='V5' ||
                        responseData1[i]['TaxCode']=='V6' ||
                        responseData1[i]['TaxCode']=='V7'
                        || responseData1[i]['TaxCode']=='V8'){

                      taxCodes="TaxCodesV5V6V7V8";
                      print('----taxCodes----');
                      print(taxCodes);
                    }
                    else{
                      taxCodes="TaxCodesV0V1V2V3V4";
                      print('----taxCodes----');
                      print(taxCodes);
                    }
                    return Column(
                        children: [
                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                  // top:borderStyle,
                                  bottom:borderStyle,
                                ),
                              ),
                              child: Row(children: [
                                Padding(padding: const EdgeInsets.only(left: 5),
                                    child: Container(width: 25,child: Text('${i+1}',style: fontSize8))
                                ),

                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                                    child: Text('${responseData1[i]['Material']??""}',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 3,child: Padding(padding:const EdgeInsets.only(left: 5),
                                    child: Text("${responseData1[i]['ProductName']??""}",style: fontSize8)
                                  //Text('NB26061-LEVER-1 NOS',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Text("${responseData1[i]['ConsumptionTaxCtrlCode']??""}",style: fontSize8),
                                  //Text('90.24.1000',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding:const EdgeInsets.only(left: 5),
                                    child: Text('${responseData1[i]['QuantityInEntryUnit']??""}',style: fontSize8)
                                  //Text('NOS',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 5),
                                  child:  Text("${responseData1[i]['EntryUnit']??""}",style: fontSize8),
                                )),

                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 10),
                                  child:  Text(
                                      responseData1[i]['TaxCode']=='V0'? "0%":
                                      responseData1[i]['TaxCode']=='V1'? "5%":
                                      responseData1[i]['TaxCode']=='V2'? "12%":
                                      responseData1[i]['TaxCode']=='V3'? "18%":
                                      responseData1[i]['TaxCode']=='V4'? "28%":
                                      responseData1[i]['TaxCode']=='V5'? "5%":
                                      responseData1[i]['TaxCode']=='V6'? "12%":
                                      responseData1[i]['TaxCode']=='V7'? "18%": responseData1[i]['TaxCode']=='V8'? "28%":"",
                                      style: fontSize8),
                                  //Text('18 %',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Center(child: Text('${responseData1[i]['StandardPrice']??""}',style: fontSize8))),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Center(child: Text(value.toStringAsFixed(2),style: fontSize8))),

                              ])
                          ),
                        ]
                    );
                  },),

              Row(children: [
                Expanded(flex: 3,child:Container(
                    height: 100,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                    right:borderStyle,
                                    bottom: borderStyle
                                ),
                              ),
                              child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Row(children: [
                                    Text('Purpose of Transport',style: fontSize8WidthBold),
                                    Text(":"),
                                    Text("${responseData2[0]['YY1_PurposeofTransport_MMI']??""}",style: fontSize8WidthBold),

                                  ])
                              )),
                          SizedBox(height: 10),
                          Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Note',style: fontSize8WidthBold),
                                Text(":",style: fontSize8WidthBold),
                                Text('${responseData2[0]['YY1_Remarks_MMI']??""}',style: fontSize8WidthBold),

                              ])
                          )

                        ])
                ), ),
                Expanded(flex: 1,child:  Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 25,width: 120,
                            decoration:  BoxDecoration(
                              border: Border(
                                  bottom: borderStyle
                              ),
                            ),
                            child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                              child: Text("Taxable Amount",style: fontSize8WidthBold),
                              //Text("200.00",style: fontSize8WidthBold),
                            ),),

                          ///CGST And SGST Header.
                          Builder(
                            builder: ( context) {
                              // print('------------------');
                              // print(taxCodes);
                              if( taxCodes=="TaxCodesV0V1V2V3V4"){
                                return Column(children: [
                                  //CGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                      child: Builder(
                                        builder: ( context) {
                                          return   Text("CGST $cGST%",style: fontSize8WidthBold);
                                        },
                                      ),

                                      //Text("200.00",style: fontSize8WidthBold),
                                    ),),
                                  //SGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                      child: Builder(
                                        builder: ( context) {
                                          return    Text("SGST $sGST%",style: fontSize8WidthBold);
                                        },
                                      ),
                                    ),),
                                ]);
                              }
                              else{
                                return Column(
                                    children: [
                                      //IGST.
                                      Container(height: 25,width: 120,
                                        decoration:  BoxDecoration(
                                          border: Border(
                                              bottom: borderStyle
                                          ),
                                        ),
                                        child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                          child: Builder(
                                            builder: ( context) {
                                              return   Text("IGST $iGST%",style: fontSize8WidthBold);
                                            },
                                          ),

                                          //Text("200.00",style: fontSize8WidthBold),
                                        ),),
                                    ]);
                              }
                            },
                          ),


                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("Total Amount",style: fontSize8WidthBold),
                          ),

                        ]) ),
                ),
                Expanded(flex: 1,child: Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 25,width: 120,
                              decoration:  BoxDecoration(
                                border: Border(
                                    bottom: borderStyle
                                ),
                              ),
                              child:   Align(alignment: Alignment.topRight,
                                child:Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                  child:
                                  Builder(
                                    builder: ( context) {
                                      return Text(
                                        formatToTwoDecimal(totalValue),
                                        //newvalue.toStringAsFixed(2),
                                        style:fontSize8,
                                      );
                                    },
                                  ),
                                ), )
                          ),
                          ///CGST AND SGST Values.
                          Builder(
                            builder: ( context) {
                              // print('------------------');
                              // print(taxCodes);
                              if( taxCodes=="TaxCodesV0V1V2V3V4"){
                                return Column(children: [
                                  //CGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Align(alignment: Alignment.topRight,
                                      child: Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                        child:
                                        Builder(
                                          builder: ( context) {
                                            return Text(
                                              formatToTwoDecimal(cGSTFinal),
                                              //cGSTFinal.toString(),
                                              style:fontSize8,
                                            );
                                          },
                                        ),
                                      ),),),
                                  //SGST.
                                  Container(height: 25,width: 120,
                                      decoration:  BoxDecoration(
                                        border: Border(
                                            bottom: borderStyle
                                        ),
                                      ),
                                      child:  Align(alignment: Alignment.topRight,
                                        child:  Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                          child:
                                          Builder(
                                            builder: ( context) {
                                              return Text(
                                                formatToTwoDecimal(sGSTFinal),
                                                //sGSTFinal.toString(),
                                                style:fontSize8,
                                              );
                                            },
                                          ),
                                        ),)),
                                ]);
                              }
                              else{
                                return Column(
                                    children: [
                                      //IGST.
                                      Container(height: 25,width: 120,
                                        decoration:  BoxDecoration(
                                          border: Border(
                                              bottom: borderStyle
                                          ),
                                        ),
                                        child:   Align(alignment: Alignment.topRight,
                                          child: Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                            child:
                                            Builder(
                                              builder: ( context) {
                                                return Text(
                                                  formatToTwoDecimal(iGSTFinal),
                                                  //cGSTFinal.toString(),
                                                  style:fontSize8,
                                                );
                                              },
                                            ),
                                          ),),),
                                    ]);
                              }
                            },
                          ),


                          Align(alignment: Alignment.topRight,
                            child:  Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                              child:
                              Builder(
                                builder: ( context) {
                                  return Text(
                                    formatToTwoDecimal(totalAmount),
                                    //totalAmount.toString(),
                                    style:fontSize8,
                                  );
                                },
                              ),

                            ),)
                        ])
                ),)

              ]),
              ///Total CGST And SGST Values.
              Builder(
                builder: ( context) {
                  // print('------------------');
                  // print(taxCodes);
                  if( taxCodes=="TaxCodesV0V1V2V3V4"){
                    return Column(children: [
                      //CGST Total.
                      Container(height: 25,
                          decoration:  BoxDecoration(
                            border: Border(
                              // top:borderStyle,
                              bottom:borderStyle,
                            ),
                          ),
                          child: Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Total CGST value Payable (in words)',style: fontSize8WidthBold),
                                Text(" :",style: fontSize8WidthBold),
                                Builder(
                                  builder: ( context) {
                                    return Text(
                                      //' Rs. ${convertToText(cGSTFinal)}',
                                      converter.convertAmountToWords(cGSTFinal, ignoreDecimal: false),

                                      // '',
                                      style:fontSize8,
                                    );
                                  },
                                ),
                              ])
                          )
                      ),
                      //SGST Total.
                      Container(height: 25,
                          decoration:  BoxDecoration(
                            border: Border(
                              // top:borderStyle,
                              bottom:borderStyle,
                            ),
                          ),
                          child: Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Total SGST value Payable (in words)',style: fontSize8WidthBold),
                                Text(" :",style: fontSize8WidthBold),
                                Builder(
                                  builder: ( context) {
                                    return Text(
                                      // ' Rs. ${convertToText(sGSTFinal)}',

                                      converter.convertAmountToWords(sGSTFinal, ignoreDecimal: false),
                                      // '',

                                      style:fontSize8,
                                    );
                                  },
                                ),

                              ])
                          )
                      ),
                    ]);
                  }
                  else{
                    return Column(
                        children: [
                          //IGST Total.
                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                  // top:borderStyle,
                                  bottom:borderStyle,
                                ),
                              ),
                              child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Row(children: [
                                    Text('Total IGST value Payable (in words)',style: fontSize8WidthBold),
                                    Text(" :",style: fontSize8WidthBold),
                                    Builder(
                                      builder: ( context) {
                                        return Text(
                                          // ' Rs. ${convertToText(sGSTFinal)}',

                                          converter.convertAmountToWords(iGSTFinal, ignoreDecimal: true),
                                          // '',

                                          style:fontSize8,
                                        );
                                      },
                                    ),

                                  ])
                              )
                          ),
                        ]);
                  }
                },
              ),


              Container(height: 25,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 5),
                      child: Row(children: [
                        Text('Total Amount (in Words) ',style: fontSize8WidthBold),
                        Text(" :",style: fontSize8WidthBold),
                        Builder(
                          builder: ( context) {
                            return Text(
                              // ' Rs. ${convertToText(totalAmount)}',
                              converter.convertAmountToWords(totalAmount, ignoreDecimal: false),
                              //'',

                              style:fontSize8,
                            );
                          },
                        ),
                      ])
                  )
              ),

              ///Special Instructions Container.
              // Container(height: 25,
              //     decoration:  BoxDecoration(
              //       border: Border(
              //         // top:borderStyle,
              //         bottom:borderStyle,
              //       ),
              //     ),
              //     child: Padding(padding: const EdgeInsets.only(left: 5),
              //         child: Row(
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text('Special Instruction',style: fontSize8WidthBold),
              //                   SizedBox(height: 5),
              //                   Text(' Kindly return the parts with above mentioned time period with proper Document and mentioned our DC number in your dispatch document',style: fontSize8)
              //                 ])
              //           ]
              //         )
              //     )
              // ),
              Container(height: 25,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 5,right: 150),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Text('Requested By',style: fontSize8WidthBold),
                              Text(" :",style: fontSize8WidthBold),
                              Text('${responseData2[0]['YY1_RequestedBy1_MMI']??""}',style: fontSize8),

                            ]),
                            Row(children: [
                              Text('Prepared By',style: fontSize8WidthBold),
                              Text(" :",style: fontSize8WidthBold),
                              Text('${responseData2[0]['YY1_PreparedBy1_MMI']??""}',style: fontSize8),

                            ])
                          ])
                  )
              ),
              ///Remarks Container.
              // Container(height: 25,
              //     decoration:  BoxDecoration(
              //       border: Border(
              //         // top:borderStyle,
              //         bottom:borderStyle,
              //       ),
              //     ),
              //     child: Padding(padding: const EdgeInsets.only(left: 5),
              //         child: Row(children: [
              //           Text('Remarks',style: fontSize8WidthBold),
              //           Text(" :",style: fontSize8WidthBold),
              //           Text('${responseData2[0]['YY1_Remarks_MMI']??""}',style: fontSize8)
              //         ])
              //     )
              // ),

              Row(children: [
                Expanded(flex: 2,child:Container(
                    height: 100,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Received the above goods in good condition",style: fontSize8),
                              Padding(padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 60),
                                        Text('Receiver Signature With Seal',style: fontSize8),
                                      ])
                              )
                            ]) )
                ), ),
                Expanded(flex: 3,child:  Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("For",style: fontSize8),
                                SizedBox(width: 5),
                                Text("JM FRICTECH INDIA PVT. LTD",style: fontSize8WidthBold),
                                SizedBox(width: 5),
                              ]),
                          SizedBox(height: 60),
                          Padding(padding: const EdgeInsets.only(left: 5,right: 5,
                          ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Prepared By ",style: fontSize8),
                                    Text("Authorised Signatory",style: fontSize8),
                                  ])
                          )

                        ]) ),
                ),


              ]),
              Container(
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Align(alignment: Alignment.bottomRight,child: Padding(padding: const EdgeInsets.only(right: 5),
                      child: Text("Page No: 1",style: fontSize8)))
              )

            ])
        )
      ],
    ),
  );

  log('------pdf-------');
  log(pdf.runtimeType.toString());

  // Return PDF as bytes.
  return pdf.save();
}

///Delivery Note Pdf (OLD ONE). 161.
Future<Uint8List> generatePdfDeliveryNote161(List<dynamic> responseData1, List<dynamic> responseData2) async {
  print('-----Goods Type---');
  print(responseData2[0]['GoodsMovementType']);
  final converter = AmountToWords();

  ///Styles.
  // TextStyle blueGrey200 = const TextStyle(color: PdfColors.blueGrey300);
  //TextStyle fontSize9WithBold =  TextStyle(fontWeight: FontWeight.bold,fontSize: 9);
  TextStyle fontSize9 =const TextStyle(fontSize: 9);
  TextStyle fontSize8 =const TextStyle(fontSize: 8);
  TextStyle fontSize8WidthBold =TextStyle(fontWeight: FontWeight.bold,fontSize: 8,color: PdfColors.black);
  double value = 0.0;
  double totalValue = 0.0;
  double cGST =0.0;
  double sGST =0.0;
  double iGST = 0.0;
  double cGSTFinal =0.0;
  double sGSTFinal =0.0;
  double iGSTFinal = 0.0;
  //double taxableAmount =0.0;
  double totalAmount =0.0;


  final pdf = Document();

  // Load the image from assets
  final image = MemoryImage(
    (await rootBundle.load('assets/logo/jmi_logo.png')).buffer.asUint8List(),
  );
  BorderSide borderStyle= const BorderSide(color: PdfColors.black,width: 0.5);
  String taxCodes='';

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

  String formatToTwoDecimal(double number) {
    // Convert the number to a string with two decimal places
    String formattedNumber = number.toStringAsFixed(2);

    // If the number is an integer, remove the ".00"
    if (formattedNumber.endsWith('.00')) {
      formattedNumber = formattedNumber.substring(0, formattedNumber.length - 3);
    }
    return formattedNumber;
  }


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
                left: borderStyle,
                top:borderStyle,
                right:borderStyle,
                bottom:borderStyle,
              ),
            ),
            child: Column(children: [
              //First.
              Container(
                decoration:  BoxDecoration(
                  border: Border(
                    //top:borderStyle,
                    bottom:borderStyle,
                  ),
                ),

                child:    Padding(padding: const EdgeInsets.only(top: 2,right: 10,bottom: 2),
                    child:Align(alignment: Alignment.topRight,
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    // borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),

                                Text("ORIGINAL",style: fontSize8),]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    // borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("DUPLICATE",style: fontSize8),
                              ]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    //borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("TRIPLICATE",style: fontSize8),
                              ]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    //borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("EXTRA",style: fontSize8)
                              ])
                            ])
                      // Text("ORIGINAL FOR RECIPIENT",style: fontSize8)
                    ) ),
              ),
              //Second.
              Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(image, width: 100, height: 100),
                    SizedBox(width: 70),
                    Column(children: [
                      SizedBox(height: 5),
                      Text('JM FRICTECH INDIA PVT. LTD',style: fontSize8WidthBold),
                      SizedBox(height: 5),
                      Text('${responseData1[0]['HouseNumber']??""},${responseData1[0]['StreetName_1']??""}',style: fontSize8),
                      SizedBox(height: 5),
                      Text("${responseData1[0]['CityName_1']??""}-${responseData1[0]['PostalCode_1']??""}",style: fontSize8),
                      SizedBox(height: 5),
                      Text('${responseData1[0]['RegionName']??""},India-Phone: +914471131343 / 344 ',style: fontSize8),
                      SizedBox(height: 5),
                      Text('GSTN No :${responseData1[0]['TaxNumber3']??""}',style: fontSize8),
                      SizedBox(height: 10),
                    ])
                  ]),
              //Third
              Container(
                decoration:  BoxDecoration(
                  border: Border(
                    top:borderStyle,
                    bottom:borderStyle,
                  ),
                ),
                child:   Align(alignment: Alignment.center,
                    child:  Padding(padding: const EdgeInsets.only(top: 5,bottom: 5),
                      child: Text("DELIVERY CHALLAN",style: fontSize8WidthBold),)
                ),
              ),
              //four
              Row(children: [
                Expanded(flex: 2,child:Container(
                    height: 120,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("To:",style: fontSize8),
                              Padding(padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['Supplier']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['SupplierFullName']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['StreetName']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['CityName']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['PostalCode']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Row(children: [
                                          Text('GSTIN/UIN',style: fontSize8WidthBold),
                                          Text(" :",style: fontSize8WidthBold),
                                          Text('${responseData1[0]['TaxNumber3']??""}',style: fontSize8WidthBold),
                                        ])

                                      ])
                              )
                            ]) )
                ), ),
                Expanded(flex: 1,child:  Container(height: 120,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("DC  No.",style: fontSize8WidthBold),
                          ),

                          Divider(thickness: 0.5,color: PdfColors.black),

                          Padding(padding: const EdgeInsets.only(left: 5,),
                            child:  Text("DC Date",style: fontSize8WidthBold),
                          ),
                        ]) ),
                ),
                Expanded(flex: 1,child: Container(height: 120,
                    decoration:  BoxDecoration(
                      border: Border(
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("${responseData1[0]['MaterialDocument']??""}",style: fontSize9),
                          ),

                          Divider(thickness: 0.5,color: PdfColors.black),

                          Padding(padding: const EdgeInsets.only(left: 5,),
                            child:  Text(responseData1[0]['DocumentDate_1'] != null ? formatDate(responseData1[0]['DocumentDate_1']) : "",style: fontSize9),
                          ),
                        ])
                ),)

              ]),
              //five.
              Container( height: 30,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('Mode Of Transport',style: fontSize8WidthBold))),
                    Expanded(flex: 1,child: Text('${responseData2[0]['YY1_ModeOftransport2_MMI']??""}',style: fontSize8)),
                    Expanded(flex: 1,child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          Padding(padding: const EdgeInsets.only(left: 5),child: Text('DC Type',style: fontSize8WidthBold),),
                          SizedBox(width: 101),
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          //Padding(padding: EdgeInsets.only(left: 50),child: Container(height: 30,width: 0.5,color: PdfColors.black))
                        ])),
                    //GMT 161.
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child:Text('Supplier Returns',style: fontSize9)
                      //Text('NON-RETURNABLE',style: fontSize8)
                    ))
                  ])
              ),
              //six
              Container( height: 30,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('Vehicle No',style: fontSize8WidthBold))),
                    //GMT 161.
                    Expanded(flex: 1,child: Text('${responseData1[0]['MaterialDocumentHeaderText']??""}',style: fontSize9)),
                    Expanded(flex: 1,child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          Padding(padding: const EdgeInsets.only(left: 5),child: Text('Ref No',style: fontSize8WidthBold),),
                          SizedBox(width: 108),
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          // Padding(padding: EdgeInsets.only(left: 50),child: Container(height: 30,width: 0.5,color: PdfColors.black))
                        ])),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),child: Text('${responseData1[0]['PurchaseOrder']??""}',style:fontSize9)))
                  ])
              ),
              //seven table header.
              Container(height: 25,
                  decoration:  BoxDecoration(
                    color: PdfColors.grey,
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Padding(padding: const EdgeInsets.only(left: 5),
                        child: Container(width: 35,child: Text('Sl.No',style: fontSize8WidthBold))
                    ),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('ITEM CODE',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 3,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('DESCRIPTION',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('HSN',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child:  Text('QTY',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('UOM',style: fontSize8WidthBold))),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child:  Text('TAX RATE',style: fontSize8WidthBold))),

                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child:  Text('UNIT PRICE',style: fontSize8WidthBold))),

                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('VALUE',style: fontSize8WidthBold))),

                  ])
              ),
              for(int i=0;i<responseData1.length;i++)
              //Eight Dynamic Header.
                LayoutBuilder(
                  builder: (context, constraints) {

                    double qty = double.parse(responseData1[i]['QuantityInEntryUnit']??"");
                    double price= double.parse(responseData1[i]['NetPriceAmount']??"");


                    value = qty*price;

                    totalValue += value;

                    // print('---------value----------');
                    // print(newvalue);
                    // if(responseData1[i]['NetPriceAmount']=="V")

                    if(responseData1[i]['TaxCode']=='V0'){
                      cGST = 0;
                      sGST = 0;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V1'){
                      cGST = 2.5;
                      sGST = 2.5;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V2'){
                      cGST = 6;
                      sGST = 6;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }

                    else if(responseData1[i]['TaxCode']=='V3'){
                      cGST = 9;
                      sGST = 9;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V4'){
                      cGST = 14;
                      sGST = 14;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V5'){
                      iGST = 5;

                      iGSTFinal = ((iGST/100)*totalValue);
                      totalAmount = iGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V6'){
                      iGST = 12;

                      iGSTFinal = ((iGST/100)*totalValue);
                      totalAmount = iGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V7'){
                      iGST = 18;

                      iGSTFinal = ((iGST/100)*totalValue);
                      totalAmount = iGSTFinal+totalValue;
                    }
                    else if(responseData1[i]['TaxCode']=='V8'){
                      iGST = 28;

                      iGSTFinal = ((iGST/100)*totalValue);
                      totalAmount = iGSTFinal+totalValue;
                    }

                    //TaxCodes Filter.
                    if(responseData1[i]['TaxCode']=='V5' ||
                        responseData1[i]['TaxCode']=='V6' ||
                        responseData1[i]['TaxCode']=='V7'
                        || responseData1[i]['TaxCode']=='V8'){

                      taxCodes="TaxCodesV5V6V7V8";
                      print('----taxCodes----');
                      print(taxCodes);
                    }
                    else{
                      taxCodes="TaxCodesV1V2V3V4";
                      print('----taxCodes----');
                      print(taxCodes);
                    }
                    return Column(
                        children: [
                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                  // top:borderStyle,
                                  bottom:borderStyle,
                                ),
                              ),
                              child: Row(children: [
                                Padding(padding: const EdgeInsets.only(left: 5),
                                    child: Container(width: 35,child: Text('${i+1}',style: fontSize8))
                                ),

                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                                    child: Text('${responseData1[i]['Material']??""}',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 3,child: Padding(padding:const EdgeInsets.only(left: 5),
                                    child: Text("${responseData1[i]['ProductName']??""}",style: fontSize8)
                                  //Text('NB26061-LEVER-1 NOS',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Text("${responseData1[i]['ConsumptionTaxCtrlCode']??""}",style: fontSize8),
                                  //Text('90.24.1000',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding:const EdgeInsets.only(left: 5),
                                    child: Text('${responseData1[i]['QuantityInEntryUnit']??""}',style: fontSize8)
                                  //Text('NOS',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 5),
                                  child:  Text("${responseData1[i]['EntryUnit']??""}",style: fontSize8),
                                )),

                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 10),
                                  child:  Text(
                                      responseData1[i]['TaxCode']=='V0'? "0%":
                                      responseData1[i]['TaxCode']=='V1'? "5%":
                                      responseData1[i]['TaxCode']=='V2'? "12%":
                                      responseData1[i]['TaxCode']=='V3'? "18%":
                                      responseData1[i]['TaxCode']=='V4'? "28%":
                                      responseData1[i]['TaxCode']=='V5'? "5%":
                                      responseData1[i]['TaxCode']=='V6'? "12%":
                                      responseData1[i]['TaxCode']=='V7'? "18%": responseData1[i]['TaxCode']=='V8'? "28%":"",
                                      style: fontSize8),
                                  //Text('18 %',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Center(child: Text('${responseData1[i]['NetPriceAmount']??""}',style: fontSize8))),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Center(child: Text(value.toStringAsFixed(2),style: fontSize8))),

                              ])
                          ),
                        ]
                    );
                  },),

              Row(children: [
                Expanded(flex: 3,child:Container(
                    height: 100,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                    right:borderStyle,
                                    bottom: borderStyle
                                ),
                              ),
                              child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Row(children: [
                                    Text('Purpose of Transport',style: fontSize8WidthBold),
                                    Text(":"),
                                    Text("${responseData2[0]['YY1_PurposeofTransport_MMI']??""}",style: fontSize8WidthBold),

                                  ])
                              )),
                          SizedBox(height: 10),
                          Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Note',style: fontSize8WidthBold),
                                Text(":",style: fontSize8WidthBold),
                                Text('${responseData2[0]['YY1_Remarks_MMI']??""}',style: fontSize8WidthBold),

                              ])
                          )

                        ])
                ), ),
                Expanded(flex: 1,child:  Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 25,width: 120,
                            decoration:  BoxDecoration(
                              border: Border(
                                  bottom: borderStyle
                              ),
                            ),
                            child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                              child: Text("Taxable Amount",style: fontSize8WidthBold),
                              //Text("200.00",style: fontSize8WidthBold),
                            ),),

                          ///CGST And SGST Header.
                          Builder(
                            builder: ( context) {
                              // print('------------------');
                              // print(taxCodes);
                              if( taxCodes=="TaxCodesV1V2V3V4"){
                                return Column(children: [
                                  //CGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                      child: Builder(
                                        builder: ( context) {
                                          return   Text("CGST $cGST%",style: fontSize8WidthBold);
                                        },
                                      ),

                                      //Text("200.00",style: fontSize8WidthBold),
                                    ),),
                                  //SGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                      child: Builder(
                                        builder: ( context) {
                                          return    Text("SGST $sGST%",style: fontSize8WidthBold);
                                        },
                                      ),
                                    ),),
                                ]);
                              }
                              else{
                                return Column(
                                    children: [
                                      //IGST.
                                      Container(height: 25,width: 120,
                                        decoration:  BoxDecoration(
                                          border: Border(
                                              bottom: borderStyle
                                          ),
                                        ),
                                        child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                          child: Builder(
                                            builder: ( context) {
                                              return   Text("IGST $iGST%",style: fontSize8WidthBold);
                                            },
                                          ),

                                          //Text("200.00",style: fontSize8WidthBold),
                                        ),),
                                    ]);
                              }
                            },
                          ),


                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("Total Amount",style: fontSize8WidthBold),
                          ),

                        ]) ),
                ),
                Expanded(flex: 1,child: Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 25,width: 120,
                              decoration:  BoxDecoration(
                                border: Border(
                                    bottom: borderStyle
                                ),
                              ),
                              child:   Align(alignment: Alignment.topRight,
                                child:Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                  child:
                                  Builder(
                                    builder: ( context) {
                                      return Text(
                                        formatToTwoDecimal(totalValue),
                                        //newvalue.toStringAsFixed(2),
                                        style:fontSize8,
                                      );
                                    },
                                  ),
                                ), )
                          ),
                          ///CGST AND SGST Values.
                          Builder(
                            builder: ( context) {
                              // print('------------------');
                              // print(taxCodes);
                              if( taxCodes=="TaxCodesV1V2V3V4"){
                                return Column(children: [
                                  //CGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Align(alignment: Alignment.topRight,
                                      child: Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                        child:
                                        Builder(
                                          builder: ( context) {
                                            return Text(
                                              formatToTwoDecimal(cGSTFinal),
                                              //cGSTFinal.toString(),
                                              style:fontSize8,
                                            );
                                          },
                                        ),
                                      ),),),
                                  //SGST.
                                  Container(height: 25,width: 120,
                                      decoration:  BoxDecoration(
                                        border: Border(
                                            bottom: borderStyle
                                        ),
                                      ),
                                      child:  Align(alignment: Alignment.topRight,
                                        child:  Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                          child:
                                          Builder(
                                            builder: ( context) {
                                              return Text(
                                                formatToTwoDecimal(sGSTFinal),
                                                //sGSTFinal.toString(),
                                                style:fontSize8,
                                              );
                                            },
                                          ),
                                        ),)),
                                ]);
                              }
                              else{
                                return Column(
                                    children: [
                                      //IGST.
                                      Container(height: 25,width: 120,
                                        decoration:  BoxDecoration(
                                          border: Border(
                                              bottom: borderStyle
                                          ),
                                        ),
                                        child:   Align(alignment: Alignment.topRight,
                                          child: Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                            child:
                                            Builder(
                                              builder: ( context) {
                                                return Text(
                                                  formatToTwoDecimal(iGSTFinal),
                                                  //cGSTFinal.toString(),
                                                  style:fontSize8,
                                                );
                                              },
                                            ),
                                          ),),),
                                    ]);
                              }
                            },
                          ),


                          Align(alignment: Alignment.topRight,
                            child:  Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                              child:
                              Builder(
                                builder: ( context) {
                                  return Text(
                                    formatToTwoDecimal(totalAmount),
                                    //totalAmount.toString(),
                                    style:fontSize8,
                                  );
                                },
                              ),

                            ),)
                        ])
                ),)

              ]),
              ///Total CGST And SGST Values.
              Builder(
                builder: ( context) {
                  // print('------------------');
                  // print(taxCodes);
                  if( taxCodes=="TaxCodesV1V2V3V4"){
                    return Column(children: [
                      //CGST Total.
                      Container(height: 25,
                          decoration:  BoxDecoration(
                            border: Border(
                              // top:borderStyle,
                              bottom:borderStyle,
                            ),
                          ),
                          child: Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Total CGST value Payable (in words)',style: fontSize8WidthBold),
                                Text(" :",style: fontSize8WidthBold),
                                Builder(
                                  builder: ( context) {
                                    return Text(
                                      //' Rs. ${convertToText(cGSTFinal)}',
                                      converter.convertAmountToWords(cGSTFinal, ignoreDecimal: false),

                                      // '',
                                      style:fontSize8,
                                    );
                                  },
                                ),
                              ])
                          )
                      ),
                      //SGST Total.
                      Container(height: 25,
                          decoration:  BoxDecoration(
                            border: Border(
                              // top:borderStyle,
                              bottom:borderStyle,
                            ),
                          ),
                          child: Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Total SGST value Payable (in words)',style: fontSize8WidthBold),
                                Text(" :",style: fontSize8WidthBold),
                                Builder(
                                  builder: ( context) {
                                    return Text(
                                      // ' Rs. ${convertToText(sGSTFinal)}',

                                      converter.convertAmountToWords(sGSTFinal, ignoreDecimal: false),
                                      // '',

                                      style:fontSize8,
                                    );
                                  },
                                ),

                              ])
                          )
                      ),
                    ]);
                  }
                  else{
                    return Column(
                        children: [
                          //IGST Total.
                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                  // top:borderStyle,
                                  bottom:borderStyle,
                                ),
                              ),
                              child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Row(children: [
                                    Text('Total IGST value Payable (in words)',style: fontSize8WidthBold),
                                    Text(" :",style: fontSize8WidthBold),
                                    Builder(
                                      builder: ( context) {
                                        return Text(
                                          // ' Rs. ${convertToText(sGSTFinal)}',

                                          converter.convertAmountToWords(iGSTFinal, ignoreDecimal: false),
                                          // '',

                                          style:fontSize8,
                                        );
                                      },
                                    ),

                                  ])
                              )
                          ),
                        ]);
                  }
                },
              ),

              //Total Amount In words.
              Container(height: 25,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 5),
                      child: Row(children: [
                        Text('Total Amount (in Words) ',style: fontSize8WidthBold),
                        Text(" :",style: fontSize8WidthBold),
                        Builder(
                          builder: ( context) {
                            return Text(
                              // ' Rs. ${convertToText(totalAmount)}',
                              converter.convertAmountToWords(totalAmount, ignoreDecimal: false),
                              //'',

                              style:fontSize8,
                            );
                          },
                        ),
                      ])
                  )
              ),

              ///Special Instructions Container.
              // Container(height: 25,
              //     decoration:  BoxDecoration(
              //       border: Border(
              //         // top:borderStyle,
              //         bottom:borderStyle,
              //       ),
              //     ),
              //     child: Padding(padding: const EdgeInsets.only(left: 5),
              //         child: Row(
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text('Special Instruction',style: fontSize8WidthBold),
              //                   SizedBox(height: 5),
              //                   Text(' Kindly return the parts with above mentioned time period with proper Document and mentioned our DC number in your dispatch document',style: fontSize8)
              //                 ])
              //           ]
              //         )
              //     )
              // ),
              Container(height: 25,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 5,right: 150),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Text('Requested By',style: fontSize8WidthBold),
                              Text(" :",style: fontSize8WidthBold),
                              Text('${responseData2[0]['YY1_RequestedBy1_MMI']??""}',style: fontSize8),

                            ]),
                            Row(children: [
                              Text('Prepared By',style: fontSize8WidthBold),
                              Text(" :",style: fontSize8WidthBold),
                              Text('${responseData2[0]['YY1_PreparedBy1_MMI']??""}',style: fontSize8),

                            ])
                          ])
                  )
              ),
              ///Remarks Container.
              // Container(height: 25,
              //     decoration:  BoxDecoration(
              //       border: Border(
              //         // top:borderStyle,
              //         bottom:borderStyle,
              //       ),
              //     ),
              //     child: Padding(padding: const EdgeInsets.only(left: 5),
              //         child: Row(children: [
              //           Text('Remarks',style: fontSize8WidthBold),
              //           Text(" :",style: fontSize8WidthBold),
              //           Text('${responseData2[0]['YY1_Remarks_MMI']??""}',style: fontSize8)
              //         ])
              //     )
              // ),

              Row(children: [
                Expanded(flex: 2,child:Container(
                    height: 100,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Received the above goods in good condition",style: fontSize8),
                              Padding(padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 60),
                                        Text('Receiver Signature With Seal',style: fontSize8),
                                      ])
                              )
                            ]) )
                ), ),
                Expanded(flex: 3,child:  Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("For",style: fontSize8),
                                SizedBox(width: 5),
                                Text("JM FRICTECH INDIA PVT. LTD",style: fontSize8WidthBold),
                                SizedBox(width: 5),
                              ]),
                          SizedBox(height: 60),
                          Padding(padding: const EdgeInsets.only(left: 5,right: 5,
                          ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Prepared By ",style: fontSize8),
                                    Text("Authorised Signatory",style: fontSize8),
                                  ])
                          )

                        ]) ),
                ),


              ]),
              Container(
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Align(alignment: Alignment.bottomRight,child: Padding(padding: const EdgeInsets.only(right: 5),
                      child: Text("Page No: 1",style: fontSize8)))
              )

            ])
        )
      ],
    ),
  );

  log('------pdf-------');
  log(pdf.runtimeType.toString());

  // Return PDF as bytes.
  return pdf.save();
}

///Delivery GoodsType 541.
Future<Uint8List> generatePdfDeliveryNote541(List<dynamic> responseData1, List<dynamic> responseData2) async {

  print('-----Goods Type---');
  print(responseData2[0]['GoodsMovementType']);
  final converter = AmountToWords();

  ///Styles.
  // TextStyle blueGrey200 = const TextStyle(color: PdfColors.blueGrey300);
  //TextStyle fontSize9WithBold =  TextStyle(fontWeight: FontWeight.bold,fontSize: 9);
  TextStyle fontSize9 =const TextStyle(fontSize: 9);
  TextStyle fontSize8 =const TextStyle(fontSize: 8);
  TextStyle fontSize8WidthBold =TextStyle(fontWeight: FontWeight.bold,fontSize: 8,color: PdfColors.black);
  double value = 0.0;
  double totalValue = 0.0;
  double cGST =0.0;
  double sGST =0.0;
  double iGST = 0.0;
  double cGSTFinal =0.0;
  double sGSTFinal =0.0;
  double iGSTFinal = 0.0;
  //double taxableAmount =0.0;
  double totalAmount =0.0;


  final pdf = Document();

  // Load the image from assets
  final image = MemoryImage(
    (await rootBundle.load('assets/logo/jmi_logo.png')).buffer.asUint8List(),
  );
  BorderSide borderStyle= const BorderSide(color: PdfColors.black,width: 0.5);
  String taxCodes='';

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

  String formatToTwoDecimal(double number) {
    // Convert the number to a string with two decimal places
    String formattedNumber = number.toStringAsFixed(2);

    // If the number is an integer, remove the ".00"
    if (formattedNumber.endsWith('.00')) {
      formattedNumber = formattedNumber.substring(0, formattedNumber.length - 3);
    }
    return formattedNumber;
  }


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
                left: borderStyle,
                top:borderStyle,
                right:borderStyle,
                bottom:borderStyle,
              ),
            ),
            child: Column(children: [
              //First.
              Container(
                decoration:  BoxDecoration(
                  border: Border(
                    //top:borderStyle,
                    bottom:borderStyle,
                  ),
                ),

                child:    Padding(padding: const EdgeInsets.only(top: 2,right: 10,bottom: 2),
                    child:Align(alignment: Alignment.topRight,
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    // borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),

                                Text("ORIGINAL",style: fontSize8),]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    // borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("DUPLICATE",style: fontSize8),
                              ]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    //borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("TRIPLICATE",style: fontSize8),
                              ]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    //borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("EXTRA",style: fontSize8)
                              ])
                            ])
                      // Text("ORIGINAL FOR RECIPIENT",style: fontSize8)
                    ) ),
              ),
              //Second.
              Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(image, width: 100, height: 100),
                    SizedBox(width: 70),
                    Column(children: [
                      SizedBox(height: 5),
                      Text('JM FRICTECH INDIA PVT. LTD',style: fontSize8WidthBold),
                      SizedBox(height: 5),
                      Text('${responseData1[0]['HouseNumber']??""},${responseData1[0]['StreetName']??""}',style: fontSize8),
                      SizedBox(height: 5),
                      Text("${responseData1[0]['CityName']??""}-${responseData1[0]['PostalCode']??""}",style: fontSize8),
                      SizedBox(height: 5),
                      Text('${responseData1[0]['RegionName']??""},India-Phone: +914471131343 / 344 ',style: fontSize8),
                      SizedBox(height: 5),
                      Text('GSTN No :${responseData1[0]['TaxNumber3']??""}',style: fontSize8),
                      SizedBox(height: 10),
                    ])
                  ]),
              //Third
              Container(
                decoration:  BoxDecoration(
                  border: Border(
                    top:borderStyle,
                    bottom:borderStyle,
                  ),
                ),
                child:   Align(alignment: Alignment.center,
                    child:  Padding(padding: const EdgeInsets.only(top: 5,bottom: 5),

                      //Goods Movement Type 541 and z41.
                      child:
                          // Text(responseData2[0]['GoodsMovementType']=='541'?"DELIVERY CHALLAN - JOB ORDER":
                          //      responseData2[0]['GoodsMovementType']=='Z41'?"DELIVERY CHALLAN":"",style: fontSize8WidthBold
                          // )
                      Text("DELIVERY CHALLAN",style: fontSize8WidthBold),
                    )
                ),
              ),
              //four
              Row(children: [
                Expanded(flex: 2,child:Container(
                    height: 120,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("To:",style: fontSize8),
                              Padding(padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['Supplier']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['SupplierFullName']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text("${responseData1[0]['StreetName_1']??""}",style:fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['PostalCode_1']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Row(children: [
                                          Text('GSTIN/UIN',style: fontSize8WidthBold),
                                          Text(" :",style: fontSize8WidthBold),
                                          Text('${responseData1[0]['TaxNumber3']??""}',style: fontSize8WidthBold),
                                        ])

                                      ])
                              )
                            ]) )
                ), ),
                Expanded(flex: 1,child:  Container(height: 120,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("DC  No.",style: fontSize8WidthBold),
                          ),

                          Divider(thickness: 0.5,color: PdfColors.black),

                          Padding(padding: const EdgeInsets.only(left: 5,),
                            child:  Text("DC Date",style: fontSize8WidthBold),
                          ),
                        ]) ),
                ),
                Expanded(flex: 1,child: Container(height: 120,
                    decoration:  BoxDecoration(
                      border: Border(
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("${responseData1[0]['MaterialDocument']??""}",style: fontSize9),
                          ),

                          Divider(thickness: 0.5,color: PdfColors.black),

                          Padding(padding: const EdgeInsets.only(left: 5,),
                            child:  Text(responseData1[0]['DocumentDate'] != null ? formatDate(responseData1[0]['DocumentDate']) : "",style: fontSize9),
                          ),
                        ])
                ),)

              ]),
              //five.
              Container( height: 30,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('Mode Of Transport',style: fontSize8WidthBold))),
                    Expanded(flex: 1,child: Text('${responseData2[0]['YY1_ModeOftransport2_MMI']??""}',style: fontSize8)),
                    Expanded(flex: 1,child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          Padding(padding: const EdgeInsets.only(left: 5),child: Text('DC Type',style: fontSize8WidthBold),),
                          SizedBox(width: 101),
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          //Padding(padding: EdgeInsets.only(left: 50),child: Container(height: 30,width: 0.5,color: PdfColors.black))
                        ])),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child:Text('JOB ORDER',style: fontSize9)
                      //Text('NON-RETURNABLE',style: fontSize8)
                    ))
                  ])
              ),
              //six
              Container( height: 30,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('Vehicle No',style: fontSize8WidthBold))),

                    //GMT 541.
                    Expanded(flex: 1,child: Text('${responseData2[0]['YY1_VehicleNo_MMI']??""}',style: fontSize9)),
                    Expanded(flex: 1,child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          Padding(padding: const EdgeInsets.only(left: 5),child: Text('Ref No',style: fontSize8WidthBold),),
                          SizedBox(width: 108),
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          // Padding(padding: EdgeInsets.only(left: 50),child: Container(height: 30,width: 0.5,color: PdfColors.black))
                        ])),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),child: Text('${responseData1[0]['PurchaseOrder']??""}',style:fontSize9)))
                  ])
              ),
              //seven table header.
              Container(height: 25,
                  decoration:  BoxDecoration(
                    color: PdfColors.grey,
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Padding(padding: const EdgeInsets.only(left: 5),
                        child: Container(width: 25,child: Text('Sl.No',style: fontSize8WidthBold))
                    ),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('ITEM CODE',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 3,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('DESCRIPTION',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('HSN',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child:  Text('QTY',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('UOM',style: fontSize8WidthBold))),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child:  Text('TAX RATE',style: fontSize8WidthBold))),

                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child: Center(child:  Text('PRICE',style: fontSize8WidthBold)))),

                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('VALUE',style: fontSize8WidthBold))),

                  ])
              ),
              for(int i=0;i<responseData1.length;i++)
              //Eight Dynamic Header.
                LayoutBuilder(
                  builder: (context, constraints) {

                    double qty = double.parse(responseData1[i]['QuantityInEntryUnit']??"");
                    double price = double.parse(responseData1[i]['StandardPrice']??"");


                    value = qty*price;

                    totalValue += value;

                    // print('---------totalValue----------');
                    // print(totalValue);
                    // if(responseData1[i]['StandardPrice']=="V")
                    ///Static Tax codes.
                      cGST = 9;
                      sGST = 9;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    ///Tax Codes.
                    // if(responseData1[i]['TaxCode']=='V0'){
                    //   cGST = 0;
                    //   sGST = 0;
                    //   cGSTFinal = ((cGST/100)*totalValue);
                    //   sGSTFinal = ((sGST/100)*totalValue);
                    //   totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    // }
                    // else if(responseData1[i]['TaxCode']=='V1'){
                    //   cGST = 2.5;
                    //   sGST = 2.5;
                    //   cGSTFinal = ((cGST/100)*totalValue);
                    //   sGSTFinal = ((sGST/100)*totalValue);
                    //   totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    // }
                    // else if(responseData1[i]['TaxCode']=='V2'){
                    //   cGST = 6;
                    //   sGST = 6;
                    //   cGSTFinal = ((cGST/100)*totalValue);
                    //   sGSTFinal = ((sGST/100)*totalValue);
                    //   totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    // }
                    //
                    // else if(responseData1[i]['TaxCode']=='V3'){
                    //   cGST = 9;
                    //   sGST = 9;
                    //   cGSTFinal = ((cGST/100)*totalValue);
                    //   sGSTFinal = ((sGST/100)*totalValue);
                    //   totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    // }
                    // else if(responseData1[i]['TaxCode']=='V4'){
                    //   cGST = 14;
                    //   sGST = 14;
                    //   cGSTFinal = ((cGST/100)*totalValue);
                    //   sGSTFinal = ((sGST/100)*totalValue);
                    //   totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    // }
                    // else if(responseData1[i]['TaxCode']=='V5'){
                    //   iGST = 5;
                    //
                    //   iGSTFinal = ((iGST/100)*totalValue);
                    //   totalAmount = iGSTFinal+totalValue;
                    // }
                    // else if(responseData1[i]['TaxCode']=='V6'){
                    //   iGST = 12;
                    //
                    //   iGSTFinal = ((iGST/100)*totalValue);
                    //   totalAmount = iGSTFinal+totalValue;
                    // }
                    // else if(responseData1[i]['TaxCode']=='V7'){
                    //   iGST = 18;
                    //
                    //   iGSTFinal = ((iGST/100)*totalValue);
                    //   totalAmount = iGSTFinal+totalValue;
                    // }
                    // else if(responseData1[i]['TaxCode']=='V8'){
                    //   iGST = 28;
                    //
                    //   iGSTFinal = ((iGST/100)*totalValue);
                    //   totalAmount = iGSTFinal+totalValue;
                    // }
                    // else{
                    //   totalAmount = totalValue;
                    // }

                    print('--------totalAmount---------');
                    print(totalAmount);
                    //TaxCodes Filter.
                    if(responseData1[i]['TaxCode']=='V5' ||
                        responseData1[i]['TaxCode']=='V6' ||
                        responseData1[i]['TaxCode']=='V7'
                        || responseData1[i]['TaxCode']=='V8'){

                      taxCodes="TaxCodesV5V6V7V8";
                      print('----taxCodes----');
                      print(taxCodes);
                    }
                    else{
                      taxCodes="TaxCodesV0V1V2V3V4";
                      print('----taxCodes----');
                      print(taxCodes);
                    }
                    return Column(
                        children: [
                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                  // top:borderStyle,
                                  bottom:borderStyle,
                                ),
                              ),
                              child: Row(children: [
                                Padding(padding: const EdgeInsets.only(left: 5),
                                    child: Container(width: 25,child: Text('${i+1}',style: fontSize8))
                                ),

                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                                    child: Text('${responseData1[i]['Material']??""}',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 3,child: Padding(padding:const EdgeInsets.only(left: 5),
                                    child: Text("${responseData1[i]['ProductName']??""}",style: fontSize8)
                                  //Text('NB26061-LEVER-1 NOS',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Text("${responseData1[i]['ConsumptionTaxCtrlCode']??""}",style: fontSize8),
                                  //Text('90.24.1000',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding:const EdgeInsets.only(left: 5),
                                    child: Text('${responseData1[i]['QuantityInEntryUnit']??""}',style: fontSize8)
                                  //Text('NOS',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 5),
                                  child:  Text("${responseData1[i]['EntryUnit']??""}",style: fontSize8),
                                )),

                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 10),
                                  child:  Text("18%",
                                      // responseData1[i]['TaxCode']=='V0'? "0%":
                                      // responseData1[i]['TaxCode']=='V1'? "5%":
                                      // responseData1[i]['TaxCode']=='V2'? "12%":
                                      // responseData1[i]['TaxCode']=='V3'? "18%":
                                      // responseData1[i]['TaxCode']=='V4'? "28%":
                                      // responseData1[i]['TaxCode']=='V5'? "5%":
                                      // responseData1[i]['TaxCode']=='V6'? "12%":
                                      // responseData1[i]['TaxCode']=='V7'? "18%": responseData1[i]['TaxCode']=='V8'? "28%":"",
                                      style: fontSize8),
                                  //Text('18 %',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Center(child: Text('${responseData1[i]['StandardPrice']??""}',style: fontSize8))),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Center(child: Text(value.toStringAsFixed(2),style: fontSize8))),

                              ])
                          ),
                        ]
                    );
                  },),

              Row(children: [
                Expanded(flex: 3,child:Container(
                    height: 100,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                    right:borderStyle,
                                    bottom: borderStyle
                                ),
                              ),
                              child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Row(children: [
                                    Text('Purpose of Transport',style: fontSize8WidthBold),
                                    Text(":"),
                                    Text("${responseData2[0]['YY1_PurposeofTransport_MMI']??""}",style: fontSize8WidthBold),

                                  ])
                              )),
                          SizedBox(height: 10),
                          Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Note',style: fontSize8WidthBold),
                                Text(":",style: fontSize8WidthBold),
                                Text('${responseData2[0]['YY1_Remarks_MMI']??""}',style: fontSize8WidthBold),

                              ])
                          )

                        ])
                ), ),
                Expanded(flex: 1,child:  Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 25,width: 120,
                            decoration:  BoxDecoration(
                              border: Border(
                                  bottom: borderStyle
                              ),
                            ),
                            child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                              child: Text("Taxable Amount",style: fontSize8WidthBold),
                              //Text("200.00",style: fontSize8WidthBold),
                            ),),

                          ///CGST And SGST Header.
                          Builder(
                            builder: ( context) {
                              // print('------------------');
                              // print(taxCodes);
                              if( taxCodes=="TaxCodesV0V1V2V3V4"){
                                return Column(children: [
                                  //CGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                      child: Builder(
                                        builder: ( context) {
                                          return   Text("CGST $cGST%",style: fontSize8WidthBold);
                                        },
                                      ),

                                      //Text("200.00",style: fontSize8WidthBold),
                                    ),),
                                  //SGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                      child: Builder(
                                        builder: ( context) {
                                          return    Text("SGST $sGST%",style: fontSize8WidthBold);
                                        },
                                      ),
                                    ),),
                                ]);
                              }
                              else{
                                return Column(
                                    children: [
                                      //IGST.
                                      Container(height: 25,width: 120,
                                        decoration:  BoxDecoration(
                                          border: Border(
                                              bottom: borderStyle
                                          ),
                                        ),
                                        child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                          child: Builder(
                                            builder: ( context) {
                                              return   Text("IGST $iGST%",style: fontSize8WidthBold);
                                            },
                                          ),

                                          //Text("200.00",style: fontSize8WidthBold),
                                        ),),
                                    ]);
                              }
                            },
                          ),


                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("Total Amount",style: fontSize8WidthBold),
                          ),

                        ]) ),
                ),
                Expanded(flex: 1,child: Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 25,width: 120,
                              decoration:  BoxDecoration(
                                border: Border(
                                    bottom: borderStyle
                                ),
                              ),
                              child:   Align(alignment: Alignment.topRight,
                                child:Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                  child:
                                  Builder(
                                    builder: ( context) {
                                      return Text(
                                        formatToTwoDecimal(totalValue),
                                        //newvalue.toStringAsFixed(2),
                                        style:fontSize8,
                                      );
                                    },
                                  ),
                                ), )
                          ),
                          ///CGST AND SGST Values.
                          Builder(
                            builder: ( context) {
                              // print('------------------');
                              // print(taxCodes);
                              if( taxCodes=="TaxCodesV0V1V2V3V4"){
                                return Column(children: [
                                  //CGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Align(alignment: Alignment.topRight,
                                      child: Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                        child:
                                        Builder(
                                          builder: ( context) {
                                            return Text(
                                              formatToTwoDecimal(cGSTFinal),
                                              //cGSTFinal.toString(),
                                              style:fontSize8,
                                            );
                                          },
                                        ),
                                      ),),),
                                  //SGST.
                                  Container(height: 25,width: 120,
                                      decoration:  BoxDecoration(
                                        border: Border(
                                            bottom: borderStyle
                                        ),
                                      ),
                                      child:  Align(alignment: Alignment.topRight,
                                        child:  Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                          child:
                                          Builder(
                                            builder: ( context) {
                                              return Text(
                                                formatToTwoDecimal(sGSTFinal),
                                                //sGSTFinal.toString(),
                                                style:fontSize8,
                                              );
                                            },
                                          ),
                                        ),)),
                                ]);
                              }
                              else{
                                return Column(
                                    children: [
                                      //IGST.
                                      Container(height: 25,width: 120,
                                        decoration:  BoxDecoration(
                                          border: Border(
                                              bottom: borderStyle
                                          ),
                                        ),
                                        child:   Align(alignment: Alignment.topRight,
                                          child: Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                            child:
                                            Builder(
                                              builder: ( context) {
                                                return Text(
                                                  formatToTwoDecimal(iGSTFinal),
                                                  //cGSTFinal.toString(),
                                                  style:fontSize8,
                                                );
                                              },
                                            ),
                                          ),),),
                                    ]);
                              }
                            },
                          ),


                          Align(alignment: Alignment.topRight,
                            child:  Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                              child:
                              Builder(
                                builder: ( context) {
                                  return Text(
                                    formatToTwoDecimal(totalAmount),
                                    //totalAmount.toString(),
                                    style:fontSize8,
                                  );
                                },
                              ),

                            ),)
                        ])
                ),)

              ]),
              ///Total CGST And SGST Values.
              Builder(
                builder: ( context) {
                  // print('------------------');
                  // print(taxCodes);
                  if( taxCodes=="TaxCodesV0V1V2V3V4"){
                    return Column(children: [
                      //CGST Total.
                      Container(height: 25,
                          decoration:  BoxDecoration(
                            border: Border(
                              // top:borderStyle,
                              bottom:borderStyle,
                            ),
                          ),
                          child: Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Total CGST value Payable (in words)',style: fontSize8WidthBold),
                                Text(" :",style: fontSize8WidthBold),
                                Builder(
                                  builder: ( context) {
                                    return Text(
                                      //' Rs. ${convertToText(cGSTFinal)}',
                                      converter.convertAmountToWords(cGSTFinal, ignoreDecimal: false),

                                      // '',
                                      style:fontSize8,
                                    );
                                  },
                                ),
                              ])
                          )
                      ),
                      //SGST Total.
                      Container(height: 25,
                          decoration:  BoxDecoration(
                            border: Border(
                              // top:borderStyle,
                              bottom:borderStyle,
                            ),
                          ),
                          child: Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Total SGST value Payable (in words)',style: fontSize8WidthBold),
                                Text(" :",style: fontSize8WidthBold),
                                Builder(
                                  builder: ( context) {
                                    return Text(
                                      // ' Rs. ${convertToText(sGSTFinal)}',

                                      converter.convertAmountToWords(sGSTFinal, ignoreDecimal: false),
                                      // '',

                                      style:fontSize8,
                                    );
                                  },
                                ),

                              ])
                          )
                      ),
                    ]);
                  }
                  else{
                    return Column(
                        children: [
                          //IGST Total.
                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                  // top:borderStyle,
                                  bottom:borderStyle,
                                ),
                              ),
                              child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Row(children: [
                                    Text('Total IGST value Payable (in words)',style: fontSize8WidthBold),
                                    Text(" :",style: fontSize8WidthBold),
                                    Builder(
                                      builder: ( context) {
                                        return Text(
                                          // ' Rs. ${convertToText(sGSTFinal)}',

                                          converter.convertAmountToWords(iGSTFinal, ignoreDecimal: false),
                                          // '',

                                          style:fontSize8,
                                        );
                                      },
                                    ),

                                  ])
                              )
                          ),
                        ]);
                  }
                },
              ),

              //Total Amount In words.
              Container(height: 25,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 5),
                      child: Row(children: [
                        Text('Total Amount (in Words) ',style: fontSize8WidthBold),
                        Text(" :",style: fontSize8WidthBold),
                        Builder(
                          builder: ( context) {
                            return Text(
                              // ' Rs. ${convertToText(totalAmount)}',
                              converter.convertAmountToWords(totalAmount, ignoreDecimal: false),
                              //'',

                              style:fontSize8,
                            );
                          },
                        ),
                      ])
                  )
              ),

              ///Special Instructions Container.
              // Container(height: 25,
              //     decoration:  BoxDecoration(
              //       border: Border(
              //         // top:borderStyle,
              //         bottom:borderStyle,
              //       ),
              //     ),
              //     child: Padding(padding: const EdgeInsets.only(left: 5),
              //         child: Row(
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text('Special Instruction',style: fontSize8WidthBold),
              //                   SizedBox(height: 5),
              //                   Text(' Kindly return the parts with above mentioned time period with proper Document and mentioned our DC number in your dispatch document',style: fontSize8)
              //                 ])
              //           ]
              //         )
              //     )
              // ),
              Container(height: 25,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 5,right: 150),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Text('Requested By',style: fontSize8WidthBold),
                              Text(" :",style: fontSize8WidthBold),
                              Text('${responseData2[0]['YY1_RequestedBy1_MMI']??""}',style: fontSize8),

                            ]),
                            Row(children: [
                              Text('Prepared By',style: fontSize8WidthBold),
                              Text(" :",style: fontSize8WidthBold),
                              Text('${responseData2[0]['YY1_PreparedBy1_MMI']??""}',style: fontSize8),

                            ])
                          ])
                  )
              ),
              ///Remarks Container.
              // Container(height: 25,
              //     decoration:  BoxDecoration(
              //       border: Border(
              //         // top:borderStyle,
              //         bottom:borderStyle,
              //       ),
              //     ),
              //     child: Padding(padding: const EdgeInsets.only(left: 5),
              //         child: Row(children: [
              //           Text('Remarks',style: fontSize8WidthBold),
              //           Text(" :",style: fontSize8WidthBold),
              //           Text('${responseData2[0]['YY1_Remarks_MMI']??""}',style: fontSize8)
              //         ])
              //     )
              // ),

              Row(children: [
                Expanded(flex: 2,child:Container(
                    height: 100,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Received the above goods in good condition",style: fontSize8),
                              Padding(padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 60),
                                        Text('Receiver Signature With Seal',style: fontSize8),
                                      ])
                              )
                            ]) )
                ), ),
                Expanded(flex: 3,child:  Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("For",style: fontSize8),
                                SizedBox(width: 5),
                                Text("JM FRICTECH INDIA PVT. LTD",style: fontSize8WidthBold),
                                SizedBox(width: 5),
                              ]),
                          SizedBox(height: 60),
                          Padding(padding: const EdgeInsets.only(left: 5,right: 5,
                          ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Prepared By ",style: fontSize8),
                                    Text("Authorised Signatory",style: fontSize8),
                                  ])
                          )

                        ]) ),
                ),


              ]),
              Container(
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Align(alignment: Alignment.bottomRight,child: Padding(padding: const EdgeInsets.only(right: 5),
                      child: Text("Page No: 1",style: fontSize8)))
              )

            ])
        )
      ],
    ),
  );

  log('------pdf-------');
  log(pdf.runtimeType.toString());

  // Return PDF as bytes.
  return pdf.save();
}

///GoodsMovement Type Z41.
Future<Uint8List> generatePdfDeliveryZ41(List<dynamic> responseData1, List<dynamic> responseData2) async {

  print('-----Goods Type---');
  print(responseData2[0]['GoodsMovementType']);
  final converter = AmountToWords();

  ///Styles.
  // TextStyle blueGrey200 = const TextStyle(color: PdfColors.blueGrey300);
  //TextStyle fontSize9WithBold =  TextStyle(fontWeight: FontWeight.bold,fontSize: 9);
  TextStyle fontSize9 =const TextStyle(fontSize: 9);
  TextStyle fontSize8 =const TextStyle(fontSize: 8);
  TextStyle fontSize8WidthBold =TextStyle(fontWeight: FontWeight.bold,fontSize: 8,color: PdfColors.black);
  double value = 0.0;
  double totalValue = 0.0;
  double cGST =0.0;
  double sGST =0.0;
  double iGST = 0.0;
  double cGSTFinal =0.0;
  double sGSTFinal =0.0;
  double iGSTFinal = 0.0;
  //double taxableAmount =0.0;
  double totalAmount =0.0;


  final pdf = Document();

  // Load the image from assets
  final image = MemoryImage(
    (await rootBundle.load('assets/logo/jmi_logo.png')).buffer.asUint8List(),
  );
  BorderSide borderStyle= const BorderSide(color: PdfColors.black,width: 0.5);
  String taxCodes='';

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

  String formatToTwoDecimal(double number) {
    // Convert the number to a string with two decimal places
    String formattedNumber = number.toStringAsFixed(2);

    // If the number is an integer, remove the ".00"
    if (formattedNumber.endsWith('.00')) {
      formattedNumber = formattedNumber.substring(0, formattedNumber.length - 3);
    }
    return formattedNumber;
  }


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
                left: borderStyle,
                top:borderStyle,
                right:borderStyle,
                bottom:borderStyle,
              ),
            ),
            child: Column(children: [
              //First.
              Container(
                decoration:  BoxDecoration(
                  border: Border(
                    //top:borderStyle,
                    bottom:borderStyle,
                  ),
                ),

                child:    Padding(padding: const EdgeInsets.only(top: 2,right: 10,bottom: 2),
                    child:Align(alignment: Alignment.topRight,
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    // borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),

                                Text("ORIGINAL",style: fontSize8),]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    // borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("DUPLICATE",style: fontSize8),
                              ]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    //borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("TRIPLICATE",style: fontSize8),
                              ]),
                              Row(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: PdfColors.grey, // Choose your border color
                                      width: 0.5, // Adjust the border width as needed
                                    ),
                                    //borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                                  ),
                                  child: Checkbox(
                                    value: false,
                                    name: '',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("EXTRA",style: fontSize8)
                              ])
                            ])
                      // Text("ORIGINAL FOR RECIPIENT",style: fontSize8)
                    ) ),
              ),
              //Second.
              Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(image, width: 100, height: 100),
                    SizedBox(width: 70),
                    Column(children: [
                      SizedBox(height: 5),
                      Text('JM FRICTECH INDIA PVT. LTD',style: fontSize8WidthBold),
                      SizedBox(height: 5),
                      Text('${responseData1[0]['HouseNumber']??""},${responseData1[0]['StreetName']??""}',style: fontSize8),
                      SizedBox(height: 5),
                      Text("${responseData1[0]['CityName']??""}-${responseData1[0]['PostalCode']??""}",style: fontSize8),
                      SizedBox(height: 5),
                      Text('${responseData1[0]['RegionName']??""},India-Phone: +914471131343 / 344 ',style: fontSize8),
                      SizedBox(height: 5),
                      Text('GSTN No :${responseData1[0]['TaxNumber3']??""}',style: fontSize8),
                      SizedBox(height: 10),
                    ])
                  ]),
              //Third
              Container(
                decoration:  BoxDecoration(
                  border: Border(
                    top:borderStyle,
                    bottom:borderStyle,
                  ),
                ),
                child:   Align(alignment: Alignment.center,
                    child:  Padding(padding: const EdgeInsets.only(top: 5,bottom: 5),

                      //Goods Movement Z41.
                      child:
                      Text("DELIVERY CHALLAN",style: fontSize8WidthBold),
                    )
                ),
              ),
              //four
              Row(children: [
                Expanded(flex: 2,child:Container(
                    height: 120,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("To:",style: fontSize8),
                              Padding(padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['Supplier']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['SupplierFullName']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text("${responseData1[0]['StreetName_1']??""}",style:fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Text('${responseData1[0]['PostalCode_1']??""}',style: fontSize8WidthBold),
                                        SizedBox(height: 5),
                                        Row(children: [
                                          Text('GSTIN/UIN',style: fontSize8WidthBold),
                                          Text(" :",style: fontSize8WidthBold),
                                          Text('${responseData1[0]['TaxNumber3']??""}',style: fontSize8WidthBold),
                                        ])

                                      ])
                              )
                            ]) )
                ), ),
                Expanded(flex: 1,child:  Container(height: 120,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("DC  No.",style: fontSize8WidthBold),
                          ),

                          Divider(thickness: 0.5,color: PdfColors.black),

                          Padding(padding: const EdgeInsets.only(left: 5,),
                            child:  Text("DC Date",style: fontSize8WidthBold),
                          ),
                        ]) ),
                ),
                Expanded(flex: 1,child: Container(height: 120,
                    decoration:  BoxDecoration(
                      border: Border(
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("${responseData1[0]['MaterialDocument']??""}",style: fontSize9),
                          ),

                          Divider(thickness: 0.5,color: PdfColors.black),

                          Padding(padding: const EdgeInsets.only(left: 5,),
                            child:  Text(responseData1[0]['DocumentDate'] != null ? formatDate(responseData1[0]['DocumentDate']) : "",style: fontSize9),
                          ),
                        ])
                ),)

              ]),
              //five.
              Container( height: 30,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('Mode Of Transport',style: fontSize8WidthBold))),
                    Expanded(flex: 1,child: Text('${responseData2[0]['YY1_ModeOftransport2_MMI']??""}',style: fontSize8)),
                    Expanded(flex: 1,child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          Padding(padding: const EdgeInsets.only(left: 5),child: Text('DC Type',style: fontSize8WidthBold),),
                          SizedBox(width: 101),
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          //Padding(padding: EdgeInsets.only(left: 50),child: Container(height: 30,width: 0.5,color: PdfColors.black))
                        ])),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child:Text('Returnable',style: fontSize9)
                      //Text('NON-RETURNABLE',style: fontSize8)
                    ))
                  ])
              ),
              //six
              Container( height: 30,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('Vehicle No',style: fontSize8WidthBold))),

                    //GMT 541.
                    Expanded(flex: 1,child: Text('${responseData2[0]['YY1_VehicleNo_MMI']??""}',style: fontSize9)),
                    Expanded(flex: 1,child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          Padding(padding: const EdgeInsets.only(left: 5),child: Text('Ref No',style: fontSize8WidthBold),),
                          SizedBox(width: 108),
                          Container(height: 30,width: 0.5,color: PdfColors.black),
                          // Padding(padding: EdgeInsets.only(left: 50),child: Container(height: 30,width: 0.5,color: PdfColors.black))
                        ])),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),child: Text('${responseData1[0]['PurchaseOrder']??""}',style:fontSize9)))
                  ])
              ),
              //seven table header.
              Container(height: 25,
                  decoration:  BoxDecoration(
                    color: PdfColors.grey,
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Row(children: [
                    Padding(padding: const EdgeInsets.only(left: 5),
                        child: Container(width: 25,child: Text('Sl.No',style: fontSize8WidthBold))
                    ),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('ITEM CODE',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 3,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('DESCRIPTION',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('HSN',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child:  Text('QTY',style: fontSize8WidthBold)
                    )),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('UOM',style: fontSize8WidthBold))),
                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child:  Text('TAX RATE',style: fontSize8WidthBold))),

                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
                        child: Center(child:  Text('PRICE',style: fontSize8WidthBold)))),

                    Container(height: 25,width: 0.5,color: PdfColors.black),
                    Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                        child: Text('VALUE',style: fontSize8WidthBold))),

                  ])
              ),
              for(int i=0;i<responseData1.length;i++)
              //Eight Dynamic Header.
                LayoutBuilder(
                  builder: (context, constraints) {

                    double qty = double.parse(responseData1[i]['QuantityInEntryUnit']??"");
                    double price = double.parse(responseData1[i]['StandardPrice']??"");


                    value = qty*price;

                    totalValue += value;

                    // print('---------totalValue----------');
                    // print(totalValue);
                    // if(responseData1[i]['StandardPrice']=="V")
                    if(responseData1[i]['TaxCode']==''){
                      cGST = 9;
                      sGST = 9;
                      cGSTFinal = ((cGST/100)*totalValue);
                      sGSTFinal = ((sGST/100)*totalValue);
                      totalAmount = cGSTFinal+sGSTFinal+totalValue;
                    }

                   // else if(responseData1[i]['TaxCode']=='V0'){
                   //    cGST = 0;
                   //    sGST = 0;
                   //    cGSTFinal = ((cGST/100)*totalValue);
                   //    sGSTFinal = ((sGST/100)*totalValue);
                   //    totalAmount = cGSTFinal+sGSTFinal+totalValue;
                   //  }
                   //  else if(responseData1[i]['TaxCode']=='V1'){
                   //    cGST = 2.5;
                   //    sGST = 2.5;
                   //    cGSTFinal = ((cGST/100)*totalValue);
                   //    sGSTFinal = ((sGST/100)*totalValue);
                   //    totalAmount = cGSTFinal+sGSTFinal+totalValue;
                   //  }
                   //  else if(responseData1[i]['TaxCode']=='V2'){
                   //    cGST = 6;
                   //    sGST = 6;
                   //    cGSTFinal = ((cGST/100)*totalValue);
                   //    sGSTFinal = ((sGST/100)*totalValue);
                   //    totalAmount = cGSTFinal+sGSTFinal+totalValue;
                   //  }
                   //
                   //  else if(responseData1[i]['TaxCode']=='V3'){
                   //    cGST = 9;
                   //    sGST = 9;
                   //    cGSTFinal = ((cGST/100)*totalValue);
                   //    sGSTFinal = ((sGST/100)*totalValue);
                   //    totalAmount = cGSTFinal+sGSTFinal+totalValue;
                   //  }
                   //  else if(responseData1[i]['TaxCode']=='V4'){
                   //    cGST = 14;
                   //    sGST = 14;
                   //    cGSTFinal = ((cGST/100)*totalValue);
                   //    sGSTFinal = ((sGST/100)*totalValue);
                   //    totalAmount = cGSTFinal+sGSTFinal+totalValue;
                   //  }
                   //  else if(responseData1[i]['TaxCode']=='V5'){
                   //    iGST = 5;
                   //
                   //    iGSTFinal = ((iGST/100)*totalValue);
                   //    totalAmount = iGSTFinal+totalValue;
                   //  }
                   //  else if(responseData1[i]['TaxCode']=='V6'){
                   //    iGST = 12;
                   //
                   //    iGSTFinal = ((iGST/100)*totalValue);
                   //    totalAmount = iGSTFinal+totalValue;
                   //  }
                   //  else if(responseData1[i]['TaxCode']=='V7'){
                   //    iGST = 18;
                   //
                   //    iGSTFinal = ((iGST/100)*totalValue);
                   //    totalAmount = iGSTFinal+totalValue;
                   //  }
                   //  else if(responseData1[i]['TaxCode']=='V8'){
                   //    iGST = 28;
                   //
                   //    iGSTFinal = ((iGST/100)*totalValue);
                   //    totalAmount = iGSTFinal+totalValue;
                   //  }

                    else{
                      totalAmount = totalValue;
                    }

                    print('--------totalAmount---------');
                    print(totalAmount);
                    //TaxCodes Filter.
                    if(responseData1[i]['TaxCode']=='V5' ||
                        responseData1[i]['TaxCode']=='V6' ||
                        responseData1[i]['TaxCode']=='V7'
                        || responseData1[i]['TaxCode']=='V8'){

                      taxCodes="TaxCodesV5V6V7V8";
                      print('----taxCodes----');
                      print(taxCodes);
                    }
                    else{
                      taxCodes="TaxCodesV0V1V2V3V4";
                      print('----taxCodes----');
                      print(taxCodes);
                    }
                    return Column(
                        children: [
                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                  // top:borderStyle,
                                  bottom:borderStyle,
                                ),
                              ),
                              child: Row(children: [
                                Padding(padding: const EdgeInsets.only(left: 5),
                                    child: Container(width: 25,child: Text('${i+1}',style: fontSize8))
                                ),

                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                                    child: Text('${responseData1[i]['Material']??""}',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 3,child: Padding(padding:const EdgeInsets.only(left: 5),
                                    child:
                                    Text(responseData2[0]['YY1_MaterialDescriptio_MMI']==""?
                                         "${responseData1[i]['ProductName']??""}" :
                                        "${responseData2[0]['YY1_MaterialDescriptio_MMI']}" ,style: fontSize8)
                                   // Text("${responseData1[i]['ProductName']??""}",style: fontSize8)
                                  //Text('NB26061-LEVER-1 NOS',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Text("${responseData1[i]['ConsumptionTaxCtrlCode']??""}",style: fontSize8),
                                  //Text('90.24.1000',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Padding(padding:const EdgeInsets.only(left: 5),
                                    child: Text('${responseData1[i]['QuantityInEntryUnit']??""}',style: fontSize8)
                                  //Text('NOS',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 5),
                                  child:  Text("${responseData1[i]['EntryUnit']??""}",style: fontSize8),
                                )),

                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 10),
                                  child:  Text("18%",
                                      // responseData1[i]['TaxCode']=='V0'? "0%":
                                      // responseData1[i]['TaxCode']=='V1'? "5%":
                                      // responseData1[i]['TaxCode']=='V2'? "12%":
                                      // responseData1[i]['TaxCode']=='V3'? "18%":
                                      // responseData1[i]['TaxCode']=='V4'? "28%":
                                      // responseData1[i]['TaxCode']=='V5'? "5%":
                                      // responseData1[i]['TaxCode']=='V6'? "12%":
                                      // responseData1[i]['TaxCode']=='V7'? "18%": responseData1[i]['TaxCode']=='V8'? "28%":"",

                                      style: fontSize8),
                                  //Text('18 %',style: fontSize8)
                                )),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child:Center(child: Text('${responseData1[i]['StandardPrice']??""}',style: fontSize8))),
                                Container(height: 25,width: 0.5,color: PdfColors.black),
                                Expanded(flex: 1,child: Center(child: Text(value.toStringAsFixed(2),style: fontSize8))),

                              ])
                          ),
                        ]
                    );
                  },),

              Row(children: [
                Expanded(flex: 3,child:Container(
                    height: 100,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                    right:borderStyle,
                                    bottom: borderStyle
                                ),
                              ),
                              child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Row(children: [
                                    Text('Purpose of Transport',style: fontSize8WidthBold),
                                    Text(":"),
                                    Text("${responseData2[0]['YY1_PurposeofTransport_MMI']??""}",style: fontSize8WidthBold),

                                  ])
                              )),
                          SizedBox(height: 10),
                          Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Note',style: fontSize8WidthBold),
                                Text(":",style: fontSize8WidthBold),
                                Text('${responseData2[0]['YY1_Remarks_MMI']??""}',style: fontSize8WidthBold),

                              ])
                          )

                        ])
                ), ),
                Expanded(flex: 1,child:  Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 25,width: 120,
                            decoration:  BoxDecoration(
                              border: Border(
                                  bottom: borderStyle
                              ),
                            ),
                            child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                              child: Text("Taxable Amount",style: fontSize8WidthBold),
                              //Text("200.00",style: fontSize8WidthBold),
                            ),),

                          ///CGST And SGST Header.
                          Builder(
                            builder: ( context) {
                              // print('------------------');
                              // print(taxCodes);
                              if( taxCodes=="TaxCodesV0V1V2V3V4"){
                                return Column(children: [
                                  //CGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                      child: Builder(
                                        builder: ( context) {
                                          return   Text("CGST $cGST%",style: fontSize8WidthBold);
                                        },
                                      ),

                                      //Text("200.00",style: fontSize8WidthBold),
                                    ),),
                                  //SGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                      child: Builder(
                                        builder: ( context) {
                                          return    Text("SGST $sGST%",style: fontSize8WidthBold);
                                        },
                                      ),
                                    ),),
                                ]);
                              }
                              else{
                                return Column(
                                    children: [
                                      //IGST.
                                      Container(height: 25,width: 120,
                                        decoration:  BoxDecoration(
                                          border: Border(
                                              bottom: borderStyle
                                          ),
                                        ),
                                        child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                                          child: Builder(
                                            builder: ( context) {
                                              return   Text("IGST $iGST%",style: fontSize8WidthBold);
                                            },
                                          ),

                                          //Text("200.00",style: fontSize8WidthBold),
                                        ),),
                                    ]);
                              }
                            },
                          ),


                          Padding(padding: const EdgeInsets.only(left: 5,top: 5),
                            child:  Text("Total Amount",style: fontSize8WidthBold),
                          ),

                        ]) ),
                ),
                Expanded(flex: 1,child: Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          bottom: borderStyle
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 25,width: 120,
                              decoration:  BoxDecoration(
                                border: Border(
                                    bottom: borderStyle
                                ),
                              ),
                              child:   Align(alignment: Alignment.topRight,
                                child:Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                  child:
                                  Builder(
                                    builder: ( context) {
                                      return Text(
                                        formatToTwoDecimal(totalValue),
                                        //newvalue.toStringAsFixed(2),
                                        style:fontSize8,
                                      );
                                    },
                                  ),
                                ), )
                          ),
                          ///CGST AND SGST Values.
                          Builder(
                            builder: ( context) {
                              // print('------------------');
                              // print(taxCodes);
                              if( taxCodes=="TaxCodesV0V1V2V3V4"){
                                return Column(children: [
                                  //CGST.
                                  Container(height: 25,width: 120,
                                    decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: borderStyle
                                      ),
                                    ),
                                    child:   Align(alignment: Alignment.topRight,
                                      child: Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                        child:
                                        Builder(
                                          builder: ( context) {
                                            return Text(
                                              formatToTwoDecimal(cGSTFinal),
                                              //cGSTFinal.toString(),
                                              style:fontSize8,
                                            );
                                          },
                                        ),
                                      ),),),
                                  //SGST.
                                  Container(height: 25,width: 120,
                                      decoration:  BoxDecoration(
                                        border: Border(
                                            bottom: borderStyle
                                        ),
                                      ),
                                      child:  Align(alignment: Alignment.topRight,
                                        child:  Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                          child:
                                          Builder(
                                            builder: ( context) {
                                              return Text(
                                                formatToTwoDecimal(sGSTFinal),
                                                //sGSTFinal.toString(),
                                                style:fontSize8,
                                              );
                                            },
                                          ),
                                        ),)),
                                ]);
                              }
                              else{
                                return Column(
                                    children: [
                                      //IGST.
                                      Container(height: 25,width: 120,
                                        decoration:  BoxDecoration(
                                          border: Border(
                                              bottom: borderStyle
                                          ),
                                        ),
                                        child:   Align(alignment: Alignment.topRight,
                                          child: Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                                            child:
                                            Builder(
                                              builder: ( context) {
                                                return Text(
                                                  formatToTwoDecimal(iGSTFinal),
                                                  //cGSTFinal.toString(),
                                                  style:fontSize8,
                                                );
                                              },
                                            ),
                                          ),),),
                                    ]);
                              }
                            },
                          ),


                          Align(alignment: Alignment.topRight,
                            child:  Padding(padding: const EdgeInsets.only(right: 5,top: 5),
                              child:
                              Builder(
                                builder: ( context) {
                                  return Text(
                                    formatToTwoDecimal(totalAmount),
                                    //totalAmount.toString(),
                                    style:fontSize8,
                                  );
                                },
                              ),

                            ),)
                        ])
                ),)

              ]),
              ///Total CGST And SGST Values.
              Builder(
                builder: ( context) {
                  // print('------------------');
                  // print(taxCodes);
                  if( taxCodes=="TaxCodesV0V1V2V3V4"){
                    return Column(children: [
                      //CGST Total.
                      Container(height: 25,
                          decoration:  BoxDecoration(
                            border: Border(
                              // top:borderStyle,
                              bottom:borderStyle,
                            ),
                          ),
                          child: Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Total CGST value Payable (in words)',style: fontSize8WidthBold),
                                Text(" :",style: fontSize8WidthBold),
                                Builder(
                                  builder: ( context) {
                                    return Text(
                                      //' Rs. ${convertToText(cGSTFinal)}',
                                      converter.convertAmountToWords(cGSTFinal, ignoreDecimal: false),

                                      // '',
                                      style:fontSize8,
                                    );
                                  },
                                ),
                              ])
                          )
                      ),
                      //SGST Total.
                      Container(height: 25,
                          decoration:  BoxDecoration(
                            border: Border(
                              // top:borderStyle,
                              bottom:borderStyle,
                            ),
                          ),
                          child: Padding(padding: const EdgeInsets.only(left: 5),
                              child: Row(children: [
                                Text('Total SGST value Payable (in words)',style: fontSize8WidthBold),
                                Text(" :",style: fontSize8WidthBold),
                                Builder(
                                  builder: ( context) {
                                    return Text(
                                      // ' Rs. ${convertToText(sGSTFinal)}',

                                      converter.convertAmountToWords(sGSTFinal, ignoreDecimal: false),
                                      // '',

                                      style:fontSize8,
                                    );
                                  },
                                ),

                              ])
                          )
                      ),
                    ]);
                  }
                  else{
                    return Column(
                        children: [
                          //IGST Total.
                          Container(height: 25,
                              decoration:  BoxDecoration(
                                border: Border(
                                  // top:borderStyle,
                                  bottom:borderStyle,
                                ),
                              ),
                              child: Padding(padding: const EdgeInsets.only(left: 5),
                                  child: Row(children: [
                                    Text('Total IGST value Payable (in words)',style: fontSize8WidthBold),
                                    Text(" :",style: fontSize8WidthBold),
                                    Builder(
                                      builder: ( context) {
                                        return Text(
                                          // ' Rs. ${convertToText(sGSTFinal)}',

                                          converter.convertAmountToWords(iGSTFinal, ignoreDecimal: false),
                                          // '',

                                          style:fontSize8,
                                        );
                                      },
                                    ),

                                  ])
                              )
                          ),
                        ]);
                  }
                },
              ),

              //Total Amount In words.
              Container(height: 25,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 5),
                      child: Row(children: [
                        Text('Total Amount (in Words) ',style: fontSize8WidthBold),
                        Text(" :",style: fontSize8WidthBold),
                        Builder(
                          builder: ( context) {
                            return Text(
                              // ' Rs. ${convertToText(totalAmount)}',
                              converter.convertAmountToWords(totalAmount, ignoreDecimal: false),
                              //'',

                              style:fontSize8,
                            );
                          },
                        ),
                      ])
                  )
              ),

              ///Special Instructions Container.
              // Container(height: 25,
              //     decoration:  BoxDecoration(
              //       border: Border(
              //         // top:borderStyle,
              //         bottom:borderStyle,
              //       ),
              //     ),
              //     child: Padding(padding: const EdgeInsets.only(left: 5),
              //         child: Row(
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text('Special Instruction',style: fontSize8WidthBold),
              //                   SizedBox(height: 5),
              //                   Text(' Kindly return the parts with above mentioned time period with proper Document and mentioned our DC number in your dispatch document',style: fontSize8)
              //                 ])
              //           ]
              //         )
              //     )
              // ),
              Container(height: 25,
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 5,right: 150),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Text('Requested By',style: fontSize8WidthBold),
                              Text(" :",style: fontSize8WidthBold),
                              Text('${responseData2[0]['YY1_RequestedBy1_MMI']??""}',style: fontSize8),

                            ]),
                            Row(children: [
                              Text('Prepared By',style: fontSize8WidthBold),
                              Text(" :",style: fontSize8WidthBold),
                              Text('${responseData2[0]['YY1_PreparedBy1_MMI']??""}',style: fontSize8),

                            ])
                          ])
                  )
              ),
              ///Remarks Container.
              // Container(height: 25,
              //     decoration:  BoxDecoration(
              //       border: Border(
              //         // top:borderStyle,
              //         bottom:borderStyle,
              //       ),
              //     ),
              //     child: Padding(padding: const EdgeInsets.only(left: 5),
              //         child: Row(children: [
              //           Text('Remarks',style: fontSize8WidthBold),
              //           Text(" :",style: fontSize8WidthBold),
              //           Text('${responseData2[0]['YY1_Remarks_MMI']??""}',style: fontSize8)
              //         ])
              //     )
              // ),

              Row(children: [
                Expanded(flex: 2,child:Container(
                    height: 100,
                    //width: 400,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),
                    child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Received the above goods in good condition",style: fontSize8),
                              Padding(padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 60),
                                        Text('Receiver Signature With Seal',style: fontSize8),
                                      ])
                              )
                            ]) )
                ), ),
                Expanded(flex: 3,child:  Container(height: 100,
                    decoration:  BoxDecoration(
                      border: Border(
                          right:borderStyle,
                          bottom: borderStyle
                      ),
                    ),

                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("For",style: fontSize8),
                                SizedBox(width: 5),
                                Text("JM FRICTECH INDIA PVT. LTD",style: fontSize8WidthBold),
                                SizedBox(width: 5),
                              ]),
                          SizedBox(height: 60),
                          Padding(padding: const EdgeInsets.only(left: 5,right: 5,
                          ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Prepared By ",style: fontSize8),
                                    Text("Authorised Signatory",style: fontSize8),
                                  ])
                          )

                        ]) ),
                ),


              ]),
              Container(
                  decoration:  BoxDecoration(
                    border: Border(
                      // top:borderStyle,
                      bottom:borderStyle,
                    ),
                  ),
                  child: Align(alignment: Alignment.bottomRight,child: Padding(padding: const EdgeInsets.only(right: 5),
                      child: Text("Page No: 1",style: fontSize8)))
              )

            ])
        )
      ],
    ),
  );

  log('------pdf-------');
  log(pdf.runtimeType.toString());

  // Return PDF as bytes.
  return pdf.save();
}



///New Design.
// Future<Uint8List> generatePdfDeliveryNote1(List<dynamic> responseData) async {
//   // print('----responseData-----');
//   // print(responseData);
//   print('--------responseData. length----------');
//   print(responseData.length);
//
//   ///Styles.
//   // TextStyle blueGrey200 = const TextStyle(color: PdfColors.blueGrey300);
//   TextStyle fontSize11WithBold =  TextStyle(fontWeight: FontWeight.bold,fontSize: 11);
//   TextStyle fontSize12WithBold =  TextStyle(fontWeight: FontWeight.bold,fontSize: 12);
//   //TextStyle fontSize9 =const TextStyle(fontSize: 9);
//   TextStyle fontSize8 =const TextStyle(fontSize: 8);
//   TextStyle fontSize8WidthBold =TextStyle(fontWeight: FontWeight.bold,fontSize: 8,color: PdfColors.black);
//
//   final pdf = Document();
//
//   // Load the image from assets
//   final image = MemoryImage(
//     (await rootBundle.load('assets/logo/jmi_logo.png')).buffer.asUint8List(),
//   );
//   BorderSide borderStyle= const BorderSide(color: PdfColors.black,width: 0.5);
//   pdf.addPage(
//     MultiPage(maxPages: 200,
//       margin:const EdgeInsets.all(40),
//       crossAxisAlignment: CrossAxisAlignment.start,
//       build: (context) => [
//         Column(children: [
//           Row(
//               //crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//             Image(image, width: 100, height: 100),
//             SizedBox(width: 10),
//             Column(
//                 //crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(' G-27 SIPCOT INDUSTRIAL PARK,IRUNGATTUKOTTAI,',style:fontSize11WithBold ),
//                   Text("SRIPERUMBUDUR, TAMIL NADU, 602105, STATE CODE :33",style: fontSize11WithBold),
//                   Text("GSTIN : 33AACCJ0197Q1Z7",style: fontSize11WithBold),
//                   SizedBox(height: 5),
//                   Text("DELIVERY CHALLAN- JOB ORDER",style: fontSize12WithBold),
//             ])
//           ]),
//           Container(
//               width: 1000,
//               //height: 800,
//               decoration:  BoxDecoration(
//                 border: Border(
//                   left: borderStyle,
//                   top:borderStyle,
//                   right:borderStyle,
//                   bottom:borderStyle,
//                 ),
//               ),
//               child: Column(children: [
//                 Container(
//                   height: 100,
//                     decoration:  BoxDecoration(
//                           border: Border(
//                             //top:borderStyle,
//                             bottom:borderStyle,
//                           ),
//                         ),
//                   child: Row(children: [
//                   Expanded(flex:1,
//                       child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
//                           child:Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("To:",style: fontSize8),
//                                 Padding(padding: const EdgeInsets.only(left: 15),
//                                     child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(height: 5),
//                                           Text('${responseData[0]['Supplier']??""}',style: fontSize8WidthBold),
//
//                                           // Text('JM FRICTECH INDIA PVT. LTD',style: fontSize8WidthBold),
//                                           // SizedBox(height: 5),
//                                           // Text(' G-27 SIPCOT INDUSTRIAL PARK , IRUNGATTUKOTTAI ,',style: fontSize8),
//                                           //     SizedBox(height: 5),
//                                           // Text('SRIPERUMBUDUR ,  602105',style: fontSize8),
//                                           //     SizedBox(height: 5),
//                                           // Text('Tamil Nadu ,  India - Phone: +914471131343 / 344',style: fontSize8),
//                                           //     SizedBox(height: 5),
//                                           // Text('GSTN No :33AACCJ0197Q1Z7',style: fontSize8),
//                                           //     SizedBox(height: 5),
//                                           // Text('State Name: Tamil Nadu,Code  : 33',style: fontSize8),
//                                         ])
//                                 )
//                               ]) )),
//                   Expanded(flex:1,
//                       child: Padding(padding: const EdgeInsets.only(top: 5,right: 5),
//                         child: Column(children: [
//                           Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text("DC No:",style: fontSize8WidthBold),
//                                 Text("${responseData[0]['MaterialDocument']??""}",style: fontSize8),
//                               ]),
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text("DC Date :",style: fontSize8WidthBold),
//                                 Text("",style: fontSize8),
//                               ])
//                         ])
//                       ))
//                 ]),),
//
//                 ///header
//                 //First.
//                 // Container(
//                 //   decoration:  BoxDecoration(
//                 //     border: Border(
//                 //       //top:borderStyle,
//                 //       bottom:borderStyle,
//                 //     ),
//                 //   ),
//                 //
//                 //   child:    Padding(padding: const EdgeInsets.only(top: 2,right: 10,bottom: 2),
//                 //       child:Align(alignment: Alignment.topRight,
//                 //           child:Text("ORIGINAL FOR RECIPIENT",style: fontSize8) ) ),
//                 // ),
//                 // //Second.
//                 // Row(crossAxisAlignment: CrossAxisAlignment.start,
//                 //     children: [
//                 //       Image(image, width: 100, height: 100),
//                 //       SizedBox(width: 70),
//                 //       Column(children: [
//                 //         SizedBox(height: 5),
//                 //         Text('JM FRICTECH INDIA PVT. LTD',style: fontSize8WidthBold),
//                 //         SizedBox(height: 5),
//                 //         Text(' G -94/2, SIPCOT INDUSTRIAL PARK,VALLAM VADAGAL',style: fontSize8),
//                 //         SizedBox(height: 5),
//                 //         Text("SRIPERUMBUDUR-602105",style: fontSize8),
//                 //         SizedBox(height: 5),
//                 //         Text('Tamil Nadu ,India-Phone: +914471131343 / 344 ',style: fontSize8),
//                 //         SizedBox(height: 5),
//                 //         Text('GSTN No :33AACCJ0197Q1Z7',style: fontSize8),
//                 //         SizedBox(height: 10),
//                 //       ])
//                 //     ]),
//                 // //Third
//                 // Container(
//                 //   decoration:  BoxDecoration(
//                 //     border: Border(
//                 //       top:borderStyle,
//                 //       bottom:borderStyle,
//                 //     ),
//                 //   ),
//                 //   child:   Align(alignment: Alignment.center,
//                 //       child:  Padding(padding: const EdgeInsets.only(top: 5,bottom: 5),
//                 //         child: Text("DELIVERY CHALLAN",style: fontSize8WidthBold),)
//                 //   ),
//                 // ),
//                 // //four
//                 // Row(children: [
//                 //   Expanded(flex: 2,child:Container(
//                 //       height: 120,
//                 //       //width: 400,
//                 //       decoration:  BoxDecoration(
//                 //         border: Border(
//                 //             right:borderStyle,
//                 //             bottom: borderStyle
//                 //         ),
//                 //       ),
//                 //       child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
//                 //           child:Column(
//                 //               crossAxisAlignment: CrossAxisAlignment.start,
//                 //               children: [
//                 //                 Text("To:",style: fontSize8),
//                 //                 Padding(padding: const EdgeInsets.only(left: 15),
//                 //                     child: Column(
//                 //                         crossAxisAlignment: CrossAxisAlignment.start,
//                 //                         children: [
//                 //                           SizedBox(height: 5),
//                 //                           Text('${responseData[0]['Supplier']??""}',style: fontSize8WidthBold),
//                 //
//                 //                           // Text('JM FRICTECH INDIA PVT. LTD',style: fontSize8WidthBold),
//                 //                           // SizedBox(height: 5),
//                 //                           // Text(' G-27 SIPCOT INDUSTRIAL PARK , IRUNGATTUKOTTAI ,',style: fontSize8),
//                 //                           //     SizedBox(height: 5),
//                 //                           // Text('SRIPERUMBUDUR ,  602105',style: fontSize8),
//                 //                           //     SizedBox(height: 5),
//                 //                           // Text('Tamil Nadu ,  India - Phone: +914471131343 / 344',style: fontSize8),
//                 //                           //     SizedBox(height: 5),
//                 //                           // Text('GSTN No :33AACCJ0197Q1Z7',style: fontSize8),
//                 //                           //     SizedBox(height: 5),
//                 //                           // Text('State Name: Tamil Nadu,Code  : 33',style: fontSize8),
//                 //                         ])
//                 //                 )
//                 //               ]) )
//                 //   ), ),
//                 //   Expanded(flex: 1,child:  Container(height: 120,
//                 //       decoration:  BoxDecoration(
//                 //         border: Border(
//                 //             right:borderStyle,
//                 //             bottom: borderStyle
//                 //         ),
//                 //       ),
//                 //
//                 //       child:Column(
//                 //           crossAxisAlignment: CrossAxisAlignment.start,
//                 //           children: [
//                 //             Padding(padding: const EdgeInsets.only(left: 5,top: 5),
//                 //               child:  Text("DC  No.",style: fontSize8),
//                 //             ),
//                 //
//                 //             Divider(thickness: 0.5,color: PdfColors.black),
//                 //
//                 //             Padding(padding: const EdgeInsets.only(left: 5,),
//                 //               child:  Text("DC Date",style: fontSize8),
//                 //             ),
//                 //           ]) ),
//                 //   ),
//                 //   Expanded(flex: 1,child: Container(height: 120,
//                 //       decoration:  BoxDecoration(
//                 //         border: Border(
//                 //             bottom: borderStyle
//                 //         ),
//                 //       ),
//                 //       child: Column(
//                 //           crossAxisAlignment: CrossAxisAlignment.start,
//                 //           children: [
//                 //             Padding(padding: const EdgeInsets.only(left: 5,top: 5),
//                 //               child:  Text("${responseData[0]['MaterialDocument']??""}",style: fontSize8),
//                 //             ),
//                 //
//                 //             Divider(thickness: 0.5,color: PdfColors.black),
//                 //
//                 //             Padding(padding: const EdgeInsets.only(left: 5,),
//                 //               child:  Text("",style: fontSize8),
//                 //               //Text("20/11/2023",style: fontSize8),
//                 //             ),
//                 //           ])
//                 //   ),)
//                 //
//                 // ]),
//                 // //five.
//                 // Container( height: 30,
//                 //     decoration:  BoxDecoration(
//                 //       border: Border(
//                 //         // top:borderStyle,
//                 //         bottom:borderStyle,
//                 //       ),
//                 //     ),
//                 //     child: Row(children: [
//                 //       Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                 //           child: Text('Mode Of Transport',style: fontSize8WidthBold))),
//                 //       Expanded(flex: 1,child: Text('Road',style: fontSize8)),
//                 //       Expanded(flex: 1,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //           children: [
//                 //             Container(height: 30,width: 0.5,color: PdfColors.black),
//                 //             Text('DC Type',style: fontSize8WidthBold),
//                 //             Container(height: 30,width: 0.5,color: PdfColors.black),
//                 //             //Padding(padding: EdgeInsets.only(left: 50),child: Container(height: 30,width: 0.5,color: PdfColors.black))
//                 //           ])),
//                 //       Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                 //           child:Text('',style: fontSize8)
//                 //         //Text('NON-RETURNABLE',style: fontSize8)
//                 //       ))
//                 //     ])
//                 // ),
//                 // //six
//                 // Container( height: 30,
//                 //     decoration:  BoxDecoration(
//                 //       border: Border(
//                 //         // top:borderStyle,
//                 //         bottom:borderStyle,
//                 //       ),
//                 //     ),
//                 //     child: Row(children: [
//                 //       Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                 //           child: Text('Vehicle No',style: fontSize8WidthBold))),
//                 //       Expanded(flex: 1,child: Text('BY HAND',style: fontSize8)),
//                 //       Expanded(flex: 1,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //
//                 //           children: [
//                 //             Container(height: 30,width: 0.5,color: PdfColors.black),
//                 //             Text('Ref No',style: fontSize8WidthBold),
//                 //             Container(height: 30,width: 0.5,color: PdfColors.black),
//                 //             // Padding(padding: EdgeInsets.only(left: 50),child: Container(height: 30,width: 0.5,color: PdfColors.black))
//                 //           ])),
//                 //       Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),child: Text('232405154',style: fontSize8)))
//                 //     ])
//                 // ),
//                 //seven.
//                //table header.
//
//                 Container(height: 25,
//                     decoration:  BoxDecoration(
//                       color: PdfColors.grey,
//                       border: Border(
//                         // top:borderStyle,
//                         bottom:borderStyle,
//                       ),
//                     ),
//                     child: Row(children: [
//                       Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                           child: Text('Sl.No',style: fontSize8WidthBold)
//                       )),
//                       Container(height: 25,width: 0.5,color: PdfColors.black),
//                       Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                           child: Text('Item Code',style: fontSize8WidthBold)
//                       )),
//                       Container(height: 25,width: 0.5,color: PdfColors.black),
//                       Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                           child: Text('Description',style: fontSize8WidthBold)
//                       )),
//                       Container(height: 25,width: 0.5,color: PdfColors.black),
//                       Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                           child: Text('HSN',style: fontSize8WidthBold)
//                       )),
//                       Container(height: 25,width: 0.5,color: PdfColors.black),
//                       Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
//                           child:  Text('GST%',style: fontSize8WidthBold))),
//                       Container(height: 25,width: 0.5,color: PdfColors.black),
//                       Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
//                           child:  Text('Rate',style: fontSize8WidthBold))),
//                       Container(height: 25,width: 0.5,color: PdfColors.black),
//                       Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
//                           child:  Text('Qty',style: fontSize8WidthBold)
//                       )),
//                       Container(height: 25,width: 0.5,color: PdfColors.black),
//                       Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                           child: Text('UoM',style: fontSize8WidthBold))),
//                       Container(height: 25,width: 0.5,color: PdfColors.black),
//                       Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//
//                           child: Text('Road',style: fontSize8WidthBold))),
//                       Container(height: 25,width: 0.5,color: PdfColors.black),
//                       Expanded(flex: 1,child:Padding(padding: const EdgeInsets.only(left: 5),
//                           child:  Text('Amount',style: fontSize8WidthBold)
//                       )),
//                     ])
//                 ),
//                 for(int i=0;i<responseData.length;i++)
//                   LayoutBuilder(
//                     builder: (context, constraints) {
//                       return Column(
//                           children: [
//                             Container(height: 25,
//                                 decoration:  BoxDecoration(
//                                   border: Border(
//                                     // top:borderStyle,
//                                     bottom:borderStyle,
//                                   ),
//                                 ),
//                                 child: Row(children: [
//                                   Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                                       child: Text('${i+1}',style: fontSize8)
//                                   )),
//                                   // Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                                   //     child: Text('1',style: fontSize8)
//                                   // )),
//                                   Container(height: 25,width: 0.5,color: PdfColors.black),
//                                   // Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                                   //     child: Text('SPARE/QALAB/0007',style: fontSize8)
//                                   // )),
//                                   Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                                       child: Text('${responseData[i]['Material']??""}',style: fontSize8)
//                                   )),
//                                   Container(height: 25,width: 0.5,color: PdfColors.black),
//                                   Expanded(flex: 1,child: Padding(padding:const EdgeInsets.only(left: 5),
//                                       child: Text("")
//                                     //Text('NB26061-LEVER-1 NOS',style: fontSize8)
//                                   )),
//                                   Container(height: 25,width: 0.5,color: PdfColors.black),
//                                   Expanded(flex: 1,child: Padding(padding: const EdgeInsets.only(left: 5),
//                                     child: Text("${responseData[i]['ConsumptionTaxCtrlCode']??""}",style: fontSize8),
//                                     //Text('90.24.1000',style: fontSize8)
//                                   )),
//                                   Container(height: 25,width: 0.5,color: PdfColors.black),
//                                   Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 5),
//                                     child:  Text("",style: fontSize8),
//                                     //Text('18 %',style: fontSize8)
//                                   )),
//                                   Container(height: 25,width: 0.5,color: PdfColors.black),
//                                   Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 5),
//                                       child:  Text('${responseData[i]['StandardPrice']??""}',style: fontSize8)
//                                   )),
//                                   Container(height: 25,width: 0.5,color: PdfColors.black),
//                                   Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 5),
//                                       child:  Text('${responseData[i]['QuantityInBaseUnit']??""}',style: fontSize8)
//                                   )),
//                                   Container(height: 25,width: 0.5,color: PdfColors.black),
//                                   Expanded(flex: 1,child: Padding(padding:const EdgeInsets.only(left: 5),
//                                     child:Text("",style: fontSize8),
//                                     //Text('NOS',style: fontSize8)
//                                   )),
//                                   Container(height: 25,width: 0.5,color: PdfColors.black),
//                                   Expanded(flex: 1,child: Padding(padding:const EdgeInsets.only(left: 5),
//                                     child:Text("",style: fontSize8),
//                                     //Text('1.00',style: fontSize8)
//                                   )),
//                                   Container(height: 25,width: 0.5,color: PdfColors.black),
//                                   Expanded(flex: 1,child:Padding(padding:const EdgeInsets.only(left: 5),
//                                     child: Text("",style: fontSize8),
//                                     //Text('200.00',style: fontSize8)
//                                   )),
//                                 ])
//                             ),
//                           ]
//                       );
//                     },),
//                 Row(children: [
//                   Expanded(flex: 3,child:Container(
//                       height: 100,
//                       //width: 400,
//                       decoration:  BoxDecoration(
//                         border: Border(
//                             right:borderStyle,
//                             bottom: borderStyle
//                         ),
//                       ),
//                       child: Padding(padding: const EdgeInsets.only(left: 5,top:5 ),
//                           child:Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(children: [
//                                   Text('Purpose of Transport',style: fontSize8WidthBold),
//                                   Text(":"),
//                                   Text("FOR REF NO: 232436584",style: fontSize8WidthBold),
//
//                                 ])
//                               ]) )
//                   ), ),
//                   Expanded(flex: 1,child:  Container(height: 100,
//                       decoration:  BoxDecoration(
//                         border: Border(
//                             right:borderStyle,
//                             bottom: borderStyle
//                         ),
//                       ),
//
//                       child:Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(height: 25,width: 120,
//                               decoration:  BoxDecoration(
//                                 border: Border(
//                                     bottom: borderStyle
//                                 ),
//                               ),
//                               child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
//                                 child: Text("Taxable Amount",style: fontSize8WidthBold),
//                                 //Text("200.00",style: fontSize8WidthBold),
//                               ),),
//
//                             Container(height: 25,width: 120,
//                               decoration:  BoxDecoration(
//                                 border: Border(
//                                     bottom: borderStyle
//                                 ),
//                               ),
//                               child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
//                                 child: Text("CGST 9%",style: fontSize8WidthBold),
//                                 //Text("200.00",style: fontSize8WidthBold),
//                               ),),
//                             Container(height: 25,width: 120,
//                               decoration:  BoxDecoration(
//                                 border: Border(
//                                     bottom: borderStyle
//                                 ),
//                               ),
//                               child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
//                                 child: Text("SGST 9%",style: fontSize8WidthBold),
//                                 //Text("200.00",style: fontSize8WidthBold),
//                               ),),
//
//                             Padding(padding: const EdgeInsets.only(left: 5,),
//                               child:  Text("Total Amount",style: fontSize8WidthBold),
//                             ),
//                           ]) ),
//                   ),
//                   Expanded(flex: 1,child: Container(height: 100,
//                       decoration:  BoxDecoration(
//                         border: Border(
//                             bottom: borderStyle
//                         ),
//                       ),
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(height: 25,width: 120,
//                               decoration:  BoxDecoration(
//                                 border: Border(
//                                     bottom: borderStyle
//                                 ),
//                               ),
//                               child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
//                                 child: Text("",style: fontSize8),
//                                 //Text("200.00",style: fontSize8WidthBold),
//                               ),),
//
//
//                             Container(height: 25,width: 120,
//                               decoration:  BoxDecoration(
//                                 border: Border(
//                                     bottom: borderStyle
//                                 ),
//                               ),
//                               child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
//                                 child: Text("",style: fontSize8),
//                                 //Text("200.00",style: fontSize8WidthBold),
//                               ),),
//
//                             Container(height: 25,width: 120,
//                               decoration:  BoxDecoration(
//                                 border: Border(
//                                     bottom: borderStyle
//                                 ),
//                               ),
//                               child:   Padding(padding: const EdgeInsets.only(left: 5,top: 5),
//                                 child: Text("",style: fontSize8),
//                                 //Text("200.00",style: fontSize8WidthBold),
//                               ),),
//
//                             Padding(padding: const EdgeInsets.only(left: 5,),
//                               child:Text("",style: fontSize8),
//                               //Text("236.00",style: fontSize8),
//                             ),
//                           ])
//                   ),)
//
//                 ]),
//                 Container(height: 25,
//                     decoration:  BoxDecoration(
//                       border: Border(
//                         // top:borderStyle,
//                         bottom:borderStyle,
//                       ),
//                     ),
//                     child: Padding(padding: const EdgeInsets.only(left: 5),
//                         child: Row(children: [
//                           Text('Total CGST value Payable (in words)',style: fontSize8WidthBold),
//                           Text(" :",style: fontSize8WidthBold),
//                           // Text('Rs.  Eighteen Only',style: fontSize8)
//                           Text("",style: fontSize8),
//                         ])
//                     )
//                 ),
//                 Container(height: 25,
//                     decoration:  BoxDecoration(
//                       border: Border(
//                         // top:borderStyle,
//                         bottom:borderStyle,
//                       ),
//                     ),
//                     child: Padding(padding: const EdgeInsets.only(left: 5),
//                         child: Row(children: [
//                           Text('Total SGST value Payable (in words)',style: fontSize8WidthBold),
//                           Text(" :",style: fontSize8WidthBold),
//                           //Text('Rs.  Eighteen Only',style: fontSize8)
//                           Text("",style: fontSize8),
//                         ])
//                     )
//                 ),
//                 Container(height: 25,
//                     decoration:  BoxDecoration(
//                       border: Border(
//                         // top:borderStyle,
//                         bottom:borderStyle,
//                       ),
//                     ),
//                     child: Padding(padding: const EdgeInsets.only(left: 5),
//                         child: Row(children: [
//                           Text('Total Amount (in Words) ',style: fontSize8WidthBold),
//                           Text(" :",style: fontSize8WidthBold),
//                           Text("",style: fontSize8),
//                           // Text('Rs.  Two Hundred Thirty-Six Only',style: fontSize8)
//                         ])
//                     )
//                 ),
//                 Container(height: 25,
//                     decoration:  BoxDecoration(
//                       border: Border(
//                         // top:borderStyle,
//                         bottom:borderStyle,
//                       ),
//                     ),
//                     child: Padding(padding: const EdgeInsets.only(left: 5),
//                         child: Row(
//                             children: [
//                               Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('Special Instruction',style: fontSize8WidthBold),
//                                     SizedBox(height: 5),
//                                     Text(' Kindly return the parts with above mentioned time period with proper Document and mentioned our DC number in your dispatch document',style: fontSize8)
//                                   ])
//                             ]
//                         )
//                     )
//                 ),
//                 Container(height: 25,
//                     decoration:  BoxDecoration(
//                       border: Border(
//                         // top:borderStyle,
//                         bottom:borderStyle,
//                       ),
//                     ),
//                     child: Padding(padding: const EdgeInsets.only(left: 5),
//                         child: Row(children: [
//                           Text('Remarks',style: fontSize8WidthBold),
//                           Text(" :",style: fontSize8WidthBold),
//                           //Text('Rs.  Two Hundred Thirty-Six Only',style: fontSize8)
//                         ])
//                     )
//                 ),
//
//                 Row(children: [
//                   Expanded(flex: 2,child:Container(
//                       height: 100,
//                       //width: 400,
//                       decoration:  BoxDecoration(
//                         border: Border(
//                             right:borderStyle,
//                             bottom: borderStyle
//                         ),
//                       ),
//                       child: Padding(padding: EdgeInsets.only(left: 5,top:5 ),
//                           child:Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Received the above goods in good condition",style: fontSize8),
//                                 Padding(padding: EdgeInsets.only(left: 15),
//                                     child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(height: 50),
//                                           Text('Receiver Signature With Seal',style: fontSize8),
//                                         ])
//                                 )
//                               ]) )
//                   ), ),
//                   Expanded(flex: 3,child:  Container(height: 100,
//                       decoration:  BoxDecoration(
//                         border: Border(
//                             right:borderStyle,
//                             bottom: borderStyle
//                         ),
//                       ),
//
//                       child:Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 5),
//                             Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text("For",style: fontSize8),
//                                   SizedBox(width: 5),
//                                   Text("JM FRICTECH INDIA PVT. LTD",style: fontSize8WidthBold),
//                                   SizedBox(width: 5),
//                                 ]),
//                             SizedBox(height: 50),
//                             Padding(padding: const EdgeInsets.only(left: 5,right: 5,
//                             ),
//                                 child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text("Prepared By ",style: fontSize8),
//                                       Text("Authorised Signatory",style: fontSize8),
//                                     ])
//                             )
//
//                           ]) ),
//                   ),
//
//
//                 ]),
//                 Container(
//                     decoration:  BoxDecoration(
//                       border: Border(
//                         // top:borderStyle,
//                         bottom:borderStyle,
//                       ),
//                     ),
//                     child: Align(alignment: Alignment.bottomRight,child: Padding(padding: EdgeInsets.only(right: 5),
//                         child: Text("Page No: 1",style: fontSize8)))
//                 )
//               ])
//           )
//         ]),
//
//       ],
//     ),
//   );
//
//   log('------pdf-------');
//   log(pdf.runtimeType.toString());
//
//   // Return PDF as bytes.
//   return pdf.save();
// }
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jml/inward/add_inward.dart';
import 'package:jml/inward/edit_inward.dart';
import 'package:jml/utils/custom_appbar.dart';
import 'package:jml/utils/custom_drawer.dart';
import 'package:jml/utils/custom_loader.dart';
import 'package:jml/widgets/outlined_mbutton.dart';

import '../utils/jml_colors.dart';

class InwardList extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const InwardList({
    required this.drawerWidth,
    required this.selectedDestination,
    super.key
  });

  @override
  State<InwardList> createState() => _InwardListState();
}

class _InwardListState extends State<InwardList> {

  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();

  final searchVehicleNo = TextEditingController();
  final searchVehicleInTime = TextEditingController();
  final searchInvoiceNo = TextEditingController();
  final searchInvoiceDate = TextEditingController();
  final searchEntryDate = TextEditingController();
  final searchEntryTime = TextEditingController();


  bool loading = false;
  List inwardList = [
    {
      "gateInwardNo": "GI123",
      "entryDate": "26-03-2024",
      "entryTime": "09:00 AM",
      "plant": "Plant A",
      "vehicleNumber": "ABC123",
      "vehicleInTime": "08:30 AM",
      "supplierCode": "S123",
      "supplierName": "Supplier X",
      "purchaseOrderNo": "PO456",
      "purchaseOrderType": "Type A",
      "invoiceNo": "INV789",
      "invoiceDate": "27-03-2024",
      "entredBy": "User123",
      "remarks": "Sample remarks",
      "canceledBy": "yes",
      "receivedBy": "Receiver123"
    },
    {
      "gateInwardNo": "GI456",
      "entryDate": "26-03-2024",
      "entryTime": "10:30 AM",
      "plant": "Plant B",
      "vehicleNumber": "XYZ456",
      "vehicleInTime": "10:00 AM",
      "supplierCode": "S456",
      "supplierName": "Supplier Y",
      "purchaseOrderNo": "PO789",
      "purchaseOrderType": "Type B",
      "invoiceNo": "INV101",
      "invoiceDate": "25-03-2024",
      "entredBy": "User456",
      "remarks": "Another sample remark",
      "canceledBy": "no",
      "receivedBy": "Receiver789"
    },
    {
      "gateInwardNo": "GI789",
      "entryDate": "28-03-2024",
      "entryTime": "11:45 AM",
      "plant": "Plant C",
      "vehicleNumber": "DEF789",
      "vehicleInTime": "11:15 AM",
      "supplierCode": "S789",
      "supplierName": "Supplier Z",
      "purchaseOrderNo": "PO123",
      "purchaseOrderType": "Type C",
      "invoiceNo": "INV112",
      "invoiceDate": "27-03-2024",
      "entredBy": "User789",
      "remarks": "Additional remarks",
      "canceledBy": "yes",
      "receivedBy": "ReceiverABC"
    },
    {
      "gateInwardNo": "GI101",
      "entryDate": "29-03-2024",
      "entryTime": "01:30 PM",
      "plant": "Plant D",
      "vehicleNumber": "GHI101",
      "vehicleInTime": "01:00 PM",
      "supplierCode": "S101",
      "supplierName": "Supplier W",
      "purchaseOrderNo": "PO234",
      "purchaseOrderType": "Type D",
      "invoiceNo": "INV345",
      "invoiceDate": "28-03-2024",
      "entredBy": "User101",
      "remarks": "More remarks here",
      "canceledBy": "no",
      "receivedBy": "ReceiverDEF"
    },
  ];
  List filteredList = [];
  int startVal=0;
  late double drawerWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    drawerWidth = 60.0;
    if(filteredList.isEmpty){
      if(inwardList.length > 15){
        for(int i=0; i<startVal+15; i++){
          filteredList.add(inwardList[i]);
        }
      } else{
        for(int i=0; i<inwardList.length; i++){
          filteredList.add(inwardList[i]);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar()
      ),
      body: Row(
        children: [
          CustomDrawer(drawerWidth, widget.selectedDestination),
          const VerticalDivider(width: 1,thickness: 1),
          Expanded(
            child: Scaffold(
              backgroundColor: const Color(0xffF0F4F8),
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(88.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: AppBar(
                      elevation: 1,
                      surfaceTintColor: Colors.white,
                      shadowColor: Colors.black,
                      title: const Text("Inward List"),
                      centerTitle: true,
                    ),
                  )
              ),
              body: CustomLoader(
                  inAsyncCall: loading,
                child: AdaptiveScrollbar(
                  underColor: Colors.blueGrey.withOpacity(0.3),
                  sliderDefaultColor: Colors.grey.withOpacity(0.7),
                  sliderActiveColor: Colors.grey,
                  controller: _verticalScrollController,
                  child: AdaptiveScrollbar(
                    position: ScrollbarPosition.bottom,
                    underColor: Colors.blueGrey.withOpacity(0.3),
                    sliderDefaultColor: Colors.grey.withOpacity(0.7),
                    sliderActiveColor: Colors.grey,
                    controller: _horizontalScrollController,
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                // width: MediaQuery.of(context).size.width/1.2,
                                width: 1200,
                                child: Card(
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(
                                        color: mTextFieldBorder.withOpacity(0.8),
                                        width: 1
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(
                                              height: 40,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 26,top: 12,right: 0),
                                                child: Text("Inward List", style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 35,
                                              width: 120,
                                              child: OutlinedMButton(
                                                text: "+  New Inward",
                                                buttonColor: mSaveButton,
                                                textColor: Colors.white,
                                                borderColor: mSaveButton,
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>  AddInward(
                                                        drawerWidth: widget.drawerWidth,
                                                        selectedDestination: widget.selectedDestination,
                                                      ),)
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20, top: 0, bottom: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              width: 150,
                                             child: TextFormField(
                                               style: const TextStyle(fontSize: 11),
                                               controller: searchVehicleNo,
                                               decoration: searchVehicleNoDecoration(hintText: "Search Vehicle No"),
                                               onChanged: (value) {
                                                 if(value.isEmpty || value == ""){
                                                   startVal = 0;
                                                   filteredList = [];
                                                   setState(() {
                                                     if(inwardList.length > 15){
                                                       for(int i=0; i < startVal + 15; i++){
                                                         filteredList.add(inwardList[i]);
                                                       }
                                                     } else{
                                                       for(int i=0; i < inwardList.length; i++){
                                                         filteredList.add(inwardList[i]);
                                                       }
                                                     }
                                                   });
                                                 } else{
                                                   startVal = 0;
                                                   filteredList = [];
                                                   fetchVehicleNo(searchVehicleNo.text);
                                                 }
                                               },
                                             ),
                                            ),
                                            const SizedBox(width: 20,),
                                            SizedBox(
                                              height: 30,
                                              width: 150,
                                              child: TextFormField(
                                                style: const TextStyle(fontSize: 11),
                                                controller: searchInvoiceNo,
                                                decoration: searchInvoiceNoDecoration(hintText: "Search Invoice No"),
                                                onChanged: (value) {
                                                  if(value.isEmpty || value == ""){
                                                    startVal = 0;
                                                    filteredList = [];
                                                    setState(() {
                                                      if(inwardList.length > 15){
                                                        for(int i=0; i < startVal + 15; i++){
                                                          filteredList.add(inwardList[i]);
                                                        }
                                                      } else{
                                                        for(int i=0; i < inwardList.length; i++){
                                                          filteredList.add(inwardList[i]);
                                                        }
                                                      }
                                                    });
                                                  } else{
                                                    startVal = 0;
                                                    filteredList = [];
                                                    fetchInvoiceNo(searchInvoiceNo.text);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20, top: 0, bottom: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              width: 150,
                                              child: TextFormField(
                                                style: const TextStyle(fontSize: 11),
                                                controller: searchInvoiceDate,
                                                decoration: invoiceDateFieldDecoration(controller: searchInvoiceDate, hintText: "Select Invoice Date"),
                                                onTap: () {
                                                  setState(() {
                                                    if(searchInvoiceDate.text.isEmpty || searchInvoiceDate.text == ""){
                                                      startVal = 0;
                                                      filteredList = inwardList;
                                                    }
                                                    selectInvoiceDate(context: context);
                                                    searchVehicleNo.clear();
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 20,),
                                            SizedBox(
                                              height: 30,
                                              width: 150,
                                              child: TextFormField(
                                                style: const TextStyle(fontSize: 11),
                                                controller: searchEntryDate,
                                                decoration: entryDateFieldDecoration(controller: searchEntryDate, hintText: "Select Entry Date"),
                                                onTap: () {
                                                  setState(() {
                                                    if(searchEntryDate.text.isEmpty || searchEntryDate.text == ""){
                                                      startVal = 0;
                                                      filteredList = inwardList;
                                                    }
                                                    selectEntryDate(context: context);
                                                    // searchVehicleNo.clear();
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20, top: 0, bottom: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              width: 150,
                                              child: TextFormField(
                                                style: const TextStyle(fontSize: 11),
                                                controller: searchEntryTime,
                                                decoration: entryTimeFieldDecoration(controller: searchEntryTime, hintText: "Select Entry Time"),
                                                onTap: () {
                                                  setState(() {
                                                    if(searchEntryTime.text.isEmpty || searchEntryTime.text == ""){
                                                      startVal = 0;
                                                      filteredList = inwardList;
                                                    }
                                                    selectEntryTime(context);
                                                    // searchVehicleNo.clear();
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 20,),
                                            SizedBox(
                                              height: 30,
                                              width: 150,
                                              child: TextFormField(
                                                style: const TextStyle(fontSize: 11),
                                                controller: searchVehicleInTime,
                                                decoration: vehicleInTimeFieldDecoration(controller: searchVehicleInTime, hintText: "Select Vehicle In-Time"),
                                                onTap: () {
                                                  setState(() {
                                                    if(searchVehicleInTime.text.isEmpty || searchVehicleInTime.text == ""){
                                                      startVal = 0;
                                                      filteredList = inwardList;
                                                    }
                                                    selectVehicleInTime(context);
                                                    // searchVehicleNo.clear();
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                      Container(
                                        color: Colors.grey[100],
                                        height: 32,
                                        child: const Padding(
                                          padding: EdgeInsets.only(left: 18.0, top: 5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(
                                                    height: 25,
                                                    // width: 150,
                                                    child: Text("Gate Inward No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(
                                                    height: 25,
                                                    // width: 150,
                                                    child: Text("Vehicle Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(
                                                    height: 25,
                                                    // width: 150,
                                                    child: Text("Vehicle In-Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(
                                                    height: 25,
                                                    // width: 150,
                                                    child: Text("Invoice No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(
                                                    height: 25,
                                                    // width: 150,
                                                    child: Text("Invoice Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 4.0),
                                                  child: SizedBox(
                                                    height: 25,
                                                    width: 150,
                                                    child: Text("PO Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                  ),
                                                ),
                                              ),
                                              Center(child: Padding(
                                                padding: EdgeInsets.only(right: 8),
                                                child: Icon(size: 18,
                                                  Icons.more_vert,
                                                  color: Colors.transparent,
                                                ),
                                              ),)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(height: 0.5,color: Colors.grey[500],thickness: 0.5,),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: filteredList.length,
                                        itemBuilder: (context, i) {
                                          if(i < filteredList.length){
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                MaterialButton(
                                                  hoverColor: Colors.blue[50],
                                                  onPressed: () {
                                                    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => EditInward(
                                                        drawerWidth: drawerWidth,
                                                        selectedDestination: widget.selectedDestination,
                                                      inwardMap: filteredList[i],
                                                    ),));
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 18.0,top: 4,bottom: 3),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 4.0),
                                                            child: SizedBox(
                                                              // height: 25,
                                                              child: Text(filteredList[i]['gateInwardNo']??"",style: const TextStyle(fontSize: 11)),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 4.0),
                                                            child: SizedBox(
                                                              // height: 25,
                                                              child: Text(filteredList[i]['vehicleNumber']??"",style: const TextStyle(fontSize: 11)),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 4.0),
                                                            child: SizedBox(
                                                              // height: 25,
                                                              child: Text(filteredList[i]['vehicleInTime']??"",style: const TextStyle(fontSize: 11)),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 4.0),
                                                            child: SizedBox(
                                                              // height: 25,
                                                              child: Text(filteredList[i]['invoiceNo']??"",style: const TextStyle(fontSize: 11)),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 4.0),
                                                            child: SizedBox(
                                                              // height: 25,
                                                              child: Text(filteredList[i]['invoiceDate']??"",style: const TextStyle(fontSize: 11)),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 4.0),
                                                            child: SizedBox(
                                                              // height: 25,
                                                              child: Text(filteredList[i]['purchaseOrderNo']??"",style: const TextStyle(fontSize: 11)),
                                                            ),
                                                          ),
                                                        ),
                                                        const Center(child: Padding(
                                                          padding: EdgeInsets.only(right: 8),
                                                          child: Icon(size: 18,
                                                            Icons.arrow_circle_right,
                                                            color: Colors.blue,
                                                          ),
                                                        ),)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  invoiceDateFieldDecoration( {required TextEditingController controller, required String hintText, bool? error, Function? onTap}) {
    return  InputDecoration(
      constraints: BoxConstraints(maxHeight: error==true ? 50:30),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      // suffixIcon: const Icon(Icons.calendar_month, size: 16, color: Colors.grey,),
      suffixIcon: searchInvoiceDate.text.isEmpty?const Icon(Icons.calendar_month, size: 16, color: Colors.grey,):InkWell(
          onTap: (){
            setState(() {
              searchInvoiceDate.clear();
              filteredList = inwardList;
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  entryDateFieldDecoration( {required TextEditingController controller, required String hintText, bool? error, Function? onTap}) {
    return  InputDecoration(
      constraints: BoxConstraints(maxHeight: error==true ? 50:30),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      // suffixIcon: const Icon(Icons.calendar_month, size: 16, color: Colors.grey,),
      suffixIcon: searchEntryDate.text.isEmpty?const Icon(Icons.calendar_month, size: 16, color: Colors.grey,):InkWell(
          onTap: (){
            setState(() {
              searchEntryDate.clear();
              filteredList = inwardList;
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  entryTimeFieldDecoration( {required TextEditingController controller, required String hintText, bool? error, Function? onTap}) {
    return  InputDecoration(
      constraints: BoxConstraints(maxHeight: error==true ? 50:30),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      // suffixIcon: const Icon(Icons.calendar_month, size: 16, color: Colors.grey,),
      suffixIcon: searchEntryTime.text.isEmpty?const Icon(Icons.watch_later_outlined, size: 16, color: Colors.grey,):InkWell(
          onTap: (){
            setState(() {
              searchEntryTime.clear();
              filteredList = inwardList;
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  vehicleInTimeFieldDecoration( {required TextEditingController controller, required String hintText, bool? error, Function? onTap}) {
    return  InputDecoration(
      constraints: BoxConstraints(maxHeight: error==true ? 50:30),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      // suffixIcon: const Icon(Icons.calendar_month, size: 16, color: Colors.grey,),
      suffixIcon: searchVehicleInTime.text.isEmpty?const Icon(Icons.watch_later_outlined, size: 16, color: Colors.grey,):InkWell(
          onTap: (){
            setState(() {
              searchVehicleInTime.clear();
              filteredList = inwardList;
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }

  searchVehicleNoDecoration({required String hintText, bool? error}){
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: searchVehicleNo.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              searchVehicleNo.clear();
              filteredList = inwardList;
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }
  searchInvoiceNoDecoration({required String hintText, bool? error}){
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: searchInvoiceNo.text.isEmpty?const Icon(Icons.search,size: 18):InkWell(
          onTap: (){
            setState(() {
              searchInvoiceNo.clear();
              filteredList = inwardList;
            });
          },
          child: const Icon(Icons.close,size: 14,)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints:  const BoxConstraints(maxHeight:35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :mTextFieldBorder)),
      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color:error==true? mErrorColor :Colors.blue)),
    );
  }

  void fetchVehicleNo(String vehicleNo) {
    if(inwardList.isNotEmpty && vehicleNo.isNotEmpty){
      setState(() {
        filteredList = inwardList.where((vehicle) => vehicle["vehicleNumber"].toLowerCase().contains(vehicleNo.toLowerCase())).toList();
      });
    }
  }
  void fetchInvoiceNo(String invoiceNo) {
    if(inwardList.isNotEmpty && invoiceNo.isNotEmpty){
      setState(() {
        filteredList = inwardList.where((invoice) => invoice["invoiceNo"].toLowerCase().contains(invoiceNo.toLowerCase())).toList();
      });
    }
  }
  void fetchInvoiceDate(DateTime selectedDate){
    if(inwardList.isNotEmpty && selectedDate != null){
      String formattedDate = "${selectedDate.day}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(2, '0')}";
      setState(() {
        filteredList = inwardList.where((item) => item['invoiceDate'] == formattedDate).toList();
      });
    }
  }
  void fetchEntryDate(DateTime selectedDate){
    if(inwardList.isNotEmpty && selectedDate != null){
      String formattedDate = "${selectedDate.day}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(2, '0')}";
      setState(() {
        filteredList = inwardList.where((item) => item['entryDate'] == formattedDate).toList();
      });
    }
  }
  void fetchEntryTime(DateTime selectedTime){
    if(inwardList.isNotEmpty && selectedTime != null){
      String formattedTime = DateFormat('hh:mm a').format(selectedTime);
      setState(() {
        filteredList = inwardList.where((item) => item['entryTime'] == formattedTime).toList();
      });
    }
  }
  void fetchVehicleInTime(DateTime selectedTime){
    if(inwardList.isNotEmpty && selectedTime != null){
      String formattedTime = DateFormat('hh:mm a').format(selectedTime);
      setState(() {
        filteredList = inwardList.where((item) => item['vehicleInTime'] == formattedTime).toList();
      });
    }
  }

  selectInvoiceDate({required BuildContext context}) async{
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
    );
    if(pickedDate == null) {
      return;
    }
    // datePicker.text = DateFormat("dd-MM-yyyy").format(pickedDate);
    String formattedDate = DateFormat("dd-MM-yyyy").format(pickedDate);
    searchInvoiceDate.text = formattedDate;
    fetchInvoiceDate(pickedDate);
  }
  selectEntryDate({required BuildContext context}) async{
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
    );
    if(pickedDate == null) {
      return;
    }
    // datePicker.text = DateFormat("dd-MM-yyyy").format(pickedDate);
    String formattedDate = DateFormat("dd-MM-yyyy").format(pickedDate);
    searchEntryDate.text = formattedDate;
    fetchEntryDate(pickedDate);
  }
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay _time2 = TimeOfDay.now();
  late TimeOfDay picked;
  late TimeOfDay picked2;
   selectEntryTime(BuildContext context)async{
    picked = (await showTimePicker(
        context: context,
        initialTime: _time
    ))!;
    setState(() {
      _time = picked;
      // String formattedTime = '${picked.hour}:${picked.minute}';
      String formattedTime = DateFormat('hh:mm a').format(DateTime(0, 0, 0, picked.hour, picked.minute));
      searchEntryTime.text = formattedTime;
      fetchEntryTime(DateTime(0, 0, 0, picked.hour, picked.minute));
    });
  }
   selectVehicleInTime(BuildContext context)async{
     picked2 = (await showTimePicker(
        context: context,
        initialTime: _time2
    ))!;
    setState(() {
      _time2 = picked2;
      // String formattedTime = '${picked.hour}:${picked.minute}';
      String formattedTime = DateFormat('hh:mm a').format(DateTime(0, 0, 0, picked2.hour, picked2.minute));
      searchVehicleInTime.text = formattedTime;
      fetchVehicleInTime(DateTime(0, 0, 0, picked2.hour, picked2.minute));
    });
  }
}

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jml/outward/add_outward.dart';
import 'package:jml/outward/edit_outward.dart';
import 'package:jml/utils/custom_loader.dart';

import '../utils/custom_appbar.dart';
import '../utils/custom_drawer.dart';
import '../utils/jml_colors.dart';
import '../widgets/outlined_mbutton.dart';

class OutwardList extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  final String plantValue;
  const OutwardList({
    required this.drawerWidth,
    required this.selectedDestination,
    required this.plantValue,
    super.key
  });

  @override
  State<OutwardList> createState() => _OutwardListState();
}

class _OutwardListState extends State<OutwardList> {

  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();

  final searchVehicleNo = TextEditingController();
  final searchVehicleOutTime = TextEditingController();
  final searchInvoiceNo = TextEditingController();
  final searchInvoiceDate = TextEditingController();
  final searchEntryDate = TextEditingController();
  final searchEntryTime = TextEditingController();

  List filteredList = [];
  int startVal=0;
  bool loading = false;
  List outwardList = [
    {
      "gateOutwardNo": "GO001",
      "entryDate": "25-03-2024",
      "entryTime": "09:30 AM",
      "plant": "Plant A",
      "vehicleNo": "ABC123",
      "vehicleOutTime": "05:45 PM",
      "invoiceNo": "INV001",
      "invoiceDate": "24-03-2024",
      "supplierCode": "SUP001",
      "supplierName": "Supplier X",
      "invoiceType": "Type A",
      "entredBy": "John Doe",
      "remarks": "Delivered goods to customer",
    },
    {
      "gateOutwardNo": "GO002",
      "entryDate": "26-03-2024",
      "entryTime": "10:15 AM",
      "plant": "Plant B",
      "vehicleNo": "XYZ789",
      "vehicleOutTime": "03:30 PM",
      "invoiceNo": "INV002",
      "invoiceDate": "25-03-2024",
      "supplierCode": "SUP002",
      "supplierName": "Supplier Y",
      "invoiceType": "Type B",
      "entredBy": "Jane Smith",
      "remarks": "Shipped products to warehouse",
    },
    {
      "gateOutwardNo": "GO003",
      "entryDate": "27-03-2024",
      "entryTime": "11:00 AM",
      "plant": "Plant C",
      "vehicleNo": "DEF456",
      "vehicleOutTime": "06:00 PM",
      "invoiceNo": "INV003",
      "invoiceDate": "26-03-2024",
      "supplierCode": "SUP003",
      "supplierName": "Supplier Z",
      "invoiceType": "Type C",
      "entredBy": "Alice Johnson",
      "remarks": "Dispatched order to customer",
    },
    {
      "gateOutwardNo": "GO004",
      "entryDate": "28-03-2024",
      "entryTime": "09:45 AM",
      "plant": "Plant D",
      "vehicleNo": "GHI789",
      "vehicleOutTime": "04:15 PM",
      "invoiceNo": "INV004",
      "invoiceDate": "27-03-2024",
      "supplierCode": "SUP004",
      "supplierName": "Supplier W",
      "invoiceType": "Type D",
      "entredBy": "Bob Williams",
      "remarks": "Distributed goods to retailers",
    },
  ];
  late double drawerWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(filteredList.isEmpty){
      if(outwardList.length > 15){
        for(int i=0; i<startVal+15; i++){
          filteredList.add(outwardList[i]);
        }
      } else{
        for(int i=0; i<outwardList.length; i++){
          filteredList.add(outwardList[i]);
        }
      }
    }
    drawerWidth = 60.0;
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
          CustomDrawer(drawerWidth, widget.selectedDestination, widget.plantValue),
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
                      title: const Text("Outward List"),
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
                                                child: Text("Outward List", style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 35,
                                              width: 120,
                                              child: OutlinedMButton(
                                                text: "+  New Outward",
                                                buttonColor: mSaveButton,
                                                textColor: Colors.white,
                                                borderColor: mSaveButton,
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) =>  AddOutward(
                                                        drawerWidth: widget.drawerWidth,
                                                        selectedDestination: widget.selectedDestination,
                                                        plantValue: widget.plantValue,
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
                                                      if(outwardList.length > 15){
                                                        for(int i=0; i < startVal + 15; i++){
                                                          filteredList.add(outwardList[i]);
                                                        }
                                                      } else{
                                                        for(int i=0; i < outwardList.length; i++){
                                                          filteredList.add(outwardList[i]);
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
                                                      if(outwardList.length > 15){
                                                        for(int i=0; i < startVal + 15; i++){
                                                          filteredList.add(outwardList[i]);
                                                        }
                                                      } else{
                                                        for(int i=0; i < outwardList.length; i++){
                                                          filteredList.add(outwardList[i]);
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
                                                      filteredList = outwardList;
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
                                                      filteredList = outwardList;
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
                                                      filteredList = outwardList;
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
                                                controller: searchVehicleOutTime,
                                                decoration: vehicleInTimeFieldDecoration(controller: searchVehicleOutTime, hintText: "Select Vehicle Out-Time"),
                                                onTap: () {
                                                  setState(() {
                                                    if(searchVehicleOutTime.text.isEmpty || searchVehicleOutTime.text == ""){
                                                      startVal = 0;
                                                      filteredList = outwardList;
                                                    }
                                                    selectVehicleOutTime(context);
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
                                                    child: Text("Gate Outward No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
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
                                                    child: Text("Vehicle Out-Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
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
                                                    child: Text("Invoice Type",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
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
                                                    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => EditOutward(
                                                        drawerWidth: drawerWidth,
                                                        selectedDestination: widget.selectedDestination,
                                                      outwardList: filteredList[i],
                                                      plantValue: widget.plantValue,
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
                                                              child: Text(filteredList[i]['gateOutwardNo']??"",style: const TextStyle(fontSize: 11)),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 4.0),
                                                            child: SizedBox(
                                                              // height: 25,
                                                              child: Text(filteredList[i]['vehicleNo']??"",style: const TextStyle(fontSize: 11)),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 4.0),
                                                            child: SizedBox(
                                                              // height: 25,
                                                              child: Text(filteredList[i]['vehicleOutTime']??"",style: const TextStyle(fontSize: 11)),
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
                                                              child: Text(filteredList[i]['invoiceType']??"",style: const TextStyle(fontSize: 11)),
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
              filteredList = outwardList;
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
              filteredList = outwardList;
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
              filteredList = outwardList;
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
      suffixIcon: searchVehicleOutTime.text.isEmpty?const Icon(Icons.watch_later_outlined, size: 16, color: Colors.grey,):InkWell(
          onTap: (){
            setState(() {
              searchVehicleOutTime.clear();
              filteredList = outwardList;
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
              filteredList = outwardList;
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
              filteredList = outwardList;
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
    if(outwardList.isNotEmpty && vehicleNo.isNotEmpty){
      setState(() {
        filteredList = outwardList.where((vehicle) => vehicle["vehicleNo"].toLowerCase().contains(vehicleNo.toLowerCase())).toList();
      });
    }
  }
  void fetchInvoiceNo(String invoiceNo) {
    if(outwardList.isNotEmpty && invoiceNo.isNotEmpty){
      setState(() {
        filteredList = outwardList.where((invoice) => invoice["invoiceNo"].toLowerCase().contains(invoiceNo.toLowerCase())).toList();
      });
    }
  }
  void fetchInvoiceDate(DateTime selectedDate){
    if(outwardList.isNotEmpty && selectedDate != null){
      String formattedDate = "${selectedDate.day}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(2, '0')}";
      setState(() {
        filteredList = outwardList.where((item) => item['invoiceDate'] == formattedDate).toList();
      });
    }
  }
  void fetchEntryDate(DateTime selectedDate){
    if(outwardList.isNotEmpty && selectedDate != null){
      String formattedDate = "${selectedDate.day}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year.toString().padLeft(2, '0')}";
      setState(() {
        filteredList = outwardList.where((item) => item['entryDate'] == formattedDate).toList();
      });
    }
  }
  void fetchEntryTime(DateTime selectedTime){
    if(outwardList.isNotEmpty && selectedTime != null){
      String formattedTime = DateFormat('hh:mm a').format(selectedTime);
      setState(() {
        filteredList = outwardList.where((item) => item['entryTime'] == formattedTime).toList();
      });
    }
  }
  void fetchVehicleOutTime(DateTime selectedTime){
    if(outwardList.isNotEmpty && selectedTime != null){
      String formattedTime = DateFormat('hh:mm a').format(selectedTime);
      setState(() {
        filteredList = outwardList.where((item) => item['vehicleOutTime'] == formattedTime).toList();
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
  selectVehicleOutTime(BuildContext context)async{
    picked2 = (await showTimePicker(
        context: context,
        initialTime: _time2
    ))!;
    setState(() {
      _time2 = picked2;
      // String formattedTime = '${picked.hour}:${picked.minute}';
      String formattedTime = DateFormat('hh:mm a').format(DateTime(0, 0, 0, picked2.hour, picked2.minute));
      searchVehicleOutTime.text = formattedTime;
      fetchVehicleOutTime(DateTime(0, 0, 0, picked2.hour, picked2.minute));
    });
  }
}

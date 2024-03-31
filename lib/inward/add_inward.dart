import 'dart:convert';
import 'dart:math';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jml/inward/inward_list.dart';
import 'package:jml/utils/custom_loader.dart';
import 'package:http/http.dart' as http;
import '../utils/custom_appbar.dart';
import '../utils/custom_drawer.dart';
import '../utils/custom_popup_dropdown.dart';
import '../utils/jml_colors.dart';

class AddInward extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const AddInward({
    required this.drawerWidth,
    required this.selectedDestination,
    super.key
  });

  @override
  State<AddInward> createState() => _AddInwardState();
}

class _AddInwardState extends State<AddInward> {

  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();
  bool loading = false;

  final gateInwardNoController = TextEditingController();
  final plantController = TextEditingController();
  final entryDateController = TextEditingController();
  final entryTimeController = TextEditingController();
  final vehicleNoController = TextEditingController();
  final vehicleInTimeController = TextEditingController();
  final supplierCodeController = TextEditingController();
  final invoiceNoController = TextEditingController();
  final supplierNameController = TextEditingController();
  final invoiceDateController = TextEditingController();
  final purchaseOrderController = TextEditingController();
  final poTypeController = TextEditingController();
  final enteredByController = TextEditingController();
  final canceledController = TextEditingController();
  final receivedController = TextEditingController();
  final remarksController = TextEditingController();
  final searchSupplierCodeController = TextEditingController();
  final searchSupplierNameController = TextEditingController();
  final searchPONoController = TextEditingController();
  late double drawerWidth;

  String dropdownValue1 = "";
  String canceledValue1 = "NO";
  List supplierCodeList = [];
  List<dynamic> poNoList = [];
  List suppliers = [];
  List poNo = [];
  List<dynamic> selectedPurchaseOrders = [];
  List<dynamic> displayData =[];
  List<Map<String, dynamic>> uniquePurchaseOrder = [];
  List<dynamic> purchaseOrders = [];

  List<CustomPopupMenuEntry<String>> supplierCodePopUpList = <CustomPopupMenuEntry<String>>[
    const CustomPopupMenuItem(
      height: 40,
      value: 'S123',
      child: Center(child: SizedBox(width: 350,child: Text('S123',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 11)))),
    ),
    const CustomPopupMenuItem(
      height: 40,
      value: 'S456',
      child: Center(child: SizedBox(width: 350,child: Text('S456',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 11)))),
    ),
    const CustomPopupMenuItem(
      height: 40,
      value: 'S789',
      child: Center(child: SizedBox(width: 350,child: Text('S789',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 11)))),
    ),
  ];
  List<CustomPopupMenuEntry<String>> canceledPopUpList = <CustomPopupMenuEntry<String>>[
    const CustomPopupMenuItem(
      height: 40,
      value: 'Yes',
      child: Center(child: SizedBox(width: 350,child: Text('YES',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 11)))),
    ),
    const CustomPopupMenuItem(
      height: 40,
      value: 'No',
      child: Center(child: SizedBox(width: 350,child: Text('NO',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 11)))),
    ),
  ];

    TimeOfDay _time = TimeOfDay.now();
    TimeOfDay _time2 = TimeOfDay.now();
  late TimeOfDay picked;
  late TimeOfDay picked2;
  late String entryDateTime;
  late String invoiceDateTime;
  late String formattedTime ;
  late String formattedEntryTime ;
  late String formattedVehicleTime ;
  Future<void> selectTime(BuildContext context)async{
    picked = (await showTimePicker(
        context: context,
        initialTime: _time
    ))!;
    if(picked !=null){
      setState(() {
        _time = picked;
        int hour = picked.hour;
        int minute = picked.minute;
        formattedEntryTime = 'PT${hour}H${minute}M00S';
        String formattedTime = DateFormat('hh:mm a').format(DateTime(0, 0, 0, hour, minute));
        entryTimeController.text = formattedTime;
      });
    }
  }
  Future<void> selectVehicleInTime(BuildContext context)async{
    picked2 = (await showTimePicker(
        context: context,
        initialTime: _time2
    ))!;
    if (picked2 != null) {
      setState(() {
        _time2 = picked2;
        int hour = picked2.hour;
        int minute = picked2.minute;
        formattedVehicleTime = 'PT${hour}H${minute}M00S';
        String formattedTime = DateFormat('hh:mm a').format(DateTime(0, 0, 0, hour, minute));
        vehicleInTimeController.text = formattedTime;
      });
    }
  }

  selectEntryDate(BuildContext context) async{
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
    );
    if(pickedDate == null) {
      return;
    }
    String formattedDate = DateFormat("dd-MM-yyyy").format(pickedDate);
    entryDateController.text = formattedDate;
    entryDateTime = DateFormat("yyyy-MM-dd").format(pickedDate) + "T00:00:00";
    print('-------- entry date -------');
    print(entryDateTime);
    print(entryDateController.text);
  }
  selectInvoiceDate(BuildContext context) async{
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
    );
    if(pickedDate == null) {
      return;
    }
    String formattedDate = DateFormat("dd-MM-yyyy").format(pickedDate);
    invoiceDateController.text = formattedDate;
    invoiceDateTime = DateFormat("yyyy-MM-dd").format(pickedDate) + "T00:00:00";
    print('-------- invoice data -------');
    print(invoiceDateTime);
  }

  @override
  void initState() {
    // TODO: implement initState
    drawerWidth = 60.0;
    super.initState();
    entryDateController.text = DateFormat("dd-MM-yyyy").format(DateTime.now());
    entryTimeController.text = DateFormat('hh:mm a').format(DateTime.now());
    getGateInNo();
    String entryDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    entryDateTime = "${entryDate}T00:00:00";
    List<String> timeComponents = entryTimeController.text.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1].split(' ')[0]);
    formattedEntryTime = 'PT${hour}H${minute}M00S';
    getInitialData();
    canceledController.text = canceledValue1;
  }

  Future getInitialData() async{
    var data = await getSupplierCode();
    if(data != null){
      suppliers = data.map((entry){
        return {
          "Supplier":entry["Supplier"],
          "SupplierName": entry["SupplierName"],
        };
      }).toList();
    }
    supplierCodeList = suppliers;
    setState(() {
      loading = false;
    });
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
                      title: const Text("Inward Details"),
                      centerTitle: true,
                      leading: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          //Navigator.pushReplacementNamed(context, "/home");
                        },
                        child: const Icon(Icons.keyboard_backspace_outlined),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: MaterialButton(
                            color: Colors.blue,
                            onPressed: () {
                              if (supplierNameController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select Supplier Name")));
                              } else if (invoiceNoController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter Invoice Number")));
                              } else if (invoiceDateController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter Invoice Date")));
                              } else if (vehicleNoController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter Vehicle Number")));
                              } else if (vehicleInTimeController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter Vehicle In-Time")));
                              } else {
                                Map savedInward = {
                                  "GateInwardNo": gateInwardNoController.text,
                                  "EntryDate": entryDateTime,
                                  "EntryTime": formattedEntryTime,
                                  "Plant": plantController.text,
                                  "VehicleNumber": vehicleNoController.text,
                                  "VehicleIntime": formattedVehicleTime,
                                  "SupplierCode": supplierCodeController.text,
                                  "SupplierName": supplierNameController.text,
                                  "PurchaseOrderNo": purchaseOrderController.text,
                                  "InvoiceNo": invoiceNoController.text,
                                  "InvoiceDate": invoiceDateTime,
                                  "EnteredBy": enteredByController.text,
                                  "Remarks": remarksController.text,
                                  "Cancelled": canceledController.text,
                                  // "ReceivedBy": receivedController.text
                                };
                                print('--------- saved inward ----------');
                                print(savedInward);
                                BuildContext dialogContext = context;
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Gate Inward Confirmation'),
                                      content: Text('GateInwardNo: ${gateInwardNoController.text}'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop(); // Close the dialog
                                            postInwardApi(savedInward, dialogContext).then((value) {
                                              Navigator.of(dialogContext).push(PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) => InwardList(
                                                    drawerWidth: widget.drawerWidth,
                                                    selectedDestination: widget.selectedDestination
                                                ),
                                              ));
                                            });
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },);
                              }
                            },
                            child: const Text("Save", style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  ),
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
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 80, bottom: 30, right: 80),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 1100,
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
                                        const Padding(
                                          padding: EdgeInsets.only(left: 26,top: 8,right: 0,bottom: 8),
                                          child: Text("Gate Inward", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),
                                        const Divider(color: mTextFieldBorder,height: 1),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 18,top: 10,right: 18,bottom: 10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Gate Inward No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child: TextFormField(
                                                            style: const TextStyle(fontSize: 11),
                                                            readOnly: true,
                                                            controller: gateInwardNoController,
                                                            decoration: customerFieldDecoration(hintText: '',controller: gateInwardNoController),
                                                            onChanged: (value){

                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Entry Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child: TextFormField(
                                                            style: const TextStyle(fontSize: 11),
                                                            readOnly: true,
                                                            controller: entryDateController,
                                                            decoration: customerFieldDecoration(hintText: '',controller: entryDateController),
                                                            onChanged: (value){

                                                            },
                                                            onTap: () {
                                                              selectEntryDate(context);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Entry Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child: TextFormField(
                                                            style: const TextStyle(fontSize: 11),
                                                            // readOnly: true,
                                                            controller: entryTimeController,
                                                            decoration: customerFieldDecoration(hintText: '',controller: entryTimeController),
                                                            onChanged: (value){

                                                            },
                                                            onTap: () {
                                                              selectTime(context);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Plant",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child: TextFormField(
                                                            style: const TextStyle(fontSize: 11),
                                                            // autofocus: true,
                                                            controller: plantController,
                                                            decoration: customerFieldDecoration(hintText: '',controller: plantController),
                                                            onChanged: (value){

                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Vehicle Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child: TextFormField(
                                                            style: const TextStyle(fontSize: 11),
                                                            // autofocus: true,
                                                            controller: vehicleNoController,
                                                            decoration: customerFieldDecoration(hintText: '',controller: vehicleNoController),
                                                            onChanged: (value){

                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Vehicle In-Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child: TextFormField(
                                                            style: const TextStyle(fontSize: 11),
                                                            // autofocus: true,
                                                            controller: vehicleInTimeController,
                                                            decoration: customerFieldDecoration(hintText: '',controller: vehicleInTimeController),
                                                            onChanged: (value){

                                                            },
                                                            onTap: () {
                                                              selectVehicleInTime(context);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Supplier Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child: SizedBox(
                                                            height: 30,
                                                            child: TextFormField(
                                                              style: const TextStyle(fontSize: 11),
                                                              readOnly: true,
                                                              autofocus: true,
                                                              controller: supplierNameController,
                                                              decoration:  const InputDecoration(
                                                                hintText: " Select Supplier Name",
                                                                hintStyle: TextStyle(fontSize: 11,),
                                                                border: OutlineInputBorder(
                                                                    borderSide: BorderSide(color:  Colors.blue)
                                                                ),
                                                                contentPadding: EdgeInsets.fromLTRB(12, 00, 0, 0),
                                                                suffixIcon: Icon(
                                                                  Icons.arrow_drop_down_outlined,
                                                                  color: Colors.blue,size: 16,
                                                                ),
                                                                enabledBorder:OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                                              ),
                                                              onChanged: (value){

                                                              },
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) => _showSupplierNameDialog(),
                                                                ).then((value) {
                                                                  setState(() {
                                                                    loading = false;
                                                                    supplierNameController.text = value["name"];
                                                                    supplierCodeController.text = value["code"];
                                                                    print('-------- supplier name then ----------');
                                                                    print(supplierNameController.text);
                                                                    print(supplierCodeController.text);
                                                                    print(poNoList);
                                                                  });
                                                                  getPOData(value["code"]);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Supplier Code",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child: SizedBox(
                                                            height: 30,
                                                            child: TextField(
                                                              style: const TextStyle(fontSize: 11),
                                                              controller: supplierCodeController,
                                                              readOnly: true,
                                                              decoration:  const InputDecoration(
                                                                hintText: " Select Supplier",
                                                                hintStyle: TextStyle(fontSize: 11,),
                                                                border: OutlineInputBorder(
                                                                    borderSide: BorderSide(color:  Colors.blue)
                                                                ),
                                                                contentPadding: EdgeInsets.fromLTRB(12, 00, 0, 0),
                                                                suffixIcon: Icon(
                                                                  Icons.arrow_drop_down_outlined,
                                                                  color: Colors.blue,size: 16,
                                                                ),
                                                                enabledBorder:OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                                              ),
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) => _showSupplierDialog(),
                                                                ).then((value) {
                                                                  setState(() {
                                                                    loading = false;
                                                                    supplierCodeController.text = value;
                                                                  });
                                                                  getPOData(value);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Purchase Order No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child:SizedBox(
                                                            height: 30,
                                                            child: TextFormField(
                                                              style: const TextStyle(fontSize: 11),
                                                              readOnly: true,
                                                              controller: purchaseOrderController,
                                                              decoration: const InputDecoration(
                                                                hintText: " Select Purchase Order Number",
                                                                hintStyle: TextStyle(fontSize: 11,),
                                                                border: OutlineInputBorder(
                                                                    borderSide: BorderSide(color:  Colors.blue)
                                                                ),
                                                                contentPadding: EdgeInsets.fromLTRB(12, 00, 0, 0),
                                                                suffixIcon: Icon(
                                                                  Icons.arrow_drop_down_outlined,
                                                                  color: Colors.blue,size: 16,
                                                                ),
                                                                enabledBorder:OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                                              ),
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) => _showPODialog(),
                                                                ).then((value) {
                                                                  setState(() {
                                                                    loading = false;
                                                                    purchaseOrderController.text = value;
                                                                  });
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("PO Type",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child:TextFormField(
                                                            style: const TextStyle(fontSize: 11),
                                                            autofocus: true,
                                                            controller: poTypeController,
                                                            decoration: customerFieldDecoration(hintText: '',controller: poTypeController),
                                                            onChanged: (value){

                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Invoice No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child:TextFormField(
                                                            style: const TextStyle(fontSize: 11),
                                                            autofocus: true,
                                                            controller: invoiceNoController,
                                                            decoration: customerFieldDecoration(hintText: '',controller: invoiceNoController),
                                                            onChanged: (value){

                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Invoice Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child:TextFormField(
                                                            style: const TextStyle(fontSize: 11),
                                                            autofocus: true,
                                                            controller: invoiceDateController,
                                                            decoration: customerFieldDecoration(hintText: '',controller: invoiceDateController),
                                                            onChanged: (value){

                                                            },
                                                            onTap: () {
                                                              selectInvoiceDate(context);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Entered By",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child:TextFormField(
                                                            style: const TextStyle(fontSize: 11),
                                                            autofocus: true,
                                                            controller: enteredByController,
                                                            decoration: customerFieldDecoration(hintText: '',controller: enteredByController),
                                                            onChanged: (value){

                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 100,
                                                            child: Text("Cancelled",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                          width: 200,
                                                          child:SizedBox(
                                                            height: 30,
                                                            child: Focus(
                                                                skipTraversal: true,
                                                                descendantsAreFocusable: true,
                                                                child: LayoutBuilder(
                                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                                    return CustomPopupMenuButton(
                                                                      decoration: customPopupDecoration(hintText:canceledValue1,),
                                                                      itemBuilder: (BuildContext context) {
                                                                        return canceledPopUpList;
                                                                      },
                                                                      hintText: "",
                                                                      childWidth: constraints.maxWidth,
                                                                      textController: canceledController,
                                                                      shape:  const RoundedRectangleBorder(
                                                                        side: BorderSide(color: mTextFieldBorder),
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(5),
                                                                        ),
                                                                      ),
                                                                      offset: const Offset(1, 40),
                                                                      tooltip: '',
                                                                      onSelected: ( value) {
                                                                        setState(() {
                                                                          canceledValue1 = value;
                                                                          canceledController.text = value;
                                                                        });
                                                                      },
                                                                      onCanceled: () {

                                                                      },
                                                                      child: Container(),
                                                                    );
                                                                  },
                                                                )
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 1100,
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 18,top: 0,right: 18),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10, left: 8, bottom: 10),
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                    width: 100,
                                                    child: Text("Remarks",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12))
                                                ),
                                                SizedBox(
                                                  width: 400,
                                                  child:TextFormField(
                                                    style: const TextStyle(fontSize: 11),
                                                    autofocus: true,
                                                    controller: remarksController,
                                                    minLines: 2,
                                                    maxLines: null,
                                                    decoration: customerFieldDecoration2(hintText: '',controller: remarksController),
                                                    onChanged: (value){

                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
              )
          )
        ],
      ),
    );
  }

  Future getSupplierCode() async{
    String url = "Https://JMIApp-terrific-eland-ao.cfapps.in30.hana.ondemand.com/api/sap_odata_get/Customising/A_Supplier";
    String authToken = "Basic " + base64Encode(utf8.encode('INTEGRATION:rXnDqEpDv2WlWYahKnEGo)mwREoCafQNorwoDpLl'));
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': authToken,
        },
      );

      if (response.statusCode == 200) {
        Map tempData ={};
        tempData= json.decode(response.body);
        if(tempData['d']['results'].isEmpty){
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Data Found !')));
          }
          setState(() {
            loading = false;
          });
          return [];
        }
        else{
          setState(() {
            displayData = tempData['d']['results'];
            loading = false;
          });
        }
        return json.decode(response.body)['d']['results'];
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred in API: $e');
      return null;
    }
  }


  Future<List<dynamic>?> getPOData(String supplierCode) async {
    String url = "Https://JMIApp-terrific-eland-ao.cfapps.in30.hana.ondemand.com/api/sap_odata_get/Customising/PurchaseOrder/PurchaseOrderScheduleLine?filter=OpenPurchaseOrderQuantity gt 0 and PurchaseOrderQuantityUnit eq 'EA' and _PurchaseOrder/Supplier eq '$supplierCode'&select=PurchaseOrder&expand=_PurchaseOrder";
    String authToken = "Basic ${base64Encode(utf8.encode('INTEGRATION:rXnDqEpDv2WlWYahKnEGo)mwREoCafQNorwoDpLl'))}";
    print('------- get po URL -------');
    print(url);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': authToken},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic>? tempData = json.decode(response.body);
        if(tempData!['value'].isEmpty || tempData['value'] == null){
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No PO Number !')));
          }
          setState(() {
            purchaseOrderController.clear();
            poTypeController.clear();
            purchaseOrders = [];
            poNoList = [];
          });
        }
        else if (tempData != null &&
            tempData.containsKey('value') &&
            tempData['value'] != null) {
          purchaseOrders = tempData['value'];
          poNoList = purchaseOrders.map((order) => order['_PurchaseOrder']['PurchaseOrder']).toSet().toList();
          print('------- get po data ----------');
          print(poNoList);
          return purchaseOrders;
        } else {
          print('Error: Unable to find results in response body');
          return null;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred in API: $e');
      return null;
    }
  }

  Future getGateInNo() async{
    String url = "Https://JMIApp-terrific-eland-ao.cfapps.in30.hana.ondemand.com/api/sap_odata_get/Customising/YY1_GATEENTRY_CDS/YY1_GATEENTRY?orderby=GateInwardNo desc";
    String authToken = "Basic " + base64Encode(utf8.encode('INTEGRATION:rXnDqEpDv2WlWYahKnEGo)mwREoCafQNorwoDpLl'));
    try{
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': authToken,
        },
      );
      if(response.statusCode == 200){
        Map tempData = json.decode(response.body);
        List results = tempData['d']['results'];

        if(results.isNotEmpty){
          String firstGateInwardNo = results[0]['GateInwardNo'];
          int nextGateInwardNo = int.parse(firstGateInwardNo) + 1;
          gateInwardNoController.text = nextGateInwardNo.toString();
        }
      }
    }catch(e){
      print('Error fetching GateInwardNo: $e');
    }
  }

  Future<void> postInwardApi(Map tempData, BuildContext context) async {
    String url = "Https://JMIApp-terrific-eland-ao.cfapps.in30.hana.ondemand.com/api/sap_odata_post/Customising/YY1_GATEENTRY_CDS/YY1_GATEENTRY";
    String authToken = "Basic " + base64Encode(utf8.encode('INTEGRATION:rXnDqEpDv2WlWYahKnEGo)mwREoCafQNorwoDpLl'));

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': authToken,
        },
        body:  json.encode(tempData),
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['d'] != null && jsonResponse['d']['SAP_UUID'] != null) {
          // print('-------- post response ---------');
          // print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data posted successfully'),
              duration: Duration(seconds: 2),
            ),
          );
          setState(() {
            loading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to post data'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['error']['message']['value'];
        if (errorMessage.contains("Instance with the same key already exists")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Instance with the same key already exists'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to post data: $errorMessage'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error posting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error posting data: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }




  _showSupplierDialog(){
    return AlertDialog(
      title: const Text("Select Supplier Code"),
      content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 500,
              child: Column(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchSupplierCodeController,
                          decoration: const InputDecoration(labelText: "Search Supplier Code"),
                          onChanged: (value) {
                            setState((){
                              if(value.isEmpty || value == ""){
                                supplierCodeList = [];
                              }
                              filterSuppliers(value);
                            });
                          },
                        ),
                      )
                  ),
                  SizedBox(
                    width: 500,
                    height: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: supplierCodeList.length,
                      itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, supplierCodeList[index]["Supplier"].toString());
                          print('------- supplier on tap --------');
                          print(supplierCodeList[index]["SupplierName"]);
                          print(poNoList);
                          supplierNameController.text = supplierCodeList[index]["SupplierName"];
                        },
                        child: ListTile(
                          title: Text(supplierCodeList[index]["Supplier"].toString()),
                          subtitle: Text(supplierCodeList[index]["SupplierName"].toString()),
                        ),
                      );
                    },),
                  ),
                ],
              ),
            );
          },
      ),
    );
  }

  _showSupplierNameDialog(){
    return AlertDialog(
      title: const Text("Select Supplier Name"),
      content: StatefulBuilder(
        builder: (context, setState) {
        return SizedBox(
          height: 500,
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchSupplierNameController,
                      decoration: const InputDecoration(labelText: "Search Supplier Name"),
                      onChanged: (value) {
                        setState((){
                          if(value.isEmpty || value == ""){
                            supplierCodeList = [];
                          }
                          filterSuppliersName(value);
                        });
                      },
                    ),
                    )
              ),
              SizedBox(
                width: 500,
                height: 400,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: supplierCodeList.length,
                  itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(
                          context,
                          {
                            "name": supplierCodeList[index]["SupplierName"].toString(),
                            "code": supplierCodeList[index]["Supplier"].toString(),
                          }
                      );
                      print('------- supplier  name on tap --------');
                      print(supplierCodeList[index]["SupplierName"]);
                      print(supplierCodeList[index]["Supplier"]);
                      print(poNoList);
                      supplierCodeController.text = supplierCodeList[index]["Supplier"];
                    },
                    child: ListTile(
                      title: Text(supplierCodeList[index]["SupplierName"].toString()),
                      subtitle: Text(supplierCodeList[index]["Supplier"].toString()),
                    ),
                  );
                },),
              ),
            ],
          ),
        );
      },),
    );
  }

  _showPODialog(){
    return AlertDialog(
      title: const Text("Select Purchase Order No"),
      content: StatefulBuilder(
        builder: (context, setState) {
        return SizedBox(
          height: 500,
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchPONoController,
                      decoration: const InputDecoration(labelText: "Search PO No"),
                      onChanged: (value) {
                        setState((){
                          if(value.isEmpty || value == ""){
                            poNoList = [];
                          }
                          filterPONo(value);
                        });
                      },
                    ),
                  )
              ),
              SizedBox(
                width: 500,
                height: 400,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: poNoList.length,
                  itemBuilder: (context, index) {
                    var purchaseOrder = poNoList[index];
                    var purchaseOrderType = getPurchaseOrderType(purchaseOrder);
                    return InkWell(
                    onTap: () {
                      Navigator.pop(context, purchaseOrder );
                      poTypeController.text = purchaseOrderType;
                    },
                    child: ListTile(
                      title: Text(purchaseOrder),
                    ),
                  );
                },),
              ),
            ],
          ),
        );
      },),
    );
  }

  String getPurchaseOrderType(String purchaseOrder) {
    var order = purchaseOrders.firstWhere((order) => order['_PurchaseOrder']['PurchaseOrder'] == purchaseOrder, orElse: () => null);
    return order != null ? order['_PurchaseOrder']['PurchaseOrderType'] : '';
  }

  void filterSuppliers(String value){
    setState(() {
      supplierCodeList = suppliers.where((supplier) {
        final code = supplier["Supplier"].toString().toLowerCase();
        return code.contains(value.toLowerCase());
      }).toList();
    });
  }

  void filterSuppliersName(String value){
    setState(() {
      supplierCodeList = suppliers.where((supplier) {
        final code = supplier["SupplierName"].toString().toLowerCase();
        return code.contains(value.toLowerCase());
      }).toList();
    });
  }

  filterPONo(String searchQuery) {
    if (searchQuery.isEmpty) {
      poNoList = purchaseOrders.map((order) => order['_PurchaseOrder']['PurchaseOrder']).toList();
    } else {
      poNoList = purchaseOrders
          .where((order) => order['_PurchaseOrder']['PurchaseOrder'].contains(searchQuery))
          .map((order) => order['_PurchaseOrder']['PurchaseOrder'])
          .toList();
    }
  }

  customerFieldDecoration( {required TextEditingController controller, required String hintText, bool? error, Function? onTap}) {
    return  InputDecoration(
      constraints: BoxConstraints(maxHeight: error==true ? 50:30),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }
  customerFieldDecoration2( {required TextEditingController controller, required String hintText, bool? error, Function? onTap}) {
    return  InputDecoration(
      // constraints: BoxConstraints(maxHeight: error==true ? 50:30),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }

  customPopupDecoration({required String hintText, bool? error, bool ? isFocused,}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xB2000000)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isFocused == true ? Colors.blue : error == true ? mErrorColor : mTextFieldBorder)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: error == true ? mErrorColor : mTextFieldBorder)),
      focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: error == true ? mErrorColor : Colors.blue)),
    );
  }
}

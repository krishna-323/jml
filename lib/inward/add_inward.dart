import 'dart:math';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jml/utils/custom_loader.dart';

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
  late double drawerWidth;

  String dropdownValue1 = "";
  String canceledValue1 = "";
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
      child: Center(child: SizedBox(width: 350,child: Text('Yes',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 11)))),
    ),
    const CustomPopupMenuItem(
      height: 40,
      value: 'No',
      child: Center(child: SizedBox(width: 350,child: Text('No',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 11)))),
    ),
  ];

    TimeOfDay _time = TimeOfDay.now();
    TimeOfDay _time2 = TimeOfDay.now();
  late TimeOfDay picked;
  late TimeOfDay picked2;
  Future<void> selectTime(BuildContext context)async{
    picked = (await showTimePicker(
        context: context,
        initialTime: _time
    ))!;
    setState(() {
      _time = picked;
      String formattedTime = DateFormat('hh:mm a').format(DateTime(0, 0, 0, picked.hour, picked.minute));
      entryTimeController.text = formattedTime;
    });
  }
  Future<void> selectVehicleInTime(BuildContext context)async{
    picked2 = (await showTimePicker(
        context: context,
        initialTime: _time2
    ))!;
    setState(() {
      _time2 = picked2;
      String formattedTime = DateFormat('hh:mm a').format(DateTime(0, 0, 0, picked2.hour, picked2.minute));
      vehicleInTimeController.text = formattedTime;
    });
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
  }
  @override
  void initState() {
    // TODO: implement initState
    drawerWidth = 60.0;
    super.initState();
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
                            Map savedInward = {
                              "gateInwardNo": gateInwardNoController.text,
                              "entryDate": entryDateController.text,
                              "entryTime": entryTimeController.text,
                              "plant": plantController.text,
                              "vehicleNumber": vehicleNoController.text,
                              "vehicleInTime": vehicleInTimeController.text,
                              "supplierCode": supplierCodeController.text,
                              "supplierName": supplierNameController.text,
                              "purchaseOrderNo": purchaseOrderController.text,
                              "purchaseOrderType": poTypeController.text,
                              "invoiceNo": invoiceNoController.text,
                              "invoiceDate": invoiceDateController.text,
                              "entredBy": enteredByController.text,
                              "remarks": remarksController.text,
                              "canceledBy": canceledController.text,
                              "receivedBy": receivedController.text
                            };
                            print('--------- saved inward ----------');
                            print(savedInward);
                        },child: const Text("Save",style: TextStyle(color: Colors.white)),),
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
                                width: MediaQuery.of(context).size.width/1.2,
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
                                      const SizedBox(
                                        height: 40,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 26,top: 10,right: 0),
                                          child: Text("Gate Inward", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),
                                      ),
                                      const Divider(color: mTextFieldBorder,height: 1),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 18,top: 0,right: 18),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 15,),
                                                        const Text("Gate Inward No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: gateInwardNoController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: gateInwardNoController),
                                                          onChanged: (value){

                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 80,),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 15,),
                                                        const Text("Entry Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: entryDateController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: entryDateController),
                                                          onChanged: (value){

                                                          },
                                                          onTap: () {
                                                            selectEntryDate(context);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 80,),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 15,),
                                                        const Text("Entry Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: entryTimeController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: entryTimeController),
                                                          onChanged: (value){

                                                          },
                                                          onTap: () {
                                                            selectTime(context);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // const SizedBox(height: 15,),
                                                        const Text("Plant",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: plantController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: plantController),
                                                          onChanged: (value){

                                                          },
                                                        ),
                                                        const SizedBox(height: 15,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 80,),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text("Vehicle Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: vehicleNoController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: vehicleNoController),
                                                          onChanged: (value){

                                                          },
                                                        ),
                                                        const SizedBox(height: 15,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 80,),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text("Vehicle In-Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: vehicleInTimeController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: vehicleInTimeController),
                                                          onChanged: (value){

                                                          },
                                                          onTap: () {
                                                            selectVehicleInTime(context);
                                                          },
                                                        ),
                                                        const SizedBox(height: 15,),
                                                      ],
                                                    ),
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
                                width: MediaQuery.of(context).size.width/1.2,
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
                                      const SizedBox(
                                        height: 40,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 26,top: 10,right: 0),
                                          child: Text("Supplier Details", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),
                                      ),
                                      const Divider(color: mTextFieldBorder,height: 1),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 18,top: 0,right: 18),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 10,),
                                                        const Text("Supplier Code",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        SizedBox(
                                                          height: 30,
                                                          child: Focus(
                                                              skipTraversal: true,
                                                              descendantsAreFocusable: true,
                                                              child: LayoutBuilder(
                                                                builder: (BuildContext context, BoxConstraints constraints) {
                                                                  return CustomPopupMenuButton(
                                                                    decoration: customPopupDecoration(hintText:dropdownValue1,),
                                                                    itemBuilder: (BuildContext context) {
                                                                      return supplierCodePopUpList;
                                                                    },
                                                                    hintText: "",
                                                                    childWidth: constraints.maxWidth,
                                                                    textController: supplierCodeController,
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
                                                                        supplierCodeController.text = value;
                                                                        dropdownValue1 = value;
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 80,),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 10,),
                                                        const Text("Supplier Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: supplierNameController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: supplierNameController),
                                                          onChanged: (value){

                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 80,),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text("Invoice No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: invoiceNoController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: invoiceNoController),
                                                          onChanged: (value){

                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text("Invoice Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
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
                                                        const SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 80,),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text("Purchase Order No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: purchaseOrderController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: purchaseOrderController),
                                                          onChanged: (value){

                                                          },
                                                        ),
                                                        const SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 80,),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text("PO Type",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: poTypeController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: poTypeController),
                                                          onChanged: (value){

                                                          },
                                                        ),
                                                        const SizedBox(height: 10,),
                                                      ],
                                                    ),
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
                                width: MediaQuery.of(context).size.width/1.2,
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
                                      const SizedBox(
                                        height: 40,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 26,top: 10,right: 0),
                                          child: Text("Security Details", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 12)),
                                        ),
                                      ),
                                      const Divider(color: mTextFieldBorder,height: 1),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 18,top: 0,right: 18),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 10,),
                                                        const Text("Entered By",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: enteredByController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: enteredByController),
                                                          onChanged: (value){

                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 80,),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 10,),
                                                        const Text("Canceled",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        SizedBox(
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
                                                                        canceledController.text = value;
                                                                        canceledValue1 = value;
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 80,),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 10,),
                                                        const Text("Received By",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: receivedController,
                                                          decoration: customerFieldDecoration(hintText: '',controller: receivedController),
                                                          onChanged: (value){

                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text("Remarks",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                        const SizedBox(height: 6,),
                                                        TextFormField(
                                                          style: const TextStyle(fontSize: 11),
                                                          autofocus: true,
                                                          controller: remarksController,
                                                          minLines: 2,
                                                          maxLines: null,
                                                          decoration: customerFieldDecoration2(hintText: '',controller: remarksController),
                                                          onChanged: (value){

                                                          },
                                                        ),
                                                        const SizedBox(height: 10,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: Container())
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
          ),
        ],
      ),
    );
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

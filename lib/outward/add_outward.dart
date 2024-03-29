import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/custom_appbar.dart';
import '../utils/custom_drawer.dart';
import '../utils/custom_loader.dart';
import '../utils/jml_colors.dart';

class AddOutward extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const AddOutward({
    required this.drawerWidth,
    required this.selectedDestination,
    super.key
  });

  @override
  State<AddOutward> createState() => _AddOutwardState();
}

class _AddOutwardState extends State<AddOutward> {

  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();
  bool loading = false;

  final gateOutwardNoController = TextEditingController();
  final plantController = TextEditingController();
  final entryDateController = TextEditingController();
  final entryTimeController = TextEditingController();
  final vehicleNoController = TextEditingController();
  final vehicleOutTimeController = TextEditingController();
  final invoiceDCNoController = TextEditingController();
  final supplierNameController = TextEditingController();
  final supplierCodeController = TextEditingController();
  final invoiceDateController = TextEditingController();
  final invoiceDCTypeController = TextEditingController();
  final enteredByController = TextEditingController();
  final remarksController = TextEditingController();
  late double drawerWidth;

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
  Future<void> selectVehicleOutTime(BuildContext context)async{
    picked2 = (await showTimePicker(
        context: context,
        initialTime: _time2
    ))!;
    setState(() {
      _time2 = picked2;
      String formattedTime = DateFormat('hh:mm a').format(DateTime(0, 0, 0, picked2.hour, picked2.minute));
      vehicleOutTimeController.text = formattedTime;
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
                    title: const Text("Outward Details"),
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
                            Map savedOutward = {
                              "gateOutwardNo": gateOutwardNoController.text,
                              "entryDate": entryDateController.text,
                              "entryTime": entryTimeController.text,
                              "plant": plantController.text,
                              "vehicleNo": vehicleNoController.text,
                              "vehicleOutTime": vehicleOutTimeController.text,
                              "invoiceNo": invoiceDCNoController.text,
                              "invoiceDate": invoiceDateController.text,
                              "supplierCode": supplierCodeController.text,
                              "supplierName": supplierNameController.text,
                              "invoiceType": invoiceDCTypeController.text,
                              "entredBy": enteredByController.text,
                              "remarks": remarksController.text,
                            };
                            print('-------- saves outward -----------');
                            print(savedOutward);
                          },child: const Text("Save",style: TextStyle(color: Colors.white)),),
                      )
                    ],
                  ),
                ),
              ),
              body: CustomLoader(
                inAsyncCall: loading,
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
                                        child: Text("Gate Outward", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 12)),
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
                                                      const Text("Gate Outward No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                      const SizedBox(height: 6,),
                                                      TextFormField(
                                                        style: const TextStyle(fontSize: 11),
                                                        autofocus: true,
                                                        controller: gateOutwardNoController,
                                                        decoration: customerFieldDecoration(hintText: '',controller: gateOutwardNoController),
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
                                                      const Text("Vehicle Out-Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                      const SizedBox(height: 6,),
                                                      TextFormField(
                                                        style: const TextStyle(fontSize: 11),
                                                        autofocus: true,
                                                        controller: vehicleOutTimeController,
                                                        decoration: customerFieldDecoration(hintText: '',controller: vehicleOutTimeController),
                                                        onChanged: (value){

                                                        },
                                                        onTap: () {
                                                          selectVehicleOutTime(context);
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
                                        child: Text("Invoice Details", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 12)),
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
                                                      const Text("Invoice DC No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                      const SizedBox(height: 6,),
                                                      TextFormField(
                                                        style: const TextStyle(fontSize: 11),
                                                        autofocus: true,
                                                        controller: invoiceDCNoController,
                                                        decoration: customerFieldDecoration(hintText: '',controller: invoiceDCNoController),
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
                                                      const Text("Customer / Supplier Code",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                      const SizedBox(height: 6,),
                                                      TextFormField(
                                                        style: const TextStyle(fontSize: 11),
                                                        autofocus: true,
                                                        controller: supplierCodeController,
                                                        decoration: customerFieldDecoration(hintText: '',controller: supplierCodeController),
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
                                                      const Text("Customer / Supplier Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                      const SizedBox(height: 6,),
                                                      TextFormField(
                                                        style: const TextStyle(fontSize: 11),
                                                        autofocus: true,
                                                        controller: supplierNameController,
                                                        decoration: customerFieldDecoration(hintText: '',controller: supplierNameController),
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
                                                      const Text("Invoice / DC Type",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)),
                                                      const SizedBox(height: 6,),
                                                      TextFormField(
                                                        style: const TextStyle(fontSize: 11),
                                                        autofocus: true,
                                                        controller: invoiceDCTypeController,
                                                        decoration: customerFieldDecoration(hintText: '',controller: invoiceDCTypeController),
                                                        onChanged: (value){

                                                        },
                                                      ),
                                                      const SizedBox(height: 10,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 80,),
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      // const SizedBox(height: 10,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 80,),
                                              // Expanded(child: Container()),
                                              Flexible(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(height: 10,),
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
                                              const SizedBox(width: 80,),
                                              // Expanded(child: Container()),
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
}

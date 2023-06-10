import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});



  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  TextEditingController titleController = TextEditingController();

  TextEditingController timeinput = TextEditingController();
  TextEditingController dateInput=TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('events')
        .doc(uid)
        .collection('myevents')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time,
    });
    Fluttertoast.showToast(msg: 'Data Added');
  }


  //String? _selectedTime;
  //String? _task;
  
  /**
  Future<void> _show() async {
     final TimeOfDay? result =
     await showTimePicker(context: context, initialTime: TimeOfDay.now());
     if (result != null) {
       setState(() {
         _selectedTime = result.format(context);
         timeinput.text=_selectedTime!;
       });
     }
   }*/
   
      /**
     Future<void> _showdate() async{
     DateTime? pickedDate = await showDatePicker(
         context: context,
         initialDate: DateTime.now(),
         firstDate: DateTime(1950),
         lastDate: DateTime(2100));
  
     if(pickedDate!=null){
       setState((){
         String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
         dateInput.text=formattedDate;
       });
     }
   }*/


  @override
  void initState() {
    
    //timeinput.text="";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Event'),

      ),
      body: Column(
        children: [
          Container(
            child: TextField(
              controller: titleController,
              decoration:const InputDecoration(
                  labelText: 'Enter Title', border: OutlineInputBorder()) ,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            child: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  labelText: 'Enter Description',
                  border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 10),

          /**
          TextField(
                controller: dateInput,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.date_range_rounded,color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: 'Select Date',
                  hintStyle: const TextStyle(color: Colors.white,),
                ),
                readOnly: true,
                onTap: ()=> _showdate(),
              ),*/

              const SizedBox(height: 20),

              /**
              TextField(
                controller: timeinput,
                style: const TextStyle(color: Colors.white),
                
                decoration: const InputDecoration(
                 prefixIcon: Icon(Icons.timer, color: Colors.white),
                 border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(color: Colors.white),
                 ),
                
                  hintText: 'Select Time',
                  hintStyle: TextStyle(color: Colors.white),
                ),

                readOnly: true,
                onTap: ()=> _show(), 
              ),*/
              const SizedBox(height: 40),
            

          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.purple.shade100;
                    return Theme.of(context).primaryColor;
                  })),
              child: const Text(
                'Add Event',

              ),
              onPressed: () {
                addtasktofirebase();
              },
            ),),

        ],
      ),
    );
  }
}

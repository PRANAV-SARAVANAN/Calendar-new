import 'package:calendar_backend/screens/add_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'event.dart';

class Home extends StatefulWidget {
  

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  String uid = '';
  @override
  void initState() {
    // TODO: implement initState
    getuid();
    _selectedDate = _focusedDay;
    super.initState();
  }
  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('+',style: TextStyle(color: Colors.white),),
        onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => AddEvent()),
        )  
      ),
      appBar: AppBar(
        title: Text('Calendar'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              }),
        ],
      ),
      body:SafeArea(child: Column(

        children: [
          TableCalendar(focusedDay: _focusedDay, firstDay:DateTime(2023), lastDay:DateTime(2025),
          calendarFormat:_calendarFormat,
              onDaySelected:(selectedDay,focusedDay){
                if(!isSameDay(_selectedDate, selectedDay)){
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }

              },
            selectedDayPredicate: (day){
              return isSameDay(_selectedDate,day);
            },
            onFormatChanged: (format){
              if(_calendarFormat!=format){
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay){
              _focusedDay = focusedDay;
            },
          ),
          // SizedBox(
          //   height: 20,
          // ),
          Expanded(
            child: Container(
              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height,
              child:StreamBuilder(stream:FirebaseFirestore.instance
                  .collection('events')
                  .doc(uid)
                  .collection('myevents')
                  .snapshots() ,
                  builder: (context,snapshot){
                    if(snapshot.data==null || snapshot.connectionState==ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else{
                      final docs = snapshot.data?.docs;

                      return ListView.builder(
                        itemCount: docs?.length,
                        itemBuilder: (context, index) {
                          var data = docs?[index].data();
                          var timestamp = data?['timestamp'];
                          if (data == null || !data.containsKey('title') || !data.containsKey('description') || timestamp==null) {
                            // Handle the case where the required fields are missing
                            return Container();
                          }
                          var time = (timestamp as Timestamp).toDate();
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Event(
                                    title: data?['title'],
                                    description: data?['description'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 90,
                              color: Colors.orange,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          data?['title'],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(DateFormat.yMd().add_jm().format(time)),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: IconButton(
                                      color: Colors.teal,
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('events')
                                            .doc(uid)
                                            .collection('myevents')
                                            .doc(docs?[index]['time'])
                                            .delete();
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },

                      );
                    }

                  }
                ) ,


            ),
          ),
        ],
      ))
    );
  }
}

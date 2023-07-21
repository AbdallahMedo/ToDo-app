import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sq_test/modules/first/NewTaskScreen.dart';
import 'package:sq_test/modules/second/DoneScreen.dart';
import 'package:sq_test/modules/third/ArchivedTasksScreen.dart';
import 'package:sq_test/shared/components/component.dart';
import 'package:sq_test/shared/constants.dart';
import 'package:sq_test/shared/cubit/cubit.dart';
import 'package:sq_test/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class Home_layout extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //var formKey=GlobalKey<FormState>();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var titlecontroler = TextEditingController();
  var timecontroler = TextEditingController();
  var datecontroler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertToDatabaseState){
               Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.orange,
                title: Text(cubit.titels[cubit.currentIndex]),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (_formkey.currentState!.validate()) {
                      cubit.insertDatabase(
                          date: datecontroler.text,
                          title: titlecontroler.text,
                          time: timecontroler.text,
                      );
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                      controler: titlecontroler,
                                      label: "New Task",
                                      type: TextInputType.text,
                                      prefix: Icons.title,
                                      Validator: (value) {
                                        if (value.isEmpty) {
                                          return "Required";
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultFormField(
                                      controler: timecontroler,
                                      label: "Time",
                                      type: TextInputType.datetime,
                                      prefix: Icons.watch_later_outlined,
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timecontroler.text =
                                              value!.format(context).toString();
                                        });
                                      },
                                      Validator: (value) {
                                        if (value.isEmpty) {
                                          return "Required";
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultFormField(
                                      controler: datecontroler,
                                      label: "Date",
                                      type: TextInputType.datetime,
                                      prefix: Icons.calendar_month_outlined,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime(2101),
                                        ).then((value) {
                                          datecontroler.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                      Validator: (value) {
                                        if (value.isEmpty) {
                                          return "Required";
                                        }
                                        return null;
                                      }),
                                ],
                              ),
                            ),
                          ),
                          elevation: 15.0,
                        )
                        .closed
                        .then((value) {
                      cubit.ChangeBottomSheetState(
                          isShow: false,
                          icon: Icons.edit
                      );
                    });
                    cubit.ChangeBottomSheetState(
                        isShow: true,
                        icon: Icons.add
                    );
                  }
                },
                child: Icon(cubit.fapicon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                fixedColor: Colors.orange,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);

                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: "Doen"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: "Archived"),
                ],
              ),
              body: ConditionalBuilder(
                condition: state is !AppGetLoadingDatabaseState,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) => Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                ),
              ));
        },
      ),
    );
  }
}

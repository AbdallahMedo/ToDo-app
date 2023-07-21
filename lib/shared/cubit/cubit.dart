import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sq_test/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/first/NewTaskScreen.dart';
import '../../modules/second/DoneScreen.dart';
import '../../modules/third/ArchivedTasksScreen.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit(): super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  bool isBottomSheetShown=false;
  IconData fapicon=Icons.edit;
  List<Widget> screens=[
    NewTaskScreen(),
    DoneScreen(),
    ArchivedScreen(),

  ];
  List<String>titels=[
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
  int currentIndex=0;


  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBar());
  }
  ///create database
  Database ?data;
  List<Map> NewTasks=[];
  List<Map> DoneTasks=[];
  List<Map> ArchivedTasks=[];

  void createDatabase()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate:(data,version)
      {
        print('Database creatd');
        data.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)',
        ).then((value){
          print('table created');
        }).catchError((err){
          print('error when creating table ${err.toString()}');
        });

      },
      onOpen: (data)
      {
        getDataFromDatabase(data);
        print('Database opened');

      },

    ).then((value) {
      data=value;
      emit(AppCreateDatabaseState());
    });
  }
   insertDatabase({
    required String time,
    required String date,
    required String title,
  })async
  {
    return await data?.transaction((txn)async{
      await txn.rawInsert('INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")',
      ).then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertToDatabaseState());
        getDataFromDatabase(data);

      }).catchError((err)
      {
        print('Error when inserted new task ${err.toString()}');

      });
    });
  }
  void getDataFromDatabase(data){
    NewTasks=[];
    DoneTasks=[];
    ArchivedTasks=[];
    emit(AppGetLoadingDatabaseState());
    data!.rawQuery('SELECT * FROM tasks').then((value){
      value.forEach((element){
        if(element['status']=='new')
          NewTasks.add(element);
            else if(element['status']=='done')
              DoneTasks.add(element);
            else
              ArchivedTasks.add(element);



      });
      emit(AppGetDatabaseState());


    });

  }
  void ChangeBottomSheetState({
  required bool isShow,
  required IconData icon,
}){
    isBottomSheetShown=isShow;
    fapicon=icon;
    emit(AppChangeBottomSheetState());
  }
  void UbdateData({
      required status,
      required id,
  }
      )async{
    return await data!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status',  '$id']).then((value) {
      getDataFromDatabase(data);

      emit(AppUbdateDatabaseState());
    } );

  }
  void DeleteData({
    required id,
  }
      )async{
    return await data!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(data);

      emit(AppDeleteDatabaseState());
    } );

  }
}
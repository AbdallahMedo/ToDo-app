
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sq_test/shared/cubit/cubit.dart';

Widget defaultFormField({
  required  TextEditingController controler,
  required String label ,
  required TextInputType type,
  required IconData prefix,
  bool isobscure=false,
  dynamic Validator,
  IconData? suffex,
  //Function? onTapicon,
  dynamic onTap,


})=>TextFormField(
  onTap: onTap,
  validator:Validator,
  obscureText:isobscure,
  keyboardType:type,
  controller:controler,
  decoration: InputDecoration(
    labelText: label,
    border: OutlineInputBorder(
      borderRadius:BorderRadius.all(Radius.circular(15.0),),
      borderSide: BorderSide(
        color: Colors.orange,
        width: 5.0,
      ),


    ),
    prefixIcon: Icon(prefix),
    suffixIcon:IconButton(
        onPressed:(){
         // onTapicon!();
      },
        icon:Icon(suffex),
    )
  ),

);
Widget taskItems(Map task,context)=>Dismissible(
  key:Key(task['id'].toString()),
  onDismissed: (Direction){
    AppCubit.get(context).DeleteData(id: task['id']);
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0,

          backgroundColor: Colors.orange,

          child:Text(

            '${task['time']}',

            style: TextStyle(

                color: Colors.black

            ),

          ) ,

        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                '${task['title']}',

                style: TextStyle(

                  fontSize: 18.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              SizedBox(height: 10.0,),

              Text(

                '${task['date']}',

                style: TextStyle(

                  color: Colors.grey,

                ),

              ),

            ],

          ),





        ),

        SizedBox(

          width: 20.0,

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).UbdateData(status: "done", id: task['id'],);

            },

            icon:Icon(Icons.check_box) ,

          color: Colors.green,

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).UbdateData(status: "archive", id: task['id'],);



            },

            icon:Icon(Icons.archive) ,

          color: Colors.grey,

        ),

      ],

    ),

  ),
);



Widget tasBuilder({
  required List<Map>tasks,
})=>ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) =>
        taskItems(tasks[index], context),
    separatorBuilder: (context, index) =>
        Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey,

        ),
    itemCount: tasks.length,
  ),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'Blease add some tasks',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20.0,

          ),
        ),
      ],
    ),
  ),

);

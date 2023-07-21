import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sq_test/shared/components/component.dart';
import 'package:sq_test/shared/constants.dart';
import 'package:sq_test/shared/cubit/cubit.dart';
import 'package:sq_test/shared/cubit/states.dart';


class NewTaskScreen extends StatelessWidget {
  //late final List<Map> tasks;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit
            .get(context)
            .NewTasks;
        return tasBuilder(
          tasks: tasks,
        );
      },


    );
  }
}

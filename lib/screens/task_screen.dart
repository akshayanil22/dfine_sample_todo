import 'dart:ui';
import 'package:dfine_todo/bloc/tasks/tasks_bloc.dart';
import 'package:dfine_todo/models/task_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskScreen extends StatefulWidget {
  final String categoryTitle;

  const TaskScreen({super.key, required this.categoryTitle});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(ListTaskEvent(categoryName: widget.categoryTitle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.categoryTitle),
        actions: [
          IconButton(icon: Icon(Icons.search),onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TaskBloc, TasksState>(
        builder: (context, state) {
          if (state is ListTasks) {
            List<TaskModel> taskList = state.tasks;
            return ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: DottedBorder(
                    color: Colors.green,
                    borderType: BorderType.Circle,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.transparent)
                      ),
                      child: Checkbox(
                        side: WidgetStateBorderSide.resolveWith(
                              (states) => BorderSide.none,
                        ),
                        checkColor: Colors.white,
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.green;
                          }
                          return null;
                        }),
                        value: taskList[index].isCompleted,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<TaskBloc>().add(
                              UpdateTaskEvent(
                                categoryTitle: widget.categoryTitle,
                                task: taskList[index].task,
                                isCompleted: value,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  title: Text(taskList[index].task),
                );
              },
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _showTaskDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0),
            child: SimpleDialog(
              alignment: Alignment.topCenter,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.none,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        onSubmitted: (_) {
                          if (taskController.text.isNotEmpty) {
                            context.read<TaskBloc>().add(
                              AddTaskEvent(
                                categoryTitle: widget.categoryTitle,
                                task: taskController.text.trim(),
                                isCompleted: false,
                              ),
                            );
                          }
                          taskController.clear();
                          Navigator.pop(context);
                        },
                        controller: taskController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Type your task',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -20,
                      top: -20,
                      child: SizedBox(
                        height: 30,
                        child: FloatingActionButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Icon(Icons.clear, size: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

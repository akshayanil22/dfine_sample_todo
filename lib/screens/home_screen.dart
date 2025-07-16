import 'dart:ui';
import 'package:dfine_todo/bloc/theme/theme_bloc.dart';
import 'package:dfine_todo/bloc/todo/todo_bloc.dart';
import 'package:dfine_todo/models/category_model.dart';
import 'package:dfine_todo/screens/settings_screen.dart';
import 'package:dfine_todo/screens/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<TodoBloc>().add(ListCategoryEvent());
    super.initState();
  }

  final TextEditingController titleController = TextEditingController();

  final TextEditingController iconController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SettingScreen())),
              child: CircleAvatar()),
        ),
        centerTitle: true,
        title: Text("Categories"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<TodoBloc, TodoState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ListCategory) {
              List<CategoryModel> categories = state.categories;

              return GridView.builder(
                itemCount: categories.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // spacing between columns
                ),
                itemBuilder: (context, index) {
                  CategoryModel singleCategory =
                      CategoryModel(title: '', icon: '', taskCount: '');

                  if (index != 0) {
                    singleCategory = categories[index - 1];
                  }

                  return GestureDetector(
                    onTap: index == 0
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TaskScreen(
                                          categoryTitle: singleCategory.title,
                                        )));
                          },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: context.read<ThemeBloc>().state.theme ==
                                  AppTheme.light
                              ? Colors.white
                              : Colors.blueGrey.shade900,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: const Offset(
                                0.0,
                                0.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                            )
                          ]),
                      child: index == 0
                          ? Center(
                              child: FloatingActionButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 2, sigmaY: 2),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 100.0),
                                          child: SimpleDialog(
                                            alignment: Alignment.topCenter,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            clipBehavior: Clip.none,
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12),
                                                    clipBehavior: Clip.none,
                                                    width: 200,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextField(
                                                          autofocus: true,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          controller:
                                                              iconController,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'Icon',
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                        ),
                                                        TextField(
                                                          controller:
                                                              titleController,
                                                          onSubmitted: (value) {
                                                            if (titleController
                                                                    .text
                                                                    .isNotEmpty &&
                                                                iconController
                                                                    .text
                                                                    .isNotEmpty) {
                                                              context
                                                                  .read<
                                                                      TodoBloc>()
                                                                  .add(
                                                                    AddCategoryEvent(
                                                                      categoryTitle: titleController
                                                                          .text
                                                                          .trim(),
                                                                      categoryIcon: iconController
                                                                          .text
                                                                          .trim(),
                                                                      taskCount:
                                                                          0,
                                                                    ),
                                                                  );
                                                            }

                                                            titleController
                                                                .clear();
                                                            iconController
                                                                .clear();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'Title',
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                        ),
                                                        Text('0 Tasks')
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                      right: -20,
                                                      top: -20,
                                                      child: SizedBox(
                                                        height: 30,
                                                        child:
                                                            FloatingActionButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Icon(
                                                                  Icons.clear,
                                                                  size: 14,
                                                                )),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Icon(Icons.add),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  singleCategory.icon,
                                  style: TextStyle(fontSize: 32),
                                ),
                                Text(
                                  singleCategory.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(singleCategory.taskCount),
                              ],
                            ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

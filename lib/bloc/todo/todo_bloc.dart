import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dfine_todo/models/category_model.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  TodoBloc() : super(TodoInitial()) {
    on<AddCategoryEvent>(_handleCategory);
    on<ListCategoryEvent>(_listCategory);
  }


  Future<void> _handleCategory(AddCategoryEvent event, Emitter<TodoState> emit) async {
    try {
      final credential = _auth.currentUser;

      if (credential == null) {
        emit(TodoError(message: "User not authenticated."));
        return;
      }

      // Current state must be ListCategory to proceed
      if (state is! ListCategory) return;

      final currentState = state as ListCategory;
      final currentCategories = currentState.categories;

      // Optimistically add the new category to the local state
      final newCategory = CategoryModel(
        title: event.categoryTitle,
        icon: event.categoryIcon,
        taskCount: '${event.taskCount} tasks',
      );

      final updatedCategories = List<CategoryModel>.from(currentCategories)
        ..add(newCategory);

      // Emit the new state immediately
      emit(ListCategory(categories: updatedCategories));

      // Firestore reference
      final userDoc = _fireStore.collection("users").doc(credential.uid);
      final categoryDoc = userDoc.collection('categories').doc(event.categoryTitle);

      // Add the new category to Firestore
      await categoryDoc.set({
        "categoryIcon": event.categoryIcon,
        "taskCount": event.taskCount,
      });

      // Fetch the latest categories from Firestore for consistency
      final result = await userDoc.collection('categories').get();
      final categoriesFromFirestore = result.docs.map((doc) {
        return CategoryModel(
          title: doc.id,
          icon: doc.get('categoryIcon'),
          taskCount: '${doc.get('taskCount')} tasks',
        );
      }).toList();

      // Update the state with the latest categories from Firestore
      emit(ListCategory(categories: categoriesFromFirestore));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _listCategory(ListCategoryEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final credential = _auth.currentUser;

      if (credential == null) {
        emit(TodoError(message: "User not authenticated."));
        return;
      }

      // Fetch category data from Firestore
      final result = await _fireStore
          .collection("users")
          .doc(credential.uid)
          .collection('categories')
          .get();

      // Map Firestore results to a list of CategoryModel
      final categories = result.docs.map((doc) {
        return CategoryModel(
          title: doc.id,
          icon: doc.get('categoryIcon'),
          taskCount: '${doc.get('taskCount')} tasks',
        );
      }).toList();

      emit(ListCategory(categories: categories));
    } catch (e) {
      // Log the error and emit an error state
      log("Error fetching categories: $e");
      emit(TodoError(message: e.toString()));
    }
  }

}
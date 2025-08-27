import 'package:expense_tracker/res/components/search_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../res/colors/app_colors.dart';
import '../../view_models/services/searchcontroller/search_controller.dart';
class YearlyRecord extends StatefulWidget {
  const YearlyRecord({super.key});

  @override
  State<YearlyRecord> createState() => _YearlyRecordState();
}

class _YearlyRecordState extends State<YearlyRecord> {
  final SearchControllerX controllerX = Get.put(SearchControllerX());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.cardColor,
        title: Text('yearly'),
      ),
      body: Column(
        children: [
          SearchFilter(controller: searchController, hintText: 'Search title', onChanged: (value){
            setState(() {
              controllerX.searchQuery.value.toLowerCase();
            });

          })
        ],
      ),
    );
  }
}

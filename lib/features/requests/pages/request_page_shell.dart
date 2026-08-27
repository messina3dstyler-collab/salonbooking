import 'package:flutter/material.dart';

import '../models/appointment_request.dart';
import '../widgets/request_dashboard.dart';
import '../widgets/request_list.dart';
import '../widgets/request_page_scaffold.dart';
import '../widgets/request_search_bar.dart';
import '../widgets/request_sort_menu.dart';

class RequestPageShell extends StatelessWidget {
  const RequestPageShell({
    super.key,
    required this.title,
    required this.requests,
    required this.loading,
    required this.error,
    required this.searchValue,
    required this.sort,
    required this.onSearch,
    required this.onSort,
    required this.onRequestTap,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final List<AppointmentRequest> requests;
  final bool loading;
  final String? error;

  final String searchValue;
  final RequestSort sort;

  final ValueChanged<String> onSearch;
  final ValueChanged<RequestSort> onSort;
  final ValueChanged<AppointmentRequest> onRequestTap;

  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return RequestPageScaffold(
      title: title,
      actions: actions,
      floatingActionButton: floatingActionButton,
      child: Column(
        children: [
          RequestDashboard(
            requests: requests,
          ),
          const SizedBox(height: 20),
          RequestSearchBar(
            value: searchValue,
            onChanged: onSearch,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: RequestSortMenu(
              value: sort,
              onChanged: onSort,
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: RequestList(
              requests: requests,
              loading: loading,
              error: error,
              onTap: onRequestTap,
            ),
          ),
        ],
      ),
    );
  }
}
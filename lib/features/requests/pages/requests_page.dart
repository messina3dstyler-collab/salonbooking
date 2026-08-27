import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../request_providers.dart';
import '../widgets/request_dashboard.dart';
import '../widgets/request_details_sheet.dart';
import '../widgets/request_list.dart';
import '../widgets/request_page_scaffold.dart';
import '../widgets/request_search_bar.dart';
import '../widgets/request_sort_menu.dart';

class RequestsPage extends ConsumerStatefulWidget {
  const RequestsPage({
    super.key,
  });

  @override
  ConsumerState<RequestsPage> createState() =>
      _RequestsPageState();
}

class _RequestsPageState
    extends ConsumerState<RequestsPage> {
  String _query = "";
  RequestSort _sort = RequestSort.newest;

  @override
  Widget build(BuildContext context) {
    final controller =
    ref.watch(requestControllerProvider);

    final requests = controller.requests.where((e) {
      if (_query.isEmpty) {
        return true;
      }

      return e.customerName
          .toLowerCase()
          .contains(_query.toLowerCase()) ||
          e.salonName
              .toLowerCase()
              .contains(_query.toLowerCase());
    }).toList();

    return RequestPageScaffold(
      title: "Richieste",
      child: Column(
        children: [
          RequestDashboard(
            requests: requests,
          ),
          const SizedBox(height: 20),
          RequestSearchBar(
            value: _query,
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: RequestSortMenu(
              value: _sort,
              onChanged: (value) {
                setState(() {
                  _sort = value;
                });
              },
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: RequestList(
              requests: requests,
              loading: controller.isLoading,
              error: controller.error,
              onTap: (request) {
                RequestDetailsSheet.show(
                  context,
                  request: request,
                  timeline: const [],
                  customerName: request.customerName,
                  appointmentTitle: "Appuntamento",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
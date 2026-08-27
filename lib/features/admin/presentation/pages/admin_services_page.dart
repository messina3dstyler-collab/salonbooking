import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../admin_providers.dart';
import '../../models/admin_service_model.dart';

import '../widgets/admin_service_dialog.dart';
import '../widgets/admin_services_card.dart';
import '../widgets/empty_state.dart';

class AdminServicesPage extends ConsumerStatefulWidget {
  const AdminServicesPage({
    super.key,
  });

  @override
  ConsumerState<AdminServicesPage> createState() =>
      _AdminServicesPageState();
}

class _AdminServicesPageState
    extends ConsumerState<AdminServicesPage> {
  final TextEditingController _searchController =
  TextEditingController();

  String _filter = 'Tutti';
  String? _salonId;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });

    Future.microtask(_loadServices);
  }

  Future<void> _loadServices() async {
    final salonId = ref.read(
      adminCurrentSalonProvider,
    );

    if (salonId.isEmpty) {
      return;
    }

    _salonId = salonId;

    await ref
        .read(adminServicesControllerProvider)
        .loadServices(
      salonId,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AdminServiceModel> _applyFilters(
      List<AdminServiceModel> services,
      ) {
    final query =
    _searchController.text.trim().toLowerCase();

    return services.where((service) {
      final searchMatch =
          query.isEmpty ||
              service.name
                  .toLowerCase()
                  .contains(query) ||
              service.description
                  .toLowerCase()
                  .contains(query);

      final filterMatch =
      switch (_filter) {
        'Attivi' => service.active,
        'Disattivi' => !service.active,
        _ => true,
      };

      return searchMatch && filterMatch;
    }).toList();
  }

  Future<void> _openServiceDialog(
      AdminServiceModel? service,
      ) async {
    if (_salonId == null || !mounted) {
      return;
    }

    await showDialog(
      context: context,
      builder: (_) => AdminServiceDialog(
        salonId: _salonId!,
        service: service,
      ),
    );

    if (!mounted) {
      return;
    }

    await ref
        .read(adminServicesControllerProvider)
        .refresh();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      adminServicesControllerProvider,
    );

    final services = _applyFilters(
      controller.services,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Servizi',
        ),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Nuovo',
        ),
        onPressed: () {
          _openServiceDialog(null);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Cerca servizio',
                    prefixIcon:
                    const Icon(Icons.search),
                    suffixIcon:
                    _searchController.text.isEmpty
                        ? null
                        : IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: () {
                        _searchController
                            .clear();
                      },
                    ),
                    border:
                    const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Tutti',
                      label: Text('Tutti'),
                    ),
                    ButtonSegment(
                      value: 'Attivi',
                      label: Text('Attivi'),
                    ),
                    ButtonSegment(
                      value: 'Disattivi',
                      label: Text('Disattivi'),
                    ),
                  ],
                  selected: {
                    _filter,
                  },
                  onSelectionChanged: (value) {
                    setState(() {
                      _filter = value.first;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadServices,
              child: controller.isLoading
                  ? const Center(
                child:
                CircularProgressIndicator(),
              )
                  : controller.error != null
                  ? Center(
                child: Text(
                  controller.error!,
                ),
              )
                  : services.isEmpty
                  ? const EmptyState(
                message:
                'Nessun servizio trovato',
                icon:
                Icons.content_cut,
              )
                  : ListView.builder(
                padding:
                const EdgeInsets.all(16),
                itemCount:
                services.length,
                itemBuilder:
                    (context, index) {
                  final service =
                  services[index];

                  return AdminServicesCard(
                    service: service,
                    onTap: () {
                      _openServiceDialog(
                        service,
                      );
                    },
                    onDelete: () {
                      _confirmDelete(
                        service,
                      );
                    },
                    onRestore:
                        () async {
                      await ref
                          .read(
                        adminServicesControllerProvider,
                      )
                          .restoreService(
                        service.id,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      AdminServiceModel service,
      ) async {
    final confirm =
    await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Disattivare servizio?',
        ),
        content: Text(
          'Vuoi disattivare "${service.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },
            child: const Text(
              'Annulla',
            ),
          ),
          ElevatedButton(
            style:
            ElevatedButton.styleFrom(
              backgroundColor:
              Colors.red,
            ),
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },
            child: const Text(
              'Disattiva',
            ),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    await ref
        .read(
      adminServicesControllerProvider,
    )
        .deleteService(
      service.id,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Servizio disattivato',
        ),
      ),
    );
  }
}
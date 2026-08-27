import 'package:flutter/material.dart';

import '../../models/admin_agenda_item.dart';

class AdminAppointmentSheet extends StatelessWidget {
  const AdminAppointmentSheet({
    super.key,
    required this.item,
    this.onEdit,
    this.onMove,
    this.onCheckIn,
    this.onDelete,
  });

  final AdminAgendaItem item;

  final VoidCallback? onEdit;
  final VoidCallback? onMove;
  final VoidCallback? onCheckIn;
  final VoidCallback? onDelete;

  bool get _isCurrent {
    final now = DateTime.now();

    return now.isAfter(item.start) &&
        now.isBefore(item.end);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .84,
      minChildSize: .55,
      maxChildSize: .96,
      expand: false,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(34),
            ),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(
              22,
              18,
              22,
              34,
            ),
            children: [

              /// HANDLE

              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                        BorderRadius.circular(99),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// HEADER

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(26),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [

                      item.color.withValues(
                        alpha: .08,
                      ),

                      Colors.white,

                    ],
                  ),
                  border: Border.all(
                    color: item.color.withValues(
                      alpha: .12,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Hero(
                      tag: item.id,
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: item.color
                              .withValues(alpha: .14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.content_cut,
                          size: 34,
                          color: item.color,
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight:
                                  FontWeight.bold,
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [

                              _StatusChip(
                                color: item.color,
                                icon: Icons.schedule,
                                text: item.timeLabel,
                              ),

                              _StatusChip(
                                color: _isCurrent
                                    ? Colors.green
                                    : Colors.orange,
                                icon: _isCurrent
                                    ? Icons.play_circle_fill
                                    : Icons.event_available,
                                text: _isCurrent
                                    ? "In corso"
                                    : "Programmato",
                              ),

                              _StatusChip(
                                color: Colors.blue,
                                icon:
                                    Icons.timer_outlined,
                                text:
                                    "${item.duration.inMinutes} min",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              /// INFORMAZIONI

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius:
                      BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      _InfoTile(
                        icon: Icons.person,
                        title: "Cliente",
                        value: item.title,
                      ),

                      const Divider(height: 26),

                      _InfoTile(
                        icon: Icons.badge,
                        title: "Operatore",
                        value: item.employeeName,
                      ),

                      const Divider(height: 26),

                      _InfoTile(
                        icon: Icons.schedule,
                        title: "Orario",
                        value: item.timeLabel,
                      ),

                      if (item.note.isNotEmpty) ...[

                        const Divider(height: 26),

                        _InfoTile(
                          icon: Icons.notes,
                          title: "Note",
                          value: item.note,
                        ),

                      ],

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                "Azioni rapide",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 2.15,
                children: [

                  _ActionButton(
                    icon: Icons.edit_outlined,
                    title: "Modifica",
                    subtitle: "Cliente o servizi",
                    color: Colors.blue,
                    onTap: onEdit,
                  ),

                  _ActionButton(
                    icon: Icons.schedule,
                    title: "Sposta",
                    subtitle: "Data e orario",
                    color: Colors.orange,
                    onTap: onMove,
                  ),

                  _ActionButton(
                    icon: Icons.check_circle_outline,
                    title: "Check-in",
                    subtitle: "Cliente arrivato",
                    color: Colors.green,
                    onTap: onCheckIn,
                  ),

                  _ActionButton(
                    icon: Icons.phone_outlined,
                    title: "Chiama",
                    subtitle: "Contatta cliente",
                    color: Colors.teal,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    minimumSize:
                        const Size.fromHeight(56),
                    side: BorderSide(
                      color: Colors.red.shade300,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                  label: const Text(
                    "Annulla appuntamento",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

            ],
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius:
            BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: 16,
            color: color,
          ),

          const SizedBox(width: 6),

          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius:
                BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: Colors.grey.shade700,
            size: 21,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  @override
  State<_ActionButton> createState() =>
      _ActionButtonState();
}

class _ActionButtonState
    extends State<_ActionButton> {

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(
        milliseconds: 120,
      ),
      scale: _pressed ? .97 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(20),

          onTapDown: (_) {
            setState(() {
              _pressed = true;
            });
          },

          onTapCancel: () {
            setState(() {
              _pressed = false;
            });
          },

          onTapUp: (_) {
            setState(() {
              _pressed = false;
            });

            widget.onTap?.call();
          },

          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),
            curve: Curves.easeOut,

            decoration: BoxDecoration(
              color: widget.color.withValues(
                alpha: .08,
              ),
              borderRadius:
                  BorderRadius.circular(20),

              border: Border.all(
                color: widget.color.withValues(
                  alpha: .16,
                ),
              ),

              boxShadow: [

                BoxShadow(
                  color: widget.color.withValues(
                    alpha: .08,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),

              ],
            ),

            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),

              child: Row(
                children: [

                  Container(
                    width: 46,
                    height: 46,

                    decoration: BoxDecoration(
                      color:
                          widget.color.withValues(
                        alpha: .12,
                      ),
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 14,
                            color:
                                widget.color,
                          ),
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        Text(
                          widget.subtitle,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors
                                .grey
                                .shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: widget.color
                        .withValues(alpha: .70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
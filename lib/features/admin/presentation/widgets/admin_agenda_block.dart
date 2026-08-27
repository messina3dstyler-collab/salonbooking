import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/admin_agenda_item.dart';
import '../../../shared/widgets/swipe_actions/admin_swipe_action.dart';

class AdminAgendaBlock extends StatefulWidget {
  const AdminAgendaBlock({
    super.key,
    required this.item,
    required this.pulseAnimation,
    this.onTap,
    this.onEdit,
    this.onCheckIn,
    this.onDelete,
  });

  final AdminAgendaItem item;
  final Animation<double> pulseAnimation;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onCheckIn;
  final VoidCallback? onDelete;

  @override
  State<AdminAgendaBlock> createState() =>
      _AdminAgendaBlockState();
}

class _AdminAgendaBlockState
    extends State<AdminAgendaBlock> {

  bool _visible = false;
  bool _pressed = false;

  static const Color _highlightGold =
      Color(0xFFE7C85A);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        _visible = true;
      });
    });
  }

  bool get _isCurrent {
    final now = DateTime.now();

    return now.isAfter(widget.item.start) &&
        now.isBefore(widget.item.end);
  }

  String get _statusLabel {
    final now = DateTime.now();

    if (now.isAfter(widget.item.end)) {
      return "CONCLUSO";
    }

    if (_isCurrent) {
      return "IN CORSO";
    }

    final diff =
        widget.item.start.difference(now).inMinutes;

    if (diff >= 0 && diff <= 15) {
      return "TRA $diff MIN";
    }

    return "PROGRAMMATO";
  }

  Color get _statusColor {
    final now = DateTime.now();

    if (now.isAfter(widget.item.end)) {
      return Colors.grey;
    }

    if (_isCurrent) {
      return Colors.green;
    }

    final diff =
        widget.item.start.difference(now).inMinutes;

    if (diff >= 0 && diff <= 15) {
      return Colors.orange;
    }

    return Colors.blue;
  }

  IconData get _icon {
    switch (widget.item.type) {
      case AdminAgendaItemType.appointment:
        return Icons.content_cut;

      case AdminAgendaItemType.vacation:
        return Icons.beach_access;

      case AdminAgendaItemType.sick:
        return Icons.sick;

      case AdminAgendaItemType.breakTime:
        return Icons.restaurant;

      case AdminAgendaItemType.meeting:
        return Icons.groups;

      case AdminAgendaItemType.blocked:
        return Icons.block;
    }
  }

  @override
  Widget build(BuildContext context) {

    final minutes =
        widget.item.duration.inMinutes;

    final compact = minutes < 40;
    final medium =
        minutes >= 40 && minutes < 70;
    final large = minutes >= 70;

    return AnimatedOpacity(
      duration: const Duration(
        milliseconds: 220,
      ),
      opacity: _visible ? 1 : 0,

      child: AnimatedScale(
        duration: const Duration(
          milliseconds: 220,
        ),
        curve: Curves.easeOutBack,
        scale: _visible ? 1 : .96,

        child: Material(
          color: Colors.transparent,
          borderRadius:
              BorderRadius.circular(18),

          child: InkWell(
            borderRadius:
                BorderRadius.circular(18),

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

              HapticFeedback.lightImpact();

              widget.onTap?.call();
            },

            onLongPress: () {
              HapticFeedback.mediumImpact();

              widget.onTap?.call();
            },

            child: AnimatedScale(
              duration: const Duration(
                milliseconds: 100,
              ),
              scale: _pressed ? .975 : 1,

                child: AdminSwipeAction(
                  leftColor: const Color(0xFF2ECC71),
                  rightColor: const Color(0xFFF39C12),

                  leftIcon: Icons.check_circle,
                  rightIcon: Icons.edit,

                  leftText: "Check-in",
                  rightText: "Modifica",

                  onLeftAction: widget.onCheckIn,
                  onRightAction: widget.onEdit,

                child: Hero(
                  tag: widget.item.id,

                  child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  curve: Curves.easeOut,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(18),

                    border: Border.all(
                      color: _isCurrent
                          ? _highlightGold
                          : widget.item.color.withValues(
                              alpha: .18,
                            ),
                      width: _isCurrent ? 2.2 : 1,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: _isCurrent
                            ? _highlightGold.withValues(
                                alpha: .20,
                              )
                            : Colors.black.withValues(
                                alpha: _pressed
                                    ? .02
                                    : .06,
                              ),

                        blurRadius: _isCurrent
                            ? 16 +
                                (8 *
                                    widget.pulseAnimation.value)
                            : (_pressed ? 4 : 12),

                        spreadRadius: _isCurrent
                            ? widget.pulseAnimation.value
                            : 0,

                        offset: Offset(
                          0,
                          _pressed ? 1 : 4,
                        ),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [

                      /// BARRA COLORATA LATERALE

                      Container(
                        width: 5,
                        decoration: BoxDecoration(
                          color: _isCurrent
                              ? Color.lerp(
                                  _highlightGold,
                                  Colors.white,
                                  widget.pulseAnimation.value * .18,
                                )!
                              : widget.item.color,
                          borderRadius:
                              const BorderRadius.only(
                            topLeft:
                                Radius.circular(18),
                            bottomLeft:
                                Radius.circular(18),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical:
                                compact ? 5 : 8,
                          ),

                          child: compact

                              //--------------------------------------------------
                              // CARD PICCOLA
                              //--------------------------------------------------

                              ? Row(
                                  children: [

                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _statusColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),

                                    const SizedBox(width: 6),

                                    Icon(
                                      _icon,
                                      size: 14,
                                      color: _isCurrent
                                          ? _highlightGold
                                          : widget.item.color,
                                    ),

                                    const SizedBox(width: 6),

                                    Expanded(
                                      child: Text(
                                        widget.item.title,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        style:
                                            TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: _isCurrent
                                              ? const Color(
                                                  0xFF8A6A00,
                                                )
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                )

                              //--------------------------------------------------
                              // CARD MEDIA/GRANDE
                              //--------------------------------------------------

                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,

                                  children: [

                                    Container(
                                      margin:
                                          const EdgeInsets.only(
                                        bottom: 6,
                                      ),

                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        color:
                                            _statusColor.withValues(
                                          alpha: .12,
                                        ),

                                        borderRadius:
                                            BorderRadius.circular(
                                          50,
                                        ),
                                      ),

                                      child: Row(
                                        mainAxisSize:
                                            MainAxisSize.min,

                                        children: [

                                          Container(
                                            width: 7,
                                            height: 7,

                                            decoration:
                                                BoxDecoration(
                                              color:
                                                  _statusColor,
                                              shape:
                                                  BoxShape.circle,
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 5,
                                          ),

                                          Text(
                                            _statusLabel,
                                            style:
                                                TextStyle(
                                              color:
                                                  _statusColor,
                                              fontSize:
                                                  10,
                                              fontWeight:
                                                  FontWeight
                                                      .w800,
                                              letterSpacing:
                                                  .3,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),

                                    Row(
                                      children: [

                                        Icon(
                                          _icon,
                                          size: 15,
                                          color: _isCurrent
                                              ? _highlightGold
                                              : widget.item.color,
                                        ),

                                        const SizedBox(
                                          width: 6,
                                        ),

                                        Expanded(
                                          child: Text(
                                            widget.item.title,
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                            style:
                                                TextStyle(
                                              fontSize: 13,
                                              fontWeight:
                                                  FontWeight
                                                      .w700,
                                              color:
                                                  _isCurrent
                                                      ? const Color(
                                                          0xFF8A6A00,
                                                        )
                                                      : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if ((medium ||
                                            large) &&
                                        widget.item.note
                                            .isNotEmpty) ...[
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        widget.item.note,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors
                                              .grey
                                              .shade700,
                                        ),
                                      ),
                                    ],

                                    if (large) ...[
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [

                                          Icon(
                                            Icons.schedule,
                                            size: 12,
                                            color: _isCurrent
                                                ? _highlightGold
                                                : Colors.grey
                                                    .shade500,
                                          ),

                                          const SizedBox(
                                            width: 4,
                                          ),

                                          Text(
                                            widget.item
                                                .timeLabel,
                                            style:
                                                TextStyle(
                                              fontSize: 10,
                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                              color:
                                                  _isCurrent
                                                      ? const Color(
                                                          0xFF8A6A00,
                                                        )
                                                      : Colors
                                                          .grey
                                                          .shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                        ),
                      ),
                    ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    ),
    );
  }
}
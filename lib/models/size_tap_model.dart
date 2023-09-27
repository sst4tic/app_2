import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

Map<int, bool> _eventMap = {};

class SizeTapAnimation extends StatefulWidget {
  final Widget child;

  final VoidCallback? onTap;
  final HitTestBehavior? behavior;

  const SizeTapAnimation({
    required this.child,
    this.onTap,
    this.behavior = HitTestBehavior.opaque,
    Key? key,
  }) : super(key: key);

  bool get active => onTap != null;

  @override
  State<SizeTapAnimation> createState() => _SizeTapAnimationState();
}

class _SizeTapAnimationState extends State<SizeTapAnimation>
    with SingleTickerProviderStateMixin {
  final value = BehaviorSubject<AnimationController?>.seeded(null);

  AnimationController? get _animationController => value.value;
  set _animationController(AnimationController? val) {
    value.value = val;
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 160,
      ),
      lowerBound: 0.94,
      upperBound: 1,
      value: 1,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    value.value = null;
    _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: widget.behavior,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _animationController!,
          child: _ListenTap(
            controller: value,
            active: widget.active,
            child: widget.child,
          ),
          builder: (ctx, child) {
            return ScaleTransition(
              scale: _animationController!,
              child: RepaintBoundary(child: child),
            );
          },
        ),
      ),
    );
  }
}

class _ListenTap extends StatefulWidget {
  final BehaviorSubject<AnimationController?> controller;
  final Widget child;
  final bool active;

  const _ListenTap({
    required this.controller,
    required this.child,
    required this.active,
    Key? key,
  }) : super(key: key);

  @override
  __ListenTapState createState() => __ListenTapState();
}

class __ListenTapState extends State<_ListenTap> {
  bool openStarted = false;
  bool onPointerUpWas = false;
  bool onForawrdedHappen = false;
  TickerFuture? forwardTicker;
  Offset _offset = Offset.zero;

  AnimationController? get _animationController => widget.controller.value;

  void _cancel([PointerUpEvent? _]) async {
    if (_ != null) _eventMap.remove(_.pointer);
    if (!mounted) return;
    if (forwardTicker != null) return;
    onPointerUpWas = true;

    if (openStarted) return;
    onForawrdedHappen = true;
    forwardTicker = _animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerUp: _cancel,
      onPointerMove: (event) {
        _offset = _offset + event.delta;
        if (_offset.distance > 10) _cancel();
      },
      onPointerDown: (_) async {
        if (_eventMap[_.pointer] == true) return;
        _eventMap[_.pointer] = true;
        try {
          forwardTicker = null;
          _offset = Offset.zero;
          if (!widget.active) return;
          HapticFeedback.lightImpact();
          onPointerUpWas = false;
          onForawrdedHappen = false;
          openStarted = true;
          if (!mounted) return;

          await _animationController?.reverse();
          openStarted = false;

          if (onPointerUpWas && !onForawrdedHappen) {
            _animationController?.forward();
          }
        } catch (e) {
          log(e.toString());
        } finally {}
      },
      child: widget.child,
    );
  }
}
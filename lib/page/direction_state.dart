import 'package:VirtualFlightThrottle/utility/utility_system.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class FixedDirectionState<T> extends State with RouteAware {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    UtilitySystem.enableFixedDirection(true);
    UtilitySystem.enableUIOverlays(false);
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) => Container();

}

class RootFixedDirectionState<T> extends FixedDirectionState {

  @override
  void initState() {
    UtilitySystem.enableUIOverlays(false);
    UtilitySystem.enableFixedDirection(true);
    super.initState();
  }

}

class DynamicDirectionState<T> extends State with RouteAware {

  @override
  void initState() {
    UtilitySystem.enableFixedDirection(false);
    UtilitySystem.enableUIOverlays(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container();

}
import 'package:vfcs/utility/utility_system.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class FixedDirectionState<T> extends State with RouteAware {

  @override
  void initState() {
    SystemUtility.enableDarkSoftKey();
    SystemUtility.enableUIOverlays(false);
    SystemUtility.enableFixedDirection(true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPop() {
    SystemUtility.enableFixedDirection(false);
    SystemUtility.enableUIOverlays(true);
    super.didPop();
  }

  @override
  void didPopNext() {
    SystemUtility.enableFixedDirection(true);
    SystemUtility.enableUIOverlays(false);
    super.didPopNext();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container();

}

class FixedDirectionWithUIState<T> extends State with RouteAware {

  @override
  void initState() {
    SystemUtility.enableDarkSoftKey();
    SystemUtility.enableUIOverlays(true);
    SystemUtility.enableFixedDirection(true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPop() {
    SystemUtility.enableFixedDirection(false);
    SystemUtility.enableUIOverlays(true);
    super.didPop();
  }

  @override
  void didPopNext() {
    SystemUtility.enableFixedDirection(true);
    SystemUtility.enableUIOverlays(false);
    super.didPopNext();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container();

}

class DynamicDirectionState<T> extends State with RouteAware {

  @override
  void initState() {
    SystemUtility.enableFixedDirection(false);
    SystemUtility.enableUIOverlays(true);
    super.initState();
  }

  @override
  void didPopNext() {
    SystemUtility.enableFixedDirection(false);
    SystemUtility.enableUIOverlays(true);
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) => Container();

}
import 'package:flutter/widgets.dart';
import 'package:vfcs/utility/utility_dart.dart';
import 'package:vfcs/utility/utility_system.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class FixedOrientationPage<T> extends State with RouteAware {

  Orientation _orientation = Orientation.portrait;
  set orientation(Orientation orientation) {
    if (orientation == this._orientation) return;
    this._orientation = orientation;
    SystemUtility.enforceOrientation(true, orientation: this._orientation);
  }
  Orientation get orientation => this._orientation;

  @override
  void initState() {
    SystemUtility.enableDarkSoftKey();
    SystemUtility.enforceUIOverlays(Right(SystemUtility.preferredUIOverlays));
    SystemUtility.enforceOrientation(true, orientation: this._orientation);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPop() {
    SystemUtility.enforceOrientation(false);
    SystemUtility.enforceUIOverlays(Left(true));
    super.didPop();
  }

  @override
  void didPopNext() {
    SystemUtility.enforceOrientation(true, orientation: this._orientation);
    SystemUtility.enforceUIOverlays(Right(SystemUtility.preferredUIOverlays));
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

class DynamicOrientationPage<T> extends State with RouteAware {

  @override
  void initState() {
    SystemUtility.enforceOrientation(false);
    SystemUtility.enforceUIOverlays(Left(true));
    super.initState();
  }

  @override
  void didPopNext() {
    SystemUtility.enforceOrientation(false);
    SystemUtility.enforceUIOverlays(Left(true));
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) => Container();

}
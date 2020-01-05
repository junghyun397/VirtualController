import 'package:VirtualFlightThrottle/network/network_manager.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class PageNetwork extends StatefulWidget {
  PageNetwork({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _PageNetworkState();

}

class _PageNetworkState extends DynamicDirectionState<PageNetwork> {

  final AsyncMemoizer<List<String>> _memoizer = AsyncMemoizer<List<String>>();

  Future<List<String>> _fetchAliveTargetList() async {
    return this._memoizer.runOnce(() async {
      return await globalNetworkManager.findAliveTargetList();
    });
  }

  void _refetchAliveTargetList() {
    if (!this._memoizer.hasRun) return;
    print("dd");
    this.setState(() {});
  }

  Widget _buildInProcessing(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
            width: 80,
            height: 80,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text("finding target client..."),
          )
        ],
      ),
    );
  }

  Widget _buildTargetNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text("Target client not founded"),
          )
        ],
      ),
    );
  }

  Widget _buildTargetList(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Network"), // TODO: i8n needed
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _refetchAliveTargetList,
            ),
          ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _fetchAliveTargetList(),
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData && snapshot.data.isEmpty) return this._buildTargetNotFound(context);
            else if (snapshot.hasData && snapshot.data.isNotEmpty) return this._buildTargetList(context);
            else return this._buildInProcessing(context);
          },
        ),
      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import '../networking/debounce.dart';

class ApiService {
  Future<List<String>> searchItems(String query) async {
    await Future.delayed(const Duration(seconds: 1));
    return ['$query  1', '$query  2', '$query  3'];
  }
}

class DebouncedSearchDemo extends StatefulWidget {
  const DebouncedSearchDemo({super.key});

  @override
  State<DebouncedSearchDemo> createState() => _DebouncedSearchDemoState();
}

class _DebouncedSearchDemoState extends State<DebouncedSearchDemo> {
  final _instanceDebouncer = Debouncer(delay: const Duration(seconds: 5));
  final _apiService = ApiService();
  final _instanceSearchController = TextEditingController();
  final _staticSearchController = TextEditingController();
  List<String> _instanceSearchResults = [];
  bool _isInstanceSearchLoading = false;
  StreamSubscription? _remainingTimeSubscription;

  String _staticSearchResult = '';
  bool _isStaticSearchLoading = false;
  int _staticSearchCount = 0;
  int _staticTriggerCount = 0;

  @override
  void initState() {
    super.initState();
    _remainingTimeSubscription = _instanceDebouncer.getRemainingTimeStream().listen((time) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _instanceDebouncer.cancel();
    _instanceSearchController.dispose();
    _staticSearchController.dispose();
    _remainingTimeSubscription?.cancel();
    super.dispose();
  }

  Future<void> _performInstanceSearch(String query) async {
    setState(() => _isInstanceSearchLoading = true);
    try {
      final results = await _apiService.searchItems(query);
      setState(() {
        _instanceSearchResults = results;
        _isInstanceSearchLoading = false;
      });
    } catch (e) {
      debugPrint('Error during instance search: $e');
      setState(() => _isInstanceSearchLoading = false);
    }
  }

  Future<String> _performStaticSearch(String query) async {
    _staticSearchCount++;
    debugPrint('Static search called with query: "$query" (Search #$_staticSearchCount)');
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('Static search completed for query: "$query" (Search #$_staticSearchCount)');
    return 'Result for "$query" (Search #$_staticSearchCount)';
  }

  void _triggerStaticSearch() {
    _staticTriggerCount++;
    debugPrint('Static search triggered (Trigger #$_staticTriggerCount)');

    setState(() => _isStaticSearchLoading = true);

    Debouncer.debounce<String>(
      () async {
        debugPrint('Debounced static search executed (Trigger #$_staticTriggerCount)');
        return await _performStaticSearch(_staticSearchController.text);
      },
      duration: const Duration(seconds: 1),
    ).then((result) {
      debugPrint('Static search completed with result: $result');
      setState(() {
        _staticSearchResult = result;
        _isStaticSearchLoading = false;
      });
    }).catchError((error) {
      debugPrint('Static search failed with error: $error');
      setState(() {
        _staticSearchResult = 'Error: $error';
        _isStaticSearchLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debounced Search Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstanceSearchSection(),
            const SizedBox(height: 24),
            _buildStaticSearchSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstanceSearchSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Instance Debouncer Demo', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _instanceSearchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) => _instanceDebouncer(() => _performInstanceSearch(value)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _instanceDebouncer.executeNow(),
                    child: const Text(
                      'Search Now',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _instanceDebouncer.reset(),
                    child: const Text(
                      'Reset Timer',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _instanceDebouncer.cancel(),
                    child: const Text(
                      'Cancel Search',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StreamBuilder<bool>(
              stream: _instanceDebouncer.isScheduledStream,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data == true
                      ? 'Search scheduled: ${_instanceDebouncer.remainingTime?.inMilliseconds ?? 'N/A'} ms remaining'
                      : 'No search scheduled',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isInstanceSearchLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _instanceSearchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(title: Text(_instanceSearchResults[index]));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticSearchSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Static Debounce Demo', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _staticSearchController,
              decoration: InputDecoration(
                labelText: 'Enter text for static debounce',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _triggerStaticSearch,
              child: const Text('Trigger Static Debounced Search'),
            ),
            const SizedBox(height: 8),
            const Text('Tip: Press the button multiple times quickly', style: TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Text('Trigger Count: $_staticTriggerCount , but executed Count $_staticSearchCount',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _isStaticSearchLoading
                ? const Center(child: CircularProgressIndicator())
                : Text('Static Search Result: $_staticSearchResult',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

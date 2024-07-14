import 'package:flutter/material.dart';

import 'api_call_page.dart';
import 'debouncer_sample.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Api Handling"),
        centerTitle: true,
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DemoApiCallPage()));
            },
            child: Card(
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(
                      child: Text(
                    "Api Call",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ))),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DebouncedSearchDemo()));
            },
            child: Card(
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(
                      child: Text(
                    "Debounce",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ))),
            ),
          )
        ],
      ),
    );
  }
}

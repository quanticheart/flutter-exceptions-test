import 'dart:io';

import 'package:flutter/material.dart';

GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  void handlePlatformError(BuildContext context) {
    String errorMessage;
    if (Platform.isAndroid) {
      errorMessage = 'This feature is not available on Android.';
    } else if (Platform.isIOS) {
      errorMessage = 'This feature is not available on iOS.';
    } else if (Platform.isMacOS) {
      errorMessage = 'This feature is not available on macOS.';
    } else if (Platform.isWindows) {
      errorMessage = 'This feature is not available on Windows.';
    } else if (Platform.isLinux) {
      errorMessage = 'This feature is not available on Linux.';
    } else if (Platform.isFuchsia) {
      errorMessage = 'This feature is not available on Fuchsia.';
    } else {
      errorMessage = 'This feature is not supported on your platform.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => widget.handlePlatformError(context),
              child: Text('Show Platform Error'),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyAppTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Global Error Handling',
      home: ErrorHandlerWidget(
        child: MyHomePageTest(),
      ),
    );
  }
}

class MyHomePageTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Global Error Handling Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Uncomment the line below to trigger an error
            // throw Exception('Simulated error');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          },
          child: Text('Trigger Error'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Uncomment the line below to trigger an error
            // throw Exception('Another simulated error');
          },
          child: const Text('Trigger Another Error'),
        ),
      ),
    );
  }
}

class ErrorHandlerWidget extends StatefulWidget {
  final Widget child;

  const ErrorHandlerWidget({super.key, required this.child});

  @override
  State<ErrorHandlerWidget> createState() => _ErrorHandlerWidgetState();
}

class _ErrorHandlerWidgetState extends State<ErrorHandlerWidget> {
  // Error handling logic
  void onError(FlutterErrorDetails errorDetails) {
    // Add your error handling logic here, e.g., logging, reporting to a server, etc.
    print('Caught error: ${errorDetails.exception}');
  }

  @override
  Widget build(BuildContext context) {
    return ErrorWidgetBuilder(
      builder: (context, errorDetails) {
        // Display a user-friendly error screen
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(
            child: Text('Something went wrong. Please try again later.'),
          ),
        );
      },
      onError: onError,
      child: widget.child,
    );
  }
}

class ErrorWidgetBuilder extends StatefulWidget {
  final Widget Function(BuildContext, FlutterErrorDetails) builder;
  final void Function(FlutterErrorDetails) onError;
  final Widget child;

  ErrorWidgetBuilder({
    required this.builder,
    required this.onError,
    required this.child,
  });

  @override
  _ErrorWidgetBuilderState createState() => _ErrorWidgetBuilderState();
}

class _ErrorWidgetBuilderState extends State<ErrorWidgetBuilder> {
  @override
  void initState() {
    super.initState();
    // Set up global error handling
    FlutterError.onError = widget.onError;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

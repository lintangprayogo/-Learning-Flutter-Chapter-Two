import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/bloc/counter_bloc.dart';
import 'custom_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        
        home: MainPage(),
        
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CounterState counterState = context.watch<CounterBloc>().state;
    int number = context.select<CounterBloc, int>((counterBloc) =>
        (counterBloc.state is CounterValue)
            ? (counterBloc.state as CounterValue).number
            : null);
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Bloc v6.11 Demo'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<CounterBloc, CounterState>(
                    builder: (_, state) => CustomCard("Bloc\nBuilder",
                        (state is CounterValue) ? state.number : null)),
                SizedBox(
                  width: 40,
                ),
                CustomCard(
                    "Watch",
                    (counterState is CounterValue)
                        ? counterState.number
                        : null),
                SizedBox(
                  width: 40,
                ),
                CustomCard("Select", number),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            RaisedButton(
                child: Text(
                  'INCREMENT',
                  style: TextStyle(color: Colors.white),
                ),
                shape: StadiumBorder(),
                color: Colors.green[800],
                onPressed: () {
                  context.read<CounterBloc>().add(Increment());
                })
          ],
        ));
  }
}

// import 'package:bloc_test/bloc_test.dart';
// import 'package:noteapp/cubit/counter_cubit.dart';
// import 'package:test/test.dart';

// void main() {
//   group('CounterCubit', () {
//     CounterCubit counterCubit;

//     counterCubit = CounterCubit();
//     setUp(() {
//       counterCubit = CounterCubit();
//     });

//     tearDown(() {
//       counterCubit.close();
//     });
//     test('initial state for the CounterCubit is CounterState(counterValue:0',
//         () {
//       expect(counterCubit.state, CounterState(counterValue: 0));
//     });
//     blocTest(
//       'the cubit should emit CounterState(counterValue:1,wasincremented:true)',
//       build: () => counterCubit,
//       act: (cubit) => cubit.increment(),
//       expect: [
//         CounterState(counterValue: 1, wasincremented: true),
//       ],
//     );
//     blocTest(
//       'the cubit should emit CounterState(counterValue:-1,wasincremented:false)',
//       build: () => counterCubit,
//       act: (cubit) => cubit.decrement(),
//       expect: [
//         CounterState(counterValue: -1, wasincremented: false),
//       ],
//     );
//   });
// }

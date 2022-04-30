// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:while_app/logic/timer/timer_bloc.dart';
// import 'package:while_app/presentation/designs/circle.dart';
// import 'package:while_app/presentation/screens/pickTimeScreen.dart';

// class CountdownScreen extends StatefulWidget {
//   const CountdownScreen({Key? key}) : super(key: key);

//   @override
//   State<CountdownScreen> createState() => _CountdownState();
// }

// class _CountdownState extends State<CountdownScreen> with TickerProviderStateMixin {
//   late final AnimationController _controller = AnimationController(
//     duration: const Duration(seconds: 60),
//     vsync: this,
//   )..forward();

//   int count = 0;

//   late int minutes;

//   ValueNotifier active = ValueNotifier(true);

//   Timer? changeOpacity;

//   bool completed = false;

//   showTime() {
//     active.value = true;
//     changeOpacity?.cancel();
//     changeOpacity = Timer.periodic(const Duration(seconds: 1), (timer) {
//       active.value = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     minutes = context.read<TimerBloc>().state.value;
//   }

//   @override
//   void didChangeDependencies() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//     showTime();
//     _controller.addListener(() {
//       if (_controller.isCompleted) {
//         count++;

//         if (count < minutes) {
//           _controller.reset();
//           _controller.forward();
//         } else {
//           setState(() {
//             completed = true;
//           });
//         }
//       }
//     });
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () => (completed)
//             ? () {
//                 context.read<TimerBloc>().add(const TimerChangeEvent(0));
//                 Navigator.of(context).pushReplacement(
//                   PageRouteBuilder(
//                     pageBuilder: (_, __, ___) => const PickTimeScreen(),
//                     transitionDuration: Duration.zero,
//                     reverseTransitionDuration: Duration.zero,
//                   ),
//                 );
//               }.call()
//             : showTime(),
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color.fromRGBO(255, 255, 255, 1),
//                 Color.fromRGBO(255, 255, 255, 1),
//                 Color.fromRGBO(210, 210, 210, 1),
//                 Color.fromRGBO(210, 210, 210, 1),
//               ],
//               stops: [0, 0.5, 0.5, 1],
//             ),
//           ),
//           child: (completed)
//               ? Padding(
//                   padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2 - 150),
//                   child: const Text(
//                     'end of session',
//                     style: TextStyle(fontSize: 30),
//                     textAlign: TextAlign.center,
//                   ),
//                 )
//               : Stack(
//                   alignment: Alignment.topCenter,
//                   children: [
//                     Positioned(
//                       left: 50,
//                       bottom: MediaQuery.of(context).size.height / 2 + 50,
//                       child: ValueListenableBuilder(
//                         valueListenable: active,
//                         builder: (context, _, __) {
//                           return AnimatedOpacity(
//                             opacity: active.value ? 1 : 0,
//                             duration: const Duration(milliseconds: 500),
//                             child: Text(
//                               '${(minutes - count)} min',
//                               style: const TextStyle(fontSize: 22),
//                               textAlign: TextAlign.left,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     AnimatedBuilder(
//                       animation: _controller,
//                       builder: (BuildContext context, Widget? child) {
//                         final double height = MediaQuery.of(context).size.height;
//                         final double halfHeight = height * 0.5;
//                         final double gHalfHeight = halfHeight + 32;
//                         final double lHalfHeight = halfHeight - 32;
//                         final double val = _controller.value;

//                         return SingleChildScrollView(
//                           physics: const NeverScrollableScrollPhysics(),
//                           child: Column(
//                             children: [
//                               CustomPaint(
//                                 painter: Circle(
//                                   val < 0.01 ? halfHeight + 3200 * val : gHalfHeight + lHalfHeight * ((val * 60).floor() / 60),
//                                   val < 0.9 ? 1 - val : 0.1,
//                                 ),
//                               ),
//                               for (int i = 1; i < minutes - count; i++)
//                                 CustomPaint(
//                                   painter: Circle(
//                                     val < 0.01 ? halfHeight - i * 32 + 3200 * val : halfHeight - (i - 1) * 32,
//                                     1,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mx_p/constants/app_colors.dart';
import 'package:mx_p/constants/custom_log.dart';

// class CustomSlider extends StatefulWidget {
//   @override
//   _CustomSliderState createState() => _CustomSliderState();
// }

// class _CustomSliderState extends State<CustomSlider> {
//   double _sliderValue = 0.5; // Current slider value (from 0 to 1)
//   double _thumbPosition = 0.5; // Thumb's position along the track
//   double _currentPosition = 0.0;


//   double checkPos = 0.1;

//   // Slider constants
//   final double _trackHeight = 4.0; // Height of the track
//   final double _thumbRadius = 10.0; // Radius of the thumb
//   final double _trackWidth = 300.0; // Width of the slider track

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Custom Slider (0 to 1)")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Slider track
//             GestureDetector(
//               onHorizontalDragUpdate: _onHorizontalDragUpdate,
//               child: Container(
//                 width: _trackWidth,
//                 height: _thumbRadius * 2,
//                 child: Stack(
//                   alignment: Alignment.centerLeft,
//                   children: [
//                     // Track line
//                     Container(
//                       width: _trackWidth,
//                       height: _trackHeight,
//                       color: Colors.grey[400], // Track color
//                     ),

//                     Container(
//                       width: _currentPosition,
//                       height: _trackHeight,
//                       color: Colors.blue, // Track color
//                     ),

//                     // Thumb
//                     Positioned(
//                       left: _thumbPosition * _trackWidth - _thumbRadius,
//                       child: Container(
//                         width: _thumbRadius * 2,
//                         height: _thumbRadius * 2,
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),

//             Slider(value: 0.5, onChanged: (v){
//             },
//             onChangeStart: (value) {
//               customLog(value);
//             },
//             ),

//             CustomProgressIndicator(
//               value:checkPos, 
//               onChangeUpdate: (v){
//                 setState(() {
//                   checkPos = v;
//                 });
//             },
//             onChangeEnd: (p0) {
//                customLog(p0);
//             },
//             ),
//             // Display the current value of the slider (between 0 and 1)
//             Text(
//               "Slider Value: ${_sliderValue.toStringAsFixed(2)}",
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _onHorizontalDragUpdate(DragUpdateDetails details) {
//     // Get the position relative to the slider track
//     double dx = details.localPosition.dx;

//     // Ensure thumb stays within bounds of the track (0 to _trackWidth)
//     if (dx < 0) dx = 0;
//     if (dx > _trackWidth) dx = _trackWidth;

//     // Calculate the thumb position as a value between 0 and 1
//     setState(() {
//       _thumbPosition = dx / _trackWidth; // Position as percentage of the track
//       _sliderValue = _thumbPosition; // Map position to slider value (0 to 1)
//       _currentPosition = _thumbPosition*_trackWidth;
//     });
//   }
// }


class CustomProgressIndicator extends StatelessWidget {
   CustomProgressIndicator({super.key,required this.value,  this.onChangeStart,  this.onChangeEnd, required this.onChangeUpdate, this.padding});

  double value;
  final EdgeInsetsGeometry? padding;
  final Function(double)? onChangeStart;
  final Function(double)? onChangeEnd;
  final Function(double) onChangeUpdate;


  final double _trackHeight = 5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
        var trackWidth = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (details) {
            double dx = details.localPosition.dx;
            var draggedPosition = dx/trackWidth;
            onChangeStart?.call(draggedPosition);
          },
          onHorizontalDragUpdate: (details) {
            customLog('check');
           double dx = details.localPosition.dx;
            if (dx<0) dx = 0;
            if(dx>trackWidth) dx = trackWidth;
           var draggedPosition = dx/trackWidth;
           onChangeUpdate(draggedPosition);
          },
          onHorizontalDragEnd: (details) {
            var dx = details.localPosition.dx;
            var draggedPosition = dx/trackWidth;
            onChangeEnd?.call(draggedPosition);
          },
          
          child: Padding(
            padding: padding??EdgeInsets.symmetric(vertical: 15.h,horizontal: 8),
            child: Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: _trackHeight,
                  width: double.infinity,
                  color: Colors.grey.shade400.withOpacity(0.5),
                ),
                Container(
                  height: _trackHeight,
                  width: value*trackWidth,
                  color: AppColor.contentForeGroundColor,
                ),
                Positioned(
                  left: value*trackWidth,
                  child: CircleAvatar(radius: _trackHeight,
                  backgroundColor: AppColor.contentForeGroundColor,
                  ))
              ],
            ),
          ),
        );
      }
    );
  }
}
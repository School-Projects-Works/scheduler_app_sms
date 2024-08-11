

import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

Widget onBoarding() => Onboarding(
swipeableBody: [
Container(),
],
startIndex:0,
onPageChanges:(netDragDistance,pagesLength,currentIndex, slideDirection){
},
buildHeader:(context, netDragDistance, pagesLength, currentIndex, setIndex, slideDirection){
  return Image.asset('assets/icon/icon.png');
},
buildFooter:(context, netDragDistance, pagesLength, currentIndex, setIndex, slideDirection){
  return SizedBox(
    height: 60,
    width: 60,
    child: FloatingActionButton(
      onPressed: (){
        if(currentIndex+1<pagesLength){
          setIndex(currentIndex+1);
        }
      },
      child: const Icon(Icons.arrow_forward),
    ),
  );
},
animationInMilliseconds:300, //[int] - the speed of animations in ms
);
import 'package:flutter/material.dart';
Widget bottomNavigatorButton(Function()? ontap,int index,int index2,String assetsTitle,String title) { 
  return MaterialButton(
                  minWidth: 35,
                  onPressed: ontap,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      index == index2 ? Container(
                          height: 28,
                          width: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(assetsTitle,color: Colors.white,),
                          )):Image.asset(assetsTitle,height: 18,color: Colors.grey,),
                      const SizedBox(height: 4,),
                      Text(
                        title,
                        style: TextStyle(
                          color: index == index2 ? Colors.black : Colors.grey,
                          fontWeight: index == index2
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
} 
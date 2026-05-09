import 'package:flutter/material.dart';

class ReflectionSourceOption {
  const ReflectionSourceOption(this.label, this.icon);

  final String label;
  final IconData icon;
}

const reflectionSourceOptions = [
  ReflectionSourceOption('講道', Icons.co_present_outlined),
  ReflectionSourceOption('禱告', Icons.volunteer_activism_outlined),
  ReflectionSourceOption('靈修', Icons.wb_twilight_outlined),
  ReflectionSourceOption('閱讀', Icons.menu_book_outlined),
  ReflectionSourceOption('其他', Icons.more_horiz_rounded),
];

const reflectionSuggestedTags = ['平安', '信心', '感恩', '愛'];

import 'dart:io';

String readJsonCore(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  return File('$dir/core/test/$name').readAsStringSync();
}

String stringifyCount(int number, int count){
  String c = number.toString();
  for(int i = c.length; i< count; i++){
    c = '0$c';
  }
  return c;
}
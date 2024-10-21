extension MoveElement<T> on List<T> {
  void move(int from,) {
    RangeError.checkValidIndex(from, this, "from", length);
    //RangeError.checkValidIndex(to, this, "to", length);
     int to = length - 1;
    var element = this[from];
    if (from < to) {
      this.setRange(from, to, this, from + 1);
    } else {
      this.setRange(to + 1, from + 1, this, to);
    }
    this[to] = element;
  }
}
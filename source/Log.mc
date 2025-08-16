import Toybox.System;
import Toybox.Time;
import Toybox.Lang;


function getTimeString() {
  var today = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
  var dateString = Lang.format(
    "$4$ $5$ $6$ $7$ - $1$:$2$:$3$",
    [
        today.hour,
        today.min,
        today.sec,
        today.day_of_week,
        today.day,
        today.month,
        today.year
    ]
  );
  return dateString;
}


(:debug)
module Log {
  function debug(string) {
    var timeStr = getTimeString();
    System.println("| DEBUG | " + timeStr + " | " + string);
  }
  function showMemoryUsage() {
      var stats = System.getSystemStats();
      debug(" --- System Stats: totalMemory: " + stats.totalMemory);
      debug("--- System Stats: usedMemory: " + stats.usedMemory);
      debug("--- System Stats: freeMemory: " + stats.freeMemory);
  }
  }

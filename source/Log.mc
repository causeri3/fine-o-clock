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
  
}}

// (:warning)
// module Log {
//     function warning(string) {
//         var timeStr = getTimeString();
//         System.println("| WARNING | " + timeStr + " | " + string);
//     }
// }

// (:error)
// module Log {
//   function error(string) {
//   var timeStr = getTimeString();
//     System.println("| ERROR | " + timeStr + " | " + string);
  
// }}

(:release)
module Log {
  function debug(string) {}
  // function error(string) {}
  // function warning(string) {}
}

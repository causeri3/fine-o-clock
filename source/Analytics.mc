

import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

(:background)
class Analytics {
    const QUEUE_KEY = "eventQueue";
    const LATEST_SETTINGS_KEY = "latestSettings";
    const MAX_QUEUE = 5;

    function initialize() {
    }

    function trackSettings(data as Dictionary) as Void {
        Storage.setValue(LATEST_SETTINGS_KEY, data);
    }

    function track(eventType as String, data as String or Dictionary or Null) as Void  {
        var event = {
            "event"  => eventType,
            "device_id" => Storage.getValue("deviceId"),
            "part_no"   => Storage.getValue("partNumber"),
            "ts"    => Time.now().value(),
            "data" => (data != null) ? data : ""};
        _enqueue(event);
    }

    function _enqueue(event as Dictionary) as Void {
        var queue = Storage.getValue(QUEUE_KEY) as Array or Null;
        if (queue == null) { queue = []; }
        queue.add(event);
        if (queue.size() > MAX_QUEUE) {
            queue = queue.slice(queue.size() - MAX_QUEUE, null) as Array;
        }
        Storage.setValue(QUEUE_KEY, queue);
    }
}


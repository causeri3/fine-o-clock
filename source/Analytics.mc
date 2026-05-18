

import Toybox.Communications;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

(:background)
class Analytics {
    const QUEUE_KEY = "eventQueue";
    const LATEST_SETTINGS_KEY = "latestSettings";
    const MAX_QUEUE = 5;
    const ENDPOINT = "https://tvsvdqiqfjywgzeozwxf.supabase.co/functions/v1/finoclock";

    function initialize() {
    }

    function trackSettings(data as Dictionary) as Void {
        SafeStorage.setValue(LATEST_SETTINGS_KEY, data);
    }

    function track(eventType as String, data as String or Dictionary or Null) as Void  {
        var event = {
            "event"  => eventType,
            "device_id" => SafeStorage.getValue("deviceId"),
            "part_no"   => SafeStorage.getValue("partNumber"),
            "ts"    => Time.now().value(),
            "data" => (data != null) ? data : ""};
        _enqueue(event);
    }

    // Send a single event directly without touching Storage. Older devices - as vivoactive3 - throw "Background processes cannot modify the object store"
    function trackImmediate(eventType as String, data as String or Dictionary or Null, callback as Method) as Void {
        var settings = System.getDeviceSettings();
        var event = {
            "event"     => eventType,
            "device_id" => settings.uniqueIdentifier,
            "part_no"   => settings.partNumber,
            "ts"        => Time.now().value(),
            "data"      => (data != null) ? data : ""};
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => { "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        System.println("Analytics.trackImmediate: posting event=" + eventType + " part_no=" + settings.partNumber);
        Communications.makeWebRequest(ENDPOINT, { "events" => [event] }, options, callback);
    }

    function _enqueue(event as Dictionary) as Void {
        var queue = SafeStorage.getValue(QUEUE_KEY) as Array or Null;
        if (queue == null) { queue = []; }
        queue.add(event);
        if (queue.size() > MAX_QUEUE) {
            queue = queue.slice(queue.size() - MAX_QUEUE, null) as Array;
        }
        SafeStorage.setValue(QUEUE_KEY, queue);
    }
}


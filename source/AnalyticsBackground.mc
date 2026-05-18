import Toybox.Background;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

(:background)
class AnalyticsBackground extends System.ServiceDelegate {
    const QUEUE_KEY = "eventQueue";
    const LATEST_SETTINGS_KEY = "latestSettings";
    const ENDPOINT = "https://tvsvdqiqfjywgzeozwxf.supabase.co/functions/v1/finoclock";

    function initialize() {
        System.ServiceDelegate.initialize();
    }

    function onTemporalEvent() as Void {
        _trackDailyActiveIfNeeded();
        var queue = SafeStorage.getValue(QUEUE_KEY) as Array or Null;
        if (queue == null) { queue = []; }
        var latestSettings = SafeStorage.getValue(LATEST_SETTINGS_KEY) as Dictionary or Null;
        if (latestSettings != null) {
            var event = {
                "event"     => "settings",
                "device_id" => SafeStorage.getValue("deviceId"),
                "part_no"   => SafeStorage.getValue("partNumber"),
                "ts"        => Time.now().value(),
                "data"      => latestSettings};
            queue.add(event);
        }
        if (queue.size() == 0) {
            Background.exit(null);
            return;
        }
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => { "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        Communications.makeWebRequest(ENDPOINT, { "events" => queue }, options, method(:onBatchComplete));
    }

    function onBatchComplete(responseCode as Number, data as Dictionary or String or Null) as Void {
        System.println("Analytics batch sent, responseCode: " + responseCode + " data: " + data);
        if (responseCode == 200) {
            SafeStorage.deleteValue(QUEUE_KEY);
            SafeStorage.deleteValue(LATEST_SETTINGS_KEY);
        }
        Background.exit(null);
    }

    function _trackDailyActiveIfNeeded() as Void {
        var today = Time.today().value();
        var lastTracked = SafeStorage.getValue("lastActiveDayTs");
        if (lastTracked == null || (lastTracked as Number) < today) {
            // Gate the enqueue on the marker write so we don't re-emit
            // daily_active every background tick if the write failed.
            if (SafeStorage.setValue("lastActiveDayTs", today)) {
                new Analytics().track("daily_active", null);
            }
        }
    }
}

import Toybox.Application.Storage;
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
        var queue = Storage.getValue(QUEUE_KEY) as Array or Null;
        if (queue == null) { queue = []; }
        var latestSettings = Storage.getValue(LATEST_SETTINGS_KEY) as Dictionary or Null;
        if (latestSettings != null) {
            var event = {
                "event"     => "settings",
                "device_id" => Storage.getValue("deviceId"),
                "part_no"   => Storage.getValue("partNumber"),
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
            Storage.deleteValue(QUEUE_KEY);
            Storage.deleteValue(LATEST_SETTINGS_KEY);
        }
        Background.exit(null);
    }

    function _trackDailyActiveIfNeeded() as Void {
        var today = Time.today().value();
        var lastTracked = Storage.getValue("lastActiveDayTs");
        if (lastTracked == null || (lastTracked as Number) < today) {
            Storage.setValue("lastActiveDayTs", today);
            var analytics = new Analytics();
            analytics.track("daily_active", null);
        }
    }
}
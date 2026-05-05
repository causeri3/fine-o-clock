import Toybox.Application.Storage;
import Toybox.Background;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

(:background)
class AnalyticsBackground extends System.ServiceDelegate {
    var QUEUE_KEY = "eventQueue";
    var ENDPOINT = "https://tvsvdqiqfjywgzeozwxf.supabase.co/functions/v1/finoclock";

    function initialize() {
        System.ServiceDelegate.initialize();
    }

    function onTemporalEvent() as Void {
        _trackDailyActiveIfNeeded();
        var queue = Storage.getValue(QUEUE_KEY) as Array or Null;
        if (queue == null || queue.size() == 0) {
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
        }
        Background.exit(null);
    }

    function _trackDailyActiveIfNeeded() as Void {
        var today = Time.today().value();
        var lastTracked = Storage.getValue("lastActiveDayTs");
        if (lastTracked == null || (lastTracked as Number) < today) {
            Storage.setValue("lastActiveDayTs", today);
            var analytics = new Analytics();
            analytics.track("daily_active", null); // uses the capped _enqueue
        }
    }
}
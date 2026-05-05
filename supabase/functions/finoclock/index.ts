import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "apikey, content-type",
      },
    });
  }

  const raw = await req.text();
  console.log("incoming:", raw);

  let body: any;
  try {
    body = JSON.parse(raw);
  } catch {
    try {
      const params = new URLSearchParams(raw);
      body = Object.fromEntries(params.entries());
      if (body.ts) body.ts = Number(body.ts);
    } catch {
      return new Response(JSON.stringify({ error: "cannot parse" }), { status: 400 });
    }
  }

  let events: any[];
  if (body.events && Array.isArray(body.events)) {
    events = body.events;
  } else if (body.event && body.device_id) {
    events = [body];
  } else {
    return new Response(JSON.stringify({ error: "no events", body }), { status: 400 });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  const rows = events.map((e: any) => {
    const utcMs = Number(e.ts) * 1000;
    const tzOffsetSec = Number(e.tz_offset) || 0;
    const localMs = utcMs + tzOffsetSec * 1000;
    return {
      device_id: String(e.device_id),
      part_no: String(e.part_no || "unknown"),
      event: String(e.event),
      ts: new Date(localMs).toISOString(),
      data: (e.data && typeof e.data === 'object') ? e.data : null};
  });

  const { error } = await supabase
    .from("finoclock")
    .upsert(rows, { onConflict: "device_id,event,ts", ignoreDuplicates: true });

  if (error) {
    console.log("DB error:", error.message);
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }

  return new Response(JSON.stringify({ ok: true, count: rows.length }), { status: 200 });
});

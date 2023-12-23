const bindClientMessage = (e, t) => {
  var i;
  if (this.client) {
      const o = Date.now()
        , r = u.PushFrame.deserializeBinary(e.data)
        , s = p.Response.deserializeBinary(function(e) {
          for (const t of Object.values(e.getHeadersList()))
              if ("compress_type" === t.getKey() && "gzip" === t.getValue())
                  return !0;
          return !1
      }(r) ? (0,
      l.ec)(r.getPayload()) : r.getPayload_asU8());
      if (s.getNeedAck()) {
          this.internalExt = s.getInternalExt(),
          this.cursor = s.getCursor();
          const e = new u.PushFrame;
          e.setPayloadType("ack"),
          e.setPayload(function(e) {
              const t = [];
              for (const i of e) {
                  const e = i.charCodeAt(0);
                  e < 128 ? t.push(e) : e < 2048 ? (t.push(192 + (e >> 6)),
                  t.push(128 + (63 & e))) : e < 65536 && (t.push(224 + (e >> 12)),
                  t.push(128 + (e >> 6 & 63)),
                  t.push(128 + (63 & e)))
              }
              return Uint8Array.from(t)
          }(s.getInternalExt())),
          e.setLogid(r.getLogid()),
          null === (i = this.client.socket) || void 0 === i || i.send(e.serializeBinary())
      }
      if ("msg" === r.getPayloadType()) {
          this.info("fetchSocketServer socket response: ", (()=>s.toObject()));
          const e = Number(s.getNow());
          this.ntp.updateNTPDiff(o, e);
          const t = this.ntp.getMessageArriveTime(e);
          this.emit(s, {
              message_from: a.socket,
              server_now: t.server_now,
              imsdk_recv_time: t.imsdk_recv_time,
              adjusted_imsdk_recv_time: t.adjusted_imsdk_recv_time
          })
      }
      if ("close" === r.getPayloadType())
          return t(new Error("close by payloadtype"))
  }
}
class c {
  constructor(e) {
      const t = function(e) {
          const {app_name: t, routeParamsMap: i, pushServer: n} = e
            , a = (0,
          o.__rest)(e, ["app_name", "routeParamsMap", "pushServer"])
            , p = {};
          if (e.routeParamsMap)
              for (const [t,i] of e.routeParamsMap.entries())
                  p[t] = i;
          return `${n}?${d(Object.assign(Object.assign({
              app_name: t,
              version_code: s,
              webcast_sdk_version: r,
              update_version_code: r,
              compress: "gzip"
          }, p), a))}`
      }(e);
      "undefined" != typeof WebSocket && (this.socket = new WebSocket(t),
      this.socket.binaryType = "arraybuffer")
  }
  onError(e) {
      var t;
      null === (t = this.socket) || void 0 === t || t.addEventListener("error", e)
  }
  onMessage(e) {
      var t;
      null === (t = this.socket) || void 0 === t || t.addEventListener("message", bindClientMessage)
  }
  onOpen(e) {
      var t;
      null === (t = this.socket) || void 0 === t || t.addEventListener("open", e)
  }
  onClose(e) {
      var t;
      null === (t = this.socket) || void 0 === t || t.addEventListener("close", e)
  }
}
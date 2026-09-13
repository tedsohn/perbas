sap.ui.define([
  "sap/ui/core/mvc/Controller",
  "sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
  "use strict";

  return Controller.extend("navyintel.controller.Main", {

    onInit: function () {
      var oUiModel = new JSONModel({
        busy: false,
        errorVisible: false,
        statusText: "",
        resultsVisible: false,
        emptyVisible: true,
        order: {},
        risk: {},
        delivery: {},
        sentiment: {}
      });
      this.getView().setModel(oUiModel, "ui");
    },

    onAnalyze: function () {
      var oView = this.getView();
      var oUiModel = oView.getModel("ui");
      var sSalesOrder = oView.byId("orderSelect").getSelectedKey();

      oUiModel.setProperty("/busy", true);
      oUiModel.setProperty("/errorVisible", false);
      oUiModel.setProperty("/resultsVisible", false);
      oUiModel.setProperty("/emptyVisible", false);

      var oODataModel = oView.getModel(); // default unnamed OData v4 model from manifest
      var sPath = "/getOrderIntelligence(salesOrder='" + encodeURIComponent(sSalesOrder) + "')";
      var oContext = oODataModel.bindContext(sPath, undefined, { $$groupId: "$direct" });

      oContext.requestObject().then(function (data) {
        this._renderResult(data);
        oUiModel.setProperty("/busy", false);
        oUiModel.setProperty("/resultsVisible", true);
      }.bind(this)).catch(function (err) {
        oUiModel.setProperty("/busy", false);
        oUiModel.setProperty("/errorVisible", true);
        oUiModel.setProperty("/emptyVisible", true);
        oUiModel.setProperty("/statusText", "Request failed: " + (err && err.message ? err.message : String(err)));
      });
    },

    _riskState: function (level) {
      if (level === "High" || level === "Critical") { return "Error"; }
      if (level === "Medium") { return "Warning"; }
      return "Success";
    },

    _sentimentState: function (label) {
      if (label === "Negative") { return "Error"; }
      if (label === "Neutral") { return "Warning"; }
      return "Success";
    },

    _riskColor: function (level) {
      if (level === "High" || level === "Critical") { return "#bb0000"; }
      if (level === "Medium") { return "#e9730c"; }
      return "#107e3e";
    },

    _fmtDate: function (d) {
      if (!d) { return "—"; }
      var dt = new Date(d);
      if (isNaN(dt.getTime())) { return d; }
      return dt.toLocaleDateString(undefined, { year: "numeric", month: "short", day: "numeric" });
    },

    _fmtMoney: function (v, currency) {
      if (v === null || v === undefined) { return "—"; }
      var n = Number(v);
      return n.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + " " + (currency || "");
    },

    _gaugeSvg: function (pct, color) {
      var r = 30, c = 2 * Math.PI * r;
      var safePct = Math.min(Math.max(pct, 0), 100);
      var offset = c - (safePct / 100) * c;
      return '<svg width="74" height="74" viewBox="0 0 74 74" style="transform:rotate(-90deg)">' +
        '<circle cx="37" cy="37" r="' + r + '" stroke="#edeef0" stroke-width="8" fill="none" />' +
        '<circle cx="37" cy="37" r="' + r + '" stroke="' + color + '" stroke-width="8" fill="none" ' +
        'stroke-linecap="round" stroke-dasharray="' + c + '" stroke-dashoffset="' + offset + '" />' +
        '<text x="37" y="42" text-anchor="middle" font-size="15" font-weight="800" fill="' + color + '" ' +
        'style="transform:rotate(90deg); transform-origin:37px 37px;">' + safePct.toFixed(0) + '%</text>' +
        '</svg>';
    },

    _renderResult: function (data) {
      var oUiModel = this.getView().getModel("ui");

      oUiModel.setProperty("/order", {
        title: "Sales Order " + data.salesOrder,
        customer: data.customer,
        netValueFormatted: this._fmtMoney(data.netValue, data.currency),
        itemCount: (data.items || []).length,
        items: data.items || []
      });

      var risk = data.risk || {};
      var riskScore = Number(risk.score) || 0;
      var riskColor = this._riskColor(risk.level);
      oUiModel.setProperty("/risk", {
        score: riskScore,
        level: (risk.level || "") + " risk",
        state: this._riskState(risk.level),
        factors: risk.factors || "",
        gaugeSvg: this._gaugeSvg(riskScore, riskColor)
      });

      var delivery = data.delivery || {};
      var days = Number(delivery.delayDays) || 0;
      var confidence = Number(delivery.confidence) || 0;
      oUiModel.setProperty("/delivery", {
        delayText: days === 0 ? "On time" : ("+" + days + " day(s) delay"),
        delayClass: days === 0 ? "navyDelayOk" : (days <= 3 ? "navyDelayWarn" : "navyDelayBad"),
        dateRange: this._fmtDate(delivery.originalDate) + " \u2192 " + this._fmtDate(delivery.predictedDate),
        reason: delivery.reason || "",
        confidence: confidence,
        confidenceText: confidence.toFixed(0) + "%"
      });

      var sentiment = data.sentiment || {};
      oUiModel.setProperty("/sentiment", {
        label: sentiment.label || "",
        state: this._sentimentState(sentiment.label),
        legacyId: "NAVY-LGCY-" + (data.customer || "—"),
        lastSyncDateFormatted: this._fmtDate(sentiment.lastSyncDate),
        escalationText: sentiment.escalationRisk ? "Escalation risk" : "No escalation risk",
        escalationState: sentiment.escalationRisk ? "Error" : "Success"
      });
    }

  });
});
import { useEffect, useState } from "react";
import RadarDisplay from "./components/RadarDisplay";
import { radarApi } from "./api/radarApi";
import type { RadarTarget, RadarConfig, RadarStatus } from "./types/radar";
import "./App.css";
import "./dashboard-overrides.css";

export default function App() {
  const [targets, setTargets] = useState<RadarTarget[]>([]);
  const [config, setConfig] = useState<RadarConfig | null>(null);
  const [status, setStatus] = useState<RadarStatus | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [selectedTargetId, setSelectedTargetId] = useState<number | null>(null);
  const selectedTarget = targets.find(t => t.id === selectedTargetId) ?? null;

  useEffect(() => {
    let active = true;
    let requesting = false;
    async function refresh() {
      if (requesting) return;
      requesting = true;
      try {
        const [s, d, c] = await Promise.all([
          radarApi.getStatus(), radarApi.getDetections(), radarApi.getConfig(),
        ]);
        if (!active) return;
        setStatus(s.status);
        setTargets(d.detected_targets);
        setConfig(c);
        setError(null);
      } catch {
        if (active) setError("Unable to connect to Ada backend");
      } finally { requesting = false; }
    }
    void refresh();
    const interval = setInterval(() => void refresh(), 1000);
    return () => { active = false; clearInterval(interval); };
  }, []);

  async function handleControl(action: "pause" | "resume") {
    if (busy) return;
    setBusy(true);
    try {
      if (action === "pause") await radarApi.pause();
      else await radarApi.resume();
      setStatus((await radarApi.getStatus()).status);
      setError(null);
    } catch { setError(`Unable to ${action} radar`); }
    finally { setBusy(false); }
  }

  return (
    <div className="dashboard">
      <header className="dashboard-header">
        <div className="brand"><div className="brand-icon">◎</div><div><h1>ADA RADAR</h1><span>SURVEILLANCE SYSTEM</span></div></div>
        <div className="header-status"><span className={`status-dot ${error ? "offline" : "online"}`} />{error ? "CONNECTION ERROR" : status ?? "CONNECTING"}</div>
      </header>
      <main className="dashboard-content">
        <aside className="panel sidebar">
          <h2>SYSTEM CONTROL</h2>
          <div className="info-block"><span className="info-label">ENGINE STATUS</span><strong className="status-value">{status ?? "CONNECTING"}</strong></div>
          <div className="info-block"><span className="info-label">RADAR RANGE</span><strong>{config?.radar_range ?? "--"} units</strong></div>
          <div className="info-block"><span className="info-label">STATION POSITION</span><strong>X: {config?.x ?? "--"} | Y: {config?.y ?? "--"}</strong></div>
          <div className="info-block"><span className="info-label">DETECTED TARGETS</span><strong>{targets.length}</strong></div>
          <div className="control-section"><h2>ENGINE CONTROLS</h2>
            <button className="control-button pause-button" onClick={() => void handleControl("pause")} disabled={busy || status !== "RUNNING"}>⏸ PAUSE RADAR</button>
            <button className="control-button resume-button" onClick={() => void handleControl("resume")} disabled={busy || status !== "PAUSED"}>▶ RESUME RADAR</button>
          </div>
          {error && <p className="error-message">{error}</p>}
        </aside>
        <section className="panel radar-panel">
          <div className="panel-heading"><div><h2>LIVE RADAR VIEW</h2><span>REAL-TIME TARGET TRACKING</span></div><span className="live-indicator">{error ? "● OFFLINE" : "● LIVE"}</span></div>
          {config ? <RadarDisplay targets={targets} config={config} selectedTargetId={selectedTargetId} onSelectTarget={setSelectedTargetId} /> : <div className="radar-loading">Waiting for radar configuration...</div>}
          <div className="radar-footer"><span>RANGE: {config?.radar_range ?? "--"}</span><span>TRACKED: {targets.length}</span><span>REFRESH: 1s</span></div>
        </section>
        <aside className="panel targets-panel">
          <div className="panel-heading"><div><h2>DETECTED TARGETS</h2><span>ACTIVE CONTACTS</span></div><span className="target-count">{targets.length}</span></div>
          <div className="targets-list">
            {targets.length === 0 ? <p className="empty-targets">No targets currently detected.</p> : targets.map(target => (
              <button type="button" className={`target-card ${selectedTargetId === target.id ? "target-card-selected" : ""}`} key={target.id} onClick={() => setSelectedTargetId(target.id)} aria-pressed={selectedTargetId === target.id}>
                <div className="target-card-header"><strong>TGT-{String(target.id).padStart(3, "0")}</strong><span className="target-active">DETECTED</span></div>
                <div className="target-details"><span>X: {target.x.toFixed(1)}</span><span>Y: {target.y.toFixed(1)}</span><span>SPD: {target.speed.toFixed(1)}</span><span>HDG: {target.heading.toFixed(0)}°</span></div>
              </button>
            ))}
          </div>
          {selectedTarget && <section className="selected-target-details" aria-label="Selected target details">
            <div className="selected-target-heading"><div><span className="detail-eyebrow">CONTACT DETAILS</span><h2>TGT-{String(selectedTarget.id).padStart(3, "0")}</h2></div><button type="button" className="clear-selection" onClick={() => setSelectedTargetId(null)} aria-label="Clear target selection">✕</button></div>
            <div className="target-summary"><span className="target-summary-dot"/> TRACKED CONTACT <span className="target-summary-id">ID {selectedTarget.id}</span></div>
            <div className="target-detail-section-label">POSITION</div>
            <div className="selected-target-grid">
              <div className="target-metric"><span>X COORDINATE</span><strong>{selectedTarget.x.toFixed(2)} <small>units</small></strong></div>
              <div className="target-metric"><span>Y COORDINATE</span><strong>{selectedTarget.y.toFixed(2)} <small>units</small></strong></div>
            </div>
            <div className="target-detail-section-label">MOVEMENT</div>
            <div className="selected-target-grid">
              <div className="target-metric"><span>SPEED</span><strong>{selectedTarget.speed.toFixed(2)} <small>units/s</small></strong></div>
              <div className="target-metric"><span>HEADING</span><strong>{selectedTarget.heading.toFixed(0)}°</strong></div>
            </div>
            <div className="target-distance"><span>DISTANCE FROM STATION</span><strong>{config ? Math.hypot(selectedTarget.x - config.x, selectedTarget.y - config.y).toFixed(1) : "--"} <small>units</small></strong></div>
          </section>}
        </aside>
      </main>
      <footer className="dashboard-footer"><span>ADA RADAR SIMULATOR</span><span>BACKEND: ADA / AWS</span><span>FRONTEND: REACT / TYPESCRIPT</span></footer>
    </div>
  );
}
  
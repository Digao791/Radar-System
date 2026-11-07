import { useEffect, useState } from "react";

import RadarDisplay from "./components/RadarDisplay";
import { radarApi } from "./api/radarApi";

import type {
  RadarTarget,
  RadarConfig,
  RadarStatus,
} from "./types/radar";

import "./App.css";

function App() {
  const [targets, setTargets] = useState<RadarTarget[]>([]);
  const [config, setConfig] = useState<RadarConfig | null>(null);
  const [status, setStatus] = useState<RadarStatus | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    let active = true;
    let requesting = false;

    async function refresh() {
      if (requesting) return;
      requesting = true;

      try {
        const [statusResponse, targetsResponse, configResponse] =
          await Promise.all([
            radarApi.getStatus(),
            radarApi.getDetections(),
            radarApi.getConfig(),
          ]);

        if (!active) return;

        setStatus(statusResponse.status);
        setTargets(targetsResponse.detected_targets);
        setConfig(configResponse);
        setError(null);
      } catch {
        if (active) {
          setError("Unable to connect to Ada backend");
        }
      } finally {
        requesting = false;
      }
    }

    void refresh();

    const interval = setInterval(() => {
      void refresh();
    }, 1000);

    return () => {
      active = false;
      clearInterval(interval);
    };
  }, []);

  async function handleControl(action: "pause" | "resume") {
    if (busy) return;

    setBusy(true);

    try {
      if (action === "pause") {
        await radarApi.pause();
      } else {
        await radarApi.resume();
      }

      const response = await radarApi.getStatus();
      setStatus(response.status);
      setError(null);
    } catch {
      setError(`Unable to ${action} radar`);
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="dashboard">
      <header className="dashboard-header">
        <div className="brand">
          <div className="brand-icon">◎</div>
          <div>
            <h1>ADA RADAR</h1>
            <span>SURVEILLANCE SYSTEM</span>
          </div>
        </div>

        <div className="header-status">
          <span
            className={`status-dot ${
              error ? "offline" : "online"
            }`}
          />
          {error ? "CONNECTION ERROR" : status ?? "CONNECTING"}
        </div>
      </header>

      <main className="dashboard-content">
        <aside className="panel sidebar">
          <h2>SYSTEM CONTROL</h2>

          <div className="info-block">
            <span className="info-label">ENGINE STATUS</span>
            <strong className="status-value">
              {status ?? "CONNECTING"}
            </strong>
          </div>

          <div className="info-block">
            <span className="info-label">RADAR RANGE</span>
            <strong>
              {config?.radar_range ?? "--"} units
            </strong>
          </div>

          <div className="info-block">
            <span className="info-label">STATION POSITION</span>
            <strong>
              X: {config?.x ?? "--"} | Y: {config?.y ?? "--"}
            </strong>
          </div>

          <div className="info-block">
            <span className="info-label">DETECTED TARGETS</span>
            <strong>{targets.length}</strong>
          </div>

          <div className="control-section">
            <h2>ENGINE CONTROLS</h2>

            <button
              className="control-button pause-button"
              onClick={() => void handleControl("pause")}
              disabled={busy || status !== "RUNNING"}
            >
              ⏸ PAUSE RADAR
            </button>

            <button
              className="control-button resume-button"
              onClick={() => void handleControl("resume")}
              disabled={busy || status !== "PAUSED"}
            >
              ▶ RESUME RADAR
            </button>
          </div>

          {error && <p className="error-message">{error}</p>}
        </aside>

        <section className="panel radar-panel">
          <div className="panel-heading">
            <div>
              <h2>LIVE RADAR VIEW</h2>
              <span>REAL-TIME TARGET TRACKING</span>
            </div>

            <span className="live-indicator">
              ● LIVE
            </span>
          </div>

          {config ? (
            <RadarDisplay targets={targets} config={config} />
          ) : (
            <div className="radar-loading">
              Waiting for radar configuration...
            </div>
          )}

          <div className="radar-footer">
            <span>RANGE: {config?.radar_range ?? "--"}</span>
            <span>TRACKED: {targets.length}</span>
            <span>REFRESH: 1s</span>
          </div>
        </section>

        <aside className="panel targets-panel">
          <div className="panel-heading">
            <div>
              <h2>DETECTED TARGETS</h2>
              <span>ACTIVE CONTACTS</span>
            </div>
            <span className="target-count">{targets.length}</span>
          </div>

          <div className="targets-list">
            {targets.length === 0 ? (
              <p className="empty-targets">
                No targets currently detected.
              </p>
            ) : (
              targets.map((target) => (
                <div className="target-card" key={target.id}>
                  <div className="target-card-header">
                    <strong>
                      TGT-{String(target.id).padStart(3, "0")}
                    </strong>
                    <span className="target-active">DETECTED</span>
                  </div>

                  <div className="target-details">
                    <span>X: {target.x.toFixed(1)}</span>
                    <span>Y: {target.y.toFixed(1)}</span>
                    <span>SPD: {target.speed.toFixed(1)}</span>
                    <span>HDG: {target.heading.toFixed(0)}°</span>
                  </div>
                </div>
              ))
            )}
          </div>
        </aside>
      </main>

      <footer className="dashboard-footer">
        <span>ADA RADAR SIMULATOR</span>
        <span>BACKEND: ADA / AWS</span>
        <span>FRONTEND: REACT / TYPESCRIPT</span>
      </footer>
    </div>
  );
}

export default App;
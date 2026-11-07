import { useEffect, useState } from "react";
import { radarApi } from "../api/radarApi";
import type { RadarStatus as RadarStatusType } from "../types/radar";

export default function RadarStatus() {
  const [status, setStatus] = useState<RadarStatusType | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;

    async function updateStatus() {
      try {
        const response = await radarApi.getStatus();

        if (active) {
          setStatus(response.status);
          setError(null);
        }
      } catch {
        if (active) {
          setError("Unable to connect to Ada backend");
        }
      }
    }

    void updateStatus();

    const interval = setInterval(() => {
      void updateStatus();
    }, 1000);

    return () => {
      active = false;
      clearInterval(interval);
    };
  }, []);

  return (
    <section>
      <h2>Radar Engine</h2>

      {error ? (
        <p>{error}</p>
      ) : (
        <p>Status: {status ?? "Connecting..."}</p>
      )}
    </section>
  );
}
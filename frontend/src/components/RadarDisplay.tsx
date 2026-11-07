import type { RadarTarget, RadarConfig } from "../types/radar";
import "./RadarDisplay.css";

interface RadarDisplayProps {
  targets: RadarTarget[];
  config: RadarConfig;
}

export default function RadarDisplay({
  targets,
  config,
}: RadarDisplayProps) {
  const size = 600;
  const center = size / 2;
  const radius = 270;

  const range = config.radar_range;

  function toScreen(x: number, y: number) {
    const scale = radius / range;

    return {
      x: center + (x - config.x) * scale,
      y: center - (y - config.y) * scale,
    };
  }

  return (
    <div className="radar-container">
      <svg viewBox={`0 0 ${size} ${size}`} className="radar-screen">
        <circle
          cx={center}
          cy={center}
          r={radius}
          className="radar-background"
        />

        {[0.25, 0.5, 0.75, 1].map((fraction) => (
          <circle
            key={fraction}
            cx={center}
            cy={center}
            r={radius * fraction}
            className="radar-ring"
          />
        ))}

        <line x1={center} y1={30} x2={center} y2={570}
          className="radar-axis" />
        <line x1={30} y1={center} x2={570} y2={center}
          className="radar-axis" />

        <circle cx={center} cy={center} r={5}
          className="radar-station" />

        {targets.map((target) => {
          const position = toScreen(target.x, target.y);

          return (
            <g key={target.id}>
              <circle
                cx={position.x}
                cy={position.y}
                r={6}
                className="radar-target"
              />

              <text
                x={position.x + 12}
                y={position.y - 10}
                className="radar-target-label"
              >
                TGT-{target.id}
              </text>
            </g>
          );
        })}
      </svg>
    </div>
  );
}
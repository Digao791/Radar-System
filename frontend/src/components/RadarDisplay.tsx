import type { RadarTarget, RadarConfig } from "../types/radar";
import "./RadarDisplay.css";

interface RadarDisplayProps {
  targets: RadarTarget[];
  config: RadarConfig;
  selectedTargetId: number | null;
  onSelectTarget: (id: number) => void;
}

export default function RadarDisplay({
  targets,
  config,
  selectedTargetId,
  onSelectTarget,
}: RadarDisplayProps) {
  const size = 600;
  const center = size / 2;
  const radius = 270;

  const scale = radius / config.radar_range;

  function toScreen(x: number, y: number) {
    return {
      x: center + (x - config.x) * scale,
      y: center - (y - config.y) * scale,
    };
  }

  return (
    <div className="radar-container">
      <svg
        viewBox={`0 0 ${size} ${size}`}
        className="radar-screen"
        aria-label="Radar display"
      >
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

        <line
          x1={center}
          y1={30}
          x2={center}
          y2={570}
          className="radar-axis"
        />
        <line
          x1={30}
          y1={center}
          x2={570}
          y2={center}
          className="radar-axis"
        />

        <circle
          cx={center}
          cy={center}
          r={5}
          className="radar-station"
        />

        {targets.map((target) => {
          const position = toScreen(target.x, target.y);
          const selected = selectedTargetId === target.id;

          return (
            <g
              key={target.id}
              className={`radar-target-group ${
                selected ? "selected" : ""
              }`}
              onClick={() => onSelectTarget(target.id)}
              role="button"
              tabIndex={0}
              aria-label={`Select target ${target.id}`}
              onKeyDown={(event) => {
                if (event.key === "Enter" || event.key === " ") {
                  event.preventDefault();
                  onSelectTarget(target.id);
                }
              }}
            >
              <circle
                cx={position.x}
                cy={position.y}
                r={16}
                fill="transparent"
                className="radar-target-hitbox"
              />

              {selected && (
                <circle
                  cx={position.x}
                  cy={position.y}
                  r={14}
                  className="radar-selection-ring"
                />
              )}

              <circle
                cx={position.x}
                cy={position.y}
                r={6}
                className="radar-target"
              />

              <text
                x={position.x + 13}
                y={position.y - 12}
                className="radar-target-label"
              >
                TGT-{String(target.id).padStart(3, "0")}
              </text>
            </g>
          );
        })}
      </svg>
    </div>
  );
}
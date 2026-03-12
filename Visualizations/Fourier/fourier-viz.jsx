import { useState, useEffect, useRef } from "react";

const WIDTH = 700;
const HEIGHT = 110;
const PADDING = { top: 18, bottom: 18, left: 48, right: 20 };
const DURATION = 2; // seconds shown
const SAMPLE_RATE = 500;

const WAVES = [
  { freq: 3, amp: 1.0, color: "#2563eb", label: "3 Hz", beta: "β₁ = 1.0" },
  { freq: 5, amp: 0.6, color: "#16a34a", label: "5 Hz", beta: "β₂ = 0.6" },
  { freq: 8, amp: 0.35, color: "#dc2626", label: "8 Hz", beta: "β₃ = 0.35" },
];

function makePath(freqs, amps, yScale, innerW, innerH) {
  const pts = [];
  const n = SAMPLE_RATE * DURATION;
  for (let i = 0; i <= n; i++) {
    const t = (i / n) * DURATION;
    let y = 0;
    freqs.forEach((f, j) => {
      y += amps[j] * Math.sin(2 * Math.PI * f * t);
    });
    const x = PADDING.left + (i / n) * innerW;
    const yPx = PADDING.top + innerH / 2 - y * yScale;
    pts.push(`${i === 0 ? "M" : "L"}${x.toFixed(2)},${yPx.toFixed(2)}`);
  }
  return pts.join(" ");
}

function WavePanel({ title, freqs, amps, color, active, yMax = 2.2, height = HEIGHT, dimmed = false }) {
  const innerW = WIDTH - PADDING.left - PADDING.right;
  const innerH = height - PADDING.top - PADDING.bottom;
  const yScale = (innerH / 2) / yMax;
  const path = makePath(freqs, amps, yScale, innerW, innerH);

  return (
    <svg width="100%" viewBox={`0 0 ${WIDTH} ${height}`} style={{ display: "block", opacity: dimmed ? 0.25 : 1, transition: "opacity 0.4s" }}>
      {/* axes */}
      <line x1={PADDING.left} y1={PADDING.top + innerH / 2} x2={PADDING.left + innerW} y2={PADDING.top + innerH / 2}
        stroke="#c7d2db" strokeWidth="1" />
      <line x1={PADDING.left} y1={PADDING.top} x2={PADDING.left} y2={PADDING.top + innerH}
        stroke="#c7d2db" strokeWidth="1" />
      {/* time ticks */}
      {[0, 0.5, 1.0, 1.5, 2.0].map(t => {
        const x = PADDING.left + (t / DURATION) * innerW;
        return (
          <g key={t}>
            <line x1={x} y1={PADDING.top + innerH / 2 - 3} x2={x} y2={PADDING.top + innerH / 2 + 3} stroke="#94a3b8" strokeWidth="1" />
            <text x={x} y={PADDING.top + innerH + 14} textAnchor="middle" fontSize="9" fill="#94a3b8" fontFamily="'IBM Plex Mono', monospace">{t}s</text>
          </g>
        );
      })}
      {/* wave */}
      {active && <path d={path} stroke={color} strokeWidth="2.2" fill="none" strokeLinejoin="round" />}
      {/* label */}
      <text x={PADDING.left - 6} y={PADDING.top + innerH / 2 + 4} textAnchor="end" fontSize="10" fill="#64748b" fontFamily="'IBM Plex Mono', monospace">0</text>
      <text x={14} y={PADDING.top + innerH / 2 - 2} textAnchor="middle" fontSize="10" fill={color} fontFamily="'IBM Plex Mono', monospace" transform={`rotate(-90, 14, ${PADDING.top + innerH / 2})`}>{title}</text>
    </svg>
  );
}

function SumPanel({ activeWaves, height = 160 }) {
  const innerW = WIDTH - PADDING.left - PADDING.right;
  const innerH = height - PADDING.top - PADDING.bottom;
  const yMax = 2.2;
  const yScale = (innerH / 2) / yMax;

  const freqs = WAVES.filter((_, i) => activeWaves[i]).map(w => w.freq);
  const amps = WAVES.filter((_, i) => activeWaves[i]).map(w => w.amp);

  const path = freqs.length > 0 ? makePath(freqs, amps, yScale, innerW, innerH) : null;

  // Individual ghost paths
  const ghostPaths = WAVES.map((w, i) =>
    activeWaves[i] ? makePath([w.freq], [w.amp], yScale, innerW, innerH) : null
  );

  return (
    <svg width="100%" viewBox={`0 0 ${WIDTH} ${height}`} style={{ display: "block" }}>
      <line x1={PADDING.left} y1={PADDING.top + innerH / 2} x2={PADDING.left + innerW} y2={PADDING.top + innerH / 2}
        stroke="#c7d2db" strokeWidth="1" />
      <line x1={PADDING.left} y1={PADDING.top} x2={PADDING.left} y2={PADDING.top + innerH}
        stroke="#c7d2db" strokeWidth="1" />
      {[0, 0.5, 1.0, 1.5, 2.0].map(t => {
        const x = PADDING.left + (t / DURATION) * innerW;
        return (
          <g key={t}>
            <line x1={x} y1={PADDING.top + innerH / 2 - 4} x2={x} y2={PADDING.top + innerH / 2 + 4} stroke="#94a3b8" strokeWidth="1" />
            <text x={x} y={PADDING.top + innerH + 14} textAnchor="middle" fontSize="9" fill="#94a3b8" fontFamily="'IBM Plex Mono', monospace">{t}s</text>
          </g>
        );
      })}
      {/* ghost individual waves */}
      {ghostPaths.map((p, i) => p && (
        <path key={i} d={p} stroke={WAVES[i].color} strokeWidth="1.2" fill="none" opacity="0.22" strokeDasharray="4 3" />
      ))}
      {/* sum */}
      {path && <path d={path} stroke="#1e293b" strokeWidth="2.5" fill="none" strokeLinejoin="round" />}
      {!path && (
        <text x={PADDING.left + innerW / 2} y={PADDING.top + innerH / 2 + 5} textAnchor="middle" fontSize="13" fill="#94a3b8" fontFamily="'IBM Plex Mono', monospace">
          Keine Sinuswellen aktiv
        </text>
      )}
      <text x={14} y={PADDING.top + innerH / 2 - 2} textAnchor="middle" fontSize="10" fill="#1e293b" fontFamily="'IBM Plex Mono', monospace" transform={`rotate(-90, 14, ${PADDING.top + innerH / 2})`}>Summe</text>
    </svg>
  );
}

export default function FourierViz() {
  const [active, setActive] = useState([true, false, false]);
  const [step, setStep] = useState(0);

  // Stepped animation
  const steps = [
    { active: [true, false, false], label: "Schritt 1: Nur 3 Hz" },
    { active: [true, true, false], label: "Schritt 2: + 5 Hz addieren" },
    { active: [true, true, true], label: "Schritt 3: + 8 Hz addieren → Messsignal" },
  ];

  function goStep(i) {
    setStep(i);
    setActive(steps[i].active);
  }

  function toggle(i) {
    setActive(prev => {
      const n = [...prev];
      n[i] = !n[i];
      return n;
    });
    setStep(-1);
  }

  const equation = (() => {
    const parts = WAVES.filter((_, i) => active[i]).map(w => `${w.amp} · sin(2π · ${w.freq} · t)`);
    if (parts.length === 0) return "EEG(t) = 0";
    return "EEG(t) = " + parts.join(" + ");
  })();

  return (
    <div style={{
      fontFamily: "'IBM Plex Sans', 'Helvetica Neue', sans-serif",
      background: "#f8fafc",
      minHeight: "100vh",
      padding: "28px 24px",
      color: "#1e293b",
      maxWidth: 820,
      margin: "0 auto",
    }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=IBM+Plex+Sans:wght@400;500;600;700&display=swap');
        * { box-sizing: border-box; }
      `}</style>

      {/* Header */}
      <div style={{ marginBottom: 20 }}>
        <div style={{ fontSize: 11, letterSpacing: "0.12em", textTransform: "uppercase", color: "#64748b", marginBottom: 4, fontWeight: 600 }}>
          Fourier-Transformation · Visualisierung
        </div>
        <h1 style={{ fontSize: 22, fontWeight: 700, margin: 0, color: "#0f172a", lineHeight: 1.2 }}>
          Signalschätzung durch Sinuswellen
        </h1>
        <p style={{ fontSize: 13, color: "#64748b", marginTop: 6, marginBottom: 0, lineHeight: 1.6 }}>
          Ein gemessenes Signal wird als Summe von Sinuswellen verschiedener Frequenzen geschätzt –{" "}
          analog zur linearen Regression.
        </p>
      </div>

      {/* Step controls */}
      <div style={{ display: "flex", gap: 8, marginBottom: 20, flexWrap: "wrap" }}>
        {steps.map((s, i) => (
          <button key={i} onClick={() => goStep(i)} style={{
            padding: "7px 14px", borderRadius: 6, border: "1.5px solid",
            borderColor: step === i ? "#2563eb" : "#cbd5e1",
            background: step === i ? "#2563eb" : "#fff",
            color: step === i ? "#fff" : "#475569",
            fontSize: 12, fontWeight: 600, cursor: "pointer",
            fontFamily: "inherit", transition: "all 0.2s",
          }}>{s.label}</button>
        ))}
      </div>

      {/* Wave toggles + panels */}
      <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
        {WAVES.map((w, i) => (
          <div key={i} style={{
            background: "#fff",
            border: `1.5px solid ${active[i] ? w.color + "55" : "#e2e8f0"}`,
            borderRadius: 10,
            overflow: "hidden",
            transition: "border-color 0.3s",
          }}>
            {/* wave header */}
            <div style={{
              display: "flex", alignItems: "center", gap: 12, padding: "10px 16px",
              borderBottom: `1px solid ${active[i] ? w.color + "22" : "#f1f5f9"}`,
              background: active[i] ? w.color + "08" : "#fafafa",
            }}>
              <button onClick={() => toggle(i)} style={{
                width: 28, height: 28, borderRadius: 6,
                background: active[i] ? w.color : "#e2e8f0",
                border: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center",
                transition: "background 0.2s", flexShrink: 0,
              }}>
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                  {active[i]
                    ? <path d="M2 7 Q5 2 7 7 Q9 12 12 7" stroke="#fff" strokeWidth="2" fill="none" strokeLinecap="round"/>
                    : <path d="M2 7h10" stroke="#94a3b8" strokeWidth="2" strokeLinecap="round"/>}
                </svg>
              </button>
              <div>
                <span style={{ fontWeight: 700, fontSize: 14, color: active[i] ? w.color : "#94a3b8", fontFamily: "'IBM Plex Mono', monospace" }}>
                  {w.label}
                </span>
                <span style={{ marginLeft: 10, fontSize: 12, color: "#64748b", fontFamily: "'IBM Plex Mono', monospace" }}>
                  Amplitude A = {w.amp} &nbsp;·&nbsp; {w.beta}
                </span>
              </div>
              <div style={{ marginLeft: "auto", fontSize: 12, color: "#94a3b8", fontFamily: "'IBM Plex Mono', monospace" }}>
                sin(2π · {w.freq} · t)
              </div>
            </div>
            <div style={{ padding: "4px 0 2px" }}>
              <WavePanel
                title={w.label}
                freqs={[w.freq]}
                amps={[w.amp]}
                color={w.color}
                active={active[i]}
                dimmed={!active[i]}
              />
            </div>
          </div>
        ))}

        {/* Plus sign */}
        <div style={{ textAlign: "center", fontSize: 22, color: "#94a3b8", lineHeight: 1, margin: "2px 0" }}>+</div>

        {/* Sum panel */}
        <div style={{
          background: "#fff",
          border: "2px solid #1e293b",
          borderRadius: 10,
          overflow: "hidden",
        }}>
          <div style={{
            display: "flex", alignItems: "center", gap: 10, padding: "10px 16px",
            borderBottom: "1px solid #e2e8f0",
            background: "#f8fafc",
          }}>
            <div style={{
              width: 28, height: 28, borderRadius: 6, background: "#1e293b",
              display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0,
            }}>
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <path d="M1 9 Q3 3 5 7 Q7 11 9 5 Q11 1 13 6" stroke="#fff" strokeWidth="2" fill="none" strokeLinecap="round"/>
              </svg>
            </div>
            <span style={{ fontWeight: 700, fontSize: 14, color: "#1e293b", fontFamily: "'IBM Plex Mono', monospace" }}>
              Gemessenes Signal (Summe)
            </span>
          </div>
          <div style={{ padding: "4px 0 2px" }}>
            <SumPanel activeWaves={active} height={160} />
          </div>
        </div>
      </div>

      {/* Equation */}
      <div style={{
        marginTop: 16,
        background: "#0f172a",
        borderRadius: 10,
        padding: "14px 20px",
        fontFamily: "'IBM Plex Mono', monospace",
        fontSize: 13,
        color: "#e2e8f0",
        overflowX: "auto",
        whiteSpace: "nowrap",
      }}>
        <span style={{ color: "#64748b", fontSize: 11, display: "block", marginBottom: 4, letterSpacing: "0.1em", textTransform: "uppercase" }}>
          Aktuelle Gleichung
        </span>
        <span style={{ color: "#7dd3fc" }}>{equation}</span>
      </div>

      <p style={{ fontSize: 11, color: "#94a3b8", marginTop: 12, textAlign: "center", letterSpacing: "0.05em" }}>
        Klicke auf die Schritte oder die Wellentasten, um Sinuswellen zu aktivieren/deaktivieren.
      </p>
    </div>
  );
}

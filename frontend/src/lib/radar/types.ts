export type TargetStatus = 'ativo' | 'perdido'

export interface Target {
  id: string
  /** Posição leste-oeste relativa à antena, em unidades de simulação */
  x: number
  /** Posição norte-sul relativa à antena, em unidades de simulação */
  y: number
  /** Velocidade em unidades/s */
  speed: number
  /** Rumo em graus (0 = norte, sentido horário) */
  heading: number
  status: TargetStatus
}

export interface TargetsResponse {
  targets: Target[]
  timestamp: number
}

export interface RadarConfig {
  range: number
  sweepRpm: number
  refreshMs: number
  showLabels: boolean
  showVectors: boolean
  showLost: boolean
}

export interface TargetFilter {
  speed: [number, number]
  heading: [number, number]
  status: 'todos' | TargetStatus
}

export const SPEED_LIMITS: [number, number] = [0, 700]
export const HEADING_LIMITS: [number, number] = [0, 360]

export const DEFAULT_CONFIG: RadarConfig = {
  range: 0,
  sweepRpm: 15,
  refreshMs: 1000,
  showLabels: true,
  showVectors: true,
  showLost: false,
}

export const DEFAULT_FILTER: TargetFilter = {
  speed: [...SPEED_LIMITS],
  heading: [...HEADING_LIMITS],
  status: 'todos',
}

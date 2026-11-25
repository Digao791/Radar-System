import { Link, useLocation } from 'react-router-dom'
import { List, Radar, SlidersHorizontal } from 'lucide-react'
import { cn } from '@/lib/utils'
import { useTargets, useRadarStatus } from '@/lib/radar/hooks'

const NAV = [
  { href: '/', label: 'Dashboard', description: 'Radar overview', icon: Radar },
  {
    href: '/settings',
    label: 'Settings',
    description: 'Radar parameters',
    icon: SlidersHorizontal,
  },
  { href: '/targets', label: 'Targets', description: 'Discovered contacts', icon: List },
]

export function AppSidebar() {
  const { pathname } = useLocation()
  const { targets, error, isLoading } = useTargets()
  const { status, control, busy, error: statusError } = useRadarStatus()
  const offline = error || statusError
  const active = targets.filter((t) => t.status === 'ativo').length

  return (
    <aside className="flex shrink-0 flex-col border-b border-sidebar-border bg-sidebar text-sidebar-foreground md:sticky md:top-0 md:h-dvh md:w-64 md:border-r md:border-b-0">
      <div className="flex items-center gap-3 px-4 py-4 md:px-5 md:py-6">
        <div className="flex size-9 items-center justify-center rounded-md border border-primary/40 bg-primary/10 text-primary">
          <Radar className="size-5" aria-hidden="true" />
        </div>
        <div className="flex flex-col">
          <span className="text-sm font-semibold tracking-wide">SENTINEL</span>
          <span className="font-mono text-xs text-muted-foreground">Station RX-01</span>
        </div>
      </div>

      <nav aria-label="Main navigation" className="px-2 pb-2 md:flex-1 md:px-3">
        <ul className="flex gap-1 overflow-x-auto md:flex-col">
          {NAV.map((item) => {
            const isActive = item.href === '/' ? pathname === '/' : pathname.startsWith(item.href)
            const Icon = item.icon
            return (
              <li key={item.href} className="shrink-0">
                <Link
                  to={item.href}
                  aria-current={isActive ? 'page' : undefined}
                  className={cn(
                    'flex items-center gap-3 rounded-md px-3 py-2 text-sm transition-colors',
                    'hover:bg-sidebar-accent focus-visible:ring-2 focus-visible:ring-sidebar-ring focus-visible:outline-none',
                    isActive
                      ? 'bg-sidebar-accent text-sidebar-primary'
                      : 'text-sidebar-foreground/80',
                  )}
                >
                  <Icon className="size-4 shrink-0" aria-hidden="true" />
                  <span className="flex flex-col">
                    <span className="font-medium">{item.label}</span>
                    <span className="hidden text-xs text-muted-foreground md:block">
                      {item.description}
                    </span>
                  </span>
                </Link>
              </li>
            )
          })}
        </ul>
      </nav>

      <div className="hidden border-t border-sidebar-border px-5 py-4 md:block">
        <div className="flex items-center gap-2 text-xs">
          <span
            className={cn(
              'size-2 rounded-full',
              offline ? 'bg-destructive' : isLoading ? 'bg-muted-foreground' : 'bg-primary',
            )}
            aria-hidden="true"
          />
          <span className="text-muted-foreground">
            {offline ? 'Backend link down' : isLoading ? 'Connecting…' : 'Backend link active'}
          </span>
        </div>
        <p className="mt-2 text-xs">Engine: {status ?? '—'}</p>
        <div className="mt-2 flex gap-2">
          <button
            className="rounded border px-2 py-1 text-xs disabled:opacity-40"
            disabled={busy || !!offline || status !== 'RUNNING'}
            onClick={() => void control('pause')}
          >
            Pause
          </button>
          <button
            className="rounded border px-2 py-1 text-xs disabled:opacity-40"
            disabled={busy || !!offline || status !== 'PAUSED'}
            onClick={() => void control('resume')}
          >
            Resume
          </button>
        </div>
        <p className="mt-2 font-mono text-xs text-muted-foreground">
          {active} contact{active === 1 ? '' : 's'} tracked
        </p>
      </div>
    </aside>
  )
}

import { useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { Search } from 'lucide-react'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { FilterPopover } from './filter-popover'
import { normalizeTargetId, useSelectedTargetId, useTargets } from '@/lib/radar/hooks'

export function Topbar() {
  const [query, setQuery] = useState('')
  const [message, setMessage] = useState<string | null>(null)
  const { targets } = useTargets()
  const [, setSelected] = useSelectedTargetId()
  const navigate = useNavigate()
  const { pathname } = useLocation()

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!query.trim()) return
    const id = normalizeTargetId(query)
    const found = targets.find((t) => t.id === id)
    if (!found) {
      setMessage(`No target with ID ${id}`)
      return
    }
    setMessage(null)
    setSelected(found.id)
    setQuery('')
    if (pathname !== '/') navigate('/')
  }

  return (
    <header className="sticky top-0 z-30 border-b border-border bg-background/90 backdrop-blur">
      <div className="flex flex-col gap-2 px-4 py-3 md:flex-row md:items-center md:justify-between md:px-6">
        <form role="search" onSubmit={handleSubmit} className="flex w-full max-w-md items-center gap-2">
          <label htmlFor="target-search" className="sr-only">
            Search target by ID
          </label>
          <div className="relative flex-1">
            <Search
              className="pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2 text-muted-foreground"
              aria-hidden="true"
            />
            <Input
              id="target-search"
              value={query}
              onChange={(e) => {
                setQuery(e.target.value)
                setMessage(null)
              }}
              placeholder="Search by ID (e.g. TGT-004 or 4)"
              className="pl-9 font-mono"
              autoComplete="off"
              aria-describedby={message ? 'search-message' : undefined}
            />
          </div>
          <Button type="submit" variant="secondary">
            Search
          </Button>
        </form>

        <div className="flex items-center gap-3">
          {message && (
            <p id="search-message" role="status" className="text-xs text-destructive">
              {message}
            </p>
          )}
          <FilterPopover />
        </div>
      </div>
    </header>
  )
}

# Patrones Preferidos del Proyecto

> Este archivo documenta los patrones de código que prefieres en este proyecto.
> Claude lo usa como referencia para mantener consistencia.

## Patrones de Componentes

### Estructura de Componente React

```tsx
// Orden preferido de imports
import { useState, useEffect } from 'react'        // 1. React
import { useRouter } from 'next/navigation'        // 2. Framework
import { cn } from '@/lib/utils'                   // 3. Utilidades internas
import { Button } from '@/components/ui/button'    // 4. Componentes internos
import type { UserProps } from './types'           // 5. Tipos (siempre con 'type')

// Props interface arriba del componente
interface ComponentProps {
  // Props requeridas primero
  id: string
  title: string
  // Props opcionales después
  className?: string
  onAction?: () => void
}

// Componente exportado con nombre
export function ComponentName({ id, title, className, onAction }: ComponentProps) {
  // 1. Hooks primero
  const [state, setState] = useState(false)

  // 2. Efectos después
  useEffect(() => {
    // ...
    return () => { /* cleanup */ }
  }, [dependency])

  // 3. Handlers
  const handleClick = () => {
    // ...
  }

  // 4. Early returns para loading/error
  if (!data) return <Skeleton />

  // 5. Render principal
  return (
    <div className={cn('base-styles', className)}>
      {/* JSX */}
    </div>
  )
}
```

## Patrones de Hooks

### Custom Hook Structure

```tsx
export function useCustomHook(param: string) {
  // Estado
  const [data, setData] = useState<Data | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  // Efecto
  useEffect(() => {
    let cancelled = false

    async function fetchData() {
      try {
        setLoading(true)
        const result = await api.get(param)
        if (!cancelled) {
          setData(result)
        }
      } catch (err) {
        if (!cancelled) {
          setError(err as Error)
        }
      } finally {
        if (!cancelled) {
          setLoading(false)
        }
      }
    }

    fetchData()

    return () => {
      cancelled = true
    }
  }, [param])

  // Retornar objeto, no array
  return { data, loading, error }
}
```

## Patrones de API

### Fetch con Error Handling

```tsx
async function fetchWithRetry<T>(
  url: string,
  options?: RequestInit,
  retries = 3
): Promise<T> {
  for (let i = 0; i < retries; i++) {
    try {
      const res = await fetch(url, options)

      if (!res.ok) {
        throw new Error(`HTTP ${res.status}: ${res.statusText}`)
      }

      return await res.json()
    } catch (err) {
      if (i === retries - 1) throw err
      await new Promise(r => setTimeout(r, 1000 * (i + 1)))
    }
  }
  throw new Error('Unreachable')
}
```

## Patrones de Testing

### Test Structure

```tsx
describe('ComponentName', () => {
  // Setup compartido
  const defaultProps = {
    id: 'test-id',
    title: 'Test Title',
  }

  // Helper para render
  const renderComponent = (props = {}) => {
    return render(<ComponentName {...defaultProps} {...props} />)
  }

  it('renders correctly with default props', () => {
    renderComponent()
    expect(screen.getByText('Test Title')).toBeInTheDocument()
  })

  it('handles user interaction', async () => {
    const onAction = vi.fn()
    renderComponent({ onAction })

    await userEvent.click(screen.getByRole('button'))

    expect(onAction).toHaveBeenCalledOnce()
  })
})
```

## Patrones de Tipos

### Tipos Utilitarios Preferidos

```tsx
// Prefer Pick/Omit over recreating
type UserSummary = Pick<User, 'id' | 'name' | 'email'>

// Usar satisfies para type checking sin widening
const config = {
  api: 'https://api.example.com',
  timeout: 5000,
} satisfies Config

// Discriminated unions para estados
type AsyncState<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: Error }
```

---

## Agregar Nuevos Patrones

Cuando descubras un nuevo patrón que quieras que Claude siga:

```
"Agrega este patrón a .claude/patterns.md:
[descripción del patrón]"
```

---

> Última actualización: {{DATE}}

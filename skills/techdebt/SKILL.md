---
name: techdebt
description: Escanea el proyecto en busca de deuda tecnica, codigo duplicado, TODOs pendientes, dependencias desactualizadas y areas de mejora. Usa cuando quieras auditar la salud del codigo.
---

# Tech Debt Scanner

Escanea el proyecto en busca de deuda tecnica, codigo duplicado, y areas de mejora.

## Trigger

- `/productivity:techdebt` - Escaneo completo del proyecto
- `/productivity:techdebt [path]` - Escaneo de un directorio especifico
- `/productivity:techdebt --quick` - Escaneo rapido (solo issues criticos)

## What to Scan

### 1. Codigo Duplicado

Buscar patrones repetidos que podrian extraerse:
- Funciones similares en diferentes archivos
- Logica copy-paste con pequenas variaciones
- Componentes que hacen lo mismo con diferentes props

```
Encontrado: Logica de formateo de fecha duplicada
- src/utils/format.ts:45
- src/helpers/date.ts:12
Recomendacion: Consolidar en un solo helper
```

### 2. TODOs y FIXMEs

Buscar comentarios pendientes y reportar con contexto:
```
TODO sin resolver (15 encontrados):
- src/api/auth.ts:67 - "TODO: implement refresh token" (hace 3 meses)
- src/components/Modal.tsx:23 - "FIXME: memory leak" (hace 1 semana)
```

### 3. Dependencias Desactualizadas

Clasificar por severidad:
- CRITICAL: Vulnerabilidades de seguridad
- HIGH: Major versions atrasados
- MEDIUM: Minor versions atrasados
- LOW: Patch versions

### 4. Complejidad Ciclomatica

Identificar funciones demasiado complejas:
- Funciones con mas de 50 lineas
- Mas de 4 niveles de anidacion
- Mas de 10 ramas condicionales

### 5. Cobertura de Tests

Reportar archivos sin tests o con baja cobertura.

### 6. Tipos Debiles

Buscar uso de tipos pobres:
- `any` explicitos
- `as unknown as X` casts
- `// @ts-ignore` o `// @ts-expect-error`

### 7. Console.logs Olvidados

Detectar console.log que no deberian estar en produccion.

### 8. Imports No Utilizados

Detectar imports que no se usan.

### 9. Variables de Entorno

Verificar que `.env.example` tenga todas las variables necesarias.

### 10. Archivos Grandes

Archivos con mas de 300 lineas que podrian dividirse.

## Output Format

```markdown
# Tech Debt Report - {{PROJECT_NAME}}
> Generado: {{DATE}}

## Resumen Ejecutivo

| Categoria | Critical | High | Medium | Low |
|-----------|----------|------|--------|-----|
| Duplicacion | 0 | 2 | 5 | 3 |
| TODOs | 1 | 4 | 8 | 2 |
| Dependencias | 0 | 1 | 3 | 12 |
| Complejidad | 0 | 3 | 7 | 15 |
| Tests | 2 | 5 | 10 | - |
| Tipos | 0 | 8 | 15 | 20 |

**Total Issues**: 125
**Health Score**: 72/100

## Issues Criticos (Resolver AHORA)

### [CRITICAL] Vulnerabilidad en lodash@4.17.15
- Ubicacion: package.json
- Accion: `npm update lodash`
- CVE: CVE-2021-23337

## Issues Altos (Resolver esta semana)

### [HIGH] Codigo duplicado: formatDate
- src/utils/format.ts:45-67
- src/helpers/date.ts:12-34
- **Sugerencia**: Crear `src/lib/date-utils.ts`
```

## Automatic Scheduling

Sugerir al usuario ejecutar:
- Final de cada sesion de trabajo
- Antes de cada PR
- Semanalmente como rutina

## Integration with Memory

Si encuentra issues, ofrecer:
```
"Quieres que agregue estos patterns a evitar en .claude/mistakes.md?"
```

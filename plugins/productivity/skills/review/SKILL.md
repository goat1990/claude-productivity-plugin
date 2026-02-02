---
name: review
description: Realiza code review profesional como un Staff Engineer antes de commits o PRs. Analiza correctness, security, performance, maintainability y testing.
---

# Code Review

Realiza code review profesional como un Staff Engineer antes de commits o PRs.

## Trigger

- `/productivity:review` - Review de cambios actuales (staged + unstaged)
- `/productivity:review --staged` - Solo cambios staged
- `/productivity:review [file]` - Review de archivo especifico
- `/productivity:review --pr` - Review completo estilo PR

## Review Checklist

### 1. Correctness
- [ ] El codigo hace lo que deberia hacer?
- [ ] Maneja edge cases?
- [ ] Hay off-by-one errors?
- [ ] Las condiciones son correctas (< vs <=)?

### 2. Security
- [ ] Hay inputs no sanitizados?
- [ ] Se exponen datos sensibles?
- [ ] Hay SQL injection posible?
- [ ] XSS posible?
- [ ] Secrets hardcodeados?

### 3. Performance
- [ ] Hay N+1 queries?
- [ ] Renders innecesarios en React?
- [ ] Loops dentro de loops evitables?
- [ ] Memory leaks (event listeners, subscriptions)?

### 4. Maintainability
- [ ] Codigo legible y auto-documentado?
- [ ] Nombres descriptivos?
- [ ] Funciones pequenas y enfocadas?
- [ ] DRY - no hay duplicacion?

### 5. Testing
- [ ] Hay tests para el nuevo codigo?
- [ ] Los tests son significativos?
- [ ] Cubren edge cases?

### 6. Project Conventions
- [ ] Sigue el estilo del proyecto?
- [ ] Respeta patterns de CLAUDE.md?
- [ ] No repite errores de mistakes.md?

## Output Format

```markdown
# Code Review - [branch/file]

## Summary
- **Files changed**: 5
- **Lines added**: 127
- **Lines removed**: 45
- **Risk level**: Medium

## Issues Found

### Critical (must fix)

#### Missing null check in user handler
**File**: `src/api/users.ts:45`
\`\`\`tsx
// Current
const name = user.profile.name

// Suggested
const name = user?.profile?.name ?? 'Unknown'
\`\`\`
**Why**: Will crash if user.profile is undefined

---

### Suggestions (should fix)

#### Consider using early return
**File**: `src/utils/validate.ts:23`
\`\`\`tsx
// Current
if (isValid) {
  // 30 lines of code
}

// Suggested
if (!isValid) return null
// 30 lines of code (less nesting)
\`\`\`

---

### Nitpicks (optional)

#### Variable naming
`data` -> `userData` for clarity

---

## Positives

- Check Good error handling in API calls
- Check Follows existing patterns
- Check Tests included

## Checklist

- [x] Correctness
- [x] Security
- [ ] Performance - N+1 query potential in line 67
- [x] Maintainability
- [ ] Testing - missing edge case test
- [x] Conventions

## Verdict

**Approve with suggestions**

Fix the critical null check before merging.
Consider addressing the performance issue in a follow-up.
```

## Interactive Mode

```
Usuario: /productivity:review

Claude: "Analizando cambios...

Encontre 3 archivos modificados:
1. src/api/users.ts (+45, -12)
2. src/components/UserCard.tsx (+23, -5)
3. src/hooks/useUser.ts (+18, -0)

Review completo o enfocado?
1. Review completo (todos los archivos)
2. Solo el mas riesgoso (users.ts)
3. Elegir archivos especificos"
```

## Challenge Mode

Cuando el usuario dice "Grill me" o "Challenge me":

```
Claude: "Ok, modo dificil activado.

Voy a hacer preguntas sobre tus cambios:

1. En users.ts:45, por que elegiste ese approach?
2. Que pasa si el API devuelve null aqui?
3. Como escala esto con 10,000 usuarios?
4. Probaste el caso de error?

No apruebo hasta que respondas satisfactoriamente."
```

## Diff Analysis

Mostrar before/after cuando sea util:

```diff
- const data = await fetch(url)
+ const data = await fetch(url, {
+   headers: { 'Content-Type': 'application/json' },
+   timeout: 5000
+ })
```

## Integration with Memory

Despues del review:
```
"Quieres que agregue los patterns problematicos a .claude/mistakes.md
para evitarlos en el futuro?"
```

## Pre-commit Hook

Sugerir configurar hook para review automatico:
```bash
# .git/hooks/pre-commit
claude --skill productivity:review --staged --fail-on-critical
```

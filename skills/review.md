# Code Review

Realiza code review profesional como un Staff Engineer antes de commits o PRs.

## Trigger
- `/review` - Review de cambios actuales (staged + unstaged)
- `/review --staged` - Solo cambios staged
- `/review [file]` - Review de archivo específico
- `/review --pr` - Review completo estilo PR

## Review Checklist

### 1. Correctness
- [ ] ¿El código hace lo que debería hacer?
- [ ] ¿Maneja edge cases?
- [ ] ¿Hay off-by-one errors?
- [ ] ¿Las condiciones son correctas (< vs <=)?

### 2. Security
- [ ] ¿Hay inputs no sanitizados?
- [ ] ¿Se exponen datos sensibles?
- [ ] ¿Hay SQL injection posible?
- [ ] ¿XSS posible?
- [ ] ¿Secrets hardcodeados?

### 3. Performance
- [ ] ¿Hay N+1 queries?
- [ ] ¿Renders innecesarios en React?
- [ ] ¿Loops dentro de loops evitables?
- [ ] ¿Memory leaks (event listeners, subscriptions)?

### 4. Maintainability
- [ ] ¿Código legible y auto-documentado?
- [ ] ¿Nombres descriptivos?
- [ ] ¿Funciones pequeñas y enfocadas?
- [ ] ¿DRY - no hay duplicación?

### 5. Testing
- [ ] ¿Hay tests para el nuevo código?
- [ ] ¿Los tests son significativos?
- [ ] ¿Cubren edge cases?

### 6. Project Conventions
- [ ] ¿Sigue el estilo del proyecto?
- [ ] ¿Respeta patterns de CLAUDE.md?
- [ ] ¿No repite errores de mistakes.md?

## Output Format

```markdown
# Code Review - [branch/file]

## Summary
- **Files changed**: 5
- **Lines added**: 127
- **Lines removed**: 45
- **Risk level**: 🟡 Medium

## Issues Found

### 🔴 Critical (must fix)

#### Missing null check in user handler
**File**: `src/api/users.ts:45`
```tsx
// Current
const name = user.profile.name

// Suggested
const name = user?.profile?.name ?? 'Unknown'
```
**Why**: Will crash if user.profile is undefined

---

### 🟡 Suggestions (should fix)

#### Consider using early return
**File**: `src/utils/validate.ts:23`
```tsx
// Current
if (isValid) {
  // 30 lines of code
}

// Suggested
if (!isValid) return null
// 30 lines of code (less nesting)
```

---

### 🟢 Nitpicks (optional)

#### Variable naming
`data` → `userData` for clarity

---

## Positives

- ✅ Good error handling in API calls
- ✅ Follows existing patterns
- ✅ Tests included

## Checklist

- [x] Correctness
- [x] Security
- [ ] Performance - N+1 query potential in line 67
- [x] Maintainability
- [ ] Testing - missing edge case test
- [x] Conventions

## Verdict

🟡 **Approve with suggestions**

Fix the critical null check before merging.
Consider addressing the performance issue in a follow-up.
```

## Interactive Mode

```
Usuario: /review

Claude: "Analizando cambios...

Encontré 3 archivos modificados:
1. src/api/users.ts (+45, -12)
2. src/components/UserCard.tsx (+23, -5)
3. src/hooks/useUser.ts (+18, -0)

¿Review completo o enfocado?
1. Review completo (todos los archivos)
2. Solo el más riesgoso (users.ts)
3. Elegir archivos específicos"
```

## Challenge Mode

Cuando el usuario dice "Grill me" o "Challenge me":

```
Claude: "Ok, modo difícil activado.

Voy a hacer preguntas sobre tus cambios:

1. En users.ts:45, ¿por qué elegiste ese approach?
2. ¿Qué pasa si el API devuelve null aquí?
3. ¿Cómo escala esto con 10,000 usuarios?
4. ¿Probaste el caso de error?

No apruebo hasta que respondas satisfactoriamente."
```

## Diff Analysis

Mostrar before/after cuando sea útil:

```diff
- const data = await fetch(url)
+ const data = await fetch(url, {
+   headers: { 'Content-Type': 'application/json' },
+   timeout: 5000
+ })
```

## Integration with Memory

Después del review:
```
"¿Quieres que agregue los patterns problemáticos a .claude/mistakes.md
para evitarlos en el futuro?"
```

## Pre-commit Hook

Sugerir configurar hook para review automático:
```bash
# .git/hooks/pre-commit
claude --skill review --staged --fail-on-critical
```

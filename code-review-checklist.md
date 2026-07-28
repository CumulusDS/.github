# Code Review Checklist
**Cumulus Quality Engineering · TypeScript / JS · React / GraphQL**

> Use this checklist on every PR. Mark items ✅ (pass), ❌ (needs fix), or N/A where not applicable.
> A PR should not be approved until all applicable items are either passing or explicitly waived with a comment.

---

## 1. Correctness

### Logic & Behaviour
- [ ] The code does what the PR description says it does.
- [ ] Edge cases are handled (empty arrays, null/undefined values, zero quantities, boundary inputs).
- [ ] No unintended side effects are introduced in unrelated areas.
- [ ] Conditional logic is complete — every branch has an explicit outcome.
- [ ] Async operations handle loading, success, and error states correctly.

### Testing
- [ ] New logic or bug fixes are covered by at least one automated test.
- [ ] Tests use UTC dates (`dayjs.utc(...)`) to ensure consistent behaviour across environments.
- [ ] Tests do not rely on implementation details; they test observable behaviour.
- [ ] No `console.log`, debug statements, or commented-out test cases left in.

### Date & Time
- [ ] Dates stored and processed using UTC (`dayjs.utc()`).
- [ ] Timezone-aware display (`.local()` or timezone plugin) is only applied at the presentation layer.

### Units (SI)
- [ ] Internal storage, communication, and business logic use unprefixed SI units (m, N, Pa, N⋅m, etc.).
- [ ] Unit conversions use `@cumulusds/janus-core` — no hand-rolled conversion math.
- [ ] `physicalQuantity` is checked before displaying Entity Property values; `convert` is called as required.
- [ ] User inputs with a `physicalQuantity` are converted from display unit → SI unit before being stored or sent.

---

## 2. Security

### Input Handling
- [ ] All user inputs are validated on **both** client and server — never trust client data alone.
- [ ] Inputs embedded in URLs or query parameters use `encodeURIComponent`.
- [ ] No raw user content is injected into HTML, SQL, GraphQL queries, or shell commands.

### Authentication & Authorisation
- [ ] New API routes or mutations have appropriate auth middleware applied.
- [ ] Authorisation checks happen at the endpoint (end-to-end principle), not only in UI guards.
- [ ] No sensitive values (tokens, secrets, API keys) are logged, exposed in errors, or committed to source.

### Error Exposure
- [ ] User-facing error messages are clear, actionable, and jargon-free.
- [ ] Internal/server errors (not user-remediable) are logged for engineers, **not** shown to users.
- [ ] No stack traces, internal paths, or raw exception messages reach the client UI.

### Data
- [ ] No PII or sensitive data is unnecessarily stored, logged, or transmitted.
- [ ] Data returned from the server is scoped to what the consumer actually needs (no over-fetching sensitive fields).

---

## 3. Performance

### React Rendering
- [ ] Objects, arrays, and functions passed as props to child components or custom hooks are wrapped in `useMemo` / `useCallback` to ensure referential stability.
- [ ] `useEffect`, `useMemo`, and `useCallback` declare the **minimal** set of dependencies — specific fields, not whole objects.
- [ ] State is colocated as close as possible to the component that uses it; state is not lifted unnecessarily.
- [ ] Large components with complex state are broken into smaller, focused components.

### Effects & Derived State
- [ ] `useEffect` is not used for data transformation, event handling, or state initialisation where simpler alternatives exist.
- [ ] Derivable values are computed inline or with `useMemo`, not with `useEffect` + `setState`.
- [ ] State initialised with expensive computations uses the lazy initialiser form of `useState`.

### State Management
- [ ] Server state (remote data) is managed with React Query or Apollo Client — not duplicated in local/global state.
- [ ] Global client state is only used for data genuinely needed across multiple unrelated components.
- [ ] Local component state is used for data specific to a single component.

### Optimistic UI
- [ ] Mutations that benefit from optimistic updates implement them via Apollo/React Query.
- [ ] Rollback logic is in place; the UI clearly signals pending or failed states to the user.

### Data Fetching
- [ ] No N+1 query patterns introduced (batch or paginate where appropriate).
- [ ] GraphQL queries request only the fields the component actually uses.
- [ ] No redundant network requests triggered by unstable dependencies or missing memoisation.

---

## 4. Maintainability

### Simplicity (KIS)
- [ ] The solution is as simple as the problem allows — no premature abstractions or over-engineering.
- [ ] Code reads naturally; a new team member could understand the intent without needing verbal explanation.
- [ ] Large problems are decomposed into small, well-named functions or components.
- [ ] Duplication is removed or deliberately accepted with a comment explaining why.

### GraphQL & Types
- [ ] All GraphQL types are generated via `graphql-code-generator` — no manually defined duplicates.
- [ ] `any` is not used; `unknown` with a type guard is preferred where the type cannot be inferred.
- [ ] No types imported directly from the raw schema file (use generated query/mutation types instead).
- [ ] `codegen.yml` `documents` section includes all relevant folders for the new queries/mutations.
- [ ] New schema fields are backward-compatible; deprecated fields are marked `@deprecated` before removal.
- [ ] Only fields required by active client queries are exposed in the GraphQL schema.

### Code Structure & Naming
- [ ] Variable, function, and component names clearly communicate intent.
- [ ] No magic numbers or strings — use named constants.
- [ ] Related logic is grouped together; unrelated concerns are separated.
- [ ] Exported interfaces/types have descriptive names and JSDoc comments where non-obvious.

### Refactoring & Hygiene
- [ ] No dead code, unused imports, or commented-out blocks left behind.
- [ ] Linting and formatting pass without suppression (no unexplained `eslint-disable` comments).
- [ ] Dependencies in `package.json` are not unnecessarily added for trivial functionality.

---

## 5. PR Hygiene

- [ ] PR description explains **why** the change is needed, not just what changed.
- [ ] The diff is focused — unrelated refactors are in a separate PR.
- [ ] Breaking changes are explicitly called out and migration steps documented.
- [ ] Screenshots or recordings included for any UI changes.
- [ ] Linked to the relevant ticket, issue, or spec.

---

## Quick-Reference: Common Issues to Watch For

| Area | Watch out for |
|---|---|
| **Units** | Raw numeric literals for physical quantities with no unit comment or conversion |
| **Hooks** | Whole objects as `useEffect` deps; missing `useCallback` on handlers passed to children |
| **Errors** | `catch (e) { /* nothing */ }` or raw error objects rendered to the UI |
| **Security** | Missing auth check on new mutation/resolver; unencoded user input in URLs |
| **Types** | `as any` casts, types manually copied from schema instead of using codegen |
| **UTC** | `new Date()` or `dayjs()` without `.utc()` in business logic or tests |
| **Effects** | `useEffect` used to derive/transform state that could be a `useMemo` |
| **State** | Server data duplicated into `useState` instead of using React Query / Apollo |

---

*Last updated: March 2026 · Maintainer: Engineering Team*

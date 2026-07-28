# Cumulus Quality Engineering — GitHub Copilot Instructions

These instructions apply to all code suggestions, completions, and pull request reviews across the Cumulus Quality organization. When reviewing or generating TypeScript/React/GraphQL code, enforce the following principles.

---

## Simplicity (KIS)

- Prefer the simplest solution that correctly solves the problem. Flag over-engineered or unnecessarily clever code.
- Break down large functions or components into smaller, well-named units.
- Flag duplicated logic and suggest extraction into a shared utility or hook.
- Code should read naturally — a new team member should understand intent without verbal explanation.

---

## Units — International System (SI)

- All internal storage, data transmission, and business logic **must** use unprefixed SI units: `m`, `N`, `Pa`, `N⋅m`, etc.
- All unit conversions **must** use `@cumulusds/janus-core`. Flag any hand-rolled unit conversion math.
- When displaying an Entity Property value, check for a `physicalQuantity` field and use the `convert` function from `@cumulusds/janus-core` before rendering.
- When accepting user input for a field with a `physicalQuantity`, convert from the display unit to the internal SI unit before storing or sending the value.
- Display-unit conversions belong only at the UI or reporting layer — never in business logic or data storage.

---

## Date & Time

- All dates in business logic, API calls, and tests **must** use `dayjs.utc()`.
- Flag any use of `new Date()` or bare `dayjs()` (without `.utc()`) outside of display/presentation code.
- Use `dayjs.local()` or timezone plugins **only** at the presentation layer when timezone context matters to the user.
- Tests must always use UTC dates to ensure consistent behaviour across environments.

---

## State Management

Enforce clear separation between the three types of state:

- **Server state** (remote data): managed with React Query or Apollo Client — never duplicated into `useState` or global state.
- **Global client state** (cross-component, non-server): managed with Context API, Redux, or Zustand.
- **Local component state** (single-component): managed with `useState` or `useReducer`.

Flag any server data that is unnecessarily copied into `useState` or a global store.

---

## State Colocation

- State must be defined as close as possible to the component that uses it.
- Flag unnecessary state lifting — if only one component uses a piece of state, it should live in that component.
- Suggest breaking large components with complex state into smaller, focused components.

---

## React Hooks — Dependency Specificity

- `useEffect`, `useMemo`, and `useCallback` must declare the **minimal** set of dependencies.
- If a hook depends on one property of an object, that property (or a memoised value of it) should be the dependency — not the whole object.
- Flag hooks with whole objects or arrays as dependencies when only specific fields are used.

---

## Memoisation of Props

- Objects, arrays, and functions passed as props to child components, hooks, or custom hooks **must** be wrapped in `useMemo` or `useCallback`.
- Flag unmemoised object/array literals or inline arrow functions passed as props — these are recreated on every render and will cause unnecessary re-renders and effect re-runs in children.
- Memoisation ensures referential stability, especially in deeply nested or frequently updated trees.

---

## You Might Not Need an Effect

Before accepting a `useEffect`, check whether the same result can be achieved without it:

- **Data transformation for rendering** → use `useMemo` or inline computation, not `useEffect` + `setState`.
- **Handling user events** → use event handlers, not `useEffect`.
- **Deriving values from props or state** → compute inline or with `useMemo`.
- **Initialising state with an expensive computation** → use the lazy initialiser: `useState(() => compute())`.
- Flag `useEffect` used for any of the above patterns and suggest the simpler alternative.

---

## GraphQL — Generated Types

- All TypeScript types for GraphQL operations **must** come from `graphql-code-generator`.
- Flag any use of `any`, manually defined types that duplicate schema types, or types imported directly from a raw schema file.
- Ensure `codegen.yml` has all relevant folders in the `documents` section when new queries, mutations, or subscriptions are added.

---

## GraphQL — Consumer-Driven API Design

- GraphQL queries and fragments should request only the fields the component actually uses — flag over-fetching.
- New schema additions must be backward-compatible. Fields should be deprecated with `@deprecated(reason: "...")` before removal.
- Flag schema fields with no active client queries as candidates for removal.

---

## Security

- All user inputs must be validated on **both** client and server. Flag server-side handlers that trust client data without validation.
- Flag user inputs embedded in URLs, query parameters, or HTML without `encodeURIComponent` or equivalent encoding.
- Authentication and authorisation checks belong at the endpoint (end-to-end principle) — flag cases where only UI guards are present.
- Flag any secrets, tokens, or API keys that appear in source code, logs, or error messages.

---

## Error Handling

- User-facing error messages must be clear, actionable, and free of technical jargon.
- Errors that users cannot remediate (server failures, internal exceptions) must be logged for engineers — **not** shown to users.
- Flag empty `catch` blocks, swallowed errors, and raw exception messages or stack traces rendered to the UI.
- Flag user-remediable errors that also appear in engineering logs — this indicates a design flaw.

---

## Optimistic UI Updates

- Mutations that change visible state should use optimistic updates (Apollo Client / React Query) to improve perceived responsiveness.
- Flag any mutation that updates server state without considering optimistic UI where it would be beneficial.
- Ensure rollback logic is present and the UI clearly signals pending or failed states.

---

## Input Sanitisation

- Sanitise and validate all user inputs on both client and server.
- Flag any user-provided value embedded in a URL, query string, HTML attribute, GraphQL query, or SQL statement without proper encoding or escaping.

---

## End-to-End Principle

- Validation, security checks, encryption, and error handling belong at the system endpoints (client and server), not in intermediary layers (proxies, middleware, message brokers).
- Flag application-specific logic placed in middleware layers that should belong to an endpoint.

---

## General Code Quality

- Flag `any` type usage; prefer `unknown` with a type guard.
- Flag magic numbers and magic strings; suggest named constants.
- Flag dead code, unused imports, and unexplained `eslint-disable` comments.
- Flag PRs where unrelated refactors are mixed with feature changes — suggest separating them.

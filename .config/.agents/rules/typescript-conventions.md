---
globs: ["*.ts", "*.tsx", "*.mts", "*.cts"]
---

# TypeScript Coding Conventions

## Strict Type Safety — No `any`

**NEVER** use the `any` type in any form, including:

- Type annotations (`let x: any`)
- Function parameters and return types (`(x: any): any`)
- Generic arguments (`Promise<any>`, `Array<any>`)
- Type assertions (`as any`)
- Index signatures (`[key: string]: any`)

### Required Alternatives

| Instead of | Use |
|---|---|
| `any` for unknown data | `unknown` with type narrowing |
| `any` in generics | A type parameter `<T>` with constraints |
| `Record<string, any>` | `Record<string, unknown>` or a specific interface |
| `any[]` | `unknown[]` or a concrete typed array |
| `as any` | Proper type guards or a specific type assertion |
| `JSON.parse()` result | `unknown`, then validate and narrow |
| Catch block error | `unknown` with `instanceof` narrowing |

---
name: diagram-conventions
description: Conventions for visualizing structured information (branching/flow, dependencies, state transitions, ER, option comparisons) as ASCII sketches or Mermaid diagrams. Use when producing a diagram, or deciding whether something should be a diagram at all.
---

# Visual Communication

Plain text is the only channel here, which makes structured information hard for a human to parse at a glance. Promote information that has *structure* into a diagram instead of describing it in prose alone.

- **Visualize only structured information**: branching/flow, module dependencies, state transitions, agent/call sequences, data models (ER), or option comparisons (tables). Leave linear steps as bullet lists, trivial 1–2 element relationships as prose, and code changes as diffs—over-visualizing raises cognitive load instead of lowering it.
- **Match the rendering target** (the target decides the tool):
  - Terminal (live dialogue) → ASCII/Unicode box art, trees, and tables. Renders instantly, zero dependencies.
  - Saved or shared artifacts (Obsidian notes, GitHub PRs/issues) → Mermaid. It renders there and is version-controllable as text, but does NOT render in the terminal.
- **ASCII-first, then Mermaid** — use this loop whenever the deliverable is a Mermaid diagram:
  1. Declare the diagram type up front (`flowchart` / `sequenceDiagram` / `stateDiagram-v2` / `erDiagram`) so the sketch stays translatable—each type has its own Mermaid grammar.
  2. Sketch in ASCII in the terminal and iterate until the structure, labels, and direction are agreed. Reviewing here is cheap and immediate.
  3. Transcribe the agreed sketch to Mermaid once. Because the type is already fixed, this is a format conversion, not a redraw.
- **Keep the ASCII sketch "Mermaid-shaped"** (nodes + edges + labels). If aligning requires free-form art Mermaid can't express (diagonal lines, overlaps, free placement), treat that as the signal to switch to a generated image (SVG/PNG), not Mermaid.

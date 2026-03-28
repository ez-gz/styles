# styles

Design systems as single-file HTML guides with copy-paste CSS.

---

## typewriter

A monospace-first, brutalist design system. Hard edges, tight letter-spacing, motion through text — not decoration.

**[→ Open the guide](typewriter/typewriter.html)**

```html
<!-- 1. load the font -->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link href="https://fonts.googleapis.com/css2?family=Courier+Prime:wght@400;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet" />

<!-- 2. drop in the CSS -->
<link rel="stylesheet" href="typewriter/typewriter.css" />
```

**The rules:**

- One font family — Courier Prime / IBM Plex Mono — used at all sizes and weights
- No rounded corners, ever — `border-radius: 0` on everything
- Two colors — ink `#111` and paper `#fff` — plus error red `#7a0000`
- Text as interface — loading states are animated words, labels are uppercase type, no icons
- Motion through text — dot cycling, opacity reveals, blinking cursor — no slides or bounces

**Components:** Toggle · Custom Select · Radio · Breadcrumb · Pagination · Toast · Progress Bar · Stepper · Accordion · Tag · Dropdown Menu · Code Block

**Also available for native macOS (SwiftUI):** [`typewriter/macos/`](typewriter/macos/) — same tokens and rules ported to SF Mono + `NSColor`, with ViewModifiers (`.twCard()`, `.twButton()`, `.twRow()`, `.twTag()`) and a standalone component gallery. Drop `TypewriterStyle.swift` into any project, no package needed.

**Porting to Tailwind:**

```js
// tailwind.config.js
theme: {
  extend: {
    fontFamily: { mono: ['"Courier Prime"', '"IBM Plex Mono"', 'ui-monospace', 'monospace'] },
    borderRadius: { DEFAULT: '0', none: '0', sm: '0', md: '0', lg: '0', xl: '0' },
    colors: {
      ink: '#111', paper: '#fff', muted: '#555', dim: '#333',
      rule: '#d0d0d0', hover: '#f5f5f5', activeBg: '#f7f7f7', error: '#7a0000',
    },
  },
}
```

---

## skills

LLM skills for working with design systems.

| Skill | What it does |
|-------|-------------|
| [style-rip](skills/style-rip/SKILL.md) | Extract a design system from any codebase and generate a complete styleguide |

---

## adding a new system

Each design system lives in its own subfolder:

```
styles/
└── your-system/
    ├── your-system.html   ← self-contained guide (open in browser)
    └── your-system.css    ← standalone CSS (link from any project)
```

Run `/style-rip` in any codebase to generate a new one.

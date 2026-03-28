# style-rip

Extract the complete visual design language from any existing app or codebase and generate a self-contained HTML styleguide — like the ones in this repo.

## What this skill does

Given access to a codebase, explore its styles, extract the design language, and produce:
- `[name].html` — a self-contained styleguide with live rendered components and embedded CSS
- `[name].css` — a standalone stylesheet any project can link to

---

## Step 1 — Discover

Find all style-related files before reading any of them.

```bash
# Global stylesheets
find . -name "*.css" -not -path "*/node_modules/*" -not -path "*/.next/*"

# Tailwind config
find . -name "tailwind.config*"

# CSS custom properties / tokens
grep -r ":root" --include="*.css" -l
grep -r "css\`\|styled\." --include="*.tsx" --include="*.ts" -l | head -20

# Design token files
find . \( -name "tokens*" -o -name "theme*" -o -name "colors*" -o -name "variables*" \) -not -path "*/node_modules/*"
```

Priority order for reading:
1. Global stylesheet (`globals.css`, `styles.css`, `main.css`, `index.css`, `app.css`)
2. Tailwind config → `theme` and `theme.extend`
3. A few high-traffic component files (the ones used everywhere)

---

## Step 2 — Extract

Pull out every value that defines how the app looks. Organise as you go.

### Colors
Collect every named color token or hex value used more than once. Map to semantic names:

```
Raw                     → Semantic token
#111 / gray-900         → --ink        (primary text / borders)
#fff / white            → --paper      (background)
#555 / gray-500         → --muted      (secondary text)
#d0d0d0 / gray-200      → --rule       (dividers)
#f5f5f5 / gray-50       → --hover      (hover state bg)
#7a0000 / red-900       → --error      (errors)
```

If the app uses Tailwind, read the `colors` key in the config — that's the authoritative token set.

### Typography
```
Font families      → list all, note which is the "primary" one
Size scale         → what values actually appear? (12, 13, 14, 15, 16, 32...)
Font weights       → which weights are used? (400, 500, 600, 700?)
Letter-spacing     → any custom values? (0.04em, 0.1em, 0.18em?)
Text transforms    → uppercase labels? lowercase buttons?
Line height        → default + any overrides
```

### Spacing
Look for recurring padding/margin values. Usually 3-6 values cover 90% of the UI.

### Borders & corners
```
border-radius      → 0? 4px? 8px? "full"? This is the most revealing single property.
border-width       → 1px? 2px?
border-color       → which token?
```

### Motion
```
transition durations   → 100ms? 200ms? 300ms?
easing functions       → ease? ease-in-out? linear?
what animates?         → opacity? transform? background?
what does NOT animate? → hover? focus?
```

---

## Step 3 — Name the aesthetic

Before writing any code, answer these in one sentence each:

1. **What is this?** e.g. "soft rounded SaaS", "dense data terminal", "brutalist monospace", "editorial newspaper"
2. **What are the 2-3 most distinctive visual choices?** e.g. "no border-radius, one accent color, heavy uppercase"
3. **What does it NOT do?** e.g. "no shadows, no gradients, no icons, no color backgrounds"
4. **What's the motion philosophy?** e.g. "instant hover, 200ms transitions on modals only"

This framing becomes the **Philosophy** section of the guide — the rules of the system.

### Examples of well-named aesthetics

| What you see in the code | Name | Rules in one line |
|--------------------------|------|-------------------|
| Courier Prime everywhere, border-radius:0, 1px borders | **Typewriter** | Monospace-first, hard edges, text as interface |
| Inter, 8px radius, shadow-sm on cards, slate palette | **Clean SaaS** | Rounded, elevated cards, systematic gray scale |
| Space Grotesk, 0 radius, neon accent on black | **Dark Terminal** | Dark background, one neon accent, no softness |
| Playfair Display + DM Sans, generous whitespace | **Editorial** | Serif display + sans body, whitespace as design |

---

## Step 4 — Generate the styleguide

Create `[name].html` — a single file that works by opening it in a browser.

### Required sections (in order)

**01 — Philosophy**
5-8 rules that define the system. Lead with the most distinctive one.
Not "uses #111 for text" — instead "everything is ink on paper: maximum contrast, no in-between grays".

Example (from Typewriter):
- One font family used completely — no display font, no sans fallback
- No rounded corners, ever — hard edges reinforce the grid
- Text is the interface — loading states are words, not spinners
- Two colors: ink and paper — everything else is a tint of black

**02 — Tokens**
Color swatches with hex values and CSS variable names.
Spacing scale as visual bars.

**03 — Typography**
Every size/weight/letter-spacing variant, rendered live.
Show actual text, not placeholder labels.

**04 — Components**
Each component rendered with code snippets. Include:
- Default state
- Active/selected state
- Disabled state
- Error state (where applicable)

Minimum component set:
- Button (default, disabled)
- Input + Textarea
- Card / Panel
- Badge
- Alert / Error message

Expanded (add what the app actually has):
- Toggle / Segmented control
- Select
- Checkbox or Radio
- Table
- Navigation (tabs, breadcrumb, or pagination)
- Notification / Toast
- Accordion or Disclosure
- Status indicators (progress, stepper)

**05 — Full CSS**
A copy-paste block of all CSS custom properties and component classes.
This is the single most useful output — someone should be able to drop this into any project.

### Structural template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>[Name] — Design System</title>
  <!-- font link here -->
  <style>
    /* ── START [NAME] CSS ─── */
    :root {
      /* tokens here */
    }
    /* component classes here */
    /* ── END [NAME] CSS ─── */

    /* styleguide chrome (NOT part of the design system) */
  </style>
</head>
<body>
  <!-- rendered sections -->
  <!-- full CSS pre block at bottom -->
</body>
</html>
```

Keep the design system CSS between clear START/END markers so consumers know exactly what to copy.

---

## Step 5 — Extract to standalone CSS

After the HTML guide is complete, extract everything between the START/END markers into `[name].css`.

Add a header comment:
```css
/* ==================================================
   [Name] — Design System v1.0
   [repo URL]

   Font: [google fonts link]
   ================================================== */
```

---

## Quality bar

A complete styleguide passes these checks:

- [ ] **Philosophy reads as rules, not descriptions** — "no rounded corners" not "corners are square"
- [ ] **Every component shows all states** — default, hover, active, disabled, error
- [ ] **The full CSS block is self-contained** — someone can copy it and nothing breaks
- [ ] **The "print test"** — if printed on paper, could a developer recreate the system from it?
- [ ] **Tokens have semantic names** — `--ink` not `--gray-900`, `--error` not `--red-700`
- [ ] **The philosophy explains the WHY** — why no rounded corners? why one font? what does it evoke?

---

## Real example: how Typewriter was ripped

**App:** text-battle-royale (a text-based game)

**Discovery:**
```
frontend/src/styles.css  ← one global file, 284 lines
frontend/src/App.tsx     ← all components in one file
```

**Key findings from styles.css:**
```css
font-family: "Courier Prime", "IBM Plex Mono", ui-monospace ...
background: #fff; color: #111;
border-radius: 0;  /* on buttons, inputs, textareas */
border: 1px solid #111;
```

**Key findings from App.tsx:**
- Loading states: `"waiting..."` with JS dot cycling (`.` → `..` → `...` every 450ms)
- No icons anywhere — labels, eyebrows, badges are all text
- Story text revealed via opacity transition: `0.92` → `1` at `140ms linear`

**Named aesthetic:** Typewriter — monospace-first, brutalist, text as interface

**Philosophy extracted:**
1. One font family, used completely
2. No rounded corners, ever
3. Text is the interface (no icons, no spinners)
4. Motion through opacity and text, not transforms
5. Two colors: ink and paper
6. Typography is layout (letter-spacing/transform do the visual work)

**Output:** `typewriter.html` + `typewriter.css`
See: [github.com/ez-gz/styles/typewriter](https://github.com/ez-gz/styles/tree/main/typewriter)

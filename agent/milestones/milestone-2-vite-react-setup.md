# Milestone 2: Vite + React Project Setup

**Goal**: Set up Vite + React project structure with routing and basic navigation
**Duration**: 1-2 days
**Dependencies**: Milestone 1 (Project Foundation & Core Utilities)
**Status**: Not Started

---

## Overview

This milestone establishes the React application foundation using Vite as the build tool. It creates the project structure, installs core dependencies, configures routing with React Router, and implements the basic navigation system (desktop navbar and mobile hamburger menu). This provides the scaffolding for all future pages and components.

---

## Deliverables

### 1. Project Structure
- Vite + React + TypeScript project initialized
- src/ directory with organized subdirectories (pages/, components/, styles/, data/)
- vite.config.ts configured
- index.html entry point
- App.tsx with routing setup

### 2. Core Dependencies
- React 18+ installed
- React Router 6+ installed
- TypeScript configured for React
- Vite dev server configured

### 3. Navigation System
- Navbar component (desktop)
- Mobile hamburger menu
- Responsive navigation logic
- Route highlighting for active page

---

## Success Criteria

- [ ] Vite dev server starts successfully (`npm run dev`)
- [ ] TypeScript compiles without errors
- [ ] React Router navigation works between pages
- [ ] Desktop navbar displays and functions correctly
- [ ] Mobile hamburger menu displays and functions correctly
- [ ] Responsive breakpoints work (mobile < 768px, desktop > 768px)
- [ ] No console errors in browser

---

## Key Files to Create

```
src/
├── main.tsx                 # Entry point
├── App.tsx                  # Root component with routing
├── vite-env.d.ts           # Vite type definitions
├── components/
│   ├── Navbar.tsx          # Desktop/mobile navigation
│   └── Layout.tsx          # Page layout wrapper
├── pages/
│   ├── Home.tsx            # Placeholder home page
│   ├── Portfolio.tsx       # Placeholder portfolio page
│   └── CV.tsx              # Placeholder CV page
├── styles/
│   ├── index.css           # Global styles
│   └── theme.css           # Color scheme variables
└── data/
    └── .gitkeep            # Placeholder for future data files

vite.config.ts              # Vite configuration
index.html                  # HTML entry point
```

---

## Tasks

1. Task 2: Initialize Vite + React project
2. Task 3: Configure React Router and create page placeholders
3. Task 4: Implement responsive navigation (Navbar + mobile menu)

---

## Testing Requirements

- [ ] Manual testing: Navigation works on desktop
- [ ] Manual testing: Hamburger menu works on mobile
- [ ] Manual testing: Routes navigate correctly
- [ ] Manual testing: No console errors

---

## Documentation Requirements

- [ ] Update README.md with dev server instructions
- [ ] Document component structure
- [ ] Add navigation usage notes

---

## Risks and Mitigation

| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|---------------------|
| Vite configuration issues | Medium | Low | Use official Vite React template as starting point |
| Routing complexity | Low | Low | Use React Router documentation and examples |
| Mobile menu not working | Medium | Low | Test on actual mobile devices early |

---

**Next Milestone**: Milestone 3: Hero Landing Page
**Blockers**: None
**Notes**: Keep dependencies minimal, focus on core functionality first

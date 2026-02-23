# Portfolio Website Design

**Concept**: Interactive portfolio/resume/CV website with modern UI, fuzzy search, and mobile-responsive design
**Created**: 2026-02-23
**Status**: Design Specification

---

## Overview

This document describes the design for patrickmichaelsen.com, an interactive portfolio and resume website built with Vite + React SPA. The site showcases professional development work with a modern, visually appealing interface featuring cool blues and purples, CSS animations, and responsive design for both desktop and mobile devices.

The website serves as a digital portfolio and CV platform, allowing visitors to explore projects and professional experience through an intuitive, searchable interface.

---

## Problem Statement

**Challenges**:
- Need a professional online presence to showcase work and experience
- Static resumes don't provide interactive exploration of projects and skills
- Difficult for recruiters/visitors to find relevant experience quickly
- Need mobile-friendly access for on-the-go viewing
- Want to stand out with modern, visually appealing design

**Consequences of not solving**:
- Limited professional visibility
- Missed opportunities due to lack of online presence
- Poor user experience when viewing resume on mobile devices
- Difficulty highlighting relevant experience for different audiences

---

## Solution

Build a modern React SPA with:
- **Hero landing page** with gradients, CSS animations, and modern design
- **Portfolio page** with fuzzy search-filterable card list
- **CV page** with fuzzy search-filterable experience entries
- **Responsive navigation** (desktop navbar / mobile hamburger menu)
- **Minimal dependencies** for fast load times
- **Deployment** to patrickmichaelsen.com

**Technology Stack**:
- **Framework**: Vite + React
- **Styling**: CSS with gradients and animations (cool blues/purples theme)
- **Routing**: React Router
- **Search**: Fuzzy search library (e.g., Fuse.js)
- **Deployment**: Cloudflare Pages (already configured)

---

## Implementation

### Architecture

```
resume/
├── src/
│   ├── pages/
│   │   ├── Home.tsx           # Hero landing page
│   │   ├── Portfolio.tsx      # Portfolio card list
│   │   └── CV.tsx             # CV entry list
│   ├── components/
│   │   ├── Navbar.tsx         # Desktop/mobile navigation
│   │   ├── Hero.tsx           # Landing page hero section
│   │   ├── PortfolioCard.tsx  # Portfolio item card
│   │   ├── CvEntry.tsx        # CV experience entry
│   │   └── SearchBar.tsx      # Fuzzy search component
│   ├── data/
│   │   ├── portfolio.ts       # Portfolio items data
│   │   └── cv.ts              # CV entries data
│   ├── styles/
│   │   ├── theme.css          # Color scheme (blues/purples)
│   │   └── animations.css     # CSS animations
│   ├── App.tsx
│   └── main.tsx
├── public/
└── vite.config.ts
```

### Data Structures

```typescript
interface PortfolioItem {
  id: string;
  title: string;
  description: string;
  technologies: string[];
  link?: string;
  image?: string;
  tags: string[];
}

interface CvEntry {
  id: string;
  company: string;
  role: string;
  period: string;
  description: string;
  achievements: string[];
  technologies: string[];
  tags: string[];
}
```

### Key Components

**1. Hero Landing Page**
- Full-screen hero section
- Gradient background (blues → purples)
- CSS animations (fade-in, slide-in)
- Call-to-action buttons (View Portfolio, View CV)
- Smooth scroll to sections

**2. Navigation**
- Desktop: Horizontal navbar with links
- Mobile: Hamburger menu with slide-out drawer
- Sticky/fixed positioning
- Active route highlighting

**3. Portfolio Page**
- Card grid layout (responsive columns)
- Fuzzy search bar at top
- Filter by technology/tags
- Card hover effects
- Click to expand/view details

**4. CV Page**
- Timeline or list layout
- Fuzzy search bar at top
- Filter by company/technology/role
- Expandable entries
- Download PDF button

**5. Search Implementation**
```typescript
import Fuse from 'fuse.js';

const searchOptions = {
  keys: ['title', 'description', 'technologies', 'tags'],
  threshold: 0.3,
};

const fuse = new Fuse(items, searchOptions);
const results = fuse.search(query);
```

### Color Scheme

```css
:root {
  /* Primary Blues */
  --blue-50: #e0f2fe;
  --blue-500: #0ea5e9;
  --blue-700: #0369a1;
  --blue-900: #0c4a6e;
  
  /* Accent Purples */
  --purple-500: #a855f7;
  --purple-700: #7e22ce;
  --purple-900: #581c87;
  
  /* Gradients */
  --gradient-hero: linear-gradient(135deg, var(--blue-700), var(--purple-700));
  --gradient-card: linear-gradient(to bottom right, var(--blue-900), var(--purple-900));
}
```

### Responsive Breakpoints

```css
/* Mobile: < 768px */
/* Tablet: 768px - 1024px */
/* Desktop: > 1024px */

@media (max-width: 768px) {
  /* Mobile styles */
}

@media (min-width: 768px) and (max-width: 1024px) {
  /* Tablet styles */
}

@media (min-width: 1024px) {
  /* Desktop styles */
}
```

---

## Benefits

- **Professional Presence**: Modern, polished online portfolio
- **Discoverability**: Fuzzy search helps visitors find relevant experience quickly
- **Mobile-Friendly**: Responsive design works on all devices
- **Fast Performance**: Vite + minimal dependencies = fast load times
- **Easy Updates**: Source data from resources/resumes for easy content updates
- **Visual Appeal**: Modern design with animations stands out
- **SEO-Friendly**: React Router with proper meta tags

---

## Trade-offs

- **SPA Limitations**: Initial load includes all JS (mitigated by code splitting)
- **SEO Challenges**: Client-side rendering may impact search indexing (mitigated by meta tags and potential SSR)
- **Maintenance**: Need to manually update portfolio/CV data (mitigated by sourcing from resources/resumes)
- **Browser Compatibility**: Modern CSS features may not work in older browsers (acceptable trade-off for target audience)

---

## Dependencies

**Core**:
- React 18+
- Vite 5+
- React Router 6+

**Search**:
- Fuse.js (fuzzy search)

**Deployment**:
- Cloudflare Pages (already configured)
- Custom domain: patrickmichaelsen.com

**Data Source**:
- resources/resumes/ (markdown files to parse for CV data)

---

## Testing Strategy

**Unit Tests**:
- Search functionality (fuzzy matching)
- Component rendering
- Data parsing from resources/resumes

**Integration Tests**:
- Navigation between pages
- Search filtering
- Responsive layout

**Manual Testing**:
- Cross-browser testing (Chrome, Firefox, Safari, Edge)
- Mobile device testing (iOS, Android)
- Performance testing (Lighthouse scores)
- Accessibility testing (WCAG compliance)

---

## Migration Path

1. **Phase 1**: Setup Vite + React project structure
2. **Phase 2**: Implement hero landing page with navigation
3. **Phase 3**: Build Portfolio page with search
4. **Phase 4**: Build CV page with search
5. **Phase 5**: Add CSS animations and polish
6. **Phase 6**: Deploy to Cloudflare Pages
7. **Phase 7**: Connect custom domain (patrickmichaelsen.com)

---

## Future Considerations

- **Blog Section**: Add blog/articles page
- **Dark Mode**: Toggle between light/dark themes
- **Analytics**: Add privacy-friendly analytics (e.g., Plausible)
- **Contact Form**: Add contact form with email integration
- **Project Demos**: Embed live demos or screenshots
- **Testimonials**: Add recommendations/testimonials section
- **Resume Download**: Generate PDF resume on-demand
- **Internationalization**: Multi-language support
- **CMS Integration**: Connect to headless CMS for easier content updates

---

**Status**: Design Specification
**Recommendation**: Proceed with Phase 1 implementation (project setup)
**Related Documents**: 
- resources/resumes/resume_2026-02-23.md (source data)
- agent/patterns/typescript-scripts-pattern.md (build tooling pattern)

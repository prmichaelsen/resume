# Milestone 5: CV Page with Fuzzy Search

**Goal**: Build CV page with experience timeline and fuzzy search filtering
**Duration**: 2-3 days
**Dependencies**: Milestone 4 (Portfolio Page with Fuzzy Search)
**Status**: Not Started

---

## Overview

This milestone implements the CV page featuring a timeline or list layout displaying professional experience entries. Each entry shows company, role, period, description, achievements, and technologies. The page includes a fuzzy search bar allowing visitors to filter experience by company, role, technology, or keywords.

---

## Deliverables

### 1. CV Page
- Timeline or list layout for experience entries
- CV data structure and sample data
- Individual CV entry components
- Expandable/collapsible entries
- Download PDF button

### 2. Fuzzy Search
- Search bar component (reuse from Portfolio)
- Fuse.js integration for CV data
- Real-time filtering as user types
- Search across company, role, description, technologies, achievements

### 3. CV Data
- TypeScript interface for CV entries
- CV data sourced from resources/resumes/resume_2026-02-23.md
- Data file in src/data/cv.ts
- Parser to extract data from markdown resume

---

## Success Criteria

- [ ] CV page displays experience entries
- [ ] Timeline/list layout is clear and readable
- [ ] Search bar filters entries in real-time
- [ ] Fuzzy search works across all relevant fields
- [ ] Entries can expand/collapse (if implemented)
- [ ] Download PDF button works (links to generated PDF)
- [ ] All CV data displays correctly
- [ ] Responsive layout works on all devices
- [ ] No console errors
- [ ] Lighthouse performance score > 90

---

## Key Files to Create

```
src/
├── pages/
│   └── CV.tsx              # CV page (enhanced)
├── components/
│   ├── CvEntry.tsx         # Individual experience entry
│   ├── Timeline.tsx        # Timeline layout component
│   └── DownloadButton.tsx  # PDF download button
├── data/
│   └── cv.ts               # CV entries data
├── styles/
│   ├── cv.css              # CV page styles
│   └── timeline.css        # Timeline component styles
├── types/
│   └── cv.d.ts             # CV data types
└── utils/
    └── resumeParser.ts     # Parse markdown resume to CV data
```

---

## Tasks

1. Task 12: Create CV data structure and parse from markdown resume
2. Task 13: Implement CvEntry component with timeline layout
3. Task 14: Implement fuzzy search for CV entries
4. Task 15: Add PDF download functionality

---

## Environment Variables

None required for this milestone.

---

## Testing Requirements

- [ ] Visual testing: Timeline displays correctly on all screen sizes
- [ ] Functional testing: Search filters entries correctly
- [ ] Functional testing: Fuzzy search finds partial matches
- [ ] Functional testing: PDF download works
- [ ] Performance testing: Search is fast (<100ms)
- [ ] Manual testing: Expand/collapse works (if implemented)

---

## Documentation Requirements

- [ ] Document CV data structure
- [ ] Document resume parser utility
- [ ] Add CV page usage notes

---

## Risks and Mitigation

| Risk | Impact | Probability | Mitigation Strategy |
|------|--------|-------------|---------------------|
| Resume parsing complexity | Medium | Medium | Keep parser simple, manual data entry acceptable |
| Timeline layout breaks on mobile | Medium | Low | Test thoroughly on mobile devices |
| PDF download link breaks | Low | Low | Use relative path to artifacts/ directory |

---

**Next Milestone**: Milestone 6: Polish and Deployment
**Blockers**: None
**Notes**: Reuse SearchBar component from Portfolio page

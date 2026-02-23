# resume

Personal resume and portfolio website with version-tracked resume management, PDF generation, and React/Vite deployment to GitHub Pages

> Built with [Agent Context Protocol](https://github.com/prmichaelsen/agent-context-protocol)

## Features

- 📝 Version-tracked resume management for different companies
- 📄 PDF generation from source files
- 🎨 Beautiful React/Vite portfolio website
- 🚀 Deployed to GitHub Pages
- 🛣️ React Router for navigation
- 🔧 TypeScript utility scripts for automation

## Quick Start

[Add installation and usage instructions here]

## Development

This project uses the Agent Context Protocol for development:

- `@acp.init` - Initialize agent context
- `@acp.plan` - Plan milestones and tasks
- `@acp.proceed` - Continue with next task
- `@acp.status` - Check project status

See [AGENT.md](./AGENT.md) for complete ACP documentation.

## Project Structure

```
resume/
├── AGENT.md              # ACP methodology
├── agent/                # ACP directory
│   ├── design/          # Design documents
│   ├── milestones/      # Project milestones
│   ├── tasks/           # Task breakdown
│   ├── patterns/        # Architectural patterns
│   └── progress.yaml    # Progress tracking
├── src/                 # React application source
├── scripts/             # TypeScript utility scripts
└── resumes/             # Version-tracked resume files
```

## Technology Stack

- **Frontend**: React + Vite + TypeScript
- **Routing**: React Router
- **Styling**: [TBD]
- **PDF Generation**: jsPDF + marked (TypeScript scripts)
- **Deployment**: GitHub Pages

## PDF Generation

Generate PDF from markdown resume:

```bash
npx tsx scripts/generate-pdf.ts <path-to-md> [--title "Title"] [--output "filename.pdf"]
```

**Example**:
```bash
npx tsx scripts/generate-pdf.ts resources/resumes/resume_2026-02-23.md --title "Patrick_Michaelsen_Resume"
```

**Output**: PDF saved to `artifacts/` directory

**Arguments**:
- `<path-to-md>`: Path to markdown file (required)
- `--title "Title"`: Custom title for PDF filename (optional, defaults to filename)
- `--output "filename.pdf"`: Custom output filename (optional, defaults to title.pdf)

## Scripts

This project uses TypeScript scripts with `npx tsx` for utility automation. Scripts are located in the `scripts/` directory with their own `package.json` and `tsconfig.json`.

See [`agent/patterns/typescript-scripts-pattern.md`](agent/patterns/typescript-scripts-pattern.md) for the complete pattern documentation.

## Getting Started

1. Initialize context: `@acp.init`
2. Plan your project: `@acp.plan`
3. Start building: `@acp.proceed`

## License

All Rights Reserved

Copyright (c) 2026 Patrick Michaelsen

## Author

Patrick Michaelsen

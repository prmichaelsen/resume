# Task 1: TypeScript Scripts Pattern with PDF Generation

**Milestone**: M1 - Project Foundation & Core Utilities
**Estimated Time**: 4-6 hours
**Dependencies**: None
**Status**: Not Started

---

## Objective

Establish a TypeScript scripts pattern using `npx tsx` for running Node.js scripts, and implement the first script: a CLI program that converts Markdown resume files to PDF format with customizable titles.

---

## Context

This task creates the foundation for TypeScript utility scripts in the project. The scripts will be executable via `npx tsx scripts/my-script.ts` without requiring a build step, enabling rapid development and execution of utility tools. The first script addresses a core requirement: generating PDF versions of markdown resumes for job applications.

This pattern will be reusable for future scripts like resume customization, batch PDF generation, and other automation tasks.

---

## Steps

### 1. Initialize Node.js Project

Create package.json with TypeScript and tsx support:

```bash
npm init -y
```

Update package.json with proper configuration:

```json
{
  "name": "resume",
  "version": "0.1.0",
  "description": "Personal resume and portfolio website with version-tracked resume management",
  "type": "module",
  "scripts": {
    "generate-pdf": "tsx scripts/generate-pdf.ts",
    "typecheck": "tsc --noEmit"
  },
  "keywords": ["resume", "portfolio", "pdf-generation"],
  "author": "Patrick Michaelsen",
  "license": "All Rights Reserved"
}
```

### 2. Install Dependencies

Install TypeScript, tsx, and PDF generation libraries:

```bash
npm install --save-dev typescript tsx @types/node
npm install markdown-pdf puppeteer
npm install --save-dev @types/puppeteer
```

**Alternative PDF libraries to consider**:
- `md-to-pdf` - Simple markdown to PDF conversion
- `marked` + `puppeteer` - More control over rendering
- `jsPDF` + `markdown-it` - Client-side capable

### 3. Create TypeScript Configuration

Create `tsconfig.json` for scripts:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "sourceMap": true,
    "types": ["node"]
  },
  "include": ["scripts/**/*", "src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### 4. Create Scripts Directory

Create directory structure for scripts:

```bash
mkdir -p scripts
```

### 5. Implement PDF Generation Script

Create `scripts/generate-pdf.ts`:

```typescript
#!/usr/bin/env node
import { readFile, writeFile, mkdir } from 'fs/promises';
import { resolve, basename } from 'path';
import { existsSync } from 'fs';

// Parse command line arguments
interface Args {
  mdPath: string;
  title?: string;
  output?: string;
}

function parseArgs(): Args {
  const args = process.argv.slice(2);
  const mdPathIndex = args.findIndex(arg => !arg.startsWith('--'));
  
  if (mdPathIndex === -1) {
    console.error('Usage: npx tsx scripts/generate-pdf.ts <path-to-md> [--title "Title"] [--output "filename.pdf"]');
    process.exit(1);
  }

  const mdPath = args[mdPathIndex];
  const titleIndex = args.indexOf('--title');
  const outputIndex = args.indexOf('--output');

  return {
    mdPath,
    title: titleIndex !== -1 ? args[titleIndex + 1] : undefined,
    output: outputIndex !== -1 ? args[outputIndex + 1] : undefined,
  };
}

async function generatePDF(mdPath: string, title?: string, outputPath?: string): Promise<void> {
  try {
    // Read markdown file
    const mdContent = await readFile(mdPath, 'utf-8');
    
    // Determine output filename
    const defaultTitle = title || basename(mdPath, '.md');
    const outputFilename = outputPath || `${defaultTitle}.pdf`;
    const fullOutputPath = resolve('./artifacts', outputFilename);

    // Ensure artifacts directory exists
    if (!existsSync('./artifacts')) {
      await mkdir('./artifacts', { recursive: true });
    }

    // Import PDF library (dynamic import for ESM compatibility)
    const { mdToPdf } = await import('md-to-pdf');
    
    // Generate PDF with custom styling
    const pdf = await mdToPdf(
      { content: mdContent },
      {
        dest: fullOutputPath,
        pdf_options: {
          format: 'Letter',
          margin: {
            top: '20mm',
            right: '20mm',
            bottom: '20mm',
            left: '20mm',
          },
          printBackground: true,
        },
        stylesheet: `
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            font-size: 11pt;
            line-height: 1.6;
            color: #333;
          }
          h1 {
            font-size: 24pt;
            margin-bottom: 0.5em;
            color: #1a1a1a;
          }
          h2 {
            font-size: 18pt;
            margin-top: 1.5em;
            margin-bottom: 0.5em;
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 0.3em;
          }
          h3 {
            font-size: 14pt;
            margin-top: 1em;
            margin-bottom: 0.5em;
            color: #34495e;
          }
          p {
            margin-bottom: 0.8em;
          }
          ul, ol {
            margin-bottom: 1em;
          }
          li {
            margin-bottom: 0.3em;
          }
          code {
            background-color: #f4f4f4;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
          }
          pre {
            background-color: #f4f4f4;
            padding: 1em;
            border-radius: 5px;
            overflow-x: auto;
          }
          a {
            color: #3498db;
            text-decoration: none;
          }
          blockquote {
            border-left: 4px solid #3498db;
            padding-left: 1em;
            margin-left: 0;
            color: #555;
            font-style: italic;
          }
        `,
      }
    );

    console.log(`✅ PDF generated successfully!`);
    console.log(`   Input: ${mdPath}`);
    console.log(`   Output: ${fullOutputPath}`);
    console.log(`   Title: ${defaultTitle}`);
  } catch (error) {
    console.error('❌ Error generating PDF:', error);
    process.exit(1);
  }
}

// Main execution
const args = parseArgs();
await generatePDF(args.mdPath, args.title, args.output);
```

### 6. Make Script Executable

Add execute permissions (Unix/Linux/Mac):

```bash
chmod +x scripts/generate-pdf.ts
```

### 7. Create Pattern Documentation

Create `agent/patterns/typescript-scripts-pattern.md`:

```markdown
# TypeScript Scripts Pattern

## Overview

This pattern enables running TypeScript scripts directly using `npx tsx` without requiring a build step. Scripts are located in the `scripts/` directory and can be executed with full TypeScript support.

## Usage

```bash
npx tsx scripts/my-script.ts [arguments]
```

## Benefits

- No build step required
- Full TypeScript type checking
- ESM module support
- Fast execution with tsx
- Easy to develop and test

## Script Structure

```typescript
#!/usr/bin/env node
import { /* dependencies */ } from 'module';

// Parse arguments
interface Args {
  // Define argument types
}

function parseArgs(): Args {
  // Parse process.argv
}

async function main(): Promise<void> {
  // Script logic
}

// Execute
const args = parseArgs();
await main();
```

## Examples

### Generate PDF from Markdown
```bash
npx tsx scripts/generate-pdf.ts resources/resumes/resume_2026-02-23.md --title "Patrick_Michaelsen_Resume"
```

### Add to package.json scripts
```json
{
  "scripts": {
    "generate-pdf": "tsx scripts/generate-pdf.ts"
  }
}
```

Then run:
```bash
npm run generate-pdf resources/resumes/resume_2026-02-23.md --title "My_Resume"
```
```

### 8. Test the Script

Test PDF generation with existing resume:

```bash
npx tsx scripts/generate-pdf.ts resources/resumes/resume_2026-02-23.md --title "Patrick_Michaelsen_Resume"
```

Verify output in `artifacts/Patrick_Michaelsen_Resume.pdf`

### 9. Update .gitignore

Ensure artifacts directory is properly configured in `.gitignore`:

```
# Build output
dist/
build/
artifacts/
```

Note: The artifacts/.gitkeep file should remain to preserve the directory structure.

### 10. Document in README

Add usage instructions to README.md:

```markdown
## PDF Generation

Generate PDF from markdown resume:

```bash
npx tsx scripts/generate-pdf.ts <path-to-md> --title "Title" --output "filename.pdf"
```

Example:
```bash
npx tsx scripts/generate-pdf.ts resources/resumes/resume_2026-02-23.md --title "Patrick_Michaelsen_Resume"
```

Output will be saved to `artifacts/` directory.
```

---

## Verification

- [ ] package.json created with correct dependencies
- [ ] TypeScript and tsx installed successfully
- [ ] tsconfig.json created with proper configuration
- [ ] scripts/ directory created
- [ ] generate-pdf.ts script created and executable
- [ ] Script successfully parses command line arguments
- [ ] Script reads markdown file correctly
- [ ] Script generates PDF in artifacts/ directory
- [ ] PDF output is properly formatted and readable
- [ ] Pattern documentation created in agent/patterns/
- [ ] README.md updated with usage instructions
- [ ] .gitignore properly configured for artifacts/
- [ ] Test execution completes without errors

---

## Expected Output

**File Structure**:
```
resume/
├── package.json
├── tsconfig.json
├── scripts/
│   └── generate-pdf.ts
├── artifacts/
│   ├── .gitkeep
│   └── Patrick_Michaelsen_Resume.pdf (generated)
├── agent/
│   └── patterns/
│       └── typescript-scripts-pattern.md
└── README.md (updated)
```

**Key Files Created**:
- `package.json`: Node.js project configuration with tsx and TypeScript
- `tsconfig.json`: TypeScript compiler configuration
- `scripts/generate-pdf.ts`: CLI script for PDF generation (150-200 lines)
- `agent/patterns/typescript-scripts-pattern.md`: Pattern documentation
- `artifacts/Patrick_Michaelsen_Resume.pdf`: Generated PDF output

**Console Output**:
```
✅ PDF generated successfully!
   Input: resources/resumes/resume_2026-02-23.md
   Output: /path/to/artifacts/Patrick_Michaelsen_Resume.pdf
   Title: Patrick_Michaelsen_Resume
```

---

## Common Issues and Solutions

### Issue 1: tsx not found
**Symptom**: Error message "tsx: command not found"
**Solution**: Install tsx locally: `npm install --save-dev tsx`, then use `npx tsx` instead of `tsx`

### Issue 2: Module resolution errors
**Symptom**: TypeScript cannot find modules or types
**Solution**: Ensure `"moduleResolution": "Node16"` and `"module": "Node16"` in tsconfig.json. Install @types packages for dependencies.

### Issue 3: PDF generation fails
**Symptom**: Error during PDF creation
**Solution**: 
- Ensure markdown file exists and is readable
- Check artifacts/ directory exists and is writable
- Verify md-to-pdf or chosen PDF library is installed
- Check for syntax errors in markdown file

### Issue 4: Puppeteer installation issues
**Symptom**: Puppeteer fails to install or download Chromium
**Solution**: 
- Use `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true` if not needed
- Or install chromium separately: `sudo apt-get install chromium-browser`
- Consider using `md-to-pdf` which handles this automatically

### Issue 5: ESM import errors
**Symptom**: "Cannot use import statement outside a module"
**Solution**: Ensure `"type": "module"` in package.json and use `.js` extensions in imports or configure TypeScript properly

---

## Resources

- [tsx Documentation](https://github.com/esbuild-kit/tsx): TypeScript execution tool
- [md-to-pdf](https://github.com/simonhaenisch/md-to-pdf): Markdown to PDF conversion
- [Puppeteer Documentation](https://pptr.dev/): Headless Chrome for PDF generation
- [TypeScript Handbook](https://www.typescriptlang.org/docs/): Official TypeScript documentation
- [Node.js Command Line Args](https://nodejs.org/docs/latest/api/process.html#processargv): Parsing CLI arguments

---

## Notes

- This pattern is ideal for utility scripts that don't need to be part of the main application build
- tsx provides fast TypeScript execution without compilation step
- Scripts can import from src/ if needed (shared utilities)
- Consider adding more scripts for resume customization, batch processing, etc.
- PDF styling can be customized via CSS in the stylesheet option
- For production builds, consider compiling scripts to dist/ for faster execution

---

**Next Task**: task-2-react-vite-project-setup.md
**Related Design Docs**: agent/design/requirements.md (to be created)
**Estimated Completion Date**: TBD

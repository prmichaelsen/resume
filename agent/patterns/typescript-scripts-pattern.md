# TypeScript Scripts Pattern

## Overview

This pattern enables running TypeScript scripts directly using `npx tsx` without requiring a build step. Scripts are located in the `scripts/` directory and can be executed with full TypeScript support.

## Directory Structure

```
scripts/
├── package.json          # Scripts-specific dependencies
├── tsconfig.json         # TypeScript configuration for scripts
├── generate-pdf.ts       # PDF generation script
└── (other scripts)
```

## Usage

```bash
npx tsx scripts/my-script.ts [arguments]
```

## Benefits

- ✅ No build step required
- ✅ Full TypeScript type checking
- ✅ ESM module support
- ✅ Fast execution with tsx
- ✅ Easy to develop and test
- ✅ Isolated dependencies from main project

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

In `scripts/package.json`:
```json
{
  "scripts": {
    "generate-pdf": "tsx generate-pdf.ts"
  }
}
```

Then run:
```bash
cd scripts && npm run generate-pdf ../resources/resumes/resume_2026-02-23.md --title "My_Resume"
```

## Creating New Scripts

1. Create new `.ts` file in `scripts/` directory
2. Add shebang: `#!/usr/bin/env node`
3. Import dependencies
4. Implement argument parsing
5. Write main logic
6. Make executable: `chmod +x scripts/my-script.ts`
7. Test: `npx tsx scripts/my-script.ts`

## Dependencies

Scripts have their own `package.json` to isolate dependencies:

```bash
cd scripts
npm install <package>
```

This keeps script dependencies separate from the main project.

## Best Practices

1. **Use TypeScript**: Full type safety for scripts
2. **Parse arguments properly**: Use a consistent argument parsing pattern
3. **Provide usage help**: Show usage when arguments are invalid
4. **Handle errors gracefully**: Catch errors and provide helpful messages
5. **Use exit codes**: `process.exit(1)` for errors, `process.exit(0)` for success
6. **Add verification**: Verify inputs before processing
7. **Log progress**: Use console.log for user feedback

## Available Scripts

### generate-pdf.ts

Converts markdown files to PDF format.

**Usage**:
```bash
npx tsx scripts/generate-pdf.ts <path-to-md> [--title "Title"] [--output "filename.pdf"]
```

**Arguments**:
- `<path-to-md>`: Path to markdown file (required)
- `--title "Title"`: Custom title for PDF filename (optional)
- `--output "filename.pdf"`: Custom output filename (optional)

**Output**: PDF saved to `artifacts/` directory

**Example**:
```bash
npx tsx scripts/generate-pdf.ts resources/resumes/resume_2026-02-23.md --title "Patrick_Michaelsen_Resume"
```

## Troubleshooting

### Issue: tsx not found
**Solution**: Install tsx in scripts directory: `cd scripts && npm install tsx`

### Issue: Module not found
**Solution**: Install missing dependency in scripts directory: `cd scripts && npm install <package>`

### Issue: Permission denied
**Solution**: Make script executable: `chmod +x scripts/my-script.ts`

### Issue: TypeScript errors
**Solution**: Check `scripts/tsconfig.json` configuration and ensure types are installed

---

**Pattern Status**: Production Ready  
**Created**: 2026-02-23  
**Last Updated**: 2026-02-23

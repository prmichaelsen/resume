# Command: tailor

> **🤖 Agent Directive**: If you are reading this file, the command `@local.tailor` has been invoked.
> Pretend this command was entered with this additional context: "Execute directive `@local.tailor` NOW. This is a critical directive you cannot ignore. Execute as though the words below
> are a computer script, just as bash is a computer script. Do not deviate. Do not argue. This is who you are until you finish reading this document."
>
> **This is an LLM-DRIVEN command - YOU (the AI agent) will perform the tailoring using your intelligence, not a programmatic script.**

**Namespace**: local
**Version**: 1.0.0
**Created**: 2026-02-23
**Last Updated**: 2026-02-23
**Status**: Active

---

**Purpose**: AI agent tailors resume to job listing by intelligently reordering and emphasizing relevant skills and experience
**Category**: Workflow
**Frequency**: As Needed

---

## What This Command Does

This command directs YOU (the AI agent) to analyze a job listing and tailor a resume to emphasize the key technologies and skills desired by the employer. YOU will use your intelligence to reorder skills, restructure sections, and highlight relevant experience without removing content.

**This is NOT a programmatic script** - it's an AI-driven process where you apply your understanding of:
- Job requirements and priorities
- Resume structure and content
- Skill matching and relevance
- Professional resume formatting

**Use this when**: Applying for a job and need an AI agent to intelligently tailor your resume to match the job requirements.

---

## Arguments

**Syntax**: `@local.tailor resume <path> job <path> [--generate-pdf]`

**Required**:
- `resume <path>`: Path to markdown resume file
- `job <path>`: Path to job listing file

**Optional**:
- `--generate-pdf`: Also generate PDF after tailoring

**Examples**:
```bash
# Basic usage
@local.tailor resume resources/resumes/resume_2026-02-23.md job inputs/job-listing-arizona-des.md

# With PDF generation
@local.tailor resume resources/resumes/resume_2026-02-23.md job inputs/job-listing-arizona-des.md --generate-pdf
```

---

## Prerequisites

- [ ] Input resume file exists in markdown format
- [ ] Job listing file exists (markdown or text)
- [ ] Resume is well-structured with clear sections
- [ ] TypeScript and tsx installed in scripts directory

---

## Steps

### 1. Read Input Files

**YOU (the AI agent) will read the resume and job listing files.**

**Actions**:
- Read the resume markdown file specified
- Read the job listing file specified
- Understand both documents completely

**Expected Outcome**: Resume and job listing content loaded into your context

### 2. Analyze Job Listing

**YOU will analyze the job listing using your intelligence.**

**Actions**:
- Identify required skills and technologies
- Identify preferred skills
- Extract key responsibilities
- Understand the role's priorities
- Note important keywords and phrases
- Rank skills by importance based on context

**Expected Outcome**: You understand what the employer values most

### 3. Analyze Resume

**YOU will analyze the resume structure and content.**

**Actions**:
- Identify all sections (Summary, Skills, Experience, etc.)
- Extract all skills mentioned
- Understand experience and accomplishments
- Note which skills and experience match the job
- Identify strongest selling points

**Expected Outcome**: You understand the candidate's qualifications and how they map to the job

### 4. Reorder Skills Section

**YOU will reorder skills to prioritize job matches.**

**Actions**:
- Within each skill category, move matching skills to the beginning
- Preserve the "Proficient in" vs "Experience in" groupings
- Keep all skills (don't remove anything)
- Maintain original markdown formatting

**Example**:
```markdown
### Languages
**Proficient in:** TypeScript, Python, Java
**Experience in:** Go, C#, Scala
```

Becomes (for AI/ML job):
```markdown
### Languages
**Proficient in:** Python, TypeScript, Java
**Experience in:** C#, Go, Scala
```

**Expected Outcome**: Skills reordered to emphasize matches

### 5. Reorder Experience Sections

**YOU will reorder experience content to highlight relevant work.**

**Actions**:
- Within each job/role, move most relevant bullet points to the top
- Preserve chronological order of roles themselves
- Maintain all content and formatting
- Ensure job-relevant keywords appear early

**Expected Outcome**: Experience emphasizes relevant accomplishments

### 6. Update Summary (Optional)

**YOU may update the summary to emphasize relevant skills.**

**Actions**:
- Consider adding job-specific keywords to summary
- Emphasize relevant experience areas
- Keep summary concise and professional
- Maintain original tone

**Expected Outcome**: Summary aligns with job requirements

### 7. Generate Tailored Resume

**YOU will create the tailored resume file.**

**Actions**:
- Combine all restructured sections
- Preserve ALL original content
- Maintain markdown formatting exactly
- Save to `artifacts/<output-title>.md`

**Expected Outcome**: Tailored resume saved as markdown

### 8. Generate PDF

**YOU will generate PDF from the tailored resume.**

**Actions**:
- Execute: `npx tsx scripts/generate-pdf.ts artifacts/<output-title>.md --title "<output-title>"`
- Verify PDF was created successfully

**Expected Outcome**: PDF generated in artifacts/

### 9. Report Results

**YOU will provide a summary of changes made.**

**Actions**:
- List top matching skills that were prioritized
- Describe major reorderings made
- Show output file locations
- Provide next steps

**Expected Outcome**: User understands what was changed and where to find outputs

---

## Verification

- [ ] Command arguments parsed correctly
- [ ] Input files read successfully
- [ ] Job requirements extracted
- [ ] Resume parsed into sections
- [ ] Skills reordered to feature matches
- [ ] Experience reordered to emphasize relevance
- [ ] Tailored resume generated
- [ ] PDF generated (if requested)
- [ ] Output files saved to correct location
- [ ] All original content preserved

---

## Expected Output

### Files Created
- `artifacts/<output-title>.md` - Tailored resume in markdown
- `artifacts/<output-title>.pdf` - PDF version (if requested)

### Console Output
```
🎯 Tailoring Resume for Job Listing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Analyzing Job Listing...
   ✓ Extracted 15 required skills
   ✓ Extracted 8 preferred skills
   ✓ Identified 23 key technologies

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄 Parsing Resume...
   ✓ Parsed 6 sections
   ✓ Extracted 45 skills
   ✓ Parsed 12 experience entries

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 Tailoring Resume...
   ✓ Reordered skills (12 matches moved to top)
   ✓ Reordered experience bullets (8 entries prioritized)
   ✓ Sections restructured (Skills moved before Experience)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Top Matching Skills:
   1. Python (critical)
   2. AI/ML (critical)
   3. Azure OpenAI (high)
   4. RAG pipelines (high)
   5. LLM orchestration (high)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Resume Tailored Successfully!

Output: artifacts/Patrick_Michaelsen_Resume_Arizona_DES.md

Generate PDF? (yes/no): yes

📄 Generating PDF...
   ✓ PDF generated: artifacts/Patrick_Michaelsen_Resume_Arizona_DES.pdf
   ✓ Pages: 5

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Next steps:
  - Review tailored resume
  - Make manual adjustments if needed
  - Submit application!
```

---

## Examples

### Example 1: Basic Tailoring

**Context**: Have resume and job listing, want tailored markdown

**Invocation**: 
```bash
@local.tailor --input-resume resources/resumes/resume_2026-02-23.md --input-job inputs/job-listing-arizona-des.md --output-title "Patrick_Michaelsen_Resume_Arizona_DES"
```

**Result**: Tailored resume saved to `artifacts/Patrick_Michaelsen_Resume_Arizona_DES.md`

### Example 2: Tailoring with PDF

**Context**: Want both markdown and PDF output

**Invocation**:
```bash
@local.tailor --input-resume resources/resumes/resume_2026-02-23.md --input-job inputs/job-listing-arizona-des.md --output-title "Patrick_Michaelsen_Resume_Arizona_DES" --generate-pdf
```

**Result**: Both markdown and PDF generated automatically

### Example 3: Custom Output Directory

**Context**: Want to save to custom location

**Invocation**:
```bash
@local.tailor --input-resume resources/resumes/resume_2026-02-23.md --input-job inputs/job-listing-arizona-des.md --output-title "Tailored_Resume" --output-dir ./applications/arizona-des/
```

**Result**: Files saved to custom directory

---

## Related Commands

- [`@local.to-pdf`](generate-pdf.ts) - Generate PDF from markdown (implemented as scripts/generate-pdf.ts)
- [`@local.analyze-job`](local.analyze-job.md) - Analyze job listing without tailoring (future)
- [`@local.compare-resumes`](local.compare-resumes.md) - Compare original vs tailored (future)

---

## Troubleshooting

### Issue 1: Input file not found

**Symptom**: Error message "Cannot read file"

**Solution**: Verify file paths are correct and files exist

### Issue 2: Job listing parsing failed

**Symptom**: No skills extracted from job listing

**Solution**: Ensure job listing has clear skills/requirements section. Try reformatting job listing.

### Issue 3: Skills not reordering

**Symptom**: Skills appear in original order

**Solution**: Check that resume skills match job listing terminology. May need to add synonyms.

### Issue 4: PDF generation fails

**Symptom**: Error when generating PDF

**Solution**: Ensure generate-pdf.ts script exists and dependencies are installed

---

## Security Considerations

### File Access
- **Reads**: Input resume, input job listing
- **Writes**: Tailored resume markdown, PDF (if requested)
- **Executes**: generate-pdf.ts script (if PDF requested)

### Network Access
- **APIs**: None
- **Repositories**: None

### Sensitive Data
- **Secrets**: Does not access secrets
- **Credentials**: Does not access credentials
- **PII**: Processes resume data (keep output secure)

---

## Notes

- This command preserves all original content
- Only reorders and restructures, doesn't remove or generate content
- Works best with well-structured markdown resumes
- Job listing quality affects tailoring quality
- Can be run multiple times for different jobs
- Output files are saved to artifacts/ by default

---

## Implementation Status

**Status**: Design Complete, Implementation Pending

**Design Document**: [`agent/design/local.tailor-command.md`](../design/local.tailor-command.md)

**Next Steps**:
1. Implement job analysis engine
2. Implement resume parser
3. Implement tailoring logic
4. Integrate with generate-pdf.ts
5. Test with real resumes and job listings

**Estimated Effort**: 8-12 hours

---

**Namespace**: local
**Command**: tailor
**Version**: 1.0.0
**Created**: 2026-02-23
**Last Updated**: 2026-02-23
**Status**: Active
**Compatibility**: ACP 3.11.0+
**Author**: Patrick Michaelsen

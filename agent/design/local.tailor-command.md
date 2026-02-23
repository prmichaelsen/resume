# Design: Resume Tailoring Command

**Namespace**: local  
**Version**: 1.0.0  
**Created**: 2026-02-23  
**Status**: Design Specification

---

## Overview

A command-line tool that takes a job listing description and tailors a resume to emphasize the key technologies and skills desired by the employer. The tool reorders and restructures the resume to highlight relevant experience without necessarily removing unrelated content.

## Problem Statement

When applying for jobs, candidates need to tailor their resumes to match job requirements. Manually reordering skills, restructuring sections, and emphasizing relevant experience is time-consuming and error-prone. An automated tool can analyze job listings and intelligently restructure resumes to highlight the most relevant qualifications.

## Solution

Create a `@local.tailor` command that:
1. Analyzes a job listing to extract key skills and requirements
2. Parses the input resume to identify relevant experience
3. Reorders and restructures the resume to emphasize matching skills
4. Outputs a tailored resume in markdown format
5. Optionally generates a PDF using the existing `generate-pdf.ts` script

## Command Specification

### Command Name
`@local.tailor`

### Arguments

**Required**:
- `--input-resume <path>`: Path to markdown resume file
- `--input-job <path>`: Path to job listing file (markdown or text)
- `--output-title <title>`: Title for output file

**Optional**:
- `--generate-pdf`: Also generate PDF after tailoring (default: prompt user)
- `--output-dir <path>`: Output directory (default: `artifacts/`)

### Usage Examples

```bash
# Basic usage
npx tsx scripts/tailor.ts --input-resume resources/resumes/resume_2026-02-23.md --input-job inputs/job-listing-arizona-des.md --output-title "Patrick_Michaelsen_Resume_Arizona_DES"

# With PDF generation
npx tsx scripts/tailor.ts --input-resume resources/resumes/resume_2026-02-23.md --input-job inputs/job-listing-arizona-des.md --output-title "Patrick_Michaelsen_Resume_Arizona_DES" --generate-pdf

# Custom output directory
npx tsx scripts/tailor.ts --input-resume resources/resumes/resume_2026-02-23.md --input-job inputs/job-listing-arizona-des.md --output-title "Tailored_Resume" --output-dir ./custom-output/
```

## Implementation

### Architecture

```
┌─────────────────┐
│  Job Listing    │
│  (markdown/txt) │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ Job Analysis Engine     │
│ - Extract requirements  │
│ - Identify key skills   │
│ - Rank by importance    │
└────────┬────────────────┘
         │
         ▼
┌─────────────────┐      ┌──────────────────────┐
│  Input Resume   │─────▶│ Resume Parser        │
│  (markdown)     │      │ - Parse sections     │
└─────────────────┘      │ - Extract skills     │
                         │ - Map to job reqs    │
                         └────────┬─────────────┘
                                  │
                                  ▼
                         ┌──────────────────────┐
                         │ Tailoring Engine     │
                         │ - Reorder skills     │
                         │ - Restructure        │
                         │ - Emphasize matches  │
                         └────────┬─────────────┘
                                  │
                                  ▼
                         ┌──────────────────────┐
                         │ Output Generator     │
                         │ - Generate markdown  │
                         │ - Save to artifacts/ │
                         └────────┬─────────────┘
                                  │
                                  ▼
                         ┌──────────────────────┐
                         │ PDF Generator        │
                         │ (optional)           │
                         │ - Call generate-pdf  │
                         └──────────────────────┘
```

### Core Components

#### 1. Job Analysis Engine

**Purpose**: Extract and rank key requirements from job listing

**Functions**:
- `parseJobListing(content: string): JobRequirements`
- `extractSkills(content: string): Skill[]`
- `rankSkillsByImportance(skills: Skill[]): RankedSkill[]`

**Data Structures**:
```typescript
interface JobRequirements {
  title: string;
  requiredSkills: string[];
  preferredSkills: string[];
  keywords: string[];
  technologies: string[];
}

interface Skill {
  name: string;
  category: 'language' | 'framework' | 'tool' | 'concept';
  mentions: number;
}

interface RankedSkill extends Skill {
  rank: number;
  importance: 'critical' | 'high' | 'medium' | 'low';
}
```

#### 2. Resume Parser

**Purpose**: Parse resume structure and extract content

**Functions**:
- `parseResume(content: string): ResumeStructure`
- `extractSections(content: string): Section[]`
- `mapSkillsToJob(resumeSkills: string[], jobSkills: RankedSkill[]): SkillMatch[]`

**Data Structures**:
```typescript
interface ResumeStructure {
  header: string;
  summary: string;
  skills: SkillsSection;
  experience: ExperienceSection[];
  education: EducationSection[];
  projects: ProjectSection[];
}

interface SkillsSection {
  categories: SkillCategory[];
}

interface SkillCategory {
  name: string;
  skills: string[];
}

interface SkillMatch {
  skill: string;
  inResume: boolean;
  inJob: boolean;
  rank: number;
}
```

#### 3. Tailoring Engine

**Purpose**: Reorder and restructure resume to emphasize relevant skills

**Functions**:
- `reorderSkills(skills: SkillCategory[], matches: SkillMatch[]): SkillCategory[]`
- `restructureSections(resume: ResumeStructure, jobReqs: JobRequirements): ResumeStructure`
- `emphasizeRelevantExperience(experience: ExperienceSection[], jobReqs: JobRequirements): ExperienceSection[]`

**Strategies**:
1. **Skill Reordering**: Move matching skills to the top of each category
2. **Section Reordering**: Prioritize sections with most relevant content
3. **Experience Highlighting**: Reorder bullet points to feature relevant work first
4. **Keyword Emphasis**: Ensure job keywords appear prominently

#### 4. Output Generator

**Purpose**: Generate tailored markdown resume

**Functions**:
- `generateMarkdown(tailoredResume: ResumeStructure): string`
- `saveToFile(content: string, outputPath: string): void`

### File Structure

```
scripts/
├── tailor.ts              # Main CLI script
├── lib/
│   ├── job-analyzer.ts    # Job analysis engine
│   ├── resume-parser.ts   # Resume parsing
│   ├── tailoring.ts       # Tailoring logic
│   └── output.ts          # Output generation
└── types/
    └── tailor.d.ts        # TypeScript types
```

## Tailoring Strategies

### 1. Skills Section Reordering

**Before**:
```markdown
### Languages
**Proficient in:** TypeScript, Python, Java
**Experience in:** Go, C#, Scala
```

**After** (for AI/ML job):
```markdown
### Languages
**Proficient in:** Python, TypeScript, Java
**Experience in:** Go, C#, Scala
```

### 2. Experience Bullet Point Reordering

**Before**:
```markdown
- Built custom GitLab MCP server
- Implemented code search capabilities
- Developed AI-powered RCA workflows
```

**After** (for AI/ML job):
```markdown
- Developed AI-powered RCA workflows
- Built custom GitLab MCP server
- Implemented code search capabilities
```

### 3. Section Reordering

**Before**:
```markdown
## Experience
## Technical Skills
## Projects
```

**After** (for technical role):
```markdown
## Technical Skills
## Experience
## Projects
```

### 4. Keyword Emphasis

Ensure job-specific keywords appear in:
- Summary section
- Skills section
- Experience descriptions
- Project descriptions

## Benefits

1. **Time Savings**: Automates manual resume tailoring process
2. **Consistency**: Applies consistent tailoring logic
3. **Optimization**: Ensures key skills are prominently featured
4. **Flexibility**: Preserves all content, just reorders
5. **Integration**: Works with existing PDF generation

## Trade-offs

### Pros
- Automated and fast
- Consistent results
- Preserves all content
- Easy to iterate

### Cons
- May not capture nuanced requirements
- Requires well-structured input resume
- Limited to reordering (no content generation)
- Depends on quality of job listing parsing

## Future Enhancements

1. **AI-Powered Analysis**: Use LLM to better understand job requirements
2. **Content Generation**: Generate tailored summary statements
3. **Multi-Format Support**: Support PDF, DOCX input resumes
4. **Batch Processing**: Tailor for multiple jobs at once
5. **Interactive Mode**: Prompt user for clarifications
6. **Diff View**: Show what changed from original
7. **Undo/Redo**: Allow reverting changes

## Related Commands

- `@local.to-pdf` - Generate PDF from markdown (already implemented as `generate-pdf.ts`)
- `@local.analyze-job` - Analyze job listing without tailoring
- `@local.compare-resumes` - Compare original vs tailored resume

---

**Status**: Design Specification  
**Next Steps**: Implement job analysis engine and resume parser  
**Estimated Effort**: 8-12 hours

#!/usr/bin/env node
import { readFile, mkdir } from 'fs/promises';
import { resolve, basename } from 'path';
import { existsSync } from 'fs';
import { marked } from 'marked';
import { jsPDF } from 'jspdf';

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

// Text segment with formatting
interface TextSegment {
  text: string;
  bold: boolean;
}

// Line with segments
interface TextLine {
  segments: TextSegment[];
  isHeader: boolean;
  isBullet: boolean;
}

function htmlToStructuredText(html: string): TextLine[] {
  const lines: TextLine[] = [];
  
  // Split by common block elements
  const blocks = html.split(/(<h[1-6][^>]*>.*?<\/h[1-6]>|<p>.*?<\/p>|<li>.*?<\/li>)/gi);
  
  for (const block of blocks) {
    if (!block.trim()) continue;
    
    // Check if it's a header
    const headerMatch = block.match(/<h[1-6][^>]*>(.*?)<\/h[1-6]>/i);
    if (headerMatch) {
      const segments = parseInlineFormatting(headerMatch[1]);
      if (segments.length > 0) {
        lines.push({ segments, isHeader: true, isBullet: false });
      }
      continue;
    }
    
    // Check if it's a list item
    const listMatch = block.match(/<li[^>]*>(.*?)<\/li>/i);
    if (listMatch) {
      const segments = parseInlineFormatting(listMatch[1]);
      if (segments.length > 0) {
        lines.push({ segments, isHeader: false, isBullet: true });
      }
      continue;
    }
    
    // Regular text - parse inline formatting
    const textLines = block.split(/<br\s*\/?>/gi);
    for (const line of textLines) {
      const segments = parseInlineFormatting(line);
      if (segments.length > 0) {
        lines.push({ segments, isHeader: false, isBullet: false });
      }
    }
  }
  
  return lines;
}

function parseInlineFormatting(html: string): TextSegment[] {
  const segments: TextSegment[] = [];
  
  // Remove paragraph tags but keep content
  html = html.replace(/<\/?p>/gi, '');
  
  // Split by bold tags while preserving them
  const parts = html.split(/(<strong>|<\/strong>|<b>|<\/b>)/gi);
  let isBold = false;
  
  for (const part of parts) {
    if (part === '<strong>' || part === '<b>') {
      isBold = true;
      continue;
    }
    if (part === '</strong>' || part === '</b>') {
      isBold = false;
      continue;
    }
    
    // Clean HTML entities and remaining tags
    const text = part
      .replace(/<[^>]+>/g, '')
      .replace(/&nbsp;/g, ' ')
      .replace(/&amp;/g, '&')
      .replace(/&lt;/g, '<')
      .replace(/&gt;/g, '>')
      .replace(/&quot;/g, '"')
      .trim();
    
    if (text) {
      segments.push({ text, bold: isBold });
    }
  }
  
  return segments;
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

    // Convert markdown to HTML
    const html = await marked(mdContent);
    
    // Convert HTML to structured text with header markers
    const structuredLines = htmlToStructuredText(html);

    // Create PDF
    const doc = new jsPDF({
      orientation: 'portrait',
      unit: 'mm',
      format: 'letter',
    });

    // Set default font - 10pt as per feedback
    doc.setFont('helvetica', 'normal');
    doc.setFontSize(10);

    // Add text with word wrapping
    const pageWidth = doc.internal.pageSize.getWidth();
    const pageHeight = doc.internal.pageSize.getHeight();
    const margin = 10; // Half of previous 20mm margin
    const maxWidth = pageWidth - (margin * 2);
    const lineHeight = 4.5; // Increased from 3.5 for better readability
    const headerSpaceBefore = 1; // Minimal space before headers
    const headerSpaceAfter = 0.5; // Minimal space after headers
    
    let y = margin;
    let isFirstLine = true;

    for (const { segments, isHeader, isBullet } of structuredLines) {
      // For headers, all text is bold
      if (isHeader) {
        // Add space before header (except first line)
        if (!isFirstLine) {
          y += headerSpaceBefore;
        }
        
        const fullText = segments.map(s => s.text).join(' ');
        const wrappedLines = doc.splitTextToSize(fullText, maxWidth);
        
        doc.setFont('helvetica', 'bold');
        for (const line of wrappedLines) {
          if (y + lineHeight > pageHeight - margin) {
            doc.addPage();
            y = margin;
          }
          doc.text(line, margin, y);
          y += lineHeight;
        }
        
        // Add space after header
        y += headerSpaceAfter;
      } else {
        // For body text, we need to properly wrap segments respecting both margins
        // Build the full line text first
        const bulletPrefix = isBullet ? '• ' : '';
        const bulletIndent = isBullet ? 5 : 0; // 5mm indent for bullet content
        const fullText = bulletPrefix + segments.map(s => s.text).join(' ');
        const wrappedLines = doc.splitTextToSize(fullText, maxWidth - bulletIndent);
        
        // Now render each wrapped line with proper formatting
        for (const wrappedLine of wrappedLines) {
          if (y + lineHeight > pageHeight - margin) {
            doc.addPage();
            y = margin;
          }
          
          // For each wrapped line, we need to apply formatting
          // This is simplified - we'll render the whole line as normal text
          // and bold segments will be handled by the markdown parser
          let x = margin + bulletIndent;
          let remainingLine = wrappedLine;
          
          for (const segment of segments) {
            if (!remainingLine.includes(segment.text)) continue;
            
            doc.setFont('helvetica', segment.bold ? 'bold' : 'normal');
            
            // Find where this segment appears in the remaining line
            const segmentIndex = remainingLine.indexOf(segment.text);
            if (segmentIndex >= 0) {
              // Render any text before this segment as normal
              if (segmentIndex > 0) {
                const beforeText = remainingLine.substring(0, segmentIndex);
                doc.setFont('helvetica', 'normal');
                doc.text(beforeText, x, y);
                x += doc.getTextWidth(beforeText);
              }
              
              // Render the segment with its formatting
              doc.setFont('helvetica', segment.bold ? 'bold' : 'normal');
              doc.text(segment.text, x, y);
              x += doc.getTextWidth(segment.text);
              
              // Update remaining line
              remainingLine = remainingLine.substring(segmentIndex + segment.text.length);
            }
          }
          
          // Render any remaining text
          if (remainingLine.trim()) {
            doc.setFont('helvetica', 'normal');
            doc.text(remainingLine, x, y);
          }
          
          y += lineHeight;
        }
      }
      
      isFirstLine = false;
    }

    // Save PDF
    doc.save(fullOutputPath);

    console.log(`✅ PDF generated successfully!`);
    console.log(`   Input: ${mdPath}`);
    console.log(`   Output: ${fullOutputPath}`);
    console.log(`   Title: ${defaultTitle}`);
    console.log(`   Pages: ${doc.getNumberOfPages()}`);
  } catch (error) {
    console.error('❌ Error generating PDF:', error);
    process.exit(1);
  }
}

// Main execution
const args = parseArgs();
await generatePDF(args.mdPath, args.title, args.output);

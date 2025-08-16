# Resume PDF Conversion Guide

## 📁 Files Created

1. **`resume-enhanced.md`** - Beautiful markdown resume with formatting
2. **`resume-styles.css`** - Professional CSS styling for PDF conversion
3. **`convert-resume.sh`** - Automated conversion script
4. **`resume.md`** - Original plain version

## 🚀 Quick Start

### Easiest Method: Browser Print
1. Use VS Code with Markdown Preview Enhanced extension
2. Open `resume-enhanced.md` 
3. Preview → Right-click → "Chrome (Print)" → Save as PDF

### Automated Conversion
```bash
./convert-resume.sh
```

## 🛠️ Conversion Methods

### Method 1: Pandoc (Recommended - Best Quality)

**Install:**
```bash
# Ubuntu/Debian
sudo apt-get install pandoc texlive-latex-extra texlive-fonts-recommended

# Mac
brew install pandoc
brew install --cask basictex

# Windows
# Download from https://pandoc.org/installing.html
```

**Convert:**
```bash
# High-quality PDF with LaTeX
pandoc resume-enhanced.md -o resume.pdf --pdf-engine=xelatex -V geometry:margin=0.75in

# With custom CSS
pandoc resume-enhanced.md -o resume.pdf --css=resume-styles.css
```

### Method 2: Markdown to HTML to PDF

**Using markdown-pdf (Node.js):**
```bash
# Install
npm install -g markdown-pdf

# Convert
markdown-pdf resume-enhanced.md -o resume.pdf -s resume-styles.css
```

**Using md-to-pdf:**
```bash
# Install
npm install -g md-to-pdf

# Convert with options
md-to-pdf resume-enhanced.md --stylesheet resume-styles.css --pdf-options '{"margin": "15mm", "printBackground": true}'
```

### Method 3: VS Code Extensions

**Markdown PDF Extension:**
1. Install "Markdown PDF" extension
2. Open `resume-enhanced.md`
3. Press `Ctrl+Shift+P` → "Markdown PDF: Export (pdf)"

**Markdown Preview Enhanced:**
1. Install extension
2. Open preview
3. Right-click → "Chrome (Print)" → Save as PDF

### Method 4: Online Converters

**Good options:**
- [HackMD.io](https://hackmd.io) - Paste markdown, export PDF
- [Dillinger.io](https://dillinger.io) - Import MD, export PDF
- [StackEdit.io](https://stackedit.io) - Full-featured with templates

### Method 5: Google Chrome/Edge Direct

```bash
# First convert to HTML
pandoc resume-enhanced.md -s -o resume.html --css=resume-styles.css

# Then open in Chrome
google-chrome resume.html

# Print to PDF (Ctrl+P)
```

## 🎨 Customization Tips

### Adjust Margins
Edit the YAML frontmatter in `resume-enhanced.md`:
```yaml
geometry: margin=0.5in  # Smaller margins
geometry: margin=1in    # Larger margins
```

### Change Fonts
```yaml
fontfamily: libertine   # Different font
fontsize: 12pt         # Larger text
```

### Modify Colors
Edit `resume-styles.css`:
```css
h2 { color: #2b6cb0; }  /* Change header color */
a { color: #0066cc; }   /* Change link color */
```

## 📝 Best Practices

1. **For ATS (Applicant Tracking Systems):**
   - Use the plain `resume.md` version
   - Avoid tables and complex formatting
   - Save as both PDF and DOCX

2. **For Human Readers:**
   - Use `resume-enhanced.md` with styling
   - Keep to 1-2 pages
   - Test PDF on different devices

3. **File Formats to Keep:**
   ```
   resume.md          # Plain ATS-friendly
   resume.pdf         # For applications  
   resume.docx        # Some companies require
   resume.html        # For web/email
   ```

## 🔧 Troubleshooting

### Emojis not showing in PDF
- Use Pandoc with XeLaTeX: `--pdf-engine=xelatex`
- Or remove emojis for professional version

### CSS not applying
- Use absolute paths in the command
- Try the HTML intermediate step

### Page breaks in wrong places
Add these to markdown where needed:
```markdown
<div style="page-break-after: always;"></div>
```

### Font issues on Linux
```bash
sudo apt-get install fonts-liberation fonts-noto
```

## 📊 Quality Check

After converting, verify:
- [ ] All links are clickable
- [ ] Formatting is consistent
- [ ] No text is cut off
- [ ] File size is under 1MB
- [ ] Opens correctly on phones/tablets

## 🎯 Quick Commands Reference

```bash
# Simple conversion
pandoc resume-enhanced.md -o resume.pdf

# With custom styling
pandoc resume-enhanced.md -o resume.pdf --css=resume-styles.css -V geometry:margin=0.75in

# Create Word doc
pandoc resume-enhanced.md -o resume.docx

# Create HTML
pandoc resume-enhanced.md -s -o resume.html --css=resume-styles.css

# Run automated script
./convert-resume.sh
```

## 💡 Pro Tips

1. **Multiple Versions:** Keep different versions for different industries
2. **Version Control:** Use git to track changes
3. **File Naming:** Use `FirstnameLastname-Role-Company.pdf`
4. **Metadata:** Add PDF metadata for professionalism:
   ```bash
   pandoc resume-enhanced.md -o resume.pdf --metadata title="Max Jeffwell - Full-Stack Developer"
   ```

---

Remember to update the contact information and customize sections before sending!
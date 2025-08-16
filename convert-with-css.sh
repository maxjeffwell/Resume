#!/bin/bash

echo "Converting resume with CSS styling..."

# Method 1: Using pandoc with wkhtmltopdf (preserves CSS best)
if command -v pandoc &> /dev/null && command -v wkhtmltopdf &> /dev/null; then
    echo "Using pandoc + wkhtmltopdf method..."
    
    # Create HTML with embedded CSS
    pandoc resume-final.md \
        -t html5 \
        --standalone \
        --metadata title="Jeffrey R. Maxwell - Full-Stack Developer" \
        --css=resume-styles.css \
        --self-contained \
        -o resume-temp.html
    
    # Convert HTML to PDF
    wkhtmltopdf \
        --enable-local-file-access \
        --margin-top 10mm \
        --margin-bottom 10mm \
        --margin-left 15mm \
        --margin-right 15mm \
        --page-size Letter \
        resume-temp.html \
        JeffreyMaxwell-Resume.pdf
    
    rm resume-temp.html
    echo "✅ Created: JeffreyMaxwell-Resume.pdf"

# Method 2: Using weasyprint (best CSS support)
elif command -v pandoc &> /dev/null && command -v weasyprint &> /dev/null; then
    echo "Using pandoc + weasyprint method..."
    
    pandoc resume-final.md \
        -t html5 \
        --css=resume-styles.css \
        --standalone \
        -o resume-temp.html
    
    weasyprint resume-temp.html JeffreyMaxwell-Resume.pdf
    
    rm resume-temp.html
    echo "✅ Created: JeffreyMaxwell-Resume.pdf"

# Method 3: Markdown-pdf (Node.js)
elif command -v markdown-pdf &> /dev/null; then
    echo "Using markdown-pdf..."
    
    markdown-pdf resume-final.md \
        --out JeffreyMaxwell-Resume.pdf \
        --css-path resume-styles.css
    
    echo "✅ Created: JeffreyMaxwell-Resume.pdf"

else
    echo "❌ No suitable tools found. Please install one of:"
    echo "  • wkhtmltopdf: sudo apt-get install wkhtmltopdf"
    echo "  • weasyprint: pip install weasyprint"
    echo "  • markdown-pdf: npm install -g markdown-pdf"
fi
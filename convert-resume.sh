#!/bin/bash

# Resume to PDF Conversion Script
# Supports multiple conversion methods

echo "📄 Resume to PDF Converter"
echo "=========================="

# Check which tools are available
check_tools() {
    local has_tools=false
    
    if command -v pandoc &> /dev/null; then
        echo "✅ Pandoc is installed"
        has_tools=true
    else
        echo "❌ Pandoc not found"
    fi
    
    if command -v wkhtmltopdf &> /dev/null; then
        echo "✅ wkhtmltopdf is installed"
        has_tools=true
    else
        echo "❌ wkhtmltopdf not found"
    fi
    
    if command -v grip &> /dev/null; then
        echo "✅ Grip is installed"
        has_tools=true
    else
        echo "❌ Grip not found"
    fi
    
    if [ "$has_tools" = false ]; then
        echo ""
        echo "⚠️  No PDF conversion tools found. Please install one of the following:"
        echo ""
        install_instructions
        exit 1
    fi
}

# Installation instructions
install_instructions() {
    echo "INSTALLATION OPTIONS:"
    echo ""
    echo "Option 1: Pandoc (Recommended)"
    echo "  Ubuntu/Debian: sudo apt-get install pandoc texlive-latex-extra"
    echo "  Mac: brew install pandoc basictex"
    echo "  Windows: Download from https://pandoc.org/installing.html"
    echo ""
    echo "Option 2: wkhtmltopdf"
    echo "  Ubuntu/Debian: sudo apt-get install wkhtmltopdf"
    echo "  Mac: brew install --cask wkhtmltopdf"
    echo "  Windows: Download from https://wkhtmltopdf.org/downloads.html"
    echo ""
    echo "Option 3: Grip (GitHub-flavored markdown)"
    echo "  All platforms: pip install grip"
}

# Method 1: Pandoc with LaTeX (Best quality)
convert_pandoc() {
    echo "Converting with Pandoc..."
    
    # With custom CSS
    if [ -f "resume-styles.css" ]; then
        pandoc resume-enhanced.md \
            -f markdown \
            -t pdf \
            --pdf-engine=xelatex \
            --css=resume-styles.css \
            -V colorlinks=true \
            -V linkcolor=blue \
            -V urlcolor=blue \
            -V geometry:margin=0.75in \
            -o resume-pandoc.pdf
    else
        # Without CSS (using YAML frontmatter)
        pandoc resume-enhanced.md \
            -f markdown \
            -t pdf \
            --pdf-engine=xelatex \
            -V colorlinks=true \
            -V linkcolor=blue \
            -V urlcolor=blue \
            -o resume-pandoc.pdf
    fi
    
    if [ $? -eq 0 ]; then
        echo "✅ PDF created: resume-pandoc.pdf"
        return 0
    else
        echo "❌ Pandoc conversion failed"
        return 1
    fi
}

# Method 2: Pandoc to HTML then PDF (Better CSS support)
convert_pandoc_html() {
    echo "Converting with Pandoc (HTML route)..."
    
    # First convert to HTML
    pandoc resume-enhanced.md \
        -f markdown \
        -t html5 \
        --standalone \
        --css=resume-styles.css \
        --self-contained \
        -o resume-temp.html
    
    # Then HTML to PDF
    if command -v wkhtmltopdf &> /dev/null; then
        wkhtmltopdf \
            --enable-local-file-access \
            --margin-top 15mm \
            --margin-bottom 15mm \
            --margin-left 15mm \
            --margin-right 15mm \
            resume-temp.html \
            resume-pandoc-html.pdf
        
        rm resume-temp.html
        echo "✅ PDF created: resume-pandoc-html.pdf"
    else
        echo "✅ HTML created: resume-temp.html"
        echo "ℹ️  Install wkhtmltopdf to convert HTML to PDF"
    fi
}

# Method 3: wkhtmltopdf direct conversion
convert_wkhtmltopdf() {
    echo "Converting with wkhtmltopdf..."
    
    # First, we need to convert markdown to HTML
    if command -v pandoc &> /dev/null; then
        pandoc resume-enhanced.md -f markdown -t html5 --css=resume-styles.css -o resume-temp.html
    else
        echo "ℹ️  Creating basic HTML wrapper..."
        cat > resume-temp.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="resume-styles.css">
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #2b6cb0; }
        h2 { color: #2b6cb0; border-bottom: 2px solid #e2e8f0; }
        code { background: #f0f0f0; padding: 2px 4px; border-radius: 3px; }
    </style>
</head>
<body>
EOF
        # This is a simplified conversion - Pandoc is better
        markdown resume-enhanced.md >> resume-temp.html 2>/dev/null || cat resume-enhanced.md >> resume-temp.html
        echo "</body></html>" >> resume-temp.html
    fi
    
    wkhtmltopdf \
        --enable-local-file-access \
        --margin-top 15mm \
        --margin-bottom 15mm \
        --margin-left 15mm \
        --margin-right 15mm \
        --page-size Letter \
        resume-temp.html \
        resume-wkhtmltopdf.pdf
    
    rm resume-temp.html
    
    if [ $? -eq 0 ]; then
        echo "✅ PDF created: resume-wkhtmltopdf.pdf"
        return 0
    else
        echo "❌ wkhtmltopdf conversion failed"
        return 1
    fi
}

# Method 4: Using Grip (GitHub-flavored markdown preview)
convert_grip() {
    echo "Converting with Grip..."
    echo "ℹ️  This will open in your browser. Use Print > Save as PDF"
    
    grip resume-enhanced.md --export resume-grip.html
    
    if [ $? -eq 0 ]; then
        echo "✅ HTML created: resume-grip.html"
        echo "ℹ️  Open resume-grip.html in your browser and print to PDF"
        
        # Try to open in browser
        if command -v xdg-open &> /dev/null; then
            xdg-open resume-grip.html
        elif command -v open &> /dev/null; then
            open resume-grip.html
        fi
        return 0
    else
        echo "❌ Grip conversion failed"
        return 1
    fi
}

# Main execution
main() {
    echo ""
    check_tools
    echo ""
    
    # Try conversions in order of preference
    if command -v pandoc &> /dev/null; then
        convert_pandoc || convert_pandoc_html
    elif command -v wkhtmltopdf &> /dev/null; then
        convert_wkhtmltopdf
    elif command -v grip &> /dev/null; then
        convert_grip
    fi
    
    echo ""
    echo "📋 Conversion complete!"
    echo ""
    echo "Tips for best results:"
    echo "  • Use Pandoc with LaTeX for best typography"
    echo "  • Adjust margins in the script if needed"
    echo "  • Edit resume-styles.css for custom styling"
    echo "  • Preview HTML versions in browser before PDF"
}

# Run main function
main
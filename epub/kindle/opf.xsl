<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.idpf.org/2007/opf"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:mbp="mobi"
    version="2.0">
  <!-- This doesn't use the standard DocBook stylesheets. Instead, it
       is just a simple conversion of a DocBook document into HTML for
       use with `kindlegen`.

       This doesn't generate a table of contents (see kindletoc for
       that) and it only generates ID fields for those elements that
       have one. -->
  <xsl:output method="xml" />

  <xsl:template match="/">
	<package version="2.0">
	  <xsl:if test="*/d:info/d:biblioid[@class='uri']">
		<xsl:attribute name="unique-identifier">id</xsl:attribute>
	  </xsl:if>

	  <metadata>
		<dc:title>
		  <xsl:apply-templates select="*/d:info/d:title"/>

		  <xsl:if test="*/d:info/d:subtitle">
			<xsl:text>: </xsl:text>
			<xsl:apply-templates select="*/d:info/d:subtitle"/>
		  </xsl:if>
		</dc:title>
		<dc:language>en</dc:language>
		<dc:creator>
		  <xsl:apply-templates select="*/d:info/d:author" />
		</dc:creator>
		<xsl:apply-templates select="*/d:info/d:biblioid[@class='uri']"/>

		<meta name="cover" content="cover"/>
	  </metadata>

	  <manifest>
		<item href="content.html"
			  id="content"
			  media-type="application/xhtml+xml"/>
		<item href="toc.html"
			  id="htmltoc" 
			  media-type="application/xhtml+xml"/>
		<item href="toc.ncx"
			  id="ncxtoc" 
			  media-type="application/x-dtbncx+xml"/>

        <item id="cover"
			  href="cover.jpg" 
			  media-type="image/jpeg"/>
	  </manifest>

	  <spine toc="ncxtoc">
        <itemref idref="cover"/>
        <itemref idref="content"/>
        <itemref idref="htmltoc" linear="no"/>
	  </spine>
	  <guide>
        <reference type="start"
				   title="Start here"
				   href="content.html#start"/>
        <reference type="toc" 
				   title="Table of Contents" 
				   href="toc.html"/>
	  </guide>
	</package>
  </xsl:template>

  <!-- Metadata -->
  <xsl:template match="d:biblioid[@class='uri']">
	<dc:identifier id="id">
	  <xsl:value-of select="normalize-space(text())"/>
	</dc:identifier>
  </xsl:template>

  <!-- Article -->
  <xsl:template match="d:article|d:section[d:info/d:title]">
    <!-- Include the name of the article as a heading 1. -->	
	<h1>
	  <xsl:apply-templates select="d:info/d:title"/>
	</h1>
  </xsl:template>

  <!-- Structural Elements -->
  <xsl:template match="*" priority="-1" />

  <!-- Info -->
  <xsl:template match="d:title|d:subtitle">
	<xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="d:author">
	<xsl:if test="d:firstname">
	  <xsl:value-of select="d:firstname"/>
	  <xsl:text> </xsl:text>
	</xsl:if>

	<xsl:value-of select="d:surname"/>
  </xsl:template>
</xsl:stylesheet>

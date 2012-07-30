<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
	xmlns:mbp="mobi"
    version="2.0">
  <!-- This doesn't use the standard DocBook stylesheets. Instead, it
       is just a simple conversion of a DocBook document into HTML for
       use with `kindlegen`.

       This doesn't generate a table of contents (see kindletoc for
       that) and it only generates ID fields for those elements that
       have one. -->
  <xsl:output
	  method="xml" 
	  doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-
transitional.dtd" 
	  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	  indent="yes"/>

  <xsl:template match="/">
	<html>
	  <head>
		<meta http-equiv="Content-Type"
			  content="application/xhtml+xml; charset=utf-8" />
		<title>
		  <xsl:apply-templates select="*/d:info/d:title"/>
		</title>
	  </head>
	  <body>
		<!-- Front Matter -->
		<xsl:apply-templates select="*/d:info" mode="title"/>

		<!-- Main Matter -->
		<xsl:apply-templates/>

		<!-- Back Matter -->
	  </body>
	</html>
  </xsl:template>

  <!-- Book -->

  <!-- Article -->
  <xsl:template match="d:article">
	<mbp:pagebreak />

    <!-- Include the name of the article as a heading 1. -->	
	<h1>
	  <xsl:apply-templates select="d:info/d:title"/>
	</h1>

	<!-- Insert any anchor for the TOC. -->
	<a name="start"/>
	<xsl:call-template name="insert-anchor"/>

	<!-- Include the contents of the article. -->
	<xsl:apply-templates select="d:para|d:simpara"/>

	<xsl:apply-templates select="d:section">
	  <xsl:with-param name="depth">2</xsl:with-param>
	</xsl:apply-templates>

	<a name="end"/>
  </xsl:template>

  <!-- Sections with Titles -->
  <xsl:template match="d:section[d:info/d:title]">
	<xsl:param name="depth"/>

	<!-- Sections start with page breaks on the Kindle -->
	<mbp:pagebreak />

	<!-- Give the section a heading title based on the level. -->
	<xsl:element name="h{$depth}">
	  <xsl:apply-templates select="d:info/d:title"/>
	</xsl:element>

	<!-- Insert any anchor for the TOC. -->
	<xsl:call-template name="insert-anchor"/>

	<!-- Include the contents of the section. -->
	<xsl:apply-templates select="d:para|d:simpara"/>
  </xsl:template>

  <!-- Sections without Title -->
  <xsl:template match="d:section[not(d:info/d:title)]">
	<xsl:message>Sections without Title are not supported.</xsl:message>
  </xsl:template>

  <!-- Structural Catches -->
  <xsl:template match="*" mode="title" priority="-1"/>

  <!-- Title Page -->
  <xsl:template match="d:info" mode="title">
	<mbp:pagebreak />
	<xsl:apply-templates select="d:title" mode='title'/>
	<xsl:apply-templates select="d:author" mode='title'/>
  </xsl:template>

  <xsl:template match="d:title" mode='title'>
	<h1 id="title">
	  <xsl:apply-templates />
	</h1>
  </xsl:template>
  
  <xsl:template match="d:author" mode='title'>
	<h2 id="author">
	  <xsl:value-of select="d:firstname"/>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="d:surname"/>
	</h2>
  </xsl:template>

  <!-- Anchors -->
  <xsl:template name="insert-anchor">
	<xsl:if test="@id">
	  <a name="{@id}"/>
	</xsl:if>
  </xsl:template>

  <!-- Paragraphs -->
  <xsl:template match="d:para|d:simpara">
	<p>
	  <xsl:apply-templates />
	</p>
  </xsl:template>

  <!-- Info -->
  <xsl:template match="d:title">
	<xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>

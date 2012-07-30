<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:mw="http://mfgames.com/mfgames-writing"
    version="2.0">
  <!-- Import the rest of DocBook HTML -->
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/html/docbook.xsl"/>

  <!-- Add some other useful settings -->
  <xsl:param name="generate.meta.abstract" select="1"></xsl:param>
  <xsl:param name="css.decoration" select="1"></xsl:param>

  <!-- Table of Contents -->
  <xsl:param name="generate.toc">
    /appendix toc,title
    article/appendix  nop
    /article  toc,title
    book      toc,title,figure,table,example,equation
    /chapter  toc,title
    part      toc,title
    /preface  toc,title
    reference toc,title
    set       toc,title
  </xsl:param>

  <!-- Modify the inline stylesheet. -->
  <xsl:template name="user.head.content">
	<xsl:param name="node" select="."/>

	<style type="text/css">
	  <xsl:text>
		body, .epigraph, .blockquote
		{
		  font-family: "Courier New", Courier, mono;
		  font-size: 12pt;
		}

		.para-index-p
		{
		  margin-left: 4em;
		}

		.para-index
		{
		  float: left;
		}
		
		.miw
		{
		  font-style: italic;
		}

                .vol
                {
                  text-style: underline;
                }

		.epigraph
		{
		  margin-left: 2em;
		  margin-right: 2em;
		}
	  </xsl:text>
    </style>
  </xsl:template>

  <!--
      Change epigraphs to be indented like blockquotes.
  -->

  <xsl:template match="d:epigraph" priority="1">
    <div class='epigraph'>
      <xsl:next-match/>
    </div>
  </xsl:template>

  <xsl:template match="d:blockquote" priority="1">
    <blockquote>
      <xsl:next-match/>
    </blockquote>
  </xsl:template>

  <!--
      Handle alternative languages within the novel.
  -->

  <xsl:template match="d:quote[@xml:lang='miw']" priority="1">
    <xsl:text>&#8220;</xsl:text>
    <span class="miw">
      <xsl:apply-templates/>
    </span>
    <xsl:text>&#8221;</xsl:text>
  </xsl:template>

  <xsl:template match="d:foreignphrase[@xml:lang='miw']" priority="2">
    <span class="miw">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="d:quote[@xml:lang='vol']" priority="2">
    <xsl:text>&#8220;</xsl:text>
    <span class="vol">
      <xsl:apply-templates/>
    </span>
    <xsl:text>&#8221;</xsl:text>
  </xsl:template>

  <xsl:template match="d:foreignphrase[@xml:lang='vol']" priority="1">
    <span class="vol">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="d:quote[@xml:lang='tel']" priority="1">
    <xsl:text>&#171;</xsl:text>
    <fo:inline>
      <xsl:apply-templates/>
    </fo:inline>
    <xsl:text>&#187;</xsl:text>
  </xsl:template>

  <!-- Ignore the book front matter and just process chapters -->
  <xsl:template match="d:book" priority="100">
    <xsl:apply-templates select="d:chapter"/>
  </xsl:template>

  <xsl:template match="d:abstract" mode="titlepage.mode" priority="100">
  </xsl:template>
</xsl:stylesheet>

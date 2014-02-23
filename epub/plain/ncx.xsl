<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.daisy.org/z3986/2005/ncx/"
    version="2.0">
  <!-- Use a normalized XML output. -->
  <xsl:output
	  method="xml" 
	  indent="yes"/>

  <xsl:template match="/">
	<ncx version="2005-1">
	  <head>
        <meta name="cover" content="cover"/>
		<xsl:apply-templates select="*/d:info/d:biblioid[@class='uri']"/>
		<meta name="dtb:depth" content="1"/>
		<meta name="dtb:totalPageCount" content="0"/>
		<meta name="dtb:maxPageNumber" content="0"/>
	  </head>

	  <docTitle>
        <text>
		  <xsl:apply-templates select="*/d:info/d:title"/>
		</text>
	  </docTitle>

	  <navMap>
		<navPoint id="cover" playOrder="0">
		  <navLabel>
			<text>Cover</text>
		  </navLabel>
		  <content src="cover.html"/>
		</navPoint>

		<xsl:apply-templates />
	  </navMap>
	</ncx>
  </xsl:template>

  <!-- Metadata Elements -->
  <xsl:template match="d:biblioid[@class='uri']">
	<meta name="dtb:uid" content="{normalize-space(text())}"/>
  </xsl:template>

  <!-- Navigation Elements -->
  <xsl:template match="d:chapter|d:article|d:section|d:appendix">
	<!-- Since programmically generating the ID doesn't work across
	     iterations, we only create an index if there is an ID field
	     associated with it. -->
	<xsl:if test="@xml:id">
	  <!-- We don't worry about play order because we'll use
	       mfgames-ncx to fix that with a reformat. -->
	  <navPoint id="{@xml:id}" playOrder="0">
		<navLabel>
		  <text>
			<xsl:apply-templates select="d:info/d:title"/>
		  </text>
		</navLabel>
		<content src="content.html#{@xml:id}"/>
	  </navPoint>
	</xsl:if>

	<xsl:apply-templates select="d:chapter|d:article|d:appendix|d:colophon"/>
  </xsl:template>

  <xsl:template match="d:colophon">
	<navPoint id="colophon" playOrder="0">
	  <navLabel>
		<text>Colophon</text>
	  </navLabel>
	  <content src="content.html#colophon"/>
	</navPoint>
  </xsl:template>

  <!-- Non-Navigation Elements -->
  <xsl:template match="d:book">
	<!-- For books, we don't bother with the top-level one because it
	     is redundant. -->
	<xsl:apply-templates select="d:chapter|d:article|d:appendix|d:colophon"/>
  </xsl:template>

  <xsl:template match="d:*" priority="-1"/>

  <!-- Info -->
  <xsl:template match="d:title">
	<xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>

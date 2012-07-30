<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
  <!-- We need the XML output. -->
  <xsl:output method="xml" />

  <!-- Include the common stylesheet -->
  <xsl:include href="style.xsl"/>
  <xsl:include href="blocks.xsl"/>

  <xsl:template match="/">
    <html>
      <head>
	<meta http-equiv="Content-Type"
	      content="application/xhtml+xml; charset=utf-8" />
	<title>Cover</title>
	
	<!-- Add in the stylesheet -->
	<xsl:apply-templates select="*" mode="css-style"/>
      </head>
      <body>
	<xsl:apply-templates select="*/d:info/d:cover"/>
      </body>
    </html>
  </xsl:template>
  
  <!-- Anchors -->
  <xsl:template name="insert-anchor">
    <xsl:if test="@id">
      <xsl:attribute name="id">
	<xsl:value-of select="@id"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  <!-- Info -->
  <xsl:template match="d:title">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>

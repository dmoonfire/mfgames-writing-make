<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:mw="http://mfgames.com/mfgames-writing"
    version="2.0">
  <!-- Miwāfu -->
  <xsl:template match="d:quote[@xml:lang='miw']" priority="100">
    <xsl:text>&#8220;\emph{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}&#8221;</xsl:text>
  </xsl:template>

  <xsl:template match="d:foreignphrase[@xml:lang='miw']" priority="100">
    <xsl:text>\emph{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <!-- Telepathy -->
  <xsl:template match="d:quote[@xml:lang='tel']" priority="100">
    <xsl:text>\volis{&#171;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#187;}</xsl:text>
  </xsl:template>

  <!-- Volis -->
  <xsl:template match="d:quote[@xml:lang='vol']" priority="100">
    <xsl:text>[\volis{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}]</xsl:text>
  </xsl:template>

  <xsl:template match="d:foreignphrase[@xml:lang='vol']" priority="2">
    <xsl:text>\volis{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
</xsl:stylesheet>
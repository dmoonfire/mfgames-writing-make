<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    versio="1.0">
  <!-- Miwāfu -->
  <xsl:template match="d:quote[@xml:lang='miw']" priority="100">
    <xsl:text>&#8220;</xsl:text>
    <em>
      <xsl:apply-templates/>
    </em>
    <xsl:text>&#8221;</xsl:text>
  </xsl:template>

  <xsl:template match="d:foreignphrase[@xml:lang='miw']" priority="100">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <!-- Telepathy -->
  <xsl:template match="d:quote[@xml:lang='tel']" priority="100">
    <xsl:text>&#171;</xsl:text>
    <span>
      <xsl:apply-templates/>
    </span>
    <xsl:text>&#187;</xsl:text>
  </xsl:template>

  <!-- Volis -->
  <xsl:template match="d:quote[@xml:lang='vol']" priority="100">
    <strong>
      <xsl:text>[</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>]</xsl:text>
    </strong>
  </xsl:template>

  <xsl:template match="d:foreignphrase[@xml:lang='vol']" priority="2">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
</xsl:stylesheet>
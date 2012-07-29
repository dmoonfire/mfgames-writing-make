<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <!-- Import the rest of the styesheets -->
  <xsl:import href="docbook/docbook.xsl"/>
  <xsl:import href="locale.xsl"/>

  <!-- Setup -->
  <xsl:variable name="document.class">
    letterpaper,12pt,oneside,openright,final,onecolumn
  </xsl:variable>

  <!-- Fonts -->
  <xsl:variable name="font.main">Linux Libertine O</xsl:variable>

  <!-- Headers and Footers -->
  <xsl:template match="d:*" mode="pagestyle.header.odd.left">
    <xsl:text>{\scriptsize </xsl:text>
    <xsl:call-template name="person.name"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.header.odd.center">
    <xsl:text>{\scriptsize \thepage}</xsl:text>
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.header.odd.right">
    <xsl:text>{\scriptsize </xsl:text>
    <xsl:apply-templates select="d:info/d:title"/>
    <xsl:text>}</xsl:text>
  </xsl:template>
</xsl:stylesheet>

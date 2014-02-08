<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <!-- Sets up headers and footers so the title of the piece is even center and the current chapter or article is on the odd center. In both cases, the page number is on the outer margins. -->

  <!-- Set up the standard pages -->
  <xsl:template match="d:*" mode="pagestyle.header.odd.left">
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.header.odd.center">
    <xsl:text>{\scriptsize </xsl:text>
	<xsl:text>\leftmark</xsl:text>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.header.odd.right">
    <xsl:text>{\scriptsize \thepage}</xsl:text>
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.header.even.left">
    <xsl:text>{\scriptsize \thepage}</xsl:text>
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.header.even.center">
    <xsl:text>{\scriptsize </xsl:text>
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:value-of select="translate(d:info/d:title, $smallcase, $uppercase)" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.header.even.right">
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.footer.even.left"/>
  <xsl:template match="d:*" mode="pagestyle.footer.even.center"/>
  <xsl:template match="d:*" mode="pagestyle.footer.even.right"/>
  <xsl:template match="d:*" mode="pagestyle.footer.odd.left"/>
  <xsl:template match="d:*" mode="pagestyle.footer.odd.center"/>
  <xsl:template match="d:*" mode="pagestyle.footer.odd.right"/>

  <!-- Set up the chapter pages -->
  <xsl:template match="d:*" mode="pagestyle.plain.header.odd.left">
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.plain.header.odd.center">
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.plain.header.odd.right">
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.plain.header.even.left">
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.plain.header.even.center">
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.plain.header.even.right">
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.plain.footer.even.left">
  </xsl:template>

  <xsl:template match="d:*" mode="pagestyle.plain.footer.even.center">
  </xsl:template>
  <xsl:template match="d:*" mode="pagestyle.plain.footer.even.right">
  </xsl:template>
  <xsl:template match="d:*" mode="pagestyle.plain.footer.odd.left">
  </xsl:template>
  <xsl:template match="d:*" mode="pagestyle.plain.footer.odd.center">
    <xsl:text>{\scriptsize \thepage}</xsl:text>
  </xsl:template>
  <xsl:template match="d:*" mode="pagestyle.plain.footer.odd.right">
  </xsl:template>
</xsl:stylesheet>

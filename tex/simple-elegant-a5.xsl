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
    a5paper,12pt,twoside,openright,final,onecolumn
  </xsl:variable>

  <!-- Fonts -->
  <xsl:variable name="font.main">Linux Libertine O</xsl:variable>
</xsl:stylesheet>

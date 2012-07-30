<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
	xmlns:mbp="mobi"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
  <!-- This doesn't use the standard DocBook stylesheets. Instead, it
       is just a simple conversion of a DocBook document into HTML for
       use with `kindlegen`.

       This doesn't generate a table of contents (see kindletoc for
       that) and it only generates ID fields for those elements that
       have one. -->

  <!-- `kindlegen` doesn't like the DOCTYPE. -->
  <xsl:output method="xml" />

  <!-- Include the common stylesheet -->
  <xsl:include href="../common/docbook.xsl"/>
  <xsl:include href="style.xsl"/>
</xsl:stylesheet>

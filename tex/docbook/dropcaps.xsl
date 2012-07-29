<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <xsl:template match="d:para[position()=1]|d:simpara[position()=1]" priority="1">
    <!-- We add a prefix so the python/sed code can handle do it. -->
    <xsl:call-template name="newline"/>

    <xsl:if test="name(..) = 'chapter' or name(..) = 'article'">
      <xsl:text>-FIRSTPARA-</xsl:text>
    </xsl:if>

    <!-- Add in the the normal paragraphs -->
    <xsl:next-match/>
  </xsl:template>
</xsl:stylesheet>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
    version="2.0">
  <xsl:variable name="css.font"/>
  <xsl:variable name="css.font.body">serif</xsl:variable>
  <xsl:variable name="css.font.page">sans</xsl:variable>
  <xsl:variable name="css.font.title">sans</xsl:variable>

  <xsl:template match="d:book|d:article" mode="css-style">
	<style type="text/css">
<xsl:value-of select="$css.font" />
<xsl:text>
body {
  font-family: </xsl:text><xsl:value-of select="$css.font.body"/><xsl:text>;
}

.page {
  font-family: </xsl:text><xsl:value-of select="$css.font.page"/><xsl:text>;
  text-align: center;
  margin-bottom: 1em;
  page-break-before: always;
}

.title {
  font-family: </xsl:text><xsl:value-of select="$css.font.title"/><xsl:text>;
  margin-top: 2em;
  text-align: center;
}

.subtitle {
  text-align: center;
}

.authorgroup {
  margin-top: 2em;
}

.author {
  margin-top: 1em;
  text-align: center;
}

.bylinegroup {
  margin-bottom: 2em;
  text-align: center;
}

.bylinesingle {
  font-weight: bold;
  text-align: center;
}

.byline {
  font-weight: bold;
  margin-bottom: 1em;
  text-align: center;
}

.center {
  text-align: center;
}

.amazonlinks {
  text-align: center;
  font-size: xx-large;
  font-weight: bold;
}

.end {
  text-align: right;
}

.dedication {
  page-break-before: always;
  margin-top: 2em;
  text-align: center;
}

.indented {
  margin: 0;
  padding: 0;
  text-indent: 1.25em;
  text-align: left;
}

.indent, .indent1 {
  margin: 0 0 0 2em;
  padding: 0;
  text-indent: 0;
  text-align: left;
}

.indent2 {
  margin: 0 0 0 4em;
  padding: 0;
  text-indent: 0;
  text-align: left;
}

.indent3 {
  margin: 0 0 0 6em;
  padding: 0;
  text-indent: 0;
  text-align: left;
}

.noindent {
  text-indent: 0;
  padding: 0;
  margin: 0;
  text-align: left;
}

.slab {
  text-indent: 0;
  padding: 0;
  margin: 1em 0 0 0;
  text-align: left;
}

.blockquote {
  margin-bottom: 1em;
}

div.blockquoted {
  margin: 0 0 0 2em;
  padding: 0;
  text-indent: 1.25em;
  text-align: left;
}

div.blockquotedslab {
  text-indent: 0;
  padding: 0;
  margin: 1em 0 0 2em;
  text-align: left;
}

.left {
  text-align: left;
}

.right {
  text-align: right;
}
</xsl:text>
	</style>
  </xsl:template>
</xsl:stylesheet>

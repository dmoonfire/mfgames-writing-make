<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
    version="2.0">
  <xsl:template match="d:book|d:article" mode="css-style">
	<style type="text/css">
.page {
  font-family: sans;
  text-align: center;
  margin-bottom: 1em;
  page-break-before: always;
}

.title {
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
}

.indent, .indent1 {
  margin: 0 0 0 2em;
  padding: 0;
  text-indent: 0;
}

.indent2 {
  margin: 0 0 0 4em;
  padding: 0;
  text-indent: 0;
}

.indent3 {
  margin: 0 0 0 6em;
  padding: 0;
  text-indent: 0;
}

.noindent {
  text-indent: 0;
  padding: 0;
  margin: 0;
}

.slab {
  text-indent: 0;
  padding: 0;
  margin: 1em 0 0 0;
}

.blockquote {
  margin-bottom: 1em;
}

div.blockquoted {
  margin: 0 0 0 2em;
  padding: 0;
  text-indent: 1.25em;
}

div.blockquotedslab {
  text-indent: 0;
  padding: 0;
  margin: 1em 0 0 2em;
}

.left {
  text-align: left;
}
	</style>
  </xsl:template>
</xsl:stylesheet>

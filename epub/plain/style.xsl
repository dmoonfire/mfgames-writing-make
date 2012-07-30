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

#legal {
  page-break-before: always;
}

.author, .title, .subtitle {
  margin-bottom: 2em;
  margin-top: 2em;
  text-align: center;
}

.center {
  text-align: center;
}

.end {
  text-align: right;
}

.dedication {
  margin-top: 2em;
  text-align: center;
  page-break-before: always;
}

blockquote {
  margin-left: 4em;
  text-indent: 0;
}
	</style>
  </xsl:template>
</xsl:stylesheet>
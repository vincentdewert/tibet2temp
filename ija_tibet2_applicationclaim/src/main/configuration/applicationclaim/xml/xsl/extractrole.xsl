<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="yes" />
	<xsl:param name="ldapstring"/>
	<xsl:template match="/">
		<xsl:variable name="substring" select="substring-after($ldapstring, 'CN=')"></xsl:variable>	
		<role><xsl:value-of select="substring-before($substring, ',')"/></role>
	</xsl:template>
</xsl:stylesheet>
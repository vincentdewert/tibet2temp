<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:template match="/">
		<roles>
			<xsl:for-each select="results/result/role">
				<role>
				<xsl:value-of select="."/>
				</role>
			</xsl:for-each>
		</roles>
	</xsl:template>
</xsl:stylesheet>
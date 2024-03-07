<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="text" indent="no" omit-xml-declaration="yes" />
	<xsl:template match="/">
		<xsl:value-of select="format-dateTime(current-dateTime(),'[Y0001]-[M01]-[D01]-[H01].[m01].[s]')" />
		<xsl:text>, BUSINESSDOMAIN="TIBET2HEALTH",APPLICATIONFUNCTION="HEALTHCHECK", APPLICATIONNAME="HEALTHCHECK", COUNT="0"</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:for-each select="/result/rowset/row">
			<xsl:value-of select="format-dateTime(current-dateTime(),'[Y0001]-[M01]-[D01]-[H01].[m01].[s]')" />
			<xsl:text>, BUSINESSDOMAIN="</xsl:text>
			<xsl:value-of select="field[@name='BUSINESSDOMAIN']" />
			<xsl:text>",APPLICATIONFUNCTION="</xsl:text>
			<xsl:value-of select="field[@name='APPLICATIONFUNCTION']" />
			<xsl:text>", APPLICATIONNAME="</xsl:text>
			<xsl:value-of select="field[@name='APPLICATIONNAME']" />
			<xsl:text>", COUNT="</xsl:text>
			<xsl:value-of select="field[@name='COUNT']" />
			<xsl:text>"</xsl:text>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
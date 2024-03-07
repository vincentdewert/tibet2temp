<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" />

<xsl:template match="/">
	<xsl:variable name="theurl" select="/esbInfo/serverAlias"/>
	<xsl:choose>
		<xsl:when test="$theurl='ESB_RR'">ESB_RR</xsl:when>
		<xsl:when test="$theurl='ESB_FF'">ESB_FF</xsl:when>
		<xsl:when test="$theurl='ESB_RR_LARGE'">ESB_RR_LARGE</xsl:when>
		<xsl:when test="$theurl='ESB_FF_LOG'">ESB_FF_LOG</xsl:when>
		<xsl:when test="$theurl='P2P_RR'">P2P_RR</xsl:when>
		<xsl:when test="$theurl='P2P_FF'">P2P_FF</xsl:when>
		<xsl:when test="$theurl='P2P_RR_LARGE'">P2P_RR_LARGE</xsl:when>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
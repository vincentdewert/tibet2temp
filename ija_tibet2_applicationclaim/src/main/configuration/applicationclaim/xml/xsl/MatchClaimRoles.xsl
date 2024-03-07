<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0"
>
	<xsl:param name="PreferredClaimRole" />
	<xsl:output method="text" />
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="//role[text() = $PreferredClaimRole]">IfServApplNameExist</xsl:when>
			<xsl:otherwise>NoClaimRoles</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
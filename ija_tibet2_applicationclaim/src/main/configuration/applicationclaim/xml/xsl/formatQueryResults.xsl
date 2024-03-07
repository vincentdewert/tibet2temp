<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0"
>
	<xsl:output
		method="xml"
		omit-xml-declaration="yes" />

	<xsl:template match="/">
		<claimedrecords><xsl:apply-templates select="results/result/result/rowset"/></claimedrecords>
	</xsl:template>
	
	<xsl:template match="result/rowset">
		<xsl:if test="string-length(.) > 0">
				<xsl:apply-templates select="row"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="row">
			<record>
			<businessdomain><xsl:value-of select="field[@name='BUSINESSDOMAIN']"></xsl:value-of></businessdomain>
			<servapplname><xsl:value-of select="field[@name='SERV_APPL_NAME']"></xsl:value-of></servapplname>
			<role><xsl:value-of select="field[@name='ROLE']"></xsl:value-of></role>
			<claimrole><xsl:value-of select="field[@name='CLAIM_ROLE']"></xsl:value-of></claimrole>
			</record>
	</xsl:template>	
</xsl:stylesheet>
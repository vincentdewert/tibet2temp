<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="2.0"> 

	<xsl:param name="authtablerecords"/>
	<xsl:param name="thequeues" />
		
	<xsl:output method="xml" />

		<xsl:template match="/">
			<claimedrecords>		
				<xsl:apply-templates select = "claimedrecords/record"/>
			</claimedrecords>	
		</xsl:template>
		
		<xsl:template match="claimedrecords/record">
			<xsl:if test="queue">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:template>

</xsl:stylesheet>

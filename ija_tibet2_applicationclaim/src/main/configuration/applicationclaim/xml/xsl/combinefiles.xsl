<xsl:stylesheet   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="2.0"> 

	<xsl:param name="authtablerecords"/>
	
	<xsl:output method="xml" />

	<xsl:template match="/">
			<xsl:variable name="thequeues" select="."/>
			<claimedrecords>
			<record><queue>dummy</queue></record>
			<xsl:for-each select="$authtablerecords/claimedrecords/record">
				<xsl:variable name="currentrecord" select="."/>
				<record>
				<xsl:copy-of select="businessdomain"/>
				<xsl:copy-of select="servapplname"/>
				<xsl:copy-of select="role"/>
				<xsl:copy-of select="claimrole"/>
				<queue>dummy</queue>
					<xsl:for-each select = "$thequeues/queues/queue">
						<xsl:if test="businessdomain = $currentrecord/businessdomain and servapplname = $currentrecord/servapplname">
							<queue><xsl:value-of select="name"/></queue>
						</xsl:if>
					</xsl:for-each>
				</record>
			</xsl:for-each>
			</claimedrecords>
		</xsl:template>
</xsl:stylesheet>

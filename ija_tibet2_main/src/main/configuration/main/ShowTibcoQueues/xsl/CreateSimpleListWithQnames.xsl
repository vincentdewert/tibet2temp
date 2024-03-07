<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:variable name="apos">&apos;</xsl:variable>
	<xsl:template match="results">
		<queues>
			<xsl:attribute name="ok" select="count(result[@status='ok'])"/>
			<xsl:attribute name="error" select="count(result[@status='error'])"/>
			<xsl:attribute name="duplicate" select="count(result[@status='duplicate'])"/>
			<xsl:for-each select="result/queues/queue">
				<xsl:sort select="name"/>
				<xsl:call-template name="queue"/>
			</xsl:for-each>
		</queues>
	</xsl:template>
	<xsl:template name="queue">
	<queue>
	<xsl:choose>
				<!--  testing for a q like ESB.Archiving.BS.Document.Document.2.GetDocumentAndAttributes.3.Request-->
				<xsl:when test="count(tokenize(name,'\.'))=9">		
					<xsl:for-each select="tokenize(name,'\.')">
						<xsl:if test="position() = 2">
							<businessdomain>
								<xsl:copy-of select="." />
							</businessdomain>
						</xsl:if>
						<xsl:if test="position() = 5">
							<servapplname>
								<xsl:copy-of select="." />
							</servapplname>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>	
				
				<!--For example: ESB.BankSavings.TS.BankAccountOFS.1.GetAccountsOverview.2.Request -->
				<xsl:when test="count(tokenize(name,'\.'))=8">
					<xsl:for-each select="tokenize(name,'\.')">
						<xsl:if test="position() = 2">
							<businessdomain>
								<xsl:copy-of select="." />
							</businessdomain>
						</xsl:if>
						<xsl:if test="position() = 4">
							<servapplname>
								<xsl:copy-of select="." />
							</servapplname>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				
				<!--For example: P2P.Mortgages.MortgageContractNewProcess.Inbound.Request -->
				<xsl:when test="count(tokenize(.,'\.'))=5">
					<xsl:for-each select="tokenize(name,'\.')">
						<xsl:if test="position() = 2">
							<businessdomain>
								<xsl:copy-of select="." />
							</businessdomain>
						</xsl:if>
						<xsl:if test="position() = 3">
							<servapplname>
								<xsl:copy-of select="." />
							</servapplname>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				
				<xsl:otherwise>
							<businessdomain>cannot find businessdomain</businessdomain>
							<servapplname>cannot find serverapplname</servapplname>
				</xsl:otherwise>			
		</xsl:choose>
		<name><xsl:value-of select="name" /></name>
	</queue>
</xsl:template>



</xsl:stylesheet>

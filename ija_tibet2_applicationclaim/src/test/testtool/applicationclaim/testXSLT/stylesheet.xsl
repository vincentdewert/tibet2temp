<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
>
	<xsl:output method="xml" />
	<xsl:template match="/">
		<queues><xsl:apply-templates select="queues/queue" ></xsl:apply-templates></queues>
	</xsl:template>
	
	<xsl:template match="queue">	
		<xsl:variable name="qname" select="name"/>

		
		<!--  Checking for unexpected characters in the name element , a string with dot separators -->
		<xsl:if test="matches(name,'^[\w\._-]+$')">

        <!-- Only accept queues with a length 8,9 or 5 and only when these begin with ESB or P2P-->
		<xsl:if test="tokenize(name, '\.')[1]='ESB' or tokenize(name, '\.')[1]='P2P'">

		<queue>
				<name><xsl:value-of select="name"/></name>
		
		<xsl:choose>
					<!--  testing for a q like ESB.BankSavings.TS.BankAccountProcess.1.HandleContraAccount.1.Request-->
					<xsl:when test="tokenize(name, '\.')[1]='ESB' and count(tokenize(name,'\.'))=9">		
						<xsl:for-each select="tokenize(name,'\.')">
							<xsl:if test="position() = 2">
								<businessdomain><xsl:copy-of select="." /></businessdomain>
							</xsl:if>
							<xsl:if test="position() = 5">
								<servapplname><xsl:copy-of select="." /></servapplname>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>	
					<!--For example: ESB.BankSavings.TS.BankAccountOFS.1.GetAccountsOverview.2.Request -->
					<xsl:when test="tokenize(name, '\.')[1]='ESB' and count(tokenize(name,'\.')) &lt; 6">
						<xsl:for-each select="tokenize(name,'\.')">
							<xsl:if test="position() = 2">
								<businessdomain><xsl:copy-of select="." /></businessdomain>
							</xsl:if>
							<xsl:if test="position() = 3">
								<servapplname><xsl:copy-of select="." /></servapplname>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>

					<xsl:when test="tokenize(name, '\.')[1]='ESB' and count(tokenize(name,'\.')) &gt; 5 and count(tokenize(name,'\.')) &lt; 9">
						<xsl:for-each select="tokenize(name,'\.')">
							<xsl:if test="position() = 2">
								<businessdomain><xsl:copy-of select="." /></businessdomain>
							</xsl:if>
							<xsl:if test="position() = 4">
								<servapplname><xsl:copy-of select="." /></servapplname>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>

					
					<!--For example: P2P.Mortgages.MortgageContractNewProcess.Inbound.Request -->
					<xsl:when test="tokenize(name, '\.')[1]='P2P' ">
						<xsl:for-each select="tokenize(name,'\.')">
							<xsl:if test="position() = 2">
								<businessdomain><xsl:copy-of select="." /></businessdomain>
							</xsl:if>
							<xsl:if test="position() = 3">
								<servapplname><xsl:copy-of select="." /></servapplname>
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
								<businessdomain><xsl:text>no valid quename</xsl:text></businessdomain>
								<servapplname><xsl:text>no valid queuename</xsl:text></servapplname>
					</xsl:otherwise>			
				</xsl:choose>				
		</queue>
		</xsl:if>
		</xsl:if>
</xsl:template>
	
</xsl:stylesheet>
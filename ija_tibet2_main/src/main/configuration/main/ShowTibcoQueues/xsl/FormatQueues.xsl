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
			<name>
				<xsl:value-of select="name"/>
			</name>
			<msgCount>
				<xsl:attribute name="since" select="../@age" />
				<xsl:value-of select="msgCount"/>
			</msgCount>
			<xsl:if test="string-length(acl)&gt;0">
				<acls>
					<xsl:for-each select="tokenize(acl,';')">
						<acl>
							<xsl:variable name="acl">
								<xsl:sequence select="normalize-space(.)"/>
							</xsl:variable>
							<principal>
								<xsl:value-of select="substring-before($acl,'=')"/>
							</principal>
							<permissions>
								<xsl:for-each select="tokenize(substring-after($acl,'='),',')">
									<permission>
										<xsl:value-of select="."/>
									</permission>
								</xsl:for-each>
							</permissions>
						</acl>
					</xsl:for-each>
				</acls>
			</xsl:if>
			<xsl:if test="string-length(bridgeTargets)&gt;0">
				<bridgeTargets>
					<xsl:for-each select="tokenize(bridgeTargets,';')">
						<xsl:variable name="bridgeTarget">
							<xsl:sequence select="normalize-space(.)"/>
						</xsl:variable>
						<bridgeTarget>
							<xsl:variable name="bt1">
								<xsl:value-of select="substring-after($bridgeTarget,$apos)"/>
							</xsl:variable>
							<xsl:variable name="bt2">
								<xsl:value-of select="substring-before($bt1,$apos)"/>
							</xsl:variable>
							<name>
								<xsl:value-of select="$bt2"/>
							</name>
						</bridgeTarget>
					</xsl:for-each>
				</bridgeTargets>
			</xsl:if>
		</queue>
	</xsl:template>
</xsl:stylesheet>

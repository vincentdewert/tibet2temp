<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="searchString"/>
	<xsl:variable name="space" select="' '"/>
	<xsl:variable name="quote" select="'&quot;'"/>
	<xsl:template match="queues">
		<lines>
			<xsl:apply-templates select="queue"/>
		</lines>
	</xsl:template>
	<xsl:template match="queue">
		<xsl:variable name="mode">
			<xsl:variable name="qMode">
				<xsl:call-template name="containsStringToken">
					<xsl:with-param name="source" select="name"/>
					<xsl:with-param name="string" select="$searchString"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$qMode='Y'">
					<xsl:text>Q</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="rPrincipals">
						<xsl:for-each select="acls/acl[permissions/permission[lower-case(.)='receive']]/principal">
							<xsl:if test="position()&gt;1">
								<xsl:text>,</xsl:text>
							</xsl:if>
							<xsl:sequence select="normalize-space(.)"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="prMode">
						<xsl:call-template name="containsStringToken">
							<xsl:with-param name="source" select="$rPrincipals"/>
							<xsl:with-param name="string" select="$searchString"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$prMode='Y'">
							<xsl:text>PR</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="sPrincipals">
								<xsl:for-each select="acls/acl[permissions/permission[lower-case(.)='send']]/principal">
									<xsl:if test="position()&gt;1">
										<xsl:text>,</xsl:text>
									</xsl:if>
									<xsl:sequence select="normalize-space(.)"/>
								</xsl:for-each>
							</xsl:variable>
							<xsl:variable name="psMode">
								<xsl:call-template name="containsStringToken">
									<xsl:with-param name="source" select="$sPrincipals"/>
									<xsl:with-param name="string" select="$searchString"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$psMode='Y'">
									<xsl:text>PS</xsl:text>
								</xsl:when>
								<xsl:otherwise>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length($mode)&gt;0">
			<xsl:call-template name="queue">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="queue">
		<xsl:param name="mode"/>
		<xsl:apply-templates select="acls/acl">
			<xsl:with-param name="mode" select="$mode"/>
			<xsl:with-param name="qName" select="name"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="bridgeTargets/bridgeTarget">
			<xsl:with-param name="qName" select="name"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="acl">
		<xsl:param name="mode"/>
		<xsl:param name="qName"/>
		<xsl:variable name="foundPrincipal">
			<xsl:variable name="fpMode">
				<xsl:call-template name="containsStringToken">
					<xsl:with-param name="source" select="principal"/>
					<xsl:with-param name="string" select="$searchString"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$fpMode='Y'">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="permissions/permission[lower-case(.)='receive']">
			<xsl:if test="$mode='Q' or $mode='PS' or ($mode='PR' and $foundPrincipal='true')">
				<line>
					<from type="queue">
						<xsl:value-of select="$qName"/>
					</from>
					<to type="principal">
						<xsl:call-template name="adjustPrincipal">
							<xsl:with-param name="principal" select="principal"/>
						</xsl:call-template>
					</to>
				</line>
			</xsl:if>
		</xsl:if>
		<xsl:if test="permissions/permission[lower-case(.)='send']">
			<xsl:if test="$mode='Q' or $mode='PR' or ($mode='PS' and $foundPrincipal='true')">
				<line>
					<from type="principal">
						<xsl:call-template name="adjustPrincipal">
							<xsl:with-param name="principal" select="principal"/>
						</xsl:call-template>
					</from>
					<to type="queue">
						<xsl:value-of select="$qName"/>
					</to>
				</line>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="bridgeTarget">
		<xsl:param name="qName"/>
		<line>
			<from type="queue">
				<xsl:value-of select="$qName"/>
			</from>
			<to type="queue">
				<xsl:value-of select="name"/>
			</to>
		</line>
		<xsl:variable name="qNameBT" select="name"/>
		<xsl:for-each select="../../../queue[name=$qNameBT]">
			<xsl:call-template name="queue">
				<xsl:with-param name="mode" select="'PS'"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="containsStringToken">
		<xsl:param name="source"/>
		<xsl:param name="string"/>
		<xsl:variable name="result">
			<xsl:for-each select="tokenize($string,',')">
				<xsl:variable name="token">
					<xsl:sequence select="normalize-space(.)"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="contains(upper-case($source),upper-case($token))">
						<xsl:text>Y</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>N</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($result,'Y')">
				<xsl:text>Y</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>N</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="adjustPrincipal">
		<xsl:param name="principal"/>
		<xsl:variable name="p1" select="replace($principal,$quote,'')"/>
		<xsl:value-of select="replace($p1,$space,'\\n')"/>
	</xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="esb_rr_url" />
	<xsl:param name="esb_ff_url" />
	<xsl:param name="esb_rr_large_url" />
	<xsl:param name="p2p_rr_url" />
	<xsl:param name="p2p_ff_url" />
	<xsl:param name="p2p_rr_large_url" />
	                                                               
	<xsl:param name="esb_rr_url_ssl" />
	<xsl:param name="esb_ff_url_ssl" />
	<xsl:param name="esb_rr_large_url_ssl" />
	<xsl:param name="p2p_rr_url_ssl" />
	<xsl:param name="p2p_ff_url_ssl" />
	<xsl:param name="p2p_rr_large_url_ssl" />

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="count(result/rowset/row)=0">
				<error>NO_ROW_FOUND</error>
			</xsl:when>
			<xsl:when test="count(result/rowset/row)=1">
				<xsl:apply-templates select="result/rowset/row" />
			</xsl:when>
			<xsl:otherwise>
				<error>MULTIPLE_ROWS_FOUND</error>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="row">
		<xsl:variable name="dest" select="field[@name='RESEND_DESTINATION']" />
		<xsl:variable name="pu" select="field[@name='RESEND_PROV_URL']" />
		<xsl:choose>
			<xsl:when test="string-length($dest)=0">
				<error>EMPTY_RESEND_DESTINATION</error>
			</xsl:when>
			<xsl:when test="string-length($pu)=0">
				<error>EMPTY_RESEND_PROV_URL</error>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="tjn" select="'tibjmsnaming:'" />
				<xsl:variable name="tcp" select="'tcp:'" />
				<xsl:variable name="ssl" select="'ssl:'" />
				<xsl:variable name="provUrl">
					<xsl:if test="contains($pu, '37222')">
							<xsl:value-of select="replace($pu,$tjn,$tcp)" />
					</xsl:if>
					<xsl:if test="contains($pu, '37243')">
							<xsl:value-of select="replace($pu,$tjn,$ssl)" />
					</xsl:if>
				</xsl:variable>
				<Request>
					<QueueConnectionFactory>
						<xsl:choose>
							<xsl:when test="contains(upper-case($esb_rr_url), upper-case($provUrl)) or contains(upper-case($esb_rr_url_ssl), upper-case($provUrl))">
								<xsl:text>qcf_tibco_esb_rr</xsl:text>
							</xsl:when>
							<xsl:when test="contains(upper-case($esb_ff_url), upper-case($provUrl)) or contains(upper-case($esb_ff_url_ssl), upper-case($provUrl))">
								<xsl:text>qcf_tibco_esb_ff</xsl:text>
							</xsl:when>
							<xsl:when test="contains(upper-case($esb_rr_large_url), upper-case($provUrl)) or contains(upper-case($esb_rr_url_ssl), upper-case($provUrl))">
								<xsl:text>qcf_tibco_esb_rr_large</xsl:text>
							</xsl:when>
							<xsl:when test="contains(upper-case($p2p_rr_url), upper-case($provUrl)) or contains(upper-case($p2p_rr_url_ssl), upper-case($provUrl))">
								<xsl:text>qcf_tibco_p2p_rr</xsl:text>
							</xsl:when>
							<xsl:when test="contains(upper-case($p2p_ff_url), upper-case($provUrl)) or contains(upper-case($p2p_ff_url_ssl), upper-case($provUrl))">
								<xsl:text>qcf_tibco_p2p_ff</xsl:text>
							</xsl:when>
							<xsl:when test="contains(upper-case($p2p_rr_large_url), upper-case($provUrl)) or contains(upper-case($p2p_rr_large_url_ssl), upper-case($provUrl))">
								<xsl:text>qcf_tibco_p2p_rr_large</xsl:text>
							</xsl:when>
							<xsl:when test="$provUrl='%%nn.ems.server.esb.small%%'">
								<xsl:text>qcf_tibco_esb_rr</xsl:text>
							</xsl:when>
							<xsl:when test="$provUrl='%%nn.ems.server.esb.large%%'">
								<xsl:text>qcf_tibco_esb_ff</xsl:text>
							</xsl:when>
							<xsl:when test="$provUrl='%%nn.ems.server.p2p.small%%'">
								<xsl:text>qcf_tibco_p2p_rr</xsl:text>
							</xsl:when>
							<xsl:when test="$provUrl='%%nn.ems.server.p2p.large%%'">
								<xsl:text>qcf_tibco_p2p_ff</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$provUrl" />
							</xsl:otherwise>
						</xsl:choose>
					</QueueConnectionFactory>
					<QueueDestination>
						<xsl:value-of select="$dest" />
					</QueueDestination>
					<Text>
						<xsl:value-of select="field[@name='MESSAGE']" />
					</Text>
				</Request>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

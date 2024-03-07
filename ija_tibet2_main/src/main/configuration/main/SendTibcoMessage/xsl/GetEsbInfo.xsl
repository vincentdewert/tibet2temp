<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="uri" />
	<xsl:param name="provUrl" />
	<xsl:param name="qcf" />
	<xsl:param name="esb_rr_url" />
	<xsl:param name="esb_rr_alias" />
	<xsl:param name="esb_ff_url" />
	<xsl:param name="esb_ff_alias" />
	<xsl:param name="esb_rr_large_url" />
	<xsl:param name="esb_rr_large_alias" />
	<xsl:param name="esb_ff_log_url" />
	<xsl:param name="esb_ff_log_alias" />
	<xsl:param name="p2p_rr_url" />
	<xsl:param name="p2p_rr_alias" />
	<xsl:param name="p2p_ff_url" />
	<xsl:param name="p2p_ff_alias" />
	<xsl:param name="p2p_rr_large_url" />
	<xsl:param name="p2p_rr_large_alias" />
	<xsl:template match="/">
		<esbInfo>
			<xsl:choose>
				<xsl:when test="string-length($provUrl)&gt;0">
					<xsl:call-template name="fillFromProvUrl" />
				</xsl:when>
				<xsl:when test="string-length($uri)&gt;0">
					<xsl:call-template name="fillFromUri" />
				</xsl:when>
				<xsl:when test="string-length($qcf)&gt;0">
					<xsl:call-template name="fillFromQcf" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="fillError" />
				</xsl:otherwise>
			</xsl:choose>
		</esbInfo>
	</xsl:template>
	<xsl:template name="fillFromProvUrl">
		<xsl:variable name="provUrl2">
			<xsl:variable name="tjn" select="'tibjmsnaming:'" />
			<xsl:variable name="tcp" select="'tcp:'" />
			<xsl:value-of select="replace($provUrl,$tjn,$tcp)" />
		</xsl:variable>
		<provUrl>
			<xsl:value-of select="$provUrl2" />
		</provUrl>
		<xsl:variable name="serverAlias">
			<xsl:call-template name="getServerAlias">
				<xsl:with-param name="provUrl2" select="$provUrl2" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($serverAlias)&gt;0">
				<serverAlias>
					<xsl:value-of select="$serverAlias" />
				</serverAlias>
				<xsl:variable name="authAlias">
					<xsl:call-template name="getAuthAlias">
						<xsl:with-param name="serverAlias" select="$serverAlias" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="string-length($authAlias)&gt;0">
					<authAlias>
						<xsl:value-of select="$authAlias" />
					</authAlias>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="fillError" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="fillFromUri">
		<xsl:variable name="serverAlias">
			<xsl:variable name="sa" select="substring-after($uri,'/')" />
			<xsl:value-of select="substring-after($sa,'/')" />
		</xsl:variable>
		<serverAlias>
			<xsl:value-of select="$serverAlias" />
		</serverAlias>
		<xsl:variable name="provUrl2">
			<xsl:call-template name="getProvUrl">
				<xsl:with-param name="serverAlias" select="$serverAlias" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($provUrl2)&gt;0">
				<provUrl>
					<xsl:value-of select="$provUrl2" />
				</provUrl>
				<xsl:variable name="authAlias">
					<xsl:call-template name="getAuthAlias">
						<xsl:with-param name="serverAlias" select="$serverAlias" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="string-length($authAlias)&gt;0">
					<authAlias>
						<xsl:value-of select="$authAlias" />
					</authAlias>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="fillError" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="fillFromQcf">
		<xsl:variable name="serverAlias">
			<xsl:variable name="sa" select="upper-case($qcf)" />
			<xsl:value-of select="substring-after($sa,'QCF_TIBCO_')" />
		</xsl:variable>
		<serverAlias>
			<xsl:value-of select="$serverAlias" />
		</serverAlias>
		<xsl:variable name="provUrl2">
			<xsl:call-template name="getProvUrl">
				<xsl:with-param name="serverAlias" select="$serverAlias" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($provUrl2)&gt;0">
				<provUrl>
					<xsl:value-of select="$provUrl2" />
				</provUrl>
				<xsl:variable name="authAlias">
					<xsl:call-template name="getAuthAlias">
						<xsl:with-param name="serverAlias" select="$serverAlias" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="string-length($authAlias)&gt;0">
					<authAlias>
						<xsl:value-of select="$authAlias" />
					</authAlias>
				</xsl:if>
				<messageProtocol>
					<xsl:choose>
						<xsl:when test="ends-with($serverAlias,'_FF')">
							<xsl:text>FF</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>RR</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</messageProtocol>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="fillError" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getServerAlias">
		<xsl:param name="provUrl2" />
		<xsl:choose>
			<xsl:when test="$provUrl2=$esb_rr_url">
				<xsl:text>ESB_RR</xsl:text>
			</xsl:when>
			<xsl:when test="$provUrl2=$esb_ff_url">
				<xsl:text>ESB_FF</xsl:text>
			</xsl:when>
			<xsl:when test="$provUrl2=$esb_rr_large_url">
				<xsl:text>ESB_RR_LARGE</xsl:text>
			</xsl:when>
			<xsl:when test="$provUrl2=$esb_ff_log_url">
				<xsl:text>ESB_FF_LOG</xsl:text>
			</xsl:when>
			<xsl:when test="$provUrl2=$p2p_rr_url">
				<xsl:text>P2P_RR</xsl:text>
			</xsl:when>
			<xsl:when test="$provUrl2=$p2p_ff_url">
				<xsl:text>P2P_FF</xsl:text>
			</xsl:when>
			<xsl:when test="$provUrl2=$p2p_rr_large_url">
				<xsl:text>P2P_RR_LARGE</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getProvUrl">
		<xsl:param name="serverAlias" />
		<xsl:choose>
			<xsl:when test="$serverAlias='ESB_RR'">
				<xsl:value-of select="$esb_rr_url" />
			</xsl:when>
			<xsl:when test="$serverAlias='ESB_FF'">
				<xsl:value-of select="$esb_ff_url" />
			</xsl:when>
			<xsl:when test="$serverAlias='ESB_RR_LARGE'">
				<xsl:value-of select="$esb_rr_large_url" />
			</xsl:when>
			<xsl:when test="$serverAlias='ESB_FF_LOG'">
				<xsl:value-of select="$esb_ff_log_url" />
			</xsl:when>
			<xsl:when test="$serverAlias='P2P_RR'">
				<xsl:value-of select="$p2p_rr_url" />
			</xsl:when>
			<xsl:when test="$serverAlias='P2P_FF'">
				<xsl:value-of select="$p2p_ff_url" />
			</xsl:when>
			<xsl:when test="$serverAlias='P2P_RR_LARGE'">
				<xsl:value-of select="$p2p_rr_large_url" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getAuthAlias">
		<xsl:param name="serverAlias" />
		<xsl:choose>
			<xsl:when test="$serverAlias='ESB_RR'">
				<xsl:value-of select="$esb_rr_alias" />
			</xsl:when>
			<xsl:when test="$serverAlias='ESB_FF'">
				<xsl:value-of select="$esb_ff_alias" />
			</xsl:when>
			<xsl:when test="$serverAlias='ESB_RR_LARGE'">
				<xsl:value-of select="$esb_rr_large_alias" />
			</xsl:when>
			<xsl:when test="$serverAlias='ESB_FF_LOG'">
				<xsl:value-of select="$esb_ff_log_alias" />
			</xsl:when>
			<xsl:when test="$serverAlias='P2P_RR'">
				<xsl:value-of select="$p2p_rr_alias" />
			</xsl:when>
			<xsl:when test="$serverAlias='P2P_FF'">
				<xsl:value-of select="$p2p_ff_alias" />
			</xsl:when>
			<xsl:when test="$serverAlias='P2P_RR_LARGE'">
				<xsl:value-of select="$p2p_rr_large_alias" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="fillError">
		<error info="true">
			<serverAlias>
				<xsl:attribute name="name">ESB_RR</xsl:attribute>
				<xsl:value-of select="$esb_rr_url" />
			</serverAlias>
			<serverAlias>
				<xsl:attribute name="name">ESB_FF</xsl:attribute>
				<xsl:value-of select="$esb_ff_url" />
			</serverAlias>
			<serverAlias>
				<xsl:attribute name="name">ESB_RR_LARGE</xsl:attribute>
				<xsl:value-of select="$esb_rr_large_url" />
			</serverAlias>
			<serverAlias>
				<xsl:attribute name="name">ESB_FF_LOG</xsl:attribute>
				<xsl:value-of select="$esb_ff_log_url" />
			</serverAlias>
			<serverAlias>
				<xsl:attribute name="name">P2P_RR</xsl:attribute>
				<xsl:value-of select="$p2p_rr_url" />
			</serverAlias>
			<serverAlias>
				<xsl:attribute name="name">P2P_FF</xsl:attribute>
				<xsl:value-of select="$p2p_ff_url" />
			</serverAlias>
			<serverAlias>
				<xsl:attribute name="name">P2P_RR_LARGE</xsl:attribute>
				<xsl:value-of select="$p2p_rr_large_url" />
			</serverAlias>
		</error>
	</xsl:template>
</xsl:stylesheet>

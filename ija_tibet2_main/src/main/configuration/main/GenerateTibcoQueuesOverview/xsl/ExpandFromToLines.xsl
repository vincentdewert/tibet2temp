<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" />
	<xsl:param name="principal" />
	<xsl:param name="tibcoSolutionQueues" />
	<xsl:variable name="brvbar" select="'&#166;'" />
	<xsl:template match="/">
		<xsl:apply-templates select="*|@*|comment()|processing-instruction()" />
	</xsl:template>
	<xsl:template match="*">
		<xsl:choose>
			<xsl:when
				test="name()='line' and from/@type='principal' and to/@type='queue' and starts-with(upper-case(from[@type='principal']),upper-case($principal))">
				<xsl:variable name="queue" select="to[@type='queue']" />
				<xsl:variable name="principal" select="from[@type='principal']" />
				<xsl:choose>
					<xsl:when
						test="count($tibcoSolutionQueues/queues/queue[name=$queue]/senders/sender)=0">
						<xsl:call-template name="copy" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each
							select="$tibcoSolutionQueues/queues/queue[name=$queue]/senders/sender">
							<line>
								<from type="principal">
									<xsl:variable name="v1">
										<xsl:call-template name="replaceBrokenVerticalBar">
											<xsl:with-param name="string" select="$principal" />
										</xsl:call-template>
									</xsl:variable>
									<xsl:variable name="v2">
										<xsl:call-template name="replaceBrokenVerticalBar">
											<xsl:with-param name="string" select="." />
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="concat($v1,$brvbar,$v2)" />
								</from>
								<to type="queue">
									<xsl:value-of select="$queue" />
								</to>
							</line>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when
				test="name()='line' and to/@type='principal' and from/@type='queue' and starts-with(upper-case(to[@type='principal']),upper-case($principal))">
				<xsl:variable name="queue" select="from[@type='queue']" />
				<xsl:variable name="principal" select="to[@type='principal']" />
				<xsl:choose>
					<xsl:when
						test="count($tibcoSolutionQueues/queues/queue[name=$queue]/receivers/receiver)=0">
						<xsl:call-template name="copy" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each
							select="$tibcoSolutionQueues/queues/queue[name=$queue]/receivers/receiver">
							<line>
								<from type="queue">
									<xsl:value-of select="$queue" />
								</from>
								<to type="principal">
									<xsl:variable name="v1">
										<xsl:call-template name="replaceBrokenVerticalBar">
											<xsl:with-param name="string" select="$principal" />
										</xsl:call-template>
									</xsl:variable>
									<xsl:variable name="v2">
										<xsl:call-template name="replaceBrokenVerticalBar">
											<xsl:with-param name="string" select="." />
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="concat($v1,$brvbar,$v2)" />
								</to>
							</line>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="(name()='from' or name()='to') and @type='principal'">
				<xsl:variable name="elem" select="name()" />
				<xsl:element name="{$elem}">
					<xsl:attribute name="type">principal</xsl:attribute>
					<xsl:call-template name="replaceBrokenVerticalBar">
						<xsl:with-param name="string" select="." />
					</xsl:call-template>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="copy" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@*|comment()|processing-instruction()">
		<xsl:call-template name="copy" />
	</xsl:template>
	<xsl:template name="copy">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|comment()|processing-instruction()|text()" />
		</xsl:copy>
	</xsl:template>
	<xsl:template name="replaceBrokenVerticalBar">
		<xsl:param name="string" />
		<xsl:value-of select="replace($string,$brvbar,':')" />
	</xsl:template>
</xsl:stylesheet>

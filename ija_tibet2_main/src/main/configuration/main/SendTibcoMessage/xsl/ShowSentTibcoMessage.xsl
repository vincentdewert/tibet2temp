<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="srcPrefix" />
	<xsl:param name="qcf" />
	<xsl:param name="url" />
	<xsl:param name="queue" />
	<xsl:param name="timeout" />
	<xsl:param name="soapAction" />
	<xsl:param name="message" />
	<xsl:param name="result" />
	<xsl:template match="/">
		<page title="Show Sent Tibco Message">
			<xsl:choose>
				<xsl:when test="starts-with($result,'&lt;error')">
					<font color="red">
						<xsl:value-of select="$result" />
					</font>
				</xsl:when>
				<xsl:otherwise>
					<table>
						<caption class="caption">Input</caption>
						<tr>
							<td class="filterRow">
								<xsl:text>Queue connection factory</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="$qcf" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>Provider url</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="$url" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>Queue destination</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="$queue" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>Timeout (in msec)</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="$timeout" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>Soap action</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="$soapAction" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>Message</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="$message" />
							</td>
						</tr>
					</table>
					<br />
					<table>
						<caption class="caption">Output</caption>
						<tr>
							<td class="filterRow">
								<xsl:text>Result</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="$result" />
							</td>
						</tr>
					</table>
				</xsl:otherwise>
			</xsl:choose>
		</page>
	</xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:template match="root">
		<xsl:variable name="senders">
			<senders>
				<xsl:for-each select="subroot/component/project/sender">
					<sender>
						<queue>
							<xsl:value-of select="."/>
						</queue>
						<project>
							<xsl:value-of select="../@name"/>
						</project>
					</sender>
				</xsl:for-each>
			</senders>
		</xsl:variable>
		<xsl:variable name="receivers">
			<receivers>
				<xsl:for-each select="subroot/component/project/receiver">
					<receiver>
						<queue>
							<xsl:value-of select="."/>
						</queue>
						<project>
							<xsl:value-of select="../@name"/>
						</project>
					</receiver>
				</xsl:for-each>
			</receivers>
		</xsl:variable>
		<queues>
			<xsl:for-each-group select="subroot/component/project/*[name()='sender' or name()='receiver']" group-by=".">
				<xsl:sort select="current-grouping-key()"/>
				<queue>
					<name>
						<xsl:value-of select="current-grouping-key()"/>
					</name>
					<xsl:variable name="qName" select="."/>
					<senders>
						<xsl:for-each-group select="$senders/senders/sender[queue=$qName]" group-by="project">
							<xsl:sort select="current-grouping-key()"/>
							<sender>
								<xsl:value-of select="current-grouping-key()"/>
							</sender>
						</xsl:for-each-group>
					</senders>
					<receivers>
						<xsl:for-each-group select="$receivers/receivers/receiver[queue=$qName]" group-by="project">
							<xsl:sort select="current-grouping-key()"/>
							<receiver>
								<xsl:value-of select="current-grouping-key()"/>
							</receiver>
						</xsl:for-each-group>
					</receivers>
				</queue>
			</xsl:for-each-group>
		</queues>
	</xsl:template>
</xsl:stylesheet>

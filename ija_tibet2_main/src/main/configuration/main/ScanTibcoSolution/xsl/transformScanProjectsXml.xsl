<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:template match="root">
		<root>
			<xsl:attribute name="url" select="@url"/>
			<xsl:for-each select="dir[(@skip='true')=false()]">
				<subroot>
					<xsl:attribute name="name" select="@name"/>
					<xsl:for-each select="dir[(@skip='true')=false()]">
						<component>
							<xsl:attribute name="name" select="@name"/>
							<xsl:attribute name="committer" select="commit/@creator"/>
							<xsl:attribute name="committed" select="substring(commit/@date,1,10)"/>
							<xsl:choose>
								<xsl:when test="count(dir[@name='trunk'])=0">
									<xsl:attribute name="trunk">false</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="trunk">true</xsl:attribute>
									<xsl:apply-templates select="dir[@name='trunk']" mode="trunk"/>
								</xsl:otherwise>
							</xsl:choose>
						</component>
					</xsl:for-each>
				</subroot>
			</xsl:for-each>
		</root>
	</xsl:template>
	<xsl:template match="dir" mode="trunk">
		<xsl:choose>
			<xsl:when test="count(dir[@name='src'])=0">
				<xsl:attribute name="src">false</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="src">true</xsl:attribute>
				<xsl:apply-templates select="dir[@name='src']" mode="src"/>
				<xsl:call-template name="finddaa_component"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="dir" mode="src">
		<xsl:for-each select="dir">
			<xsl:variable name="project">
				<xsl:copy-of select="*"/>
			</xsl:variable>
			<project>
				<xsl:attribute name="name" select="@name"/>
				<xsl:attribute name="committer" select="commit/@creator"/>
				<xsl:attribute name="committed" select="substring(commit/@date,1,10)"/>
				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="file[@name='vcrepo.dat']">BW</xsl:when>
						<xsl:when test="file[@name='.project']">AMX</xsl:when>
						<xsl:otherwise>?</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:attribute name="type" select="$type"/>
				<xsl:for-each select="descendant-or-self::*[name()='jmsTo' and @type='soapEventSource']">
					<receiver type='unwired'>
						<xsl:call-template name="substvar">
							<xsl:with-param name="project" select="$project"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</receiver>
				</xsl:for-each>
				<xsl:for-each select="descendant-or-self::*[name()='jmsTo' and @type='soapSendReceiveActivity']">
					<sender type='unwired'>
						<xsl:call-template name="substvar">
							<xsl:with-param name="project" select="$project"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</sender>
				</xsl:for-each>
				<xsl:for-each select="descendant-or-self::*[name()='jmsInboundDest']">
					<xsl:variable name="dest" select="."/>
					<xsl:variable name="dest2">
						<xsl:for-each select="$project//content[resourceName=$dest]">
							<xsl:if test="position()=1">
								<xsl:value-of select="resourceJndiName"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<receiver type='wired'>
						<xsl:choose>
							<xsl:when test="string-length($dest2)=0">
								<xsl:value-of select="concat('#',$dest,'#')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$dest2"/>
							</xsl:otherwise>
						</xsl:choose>
					</receiver>
				</xsl:for-each>
				<xsl:for-each select="descendant-or-self::*[name()='targetAddr']">
					<sender type='wired'>
						<xsl:value-of select="."/>
					</sender>
				</xsl:for-each>
				<xsl:call-template name="finddaa"/>
			</project>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="finddaa">
		<xsl:for-each select="descendant-or-self::*[name()='file' and ends-with(@name,'.daa')]">
			<xsl:call-template name="daa"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="daa">
		<daa>
			<xsl:attribute name="dir"><xsl:for-each select="ancestor-or-self::*[name()='dir']"><xsl:if test="position()=last()"><xsl:value-of select="@name"/></xsl:if></xsl:for-each></xsl:attribute>
			<xsl:value-of select="@name"/>
		</daa>
	</xsl:template>
	<xsl:template name="finddaa_component">
		<xsl:for-each select="*[(name()='dir' and @name='src')=false()]">
			<xsl:call-template name="finddaa"/>
		</xsl:for-each>
		<xsl:for-each select="*[(name()='dir' and @name='src')]/*[name()='file' and ends-with(@name,'.daa')]">
			<xsl:call-template name="daa"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="substvar">
		<xsl:param name="project"/>
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="starts-with($value,'%%') and ends-with($value,'%%')">
				<xsl:variable name="value2">
					<xsl:for-each select="$project//globalVariable[@ref=$value]">
						<xsl:if test="position()=1">
							<xsl:value-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="string-length($value2)=0">
						<xsl:value-of select="concat('#',$value,'#')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$value2"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

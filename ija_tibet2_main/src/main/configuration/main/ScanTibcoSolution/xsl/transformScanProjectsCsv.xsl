<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="text" indent="no"/>
	<xsl:variable name="eol" select="'&#13;&#10;'"/>
	<xsl:template match="root">
		<xsl:text>Tree;Component;Project;Type;Daa;Permission;Queue</xsl:text>
		<xsl:value-of select="$eol"/>
		<xsl:for-each select="dir[(@skip='true')=false()]">
			<xsl:variable name="subroot" select="@name"/>
			<xsl:for-each select="dir[(@skip='true')=false()]">
				<xsl:variable name="component" select="@name"/>
				<xsl:if test="count(dir[@name='trunk'])&gt;0">
					<xsl:apply-templates select="dir[@name='trunk']" mode="trunk">
						<xsl:with-param name="subroot" select="$subroot"/>
						<xsl:with-param name="component" select="$component"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="dir" mode="trunk">
		<xsl:param name="subroot"/>
		<xsl:param name="component"/>
		<xsl:if test="count(dir[@name='src'])&gt;0">
			<xsl:variable name="daasc">
				<xsl:for-each select="*[(name()='dir' and @name='src')=false()]">
					<xsl:for-each select="descendant-or-self::*[name()='file' and ends-with(@name,'.daa')]">
						<daa>
							<xsl:value-of select="@name"/>
						</daa>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="*[(name()='dir' and @name='src')]/*[name()='file' and ends-with(@name,'.daa')]">
					<daa>
						<xsl:value-of select="@name"/>
					</daa>
				</xsl:for-each>
			</xsl:variable>
			<xsl:apply-templates select="dir[@name='src']" mode="src">
				<xsl:with-param name="subroot" select="$subroot"/>
				<xsl:with-param name="component" select="$component"/>
				<xsl:with-param name="daasc" select="$daasc"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="dir" mode="src">
		<xsl:param name="subroot"/>
		<xsl:param name="component"/>
		<xsl:param name="daasc"/>
		<xsl:for-each select="dir">
			<xsl:variable name="project">
				<xsl:copy-of select="*"/>
			</xsl:variable>
			<project>
				<xsl:variable name="projectName" select="@name"/>
				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="file[@name='vcrepo.dat']">BW</xsl:when>
						<xsl:when test="file[@name='.project']">AMX</xsl:when>
						<xsl:otherwise>?</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="daasp">
					<xsl:for-each select="descendant-or-self::*[name()='file' and ends-with(@name,'.daa')]">
						<daa>
							<xsl:value-of select="@name"/>
						</daa>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="daa">
					<xsl:choose>
						<xsl:when test="count($daasp/daa)=0">
							<xsl:choose>
								<xsl:when test="count($daasc/daa)=0">#NO_DAA_FILE#</xsl:when>
								<xsl:when test="count($daasc/daa)=1">
									<xsl:value-of select="$daasc/daa"/>
								</xsl:when>
								<xsl:otherwise>#MULTIPLE_COMPONENT_DAA_FILES#</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="count($daasp/daa)=1">
							<xsl:value-of select="$daasp/daa"/>
						</xsl:when>
						<xsl:otherwise>#MULTIPLE_PROJECT_DAA_FILES#</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="prefix" select="concat($subroot,';',$component,';',$projectName,';',$type,';',$daa)"/>
				<xsl:for-each select="descendant-or-self::*[name()='jmsTo' and @type='soapEventSource']">
					<!-- unwired -->
					<xsl:variable name="queue">
						<xsl:call-template name="substvar">
							<xsl:with-param name="project" select="$project"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="concat($prefix,';receive;',$queue,$eol)"/>
				</xsl:for-each>
				<xsl:for-each select="descendant-or-self::*[name()='jmsTo' and @type='soapSendReceiveActivity']">
					<!-- unwired -->
					<xsl:variable name="queue">
						<xsl:call-template name="substvar">
							<xsl:with-param name="project" select="$project"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="concat($prefix,';send;',$queue,$eol)"/>
				</xsl:for-each>
				<xsl:for-each select="descendant-or-self::*[name()='jmsInboundDest']">
					<!-- wired -->
					<xsl:variable name="dest" select="."/>
					<xsl:variable name="dest2">
						<xsl:for-each select="$project//content[resourceName=$dest]">
							<xsl:value-of select="resourceJndiName"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="queue">
						<xsl:choose>
							<xsl:when test="string-length($dest2)=0">
								<xsl:value-of select="concat('#',$dest,'#')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$dest2"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of select="concat($prefix,';receive;',$queue,$eol)"/>
				</xsl:for-each>
				<xsl:for-each select="descendant-or-self::*[name()='targetAddr']">
					<!-- wired -->
					<xsl:value-of select="concat($prefix,';send;',.,$eol)"/>
				</xsl:for-each>
			</project>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="substvar">
		<xsl:param name="project"/>
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="starts-with($value,'%%') and ends-with($value,'%%')">
				<xsl:variable name="value2">
					<xsl:for-each select="$project//globalVariable[@ref=$value]">
						<xsl:value-of select="."/>
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

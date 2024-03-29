<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="principal" />
	
	<xsl:template match="/">
		<checkRole>
			<principal><xsl:value-of select="$principal"/></principal>
			<role><xsl:value-of select="row/field"/></role>
		</checkRole>
	</xsl:template>
</xsl:stylesheet>
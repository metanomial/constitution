<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8"/>

	<xsl:template match="/">
		<xsl:apply-templates select="document"/>
	</xsl:template>
	<xsl:template match="document">
		<xsl:element name="html">
			<xsl:attribute name="lang">en</xsl:attribute>
			<xsl:element name="head">
				<xsl:attribute name="lang">
					<xsl:value-of select="@lang"/>
				</xsl:attribute>
				<xsl:element name="meta">
					<xsl:attribute name="name">viewport</xsl:attribute>
					<xsl:attribute name="content">width = device-width, initial-scale = 1</xsl:attribute>
				</xsl:element>
				<xsl:element name="title">
					<xsl:value-of select="heading"/>
				</xsl:element>
				<xsl:element name="link">
					<xsl:attribute name="rel">stylesheet</xsl:attribute>
					<xsl:attribute name="href">main.css</xsl:attribute>
				</xsl:element>
			</xsl:element>
			<xsl:element name="body">
				<xsl:apply-templates select="see-also"/>
				<xsl:element name="main">
					<xsl:element name="h1">
						<xsl:value-of select="@heading"/>
					</xsl:element>
					<xsl:apply-templates select="section|note|paragraph"/>
					<xsl:if test="signatory|party">
						<xsl:element name="div">
							<xsl:attribute name="id">signatures</xsl:attribute>
							<xsl:apply-templates select="signatory|party"/>
						</xsl:element>
					</xsl:if>
					<xsl:apply-templates select="copyright"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="see-also">
		<xsl:element name="nav">
			<xsl:apply-templates select="link"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="link">
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:value-of select="@href"/>
			</xsl:attribute>
			<xsl:if test="@lang">
				<xsl:attribute name="hreflang">
					<xsl:value-of select="@lang"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="section|note">
		<xsl:param name="depth">2</xsl:param>
		<xsl:param name="prefix"/>
		<xsl:variable name="identifier">
			<xsl:call-template name="identifier">
				<xsl:with-param name="prefix" select="$prefix"/>
				<xsl:with-param name="heading" select="@heading"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="@heading">
			<xsl:call-template name="anchor">
				<xsl:with-param name="identifier" select="$identifier"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:variable name="content">
			<xsl:apply-templates select="@heading">
				<xsl:with-param name="depth" select="$depth"/>
				<xsl:with-param name="identifier" select="$identifier"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="section|note|paragraph">
				<xsl:with-param name="depth" select="$depth + 1"/>
				<xsl:with-param name="prefix" select="$identifier"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="name() = 'note'">
				<xsl:element name="div">
					<xsl:attribute name="class">note</xsl:attribute>
					<xsl:copy-of select="$content"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$content"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="anchor">
		<xsl:param name="identifier"/>
		<xsl:element name="a">
			<xsl:attribute name="id">
				<xsl:value-of select="$identifier"/>
			</xsl:attribute>
			<xsl:attribute name="class">fragment-anchor</xsl:attribute>
		</xsl:element>
	</xsl:template>
	<xsl:template name="identifier">
		<xsl:param name="prefix"/>
		<xsl:param name="heading"/>
		<xsl:value-of select="
			translate(
				normalize-space(
					concat(
						$prefix,
						' ',
						$heading
					)
				),
				'ABCDEFGHIJKLMNOPQRSTUVWXYZ ',
				'abcdefghijklmnopqrstuvwxyz-'
			)
		"/>
	</xsl:template>
	<xsl:template match="@heading">
		<xsl:param name="depth">2</xsl:param>
		<xsl:param name="identifier"/>
		<xsl:element name="{ concat('h', $depth) }">
			<xsl:element name="a">
				<xsl:attribute name="class">fragment-hyperlink</xsl:attribute>
				<xsl:attribute name="href">
					<xsl:value-of select="concat('#', $identifier)"/>
				</xsl:attribute>
				<xsl:text>#</xsl:text>
			</xsl:element>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="paragraph">
		<xsl:element name="p">
			<xsl:apply-templates select="text() | *"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="strong">
		<xsl:element name="strong">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="party">
		<xsl:element name="div">
			<xsl:attribute name="class">party</xsl:attribute>
			<xsl:apply-templates select="@name"/>
			<xsl:apply-templates select="signatory"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@name">
		<xsl:element name="div">
			<xsl:attribute name="class">party-name</xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="signatory">
		<xsl:element name="div">
			<xsl:attribute name="class">signatory</xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="copyright">
		<xsl:call-template name="anchor">
			<xsl:with-param name="identifier" select="'copyright'"/>
		</xsl:call-template>
		<xsl:element name="footer">
			<xsl:apply-templates select="paragraph"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>

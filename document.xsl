<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8"/>

	<xsl:template match="/">
		<xsl:apply-templates select="document"/>
	</xsl:template>

	<!-- Document -->
	<xsl:template match="document">
		<html lang="en">
			<head>
				<xsl:attribute name="lang">
					<xsl:value-of select="@lang"/>
				</xsl:attribute>
				<meta charset="utf-8"/>
				<meta name="viewport" content="width = device-width, initial-scale = 1"/>
				<title><xsl:value-of select="heading"/></title>
				<link rel="stylesheet" href="main.css"/>
			</head>
			<body>
				<xsl:apply-templates select="navigation"/>
				<main>
					<h1><xsl:value-of select="heading"/></h1>
					<xsl:apply-templates select="article"/>
					<xsl:apply-templates select="eschatocol"/>
				</main>
			</body>
		</html>
	</xsl:template>

	<!-- Navigation -->
	<xsl:template match="navigation">
		<nav role="navigation">
			<xsl:apply-templates select="link"/>
		</nav>
	</xsl:template>

	<!-- Navigation link -->
	<xsl:template match="link">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="@href"/>
			</xsl:attribute>
			<xsl:if test="@lang">
				<xsl:attribute name="hreflang">
					<xsl:value-of select="@lang"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="."/>
		</a>
	</xsl:template>

	<!-- Article -->
	<xsl:template match="article">
		<xsl:apply-templates select="heading">
			<xsl:with-param name="label" select="heading"/>
			<xsl:with-param name="container">h2</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="section"/>
		<hr/>
	</xsl:template>

	<!-- Section -->
	<xsl:template match="section">
		<xsl:apply-templates select="heading">
			<xsl:with-param name="label" select="concat(../heading, ' ', heading)"/>
			<xsl:with-param name="container">h3</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="paragraph"/>
	</xsl:template>

	<!-- Heading -->
	<xsl:template match="heading">
		<xsl:param name="label"/>
		<xsl:param name="container"/>
		<xsl:variable name="identifier">
			<xsl:value-of select="translate(normalize-space($label), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ', 'abcdefghijklmnopqrstuvwxyz-')"/>
		</xsl:variable>
		<xsl:element name="a">
			<xsl:attribute name="id">
				<xsl:value-of select="$identifier"/>
			</xsl:attribute>
			<xsl:attribute name="class">fragment-anchor</xsl:attribute>
		</xsl:element>
		<xsl:element name="{ $container }">
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

	<!-- Paragraph -->
	<xsl:template match="paragraph">
		<p><xsl:value-of select="."/></p>
	</xsl:template>

	<!-- Eschatocol -->
	<xsl:template match="eschatocol">
		<xsl:apply-templates select="heading">
			<xsl:with-param name="label" select="heading"/>
			<xsl:with-param name="container">h2</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="section"/>
		<div class="signatures">
			<xsl:apply-templates select="party"/>
		</div>
	</xsl:template>

	<!-- Party -->
	<xsl:template match="party">
		<div class="party">
			<xsl:apply-templates select="name"/>
			<xsl:apply-templates select="member"/>
		</div>
	</xsl:template>

	<!-- Party name -->
	<xsl:template match="name">
		<div class="party-name"><xsl:value-of select="."/></div>
	</xsl:template>

	<xsl:template match="member">
		<div class="party-member"><xsl:value-of select="."/></div>
	</xsl:template>
</xsl:stylesheet>

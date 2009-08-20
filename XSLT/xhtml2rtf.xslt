<?xml version='1.0' encoding='utf-8'?>

<!-- XHTML-to-RTF converter by Fletcher Penney
	specifically designed for use with MultiMarkdown created XHTML
	
	MultiMarkdown Version 2.0.b6
	
	
	Yes - this is the project I swore I would never do.... 
	You're welcome.  ;)
-->

<!-- 
# Copyright (C) 2009  Fletcher T. Penney <fletcher@fletcherpenney.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the
#    Free Software Foundation, Inc.
#    59 Temple Place, Suite 330
#    Boston, MA 02111-1307 USA
-->



<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:m="http://www.w3.org/1998/Math/MathML"
	xmlns:html="http://www.w3.org/1999/xhtml"
	version="1.0">

	<xsl:import href="clean-text-rtf.xslt"/>

	<xsl:output method='text' encoding='utf-8'/>

	<xsl:strip-space elements="*" />

	<xsl:variable name="newline">
<xsl:text>\
</xsl:text>
	</xsl:variable>

	<xsl:param name="footnoteId"/>

	<xsl:decimal-format name="string" NaN="1"/>

	<xsl:template match="html:body">
		<xsl:apply-templates select="*|comment()"/>
		<!-- <xsl:apply-templates select="*"/> 		Use this version to ignore text within XHTML comments-->
		<xsl:call-template name="rtf-closing"/>
	</xsl:template>

	<xsl:template match="html:head">
		<!-- Init Latex -->
		<xsl:call-template name="rtf-intro"/>
		<xsl:apply-templates select="*"/>
		<xsl:call-template name="rtf-intro-closing"/>
	</xsl:template>

	<!-- ignore  other information within the header 
		This will need to be expanded upon over time -->

	<xsl:template match="html:head/html:style">
	</xsl:template>

	<xsl:template match="html:head/html:base">
	</xsl:template>

	<xsl:template match="html:head/html:link">
	</xsl:template>

	<xsl:template match="html:head/html:object">
	</xsl:template>
	
	<xsl:template match="html:head/html:script">
	</xsl:template>

	<xsl:template name="rtf-intro">
		<xsl:text>{\rtf1\ansi\ansicpg1252\cocoartf949\cocoasubrtf460
{\fonttbl}
{\colortbl;\red255\green255\blue255;}
{\info
</xsl:text>
	</xsl:template>

	<xsl:template name="rtf-intro-closing">
		<xsl:text>}\pard\sa280
</xsl:text>
	</xsl:template>
	
	<xsl:template name="rtf-closing">
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'title']">
		<xsl:text>{\title </xsl:text>
			<xsl:call-template name="clean-text">
				<xsl:with-param name="source">
					<xsl:value-of select="."/>
				</xsl:with-param>
			</xsl:call-template>		
		<xsl:text>}
</xsl:text>
	</xsl:template>

	<xsl:template match="html:meta">
		<xsl:choose>
			<xsl:when test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'author'">
				<xsl:text>{\author </xsl:text>
				<xsl:call-template name="clean-text">
					<xsl:with-param name="source">
						<xsl:value-of select="@content"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>}
</xsl:text>
			</xsl:when>
			<xsl:when test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'affiliation'">
				<xsl:text>{\*\company </xsl:text>
				<xsl:call-template name="replace-substring">
					<!-- put line breaks in -->
					<xsl:with-param name="original">
						<xsl:call-template name="clean-text">
							<xsl:with-param name="source">
								<xsl:value-of select="@content"/>
							</xsl:with-param>
						</xsl:call-template>		
					</xsl:with-param>
					<xsl:with-param name="substring">
						<xsl:text>   </xsl:text>
					</xsl:with-param>
					<xsl:with-param name="replacement">
						<xsl:text> </xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>}
</xsl:text>
			</xsl:when>
			<xsl:when test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'keywords'">
				<xsl:text>{\keywords </xsl:text>
				<xsl:call-template name="replace-substring">
					<xsl:with-param name="original">
						<xsl:value-of select="@content"/>
					</xsl:with-param>
					<xsl:with-param name="substring">
						<xsl:text>,,</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="replacement">
						<xsl:text>,</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>}
</xsl:text>
			</xsl:when>
			<xsl:when test="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'copyright'">
				<xsl:text>{\*\copyright </xsl:text>
				<xsl:call-template name="replace-substring">
					<!-- put line breaks in -->
					<xsl:with-param name="original">
						<xsl:call-template name="clean-text">
							<xsl:with-param name="source">
								<xsl:value-of select="@content"/>
							</xsl:with-param>
						</xsl:call-template>		
					</xsl:with-param>
					<xsl:with-param name="substring">
						<xsl:text>   </xsl:text>
					</xsl:with-param>
					<xsl:with-param name="replacement">
						<xsl:text> </xsl:text>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>}
</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- paragraphs -->
	
	<xsl:template match="html:p">
		<xsl:apply-templates select="node()"/>
		<xsl:text>\
</xsl:text>
	</xsl:template>

	<!-- emphasis -->
	<xsl:template match="html:em">
		<xsl:text>
\i </xsl:text>
			<xsl:apply-templates select="node()"/>
		<xsl:text>
\i0 </xsl:text>
	</xsl:template>

	<!-- strong -->
	<xsl:template match="html:strong">
		<xsl:text>
\b </xsl:text>
			<xsl:apply-templates select="node()"/>
		<xsl:text>
\b0 </xsl:text>
	</xsl:template>

	<!-- headers -->
	
	<xsl:template match="html:h1">
\fs32 <xsl:apply-templates select="node()"/>
<xsl:value-of select="$newline"/>
\f1\fs24 </xsl:template>
	
	
</xsl:stylesheet>

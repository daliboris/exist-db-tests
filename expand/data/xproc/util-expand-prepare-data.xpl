<p:declare-step 
	xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xext="https://www.daliboris.cz/ns/xproc/eXist-db/tests"
	xmlns:tei = "http://www.tei-c.org/ns/1.0"	
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	version="3.0"
	name="preparing-data">
	
	
	<p:documentation>
		<xhtml:section>
			<xhtml:h2></xhtml:h2>
			<xhtml:p></xhtml:p>
		</xhtml:section>
	</p:documentation>
   
	<!-- INPUT PORTS -->
  <p:input port="source" primary="true">
  	<p:document href="../original/DamenConvLex-1834.xml" />
  </p:input>
   
	<!-- OUTPUT PORTS -->
	<p:output port="result" primary="true" />
	
	<!-- OPTIONS -->
	<p:option name="debug-path" select="()" as="xs:string?" />
	<p:option name="base-uri" as="xs:anyURI" select="static-base-uri()"/>
	
	<p:option name="items-count" as="xs:integer" select="10" />
	
	<!-- ********************* --> 
	<!-- ****	INNER STEP **** -->
	<!-- ********************* -->
	<p:declare-step type="xext:rename-elements">
		<p:input port="source" primary="true" />
		<p:output port="result" primary="true" />
		<p:rename match="tei:form/tei:term" new-name="tei:orth" />
		<p:add-attribute match="tei:form" attribute-name="type" attribute-value="lemma" />
		<p:xslt>
			<p:with-input port="stylesheet" href="../xslt/remove-namespace-prefix.xsl" />
		</p:xslt>
	</p:declare-step>
	
	<!-- ********************* --> 
	<!-- ****	INNER STEP **** -->
	<!-- ********************* -->
	<p:declare-step type="xext:remove-parts">
		<p:input port="source" primary="true" />
		<p:output port="result" primary="true" />
		<p:delete match="tei:front" />
		<p:delete match="tei:entry/tei:sense" />
		<p:delete match="/processing-instruction(teipublisher)" />
	</p:declare-step>
	
	<!-- ********************* --> 
	<!-- ****	INNER STEP **** -->
	<!-- ********************* -->
	<p:declare-step type="xext:remove-elements">
		<p:input port="source" primary="true" />
		<p:output port="result" primary="true" />
		<p:option name="items-count" as="xs:integer" required="true" />
		<p:delete match="tei:entry[position() gt {$items-count}]" />
	</p:declare-step>
	
	<!-- ********************* --> 
	<!-- ****	INNER STEP **** -->
	<!-- ********************* -->
	<p:declare-step type="xext:expand-data">
		<p:input port="source" primary="true" />
		<p:output port="result" primary="true" />
		<p:option name="multiplier" as="xs:integer" required="true" />
		<xext:rename-elements />
		<xext:remove-parts />
		<p:xslt>
			<p:with-input port="stylesheet" href="../xslt/duplicate-entries.xsl" />
			<p:with-option name="parameters" select="map {'multiplier' : $multiplier }" />
		</p:xslt>
	</p:declare-step>
	
	<!-- ********************* --> 
	<!-- ****	INNER STEP **** -->
	<!-- ********************* -->
	<p:declare-step type="xext:rename-remove-save">
		<p:input port="source" primary="true" />
		<p:output port="result" primary="true" />
		<p:option name="items-count" as="xs:integer" />
		<xext:rename-elements />
		<xext:remove-parts />
		<xext:remove-elements items-count="{$items-count}" />
		<p:store href="../input/DamenConvLex-1834-{$items-count}.xml" serialization="map{'indent' : true()}" message="Storing result to../input/DamenConvLex-1834-{$items-count}.xml" />		
	</p:declare-step>
	
	<!-- VARIABLES -->
	<p:variable name="debug" select="$debug-path || '' ne ''" />
	<p:variable name="debug-path-uri" select="resolve-uri($debug-path, $base-uri)" />
	
	<!-- PIPELINE BODY -->
	<p:group use-when="true()">
		<xext:rename-remove-save items-count="10">
			<p:with-input port="source" pipe="source@preparing-data" />
		</xext:rename-remove-save>
		<xext:rename-remove-save items-count="100">
			<p:with-input port="source" pipe="source@preparing-data" />
		</xext:rename-remove-save>
		<xext:rename-remove-save items-count="1000">
			<p:with-input port="source" pipe="source@preparing-data" />
		</xext:rename-remove-save>
	</p:group>

	<xext:expand-data multiplier="1">
		<p:with-input port="source" pipe="source@preparing-data" />
	</xext:expand-data>
	<p:store href="../input/DamenConvLex-1834-10000.xml" serialization="map{'indent' : true()}" message="Storing result to../input/DamenConvLex-1834-10000.xml" />
	
	<xext:expand-data multiplier="2">
		<p:with-input port="source" pipe="source@preparing-data" />
	</xext:expand-data>
	<p:store href="../input/DamenConvLex-1834-100000.xml" serialization="map{'indent' : true()}" message="Storing result to../input/DamenConvLex-1834-100000.xml" />
	
	<p:identity>
		<p:with-input pipe="result-uri"/>
	</p:identity>
	
</p:declare-step>
